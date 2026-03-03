output "distribution_ids" {
    value = { for k, v in aws_cloudfront_distribution.this : k => v.id }
}

output "distribution_arns" {
    value = { for k, v in aws_cloudfront_distribution.this : k => v.arn }
}

output "distribution_domain_names" {
    value = { for k, v in aws_cloudfront_distribution.this : k => v.domain_name }
}

output "oac_ids" {
    value = { for k, v in aws_cloudfront_origin_access_control.this : k => v.id }
}
