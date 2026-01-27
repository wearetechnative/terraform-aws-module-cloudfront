# Terraform AWS Module Cloudfront ![](https://img.shields.io/github/workflow/status/TechNative-B-V/terraform-aws-module-name/tflint.yaml?style=plastic)

<!-- SHIELDS -->

This module implements ...

[![](we-are-technative.png)](https://www.technative.nl)

## How does it work

### First use after you clone this repository or when .pre-commit-config.yaml is updated

Run `pre-commit install` to install any guardrails implemented using pre-commit.

See [pre-commit installation](https://pre-commit.com/#install) on how to install pre-commit.

...

## Usage

To use this module ...

```hcl
module "cloudfront_distro"{
  source = "./cloudfront_module"
  aws_account_id = var.aws_account_id
  infra_environment = var.infra_environment
  git_url = var.git_url
  project = var.project
  distributions = {
    first = {
      allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
      cached_methods = ["GET", "HEAD"]
      viewer_protocol_policy = "redirect-to-https" //"Protocol that users can use to access the files in the origin. allow-all, https-only, or redirect-to-https.
      default_origin_id = "verzekeringskaarten.s3.eu-west-1.amazonaws.com"
      default_certificate = false
      acm_certificate = "arn:aws:acm:us-east-1:158565517012:certificate/9d1b2a9c-4b64-43a0-9d03-d6b1c841b920"
      minimum_protocol_version =  "TLSv1.2_2021"
      alternate_domain_names = ["benext-nonprod.technative.cloud"]
      origin = [
        {
          origin_id = "verzekeringskaarten.s3.eu-west-1.amazonaws.com"
          domain_name = "verzekeringskaarten-pank.s3.eu-west-1.amazonaws.com"
          origin_path = "/zorg"
        },
        {
          origin_id = "void_verzekeringskaarten.s3.eu-west-1.amazonaws.com"
          domain_name = "verzekeringskaarten-pank.s3.eu-west-1.amazonaws.com"
          origin_path = "/void"
        }
      ]
      custom_error_response = [
        {
          error_caching_min_ttl = 10
          error_code = 403
          response_code = 403
          response_page_path = "/index.html"
        }
      ]
      ordered_cache_behaviour = [
        {
          allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
          cached_methods = ["GET", "HEAD"]
          viewer_protocol_policy = "redirect-to-https"
          path_pattern = "/*/_archive/*"
          target_origin_id = "void_verzekeringskaarten.s3.eu-west-1.amazonaws.com"
        }
      ]
    },
    second = {
      allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
      cached_methods = ["GET", "HEAD"]
      viewer_protocol_policy = "redirect-to-https" //"Protocol that users can use to access the files in the origin. allow-all, https-only, or redirect-to-https.
      default_origin_id = "voorwarden_unitedconsumers_oac"
      default_certificate = true
      acm_certificate = ""
      minimum_protocol_version = "TLSv1.2_2021"
      alternate_domain_names = []
      origin = [
        {
          origin_id = "voorwarden_unitedconsumers_oac"
          domain_name = "verzekeringskaarten-pank.s3.eu-west-1.amazonaws.com"
          origin_path = "/voorwarden.unitedconsumers.com"
        },
      ]
      custom_error_response = []
      ordered_cache_behaviour = []
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
| [aws_cloudfront_distribution.new_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | ID of the AWS account. | `string` | n/a | yes |
| <a name="input_distributions"></a> [distributions](#input\_distributions) | Full description of distributions | <pre>map(object({<br>    allowed_methods = list(string)<br>    cached_methods = list(string)<br>    viewer_protocol_policy = string<br>    default_origin_id = string<br>    alternate_domain_names = list(string)<br>    default_certificate = bool<br>    acm_certificate = string<br>    minimum_protocol_version = string<br>    origin = list(object({<br>      origin_id = string<br>      origin_path = string<br>      domain_name = string<br>    }))<br>    custom_error_response = list(object({<br>      error_caching_min_ttl = number<br>      error_code = number<br>      response_code = number<br>      response_page_path = string<br>    }))<br>    ordered_cache_behaviour = list(object({<br>      allowed_methods = list(string)<br>      cached_methods = list(string)<br>      viewer_protocol_policy = string<br>      target_origin_id = string<br>      path_pattern = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_git_url"></a> [git\_url](#input\_git\_url) | Git repository ID or URL for tagging and tracking. | `string` | n/a | yes |
| <a name="input_infra_environment"></a> [infra\_environment](#input\_infra\_environment) | Name of the infrastructure environment. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of the project. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
