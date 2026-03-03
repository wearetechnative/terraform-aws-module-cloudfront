locals {
  oac_origins = { for item in flatten([
    for dist_key, dist in var.distributions : [
      for origin in dist.origin : {
        key      = "${dist_key}-${origin.origin_id}"
        dist_key = dist_key
        origin   = origin
      } if origin.create_oac == true
    ]
  ]) : item.key => item }
}
