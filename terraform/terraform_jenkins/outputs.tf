output "vpc_id" {
  description = "The BirdWatching-VPC id"
  value = module.network.vpc_id
}

output "gw_main" {
  description = "The internet gateway id"
  value = module.network.gw_main
}