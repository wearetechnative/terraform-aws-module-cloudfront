# Terraform AWS Module Cloudfront ![](https://img.shields.io/github/workflow/status/TechNative-B-V/terraform-aws-module-name/tflint.yaml?style=plastic)

<!-- SHIELDS -->

This module implements AWS CloudFront distributions with full support for Origin Access Control (OAC), CloudFront functions, cache policies, WAF associations, custom origins, and ordered cache behaviours.

[![](we-are-technative.png)](https://www.technative.nl)

## How does it work

This Terraform module provisions multiple AWS CloudFront distributions based on the configuration values you supply. Each entry in the `distributions` map creates one distribution. The module also creates `aws_cloudfront_origin_access_control` resources for any origin that has `create_oac = true`.

The examples below cover the three most common patterns:

1. **Standard S3 distribution** — single S3 origin with OAC created by the module, a managed cache policy, a CloudFront viewer-request function, and a custom ACM certificate.
2. **Multi-origin distribution** — two S3 origins with OAC, an ordered cache behaviour routing a path pattern to a secondary origin, and a custom error response.
3. **Custom (ALB / S3-website) origin** — no OAC, using `custom_origin_config` for HTTPS-only forwarding to a load balancer.

### First use after you clone this repository or when .pre-commit-config.yaml is updated

Run `pre-commit install` to install any guardrails implemented using pre-commit.

See [pre-commit installation](https://pre-commit.com/#install) on how to install pre-commit.

## Usage

```hcl
resource "aws_cloudfront_function" "url_index_rewrite" {
  name    = "url-index-rewrite"
  runtime = "cloudfront-js-2.0"
  code    = file("${path.module}/files/url-index-rewrite.js")
}

module "cloudfront" {
  source            = "git@github.com:wearetechnative/terraform-aws-module-cloudfront.git"
  aws_account_id    = var.aws_account_id
  infra_environment = var.infra_environment
  git_url           = var.git_url
  project           = var.project

  distributions = {

    "voorwaarden.example.nl" = {
      allowed_methods          = ["GET", "HEAD"]
      cached_methods           = ["GET", "HEAD"]
      viewer_protocol_policy   = "redirect-to-https"
      default_origin_id        = "publications-example.s3.eu-central-1.amazonaws.com"
      cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
      comment                  = "Example - voorwaarden"
      alternate_domain_names   = ["voorwaarden.example.nl"]
      default_certificate      = false
      acm_certificate          = "arn:aws:acm:us-east-1:123456789012:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
      minimum_protocol_version = "TLSv1.2_2021"

      function_associations = [
        {
          event_type   = "viewer-request"
          function_arn = aws_cloudfront_function.url_index_rewrite.arn
        }
      ]

      origin = [
        {
          origin_id   = "publications-example.s3.eu-central-1.amazonaws.com"
          domain_name = "publications-example.s3.eu-central-1.amazonaws.com"
          create_oac  = true
        }
      ]
    }

    "www.example-archive.nl" = {
      allowed_methods          = ["GET", "HEAD"]
      cached_methods           = ["GET", "HEAD"]
      viewer_protocol_policy   = "redirect-to-https"
      default_origin_id        = "publications-archive.s3.eu-west-1.amazonaws.com"
      cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
      comment                  = "Example archive site"
      alternate_domain_names   = ["www.example-archive.nl", "example-archive.nl"]
      default_certificate      = false
      acm_certificate          = "arn:aws:acm:us-east-1:123456789012:certificate/yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"
      minimum_protocol_version = "TLSv1.2_2021"

      function_associations = [
        {
          event_type   = "viewer-request"
          function_arn = aws_cloudfront_function.url_index_rewrite.arn
        }
      ]

      origin = [
        {
          origin_id   = "publications-archive.s3.eu-west-1.amazonaws.com"
          domain_name = "publications-archive.s3.eu-west-1.amazonaws.com"
          origin_path = "/live"
          create_oac  = true
        },
        {
          origin_id   = "void_publications-archive.s3.eu-west-1.amazonaws.com"
          domain_name = "publications-archive.s3.eu-west-1.amazonaws.com"
          origin_path = "/void"
          create_oac  = true
        }
      ]

      ordered_cache_behaviour = [
        {
          path_pattern           = "/*/_archive/*"
          allowed_methods        = ["GET", "HEAD"]
          cached_methods         = ["GET", "HEAD"]
          viewer_protocol_policy = "redirect-to-https"
          target_origin_id       = "void_publications-archive.s3.eu-west-1.amazonaws.com"
          cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
        }
      ]

      custom_error_response = [
        {
          error_code            = 403
          error_caching_min_ttl = 10
          response_code         = 404
          response_page_path    = "/index.html"
        }
      ]
    }

    "app.example.nl" = {
      allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
      cached_methods           = ["GET", "HEAD"]
      viewer_protocol_policy   = "redirect-to-https"
      default_origin_id        = "alb-example"
      cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
      comment                  = "Example ALB origin"
      alternate_domain_names   = ["app.example.nl"]
      default_certificate      = false
      acm_certificate          = "arn:aws:acm:us-east-1:123456789012:certificate/zzzzzzzz-zzzz-zzzz-zzzz-zzzzzzzzzzzz"
      minimum_protocol_version = "TLSv1.2_2021"
      web_acl_id               = "arn:aws:wafv2:us-east-1:123456789012:global/webacl/example-acl/xxxxxxxx"

      origin = [
        {
          origin_id   = "alb-example"
          domain_name = "my-alb-1234567890.eu-west-1.elb.amazonaws.com"
          custom_origin_config = {
            origin_protocol_policy = "https-only"
            origin_ssl_protocols   = ["TLSv1.2"]
          }
        }
      ]
    }

  }
}
```

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | ID of the AWS account. | `string` | n/a | yes |
| <a name="input_git_url"></a> [git\_url](#input\_git\_url) | Git repository ID or URL for tagging and tracking. | `string` | n/a | yes |
| <a name="input_infra_environment"></a> [infra\_environment](#input\_infra\_environment) | Name of the infrastructure environment. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of the project. | `string` | n/a | yes |
| <a name="input_distributions"></a> [distributions](#input\_distributions) | Map of CloudFront distribution configurations. Each key is a logical distribution name. | `map(object({...}))` | `{}` | no |

### `distributions` object fields

**Distribution-level:**

| Field | Type | Default | Description |
|---|---|---|---|
| `allowed_methods` | `list(string)` | required | HTTP methods CloudFront processes and forwards to the origin. |
| `cached_methods` | `list(string)` | required | HTTP methods whose responses CloudFront caches. |
| `viewer_protocol_policy` | `string` | required | `allow-all`, `https-only`, or `redirect-to-https`. |
| `default_origin_id` | `string` | required | `origin_id` of the origin used as the default. |
| `default_certificate` | `bool` | required | Set `true` to use the CloudFront default certificate instead of ACM. |
| `minimum_protocol_version` | `string` | required | Minimum TLS version, e.g. `TLSv1.2_2021`. Ignored when `default_certificate = true`. |
| `cache_policy_id` | `optional(string)` | `null` | ID of the cache policy to attach. Use `658327ea-f89d-4fab-a63d-7e88639e58f6` for the AWS-managed Caching Optimized policy. |
| `compress` | `optional(bool)` | `true` | Enable automatic object compression. |
| `comment` | `optional(string)` | `null` | Human-readable description shown in the AWS console. |
| `price_class` | `optional(string)` | `"PriceClass_100"` | `PriceClass_100`, `PriceClass_200`, or `PriceClass_All`. |
| `http_version` | `optional(string)` | `"http2"` | `http1.1`, `http2`, `http2and3`, or `http3`. |
| `is_ipv6_enabled` | `optional(bool)` | `true` | Enable IPv6. |
| `web_acl_id` | `optional(string)` | `null` | ARN of a CloudFront-scoped WAF v2 Web ACL (`us-east-1`). |
| `alternate_domain_names` | `optional(list(string))` | `null` | CNAMEs for the distribution. |
| `acm_certificate` | `optional(string)` | `null` | ACM certificate ARN in `us-east-1`. Required when `default_certificate = false`. |
| `function_associations` | `optional(list(object))` | `null` | CloudFront function associations for the default cache behavior. See below. |
| `origin` | `list(object)` | required | List of origins. See below. |
| `custom_error_response` | `optional(list(object))` | `null` | Custom error response rules. See below. |
| `ordered_cache_behaviour` | `optional(list(object))` | `null` | Ordered cache behaviors evaluated before the default. See below. |

**`function_associations` object:**

| Field | Type | Description |
|---|---|---|
| `event_type` | `string` | `viewer-request` or `viewer-response`. |
| `function_arn` | `string` | ARN of the `aws_cloudfront_function`. |

**`origin` object:**

| Field | Type | Default | Description |
|---|---|---|---|
| `origin_id` | `string` | required | Unique identifier for this origin within the distribution. |
| `domain_name` | `string` | required | DNS name of the origin (S3 bucket regional endpoint or ALB DNS name). |
| `origin_path` | `optional(string)` | `""` | Path prefix CloudFront appends to requests. |
| `create_oac` | `optional(bool)` | `false` | When `true`, the module creates an `aws_cloudfront_origin_access_control` for this origin. |
| `origin_access_control_id` | `optional(string)` | `null` | ID of an externally managed OAC. Used when `create_oac = false` but OAC is still required. |
| `s3_origin_config` | `optional(object)` | `null` | Legacy OAI config. Set `origin_access_identity` to the OAI path. |
| `custom_origin_config` | `optional(object)` | `null` | Required for ALB or S3-website origins. See fields below. |

**`custom_origin_config` object:**

| Field | Type | Default | Description |
|---|---|---|---|
| `origin_protocol_policy` | `string` | required | `http-only`, `https-only`, or `match-viewer`. |
| `origin_ssl_protocols` | `list(string)` | required | e.g. `["TLSv1.2"]`. |
| `http_port` | `optional(number)` | `80` | HTTP port on the origin. |
| `https_port` | `optional(number)` | `443` | HTTPS port on the origin. |

**`ordered_cache_behaviour` object:**

| Field | Type | Default | Description |
|---|---|---|---|
| `path_pattern` | `string` | required | Path pattern this behavior applies to, e.g. `/api/*`. |
| `target_origin_id` | `string` | required | `origin_id` of the origin to route matching requests to. |
| `allowed_methods` | `list(string)` | required | HTTP methods CloudFront processes. |
| `cached_methods` | `list(string)` | required | HTTP methods whose responses are cached. |
| `viewer_protocol_policy` | `string` | required | `allow-all`, `https-only`, or `redirect-to-https`. |
| `cache_policy_id` | `optional(string)` | `null` | Cache policy ID for this behavior. |
| `compress` | `optional(bool)` | `true` | Enable compression for this behavior. |
| `function_associations` | `optional(list(object))` | `null` | CloudFront function associations for this behavior. |

**`custom_error_response` object:**

| Field | Type | Description |
|---|---|---|
| `error_code` | `number` | HTTP error code from the origin, e.g. `403`. |
| `response_code` | `number` | HTTP status code returned to the viewer. |
| `response_page_path` | `string` | Path to the custom error page, e.g. `/index.html`. |
| `error_caching_min_ttl` | `number` | Minimum TTL (seconds) to cache the error response. |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_distribution_ids"></a> [distribution\_ids](#output\_distribution\_ids) | Map of distribution keys to CloudFront distribution IDs. |
| <a name="output_distribution_arns"></a> [distribution\_arns](#output\_distribution\_arns) | Map of distribution keys to CloudFront distribution ARNs. |
| <a name="output_distribution_domain_names"></a> [distribution\_domain\_names](#output\_distribution\_domain\_names) | Map of distribution keys to CloudFront distribution domain names. |
| <a name="output_oac_ids"></a> [oac\_ids](#output\_oac\_ids) | Map of OAC keys to Origin Access Control IDs created by this module. |
<!-- END_TF_DOCS -->
