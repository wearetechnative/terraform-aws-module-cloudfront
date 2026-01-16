variable "allowed_methods"{
  description = "allowed http methods"
  type = list(string)
}

variable "cached_methods"{
  type = list(string)
}

variable "viewer_protocol_policy" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "origin_id" {
  type = string
}

variable "origin_path" {
  type = string
  default = ""
}

variable "alternate_domain_names" {
  type = list(string)
  default = []
}

variable "ordered_cache_behaviour"{
  type = list(object({
    ordered_cache_allowed_methods = list(string)
    ordered_cached_methods = list(string)
    ordered_cached_viewer_protocol_policy = string
    ordered_cached_origin_id = string
    ordered_cached_origin_path_pattern = string
    ordered_cached_domain_name = string
  }))
  default = [ {
    ordered_cache_allowed_methods = [ ]
    ordered_cached_methods = [ ]
    ordered_cached_viewer_protocol_policy = null
    ordered_cached_origin_id = null
    ordered_cached_origin_path_pattern = null
    ordered_cached_domain_name = null
  }]
}

variable "custom_error_response"{
  type = list(object({
    error_caching_min_ttl = string
    error_code = string
    response_code = string
    response_page_path = string
  }))
  default = [{
    error_caching_min_ttl = null
    error_code            = null
    response_code         = null
    response_page_path    = null
  }]
}
