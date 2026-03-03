
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
    allowed_methods          = list(string)
    cached_methods           = list(string)
    viewer_protocol_policy   = string
    default_origin_id        = string
    cache_policy_id          = optional(string)
    compress                 = optional(bool, true)
    comment                  = optional(string)
    price_class              = optional(string, "PriceClass_100")
    http_version             = optional(string, "http2")
    is_ipv6_enabled          = optional(bool, true)
    web_acl_id               = optional(string)
    alternate_domain_names   = optional(list(string))
    default_certificate      = bool
    acm_certificate          = optional(string)
    minimum_protocol_version = string
    function_associations = optional(list(object({
      event_type   = string
      function_arn = string
    })))
    origin = list(object({
      origin_id                = string
      origin_path              = optional(string, "")
      domain_name              = string
      origin_access_control_id = optional(string)
      oac_name                 = optional(string)
      create_oac               = optional(bool, false)
      s3_origin_config = optional(object({
        origin_access_identity = string
      }))
      custom_origin_config = optional(object({
        http_port              = optional(number, 80)
        https_port             = optional(number, 443)
        origin_protocol_policy = string
        origin_ssl_protocols   = list(string)
      }))
    }))
    custom_error_response = optional(list(object({
      error_caching_min_ttl = number
      error_code            = number
      response_code         = number
      response_page_path    = string
    })))
    ordered_cache_behaviour = optional(list(object({
      allowed_methods        = list(string)
      cached_methods         = list(string)
      viewer_protocol_policy = string
      target_origin_id       = string
      path_pattern           = string
      cache_policy_id        = optional(string)
      compress               = optional(bool, true)
      function_associations = optional(list(object({
        event_type   = string
        function_arn = string
      })))
    })))
  }))
  default = {}
}


