locals {
    cloudfront_distribution = { for k, value in flatten([
        for key, value in var.distributions : {
            distribution_name = key
            allowed_methods = value.allowed_methods
            cached_methods = value.cached_methods
            viewer_protocol_policy = value.viewer_protocol_policy
            default_origin_id = value.default_origin_id
            default_certificate = value.default_certificate
            acm_certificate = value.acm_certificate
            minimum_protocol_version = value.minimum_protocol_version 
            alternate_domain_names = value.alternate_domain_names
            origin = value.origin
            custom_error_response = value.custom_error_response
            ordered_cache_behaviour = value.ordered_cache_behaviour
        }
    ]): "${value.distribution_name}" => value}
}