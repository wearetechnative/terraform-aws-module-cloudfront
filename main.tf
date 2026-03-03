resource "aws_cloudfront_origin_access_control" "this" {
  for_each = local.oac_origins

  name                              = each.value.origin.oac_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  for_each            = var.distributions
  aliases             = each.value.alternate_domain_names
  comment             = each.value.comment
  enabled             = each.value.enabled
  price_class         = each.value.price_class
  http_version        = each.value.http_version
  is_ipv6_enabled     = each.value.is_ipv6_enabled
  web_acl_id          = each.value.web_acl_id
  default_root_object = each.value.default_root_object
  default_cache_behavior {
    allowed_methods        = each.value.allowed_methods
    cached_methods         = each.value.cached_methods
    viewer_protocol_policy = each.value.viewer_protocol_policy
    target_origin_id       = each.value.default_origin_id
    cache_policy_id        = each.value.cache_policy_id
    compress               = each.value.compress

    dynamic "function_association" {
      for_each = each.value.function_associations != null ? each.value.function_associations : []
      content {
        event_type   = function_association.value.event_type
        function_arn = function_association.value.function_arn
      }
    }
  }
  dynamic "ordered_cache_behavior" {
    for_each = each.value.ordered_cache_behavior != null ? each.value.ordered_cache_behavior : []

    content {
      path_pattern           = ordered_cache_behavior.value.path_pattern
      allowed_methods        = ordered_cache_behavior.value.allowed_methods
      cached_methods         = ordered_cache_behavior.value.cached_methods
      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
      target_origin_id       = ordered_cache_behavior.value.target_origin_id
      cache_policy_id        = ordered_cache_behavior.value.cache_policy_id
      compress               = ordered_cache_behavior.value.compress

      dynamic "function_association" {
        for_each = ordered_cache_behavior.value.function_associations != null ? ordered_cache_behavior.value.function_associations : []
        content {
          event_type   = function_association.value.event_type
          function_arn = function_association.value.function_arn
        }
      }
    }

  }

  dynamic "custom_error_response" {
    for_each = each.value.custom_error_response != null ? each.value.custom_error_response : []
    content {
      error_code            = custom_error_response.value.error_code
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
    }

  }

  dynamic "origin" {
    for_each = each.value.origin
    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id
      origin_path = origin.value.origin_path

      origin_access_control_id = (
        origin.value.create_oac == true
        ? aws_cloudfront_origin_access_control.this["${each.key}-${origin.value.origin_id}"].id
        : origin.value.origin_access_control_id
      )

      dynamic "s3_origin_config" {
        for_each = origin.value.s3_origin_config != null ? [origin.value.s3_origin_config] : []
        content {
          origin_access_identity = s3_origin_config.value.origin_access_identity
        }
      }

      dynamic "custom_origin_config" {
        for_each = origin.value.custom_origin_config != null ? [origin.value.custom_origin_config] : []
        content {
          http_port              = custom_origin_config.value.http_port
          https_port             = custom_origin_config.value.https_port
          origin_protocol_policy = custom_origin_config.value.origin_protocol_policy
          origin_ssl_protocols   = custom_origin_config.value.origin_ssl_protocols
        }
      }
    }


  }
  restrictions {
    geo_restriction {
      restriction_type = each.value.geo_restriction.restriction_type
      locations        = each.value.geo_restriction.locations
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = each.value.default_certificate
    acm_certificate_arn            = each.value.acm_certificate
    ssl_support_method             = each.value.default_certificate == false ? "sni-only" : null
    minimum_protocol_version       = each.value.default_certificate == false ? each.value.minimum_protocol_version : null
  }
}

