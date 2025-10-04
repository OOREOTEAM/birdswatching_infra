output "jenkins_url" {
  description = "The URL to access the Jenkins web UI"
  value       = "http://${module.jenkins_server.private}:8080"
}