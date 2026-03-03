locals {
    cloudfront_distribution = { for key, value in var.distributions : key => {
            distribution_name = key
            allowed_methods = value.allowed_methods
            cached_methods = value.cached_methods
            viewer_protocol_policy = value.viewer_protocol_policy
            default_origin_id = value.default_origin_id
            cache_policy_id = value.cache_policy_id
            compress = value.compress
            comment = value.comment
            price_class = value.price_class
            http_version = value.http_version
            is_ipv6_enabled = value.is_ipv6_enabled
            web_acl_id = value.web_acl_id
            default_certificate = value.default_certificate
            acm_certificate = value.acm_certificate
            minimum_protocol_version = value.minimum_protocol_version 
            alternate_domain_names = value.alternate_domain_names
            function_associations = value.function_associations
            origin = value.origin
            custom_error_response = value.custom_error_response
            ordered_cache_behaviour = value.ordered_cache_behaviour
        }
    }

    oac_origins = { for item in flatten([
        for dist_key, dist in var.distributions : [
            for origin in dist.origin : {
                key = "${dist_key}-${origin.origin_id}"
                dist_key = dist_key
                origin = origin
            } if origin.create_oac == true
        ]
    ]): item.key => item}
}
