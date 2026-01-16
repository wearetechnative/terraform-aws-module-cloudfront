resource "aws_cloudfront_distribution" "example_distribution" {
    aliases = var.alternate_domain_names
    default_cache_behavior {
      allowed_methods = var.allowed_methods    
      cached_methods = var.cached_methods
      viewer_protocol_policy = var.viewer_protocol_policy
      target_origin_id = var.origin_id
      forwarded_values {
        query_string = false
        cookies {
         forward = "none"
        }
     }
    } 
    dynamic ordered_cache_behavior {
      for_each = var.ordered_cache_behaviour
      content{
        allowed_methods = each.value.ordered_cache_allowed_methods
        cached_methods = each.value.ordered_cached_methods
        viewer_protocol_policy = each.value.ordered_viewer_protocol_policy
        path_pattern = each.value.ordered_cached_origin_path_pattern
        target_origin_id = each.value.ordered_cached_origin_id
      }
    } 

    dynamic custom_error_response {
      for_each = var.custom_error_response
      content{
        error_caching_min_ttl = each.value.error_caching_min_ttl
        error_code = each.value.error_code
        response_code = each.value.response_code

      }
      
    }
    enabled = true
    origin {
        domain_name = var.domain_name
        origin_id = var.origin_id
        origin_path = var.origin_path
    }
    restrictions {
      geo_restriction {
        locations = [  ]
        restriction_type = "none"
      }
    }
    viewer_certificate {
      cloudfront_default_certificate = true
    }
}
