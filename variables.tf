
variable "aws_account_id" {
  description = "ID of the AWS account."
  type        = string
}

variable "infra_environment" {
  description = "Name of the infrastructure environment."
  type        = string
}

variable "project" {
  description = "Name of the project."
  type        = string
}

variable "git_url" {
  description = "Git repository ID or URL for tagging and tracking."
  type        = string
}

variable "allowed_methods"{
  description = "Which HTTP methods CloudFront processes and forwards to origin."
  type = list(string)
}

variable "cached_methods"{
  description = "CloudFront caches the response to requests using the specified HTTP methods."
  type = list(string)
}

variable "viewer_protocol_policy" {
  description = "Protocol that users can use to access the files in the origin. allow-all, https-only, or redirect-to-https."
  type = string
}

variable "default_origin_id" {
  description = "The origin id which you want as default for your distribution"
  type = string
}

variable "alternate_domain_names" {
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution."
  type = list(string)
  default = []
}

variable "ordered_cache_behaviour"{
  description = "Ordered list of cache behaviors(The topmost cache behavior will have precedence 0.)"
  type = list(object({
    allowed_methods = list(string)
    cached_methods = list(string)
    viewer_protocol_policy = string
    target_origin_id = string
    path_pattern = string
  }))
  default = [{
    allowed_methods = [ ]
    cached_methods = [ ]
    viewer_protocol_policy = null
    target_origin_id = null
    path_pattern = null
  }]
}

variable "custom_error_response"{
  description = "Cloudfront error response elements"
  type = list(object({
    error_caching_min_ttl = number
    error_code = number
    response_code = number
    response_page_path = string
  }))
  default = [{
    error_caching_min_ttl = 0
    error_code            = 0
    response_code         = 0
    response_page_path    = null
  }]
}

variable "origin"{
  description = "Origins for this distribution"
  type = list(object({
    origin_id = string
    origin_path = string
    domain_name = string

  }))
  default = [ {
    origin_id = null
    origin_path = null
    domain_name = null
  } ]
}

variable "default_certificate" {
  description = "It is true when using CloudFront domain name for the distribution"
  type = bool
  default = true
}

variable "acm_certificate"{
  description = "ARN of the AWS Certificate Manager certificate that you wish to use with this distribution"
  type = string
}

variable "minimum_protocol_version" {
  description = "Minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections"
  type = string
}