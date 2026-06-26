output "aws_region" {
  description = "Region of the S3 SPA origin bucket (Seoul)."
  value       = var.aws_region
}

output "bucket_name" {
  description = "S3 bucket for Vite build artifacts (ap-northeast-2)."
  value       = try(aws_s3_bucket.site[0].id, null)
}

output "bucket_arn" {
  description = "S3 bucket ARN."
  value       = try(aws_s3_bucket.site[0].arn, null)
}

output "cloudfront_distribution_id" {
  description = "Use for cache invalidation after deploy."
  value       = try(aws_cloudfront_distribution.site[0].id, null)
}

output "cloudfront_domain_name" {
  description = "Default *.cloudfront.net hostname (before custom DNS)."
  value       = try(aws_cloudfront_distribution.site[0].domain_name, null)
}

output "cloudfront_hosted_zone_id" {
  description = "Route53 alias target zone id for CloudFront."
  value       = try(aws_cloudfront_distribution.site[0].hosted_zone_id, null)
}

output "site_urls" {
  description = "Public URLs for the SPA."
  value = var.enabled && length(var.hostnames) > 0 ? [
    for h in var.hostnames : "https://${h}"
  ] : (var.enabled ? ["https://${aws_cloudfront_distribution.site[0].domain_name}"] : [])
}

output "acm_certificate_arn" {
  description = "ACM cert ARN (us-east-1) when custom hostnames are set."
  value       = try(aws_acm_certificate.site[0].arn, null)
}

output "custom_domain_enabled" {
  description = "When false, CloudFront uses *.cloudfront.net until ACM is validated; then set custom_domain_enabled=true and re-apply."
  value       = var.custom_domain_enabled
}

output "acm_dns_validation_records" {
  description = "Add these in Cloudflare (or Route53) before setting custom_domain_enabled=true."
  value = local.request_acm_cert ? [
    for dvo in aws_acm_certificate.site[0].domain_validation_options : {
      domain = dvo.domain_name
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      value  = dvo.resource_record_value
    }
  ] : []
}

output "cloudflare_cname_records" {
  description = "Create these CNAME records in Cloudflare (DNS only / grey cloud). No IP address."
  value = var.enabled && length(var.hostnames) > 0 && try(aws_cloudfront_distribution.site[0].domain_name, null) != null ? [
    for host in var.hostnames : {
      cloudflare_type     = "CNAME"
      cloudflare_name     = length(split(".", host)) == 2 ? "@" : (length(split(".", host)) > 2 ? element(split(".", host), 0) : host)
      cloudflare_target   = aws_cloudfront_distribution.site[0].domain_name
      full_hostname       = host
      proxy_recommended   = "DNS only (grey cloud)"
      replaces_vercel_for = host
    }
  ] : []
}
