output "workspace_arn" {
    description = "The Amazon Resource name (ARN) of the Grafana Workspace"
    value = aws_grafana_workspace.grafanaspace.arn 
}
output "workspace_endpoint" {
    description = "The endpoint of the Grafana workspace"
    value = aws_grafana_workspace.grafanaspace.endpoint
}