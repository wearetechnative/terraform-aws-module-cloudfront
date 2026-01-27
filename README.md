> START INSTRUCTION FOR TECHNATIVE ENGINEERS

# terraform-aws-module-template

Template for creating a new TerraForm AWS Module. For TechNative Engineers.

## Instructions

### Your Module Name

Think hard and come up with the shortest descriptive name for your module.
Look at competition in the [terraform
registry](https://registry.terraform.io/).

Your module name should be max. three words seperated by dashes. E.g.

- html-form-action
- new-account-notifier
- budget-alarms
- fix-missing-tags

### Setup Github Project

1. Click the template button on the top right...
1. Name github project `terraform-aws-[your-module-name]`
1. Make project private untill ready for publication
1. Add a description in the `About` section (top right)
1. Add tags: `terraform`, `terraform-module`, `aws` and more tags relevant to your project: e.g. `s3`, `lambda`, `sso`, etc..
1. Install `pre-commit`

### Develop your module

1. Develop your module
1. Try to use the [best practices for TerraForm
   development](https://www.terraform-best-practices.com/) and [TerraForm AWS
   Development](https://github.com/ozbillwang/terraform-best-practices).

## Finish project documentation

1. Set well written title
2. Add one or more shields
3. Start readme with a short and complete as possible module description. This
   is the part where you sell your module.
4. Complete README with well written documentation. Try to think as a someone
   with three months of Terraform experience.
5. Check if pre-commit correctly generates the standard Terraform documentation.

## Publish module

If your module is in a state that it could be useful for others and ready for
publication, you can publish a first version.

1. Create a [Github
   Release](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)
2. Publish in the TerraForm Registry under the Technative Namespace (the GitHub
   Repo must be in the TechNative Organization)

---

> END INSTRUCTION FOR TECHNATIVE ENGINEERS


# Terraform AWS [Module Name] ![](https://img.shields.io/github/workflow/status/TechNative-B-V/terraform-aws-module-name/tflint.yaml?style=plastic)

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
{
  some_conf = "might need explanation"
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
| [aws_cloudfront_distribution.example_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate"></a> [acm\_certificate](#input\_acm\_certificate) | ARN of the AWS Certificate Manager certificate that you wish to use with this distribution | `string` | n/a | yes |
| <a name="input_allowed_methods"></a> [allowed\_methods](#input\_allowed\_methods) | Which HTTP methods CloudFront processes and forwards to origin. | `list(string)` | n/a | yes |
| <a name="input_alternate_domain_names"></a> [alternate\_domain\_names](#input\_alternate\_domain\_names) | Extra CNAMEs (alternate domain names), if any, for this distribution. | `list(string)` | `[]` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | ID of the AWS account. | `string` | n/a | yes |
| <a name="input_cached_methods"></a> [cached\_methods](#input\_cached\_methods) | CloudFront caches the response to requests using the specified HTTP methods. | `list(string)` | n/a | yes |
| <a name="input_custom_error_response"></a> [custom\_error\_response](#input\_custom\_error\_response) | Cloudfront error response elements | <pre>list(object({<br>    error_caching_min_ttl = number<br>    error_code = number<br>    response_code = number<br>    response_page_path = string<br>  }))</pre> | <pre>[<br>  {<br>    "error_caching_min_ttl": 0,<br>    "error_code": 0,<br>    "response_code": 0,<br>    "response_page_path": null<br>  }<br>]</pre> | no |
| <a name="input_default_certificate"></a> [default\_certificate](#input\_default\_certificate) | It is true when using CloudFront domain name for the distribution | `bool` | `true` | no |
| <a name="input_default_origin_id"></a> [default\_origin\_id](#input\_default\_origin\_id) | The origin id which you want as default for your distribution | `string` | n/a | yes |
| <a name="input_git_url"></a> [git\_url](#input\_git\_url) | Git repository ID or URL for tagging and tracking. | `string` | n/a | yes |
| <a name="input_infra_environment"></a> [infra\_environment](#input\_infra\_environment) | Name of the infrastructure environment. | `string` | n/a | yes |
| <a name="input_minimum_protocol_version"></a> [minimum\_protocol\_version](#input\_minimum\_protocol\_version) | Minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections | `string` | n/a | yes |
| <a name="input_ordered_cache_behaviour"></a> [ordered\_cache\_behaviour](#input\_ordered\_cache\_behaviour) | Ordered list of cache behaviors(The topmost cache behavior will have precedence 0.) | <pre>list(object({<br>    allowed_methods = list(string)<br>    cached_methods = list(string)<br>    viewer_protocol_policy = string<br>    target_origin_id = string<br>    path_pattern = string<br>  }))</pre> | <pre>[<br>  {<br>    "allowed_methods": [],<br>    "cached_methods": [],<br>    "path_pattern": null,<br>    "target_origin_id": null,<br>    "viewer_protocol_policy": null<br>  }<br>]</pre> | no |
| <a name="input_origin"></a> [origin](#input\_origin) | Origins for this distribution | <pre>list(object({<br>    origin_id = string<br>    origin_path = string<br>    domain_name = string<br><br>  }))</pre> | <pre>[<br>  {<br>    "domain_name": null,<br>    "origin_id": null,<br>    "origin_path": null<br>  }<br>]</pre> | no |
| <a name="input_project"></a> [project](#input\_project) | Name of the project. | `string` | n/a | yes |
| <a name="input_viewer_protocol_policy"></a> [viewer\_protocol\_policy](#input\_viewer\_protocol\_policy) | Protocol that users can use to access the files in the origin. allow-all, https-only, or redirect-to-https. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
