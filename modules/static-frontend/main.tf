terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws, aws.us_east_1]
    }
  }
}

locals {
  name_prefix = "${var.project_name}-${var.environment}-fe"
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      Component   = "static-frontend"
      Region      = var.aws_region
      ManagedBy   = "Terraform"
    },
    var.tags
  )
  create_dns        = var.enabled && var.route53_zone_id != "" && length(var.hostnames) > 0
  use_custom_domain = var.enabled && length(var.hostnames) > 0 && (local.create_dns || var.custom_domain_enabled)
  request_acm_cert  = var.enabled && length(var.hostnames) > 0
}

# S3 origin in Seoul (same region as EC2 API/GEO stack).
resource "aws_s3_bucket" "site" {
  count  = var.enabled ? 1 : 0
  bucket = "${local.name_prefix}-${var.aws_region}-${data.aws_caller_identity.current.account_id}"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-spa-origin"
  })
}

resource "aws_s3_bucket_public_access_block" "site" {
  count                   = var.enabled ? 1 : 0
  bucket                  = aws_s3_bucket.site[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "site" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.site[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "site" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.site[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_cloudfront_origin_access_control" "site" {
  count                             = var.enabled ? 1 : 0
  name                              = "${local.name_prefix}-oac"
  description                       = "OAC for Mek-Lab simulation SPA S3 origin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_acm_certificate" "site" {
  count    = local.request_acm_cert ? 1 : 0
  provider = aws.us_east_1

  domain_name               = var.hostnames[0]
  subject_alternative_names = length(var.hostnames) > 1 ? slice(var.hostnames, 1, length(var.hostnames)) : []
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = local.common_tags
}

resource "aws_route53_record" "cert_validation" {
  for_each = local.create_dns ? {
    for dvo in aws_acm_certificate.site[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  zone_id         = var.route53_zone_id
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  ttl             = 60
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "site" {
  count    = local.create_dns ? 1 : 0
  provider = aws.us_east_1

  certificate_arn         = aws_acm_certificate.site[0].arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

data "aws_acm_certificate" "issued" {
  count       = local.use_custom_domain && !local.create_dns ? 1 : 0
  provider    = aws.us_east_1
  domain      = var.hostnames[0]
  statuses    = ["ISSUED"]
  most_recent = true
}

resource "aws_cloudfront_distribution" "site" {
  count       = var.enabled ? 1 : 0
  enabled     = true
  comment     = "Mek-Lab simulation frontend (${var.environment})"
  aliases     = local.use_custom_domain ? var.hostnames : null
  price_class = var.price_class

  default_root_object = "index.html"

  origin {
    domain_name              = aws_s3_bucket.site[0].bucket_regional_domain_name
    origin_id                = "s3-${local.name_prefix}"
    origin_access_control_id = aws_cloudfront_origin_access_control.site[0].id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "s3-${local.name_prefix}"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  # Hashed Vite assets — long cache
  ordered_cache_behavior {
    path_pattern           = "assets/*"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "s3-${local.name_prefix}"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 31536000
    max_ttl     = 31536000
  }

  # SPA client-side routes
  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = !local.use_custom_domain
    acm_certificate_arn = local.use_custom_domain ? (
      local.create_dns
      ? aws_acm_certificate_validation.site[0].certificate_arn
      : data.aws_acm_certificate.issued[0].arn
    ) : null
    ssl_support_method       = local.use_custom_domain ? "sni-only" : null
    minimum_protocol_version = local.use_custom_domain ? "TLSv1.2_2021" : null
  }

  tags = local.common_tags

  depends_on = [aws_s3_bucket_public_access_block.site]
}

data "aws_iam_policy_document" "bucket_policy" {
  count = var.enabled ? 1 : 0

  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.site[0].arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.site[0].arn]
    }
  }
}

resource "aws_s3_bucket_policy" "site" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.site[0].id
  policy = data.aws_iam_policy_document.bucket_policy[0].json
}

resource "aws_route53_record" "site_alias" {
  for_each = local.create_dns ? toset(var.hostnames) : toset([])

  zone_id = var.route53_zone_id
  name    = each.value
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site[0].domain_name
    zone_id                = aws_cloudfront_distribution.site[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "site_alias_aaaa" {
  for_each = local.create_dns ? toset(var.hostnames) : toset([])

  zone_id = var.route53_zone_id
  name    = each.value
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.site[0].domain_name
    zone_id                = aws_cloudfront_distribution.site[0].hosted_zone_id
    evaluate_target_health = false
  }
}

data "aws_caller_identity" "current" {}
