
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

variable "distributions" {
  description = "Full description of distributions"
  type = map(object({
    allowed_methods = list(string)
    cached_methods = list(string)
    viewer_protocol_policy = string
    default_origin_id = string
    alternate_domain_names = list(string)
    default_certificate = bool
    acm_certificate = string
    minimum_protocol_version = string
    origin = list(object({
      origin_id = string
      origin_path = string
      domain_name = string
    }))
    custom_error_response = list(object({
      error_caching_min_ttl = number
      error_code = number
      response_code = number
      response_page_path = string
    }))
    ordered_cache_behaviour = list(object({
      allowed_methods = list(string)
      cached_methods = list(string)
      viewer_protocol_policy = string
      target_origin_id = string
      path_pattern = string
    }))
  }))
  default = {}
}

