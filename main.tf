resource "aws_cloudfront_distribution" "new_distribution" {
    for_each = local.cloudfront_distribution
    aliases = each.value.alternate_domain_names
    default_cache_behavior {
      allowed_methods = each.value.allowed_methods    //["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
      cached_methods = each.value.cached_methods//["GET", "HEAD"]
      viewer_protocol_policy = each.value.viewer_protocol_policy//"redirect-to-https"
      target_origin_id = each.value.default_origin_id//"d3sizd68cnvctg"
      forwarded_values {
        query_string = false
        cookies {
         forward = "none"
        }
     }
    } 
    dynamic ordered_cache_behavior {
      for_each =  each.value.ordered_cache_behaviour
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
      for_each = each.value.custom_error_response
      content{
        error_code = custom_error_response.value.error_code
        error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
        response_code = custom_error_response.value.response_code
        response_page_path = custom_error_response.value.response_page_path
      }
        
    }
    enabled = true

    dynamic origin {
      for_each = each.value.origin
      content{
        domain_name = origin.value.domain_name//"websitepankhuri.s3.eu-central-1.amazonaws.com"
        origin_id = origin.value.origin_id//"d3sizd68cnvctg"
        origin_path = origin.value.origin_path//"/index.html"
      }
        
    
    }
    restrictions {
      geo_restriction {
        locations = [  ]
        restriction_type = "none"
      }
    }
    viewer_certificate {
      cloudfront_default_certificate = each.value.default_certificate
      acm_certificate_arn = each.value.acm_certificate
      ssl_support_method = each.value.default_certificate==false ? "sni-only":null
      minimum_protocol_version = each.value.default_certificate==false ? each.value.minimum_protocol_version:null
    }
}
    