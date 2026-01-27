resource "aws_cloudfront_distribution" "example_distribution" {
    aliases = var.alternate_domain_names
    default_cache_behavior {
      allowed_methods = var.allowed_methods    
      cached_methods = var.cached_methods
      viewer_protocol_policy = var.viewer_protocol_policy
      target_origin_id = var.default_origin_id
      forwarded_values {
        query_string = false
        cookies {
          forward = "none"
        }
      }
    } 
    dynamic ordered_cache_behavior {
      for_each =  var.ordered_cache_behaviour
      content{
        path_pattern = ordered_cache_behavior.value.path_pattern
        allowed_methods = ordered_cache_behavior.value.allowed_methods
        cached_methods = ordered_cache_behavior.value.cached_methods
        viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
        target_origin_id = ordered_cache_behavior.value.target_origin_id
        forwarded_values {
          query_string = false
          cookies {
            forward = "none"
          }
        }
      }
    } 

    dynamic custom_error_response {
      for_each = var.custom_error_response
      content{
        error_code = custom_error_response.value.error_code
        error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
        response_code = custom_error_response.value.response_code
        response_page_path = custom_error_response.value.response_page_path
      }
    }
    enabled = true

    dynamic origin {
      for_each = var.origin
      content{
        domain_name = origin.value.domain_name
        origin_id = origin.value.origin_id
        origin_path = origin.value.origin_path
      }
    }
    restrictions {
      geo_restriction {
        locations = [  ]
        restriction_type = "none"
      }
    }
    viewer_certificate {
      cloudfront_default_certificate = var.default_certificate
      acm_certificate_arn = var.acm_certificate
      ssl_support_method = var.default_certificate==false ? "sni-only":null
      minimum_protocol_version = var.default_certificate==false ? var.minimum_protocol_version:null
    }
}