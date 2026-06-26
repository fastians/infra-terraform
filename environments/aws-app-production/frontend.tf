# Simulation SPA: S3 (Seoul) + CloudFront — replaces Vercel at mek-lab.com / www.
# API/GEO/LLM remain on api.mek-lab.com (EC2 in ap-northeast-2).
# ACM for CloudFront must use us-east-1 (AWS global requirement); S3 origin stays in Seoul.

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

module "frontend" {
  source = "../../modules/static-frontend"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  project_name          = var.project_name
  environment           = var.environment
  aws_region            = var.aws_region
  enabled               = var.enable_frontend_cdn
  hostnames             = var.frontend_hostnames
  route53_zone_id       = var.frontend_route53_zone_id
  price_class           = var.frontend_cloudfront_price_class
  custom_domain_enabled = var.frontend_custom_domain_enabled
  tags                  = var.tags
}
