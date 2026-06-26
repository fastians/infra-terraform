variable "project_name" {
  type        = string
  description = "Project label used in resource names."
}

variable "environment" {
  type        = string
  description = "Environment label (e.g. app-production)."
}

variable "aws_region" {
  type        = string
  default     = "ap-northeast-2"
  description = "AWS region for the S3 origin bucket (Seoul: ap-northeast-2)."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "When false, no frontend resources are created."
}

variable "hostnames" {
  type        = list(string)
  description = "Custom hostnames on CloudFront (e.g. mek-lab.com, www.mek-lab.com)."
  default     = []
}

variable "route53_zone_id" {
  type        = string
  default     = ""
  description = "If set, create ACM DNS validation records and A/AAAA alias records for hostnames."
}

variable "custom_domain_enabled" {
  type        = bool
  default     = false
  description = "Attach mek-lab.com to CloudFront. Set true only after ACM cert is ISSUED (Cloudflare validation CNAMEs added)."
}

variable "price_class" {
  type        = string
  default     = "PriceClass_200"
  description = "CloudFront price class. 200 includes Asia (Seoul edge); use All for global lowest latency."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Extra tags merged into all resources."
}
