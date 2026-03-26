output "web_public_ip" {
  description = "Public IP of the web tier instance"
  value       = module.web.public_ip
}

output "web_url" {
  description = "URL to access the registration form"
  value       = "http://${module.web.public_ip}"
}

output "app_private_ip" {
  description = "Private IP of the application tier instance"
  value       = module.app.private_ip
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.db_endpoint
}
