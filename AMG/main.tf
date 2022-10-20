####### Workspace Creation #########
resource "aws_grafana_workspace" "grafanaspace" {
  name = var.name
  account_access_type      = var.account_access_type
  authentication_providers = var.authentication_providers
  permission_type          = var.permission_type
  role_arn                 = aws_iam_role.AMGPrometheusDataSource-role.arn
  tags = {
    "Name" = var.name
  }
}

### Cross account iam role ######
resource "aws_iam_role" "AMGPrometheusDataSource-role" {
  name = var.aws_iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "grafana.amazonaws.com"
        }
      },
    ]
  })
}
### policy creation ####

resource "aws_iam_policy" "AMGPrometheusDataSource-policy" {
  name        = var.aws_iam_policy_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "VisualEditor0",
        Action = "sts:AssumeRole",
        Effect   = "Allow",
        Resource = [
          "arn:aws:iam::${var.account_id[0]}:role/AMGPrometheusDataSourceRole-Development",
          "arn:aws:iam::${var.account_id[0]}:role/AMGCloudWatchDataSourceRole-Development",
          "arn:aws:iam::${var.account_id[1]}:role/AMGCloudWatchDataSourceRole-Distinct",
        ]
      },
    ]
  })
}

#### policy attachment ###
resource "aws_iam_policy_attachment" "AMGPrometheusDataSource-policyattachment" {
  name       = "AMGPrometheusDataSource-policyattachment"
  roles      = [aws_iam_role.AMGPrometheusDataSource-role.name]
  policy_arn = aws_iam_policy.AMGPrometheusDataSource-policy.arn
}


resource "aws_grafana_workspace_api_key" "key" {
  key_name        = "admin"
  key_role        = var.Admin_permission
  seconds_to_live = 3600
  workspace_id    = aws_grafana_workspace.grafanaspace.id
}
/*resource "aws_grafana_role_association" "example" {
  role         = "ADMIN"
  user_ids     = ["USER_ID_1", "USER_ID_2"]
  workspace_id = aws_grafana_workspace.example.id
}*/

output "namespace" {
  value = aws_grafana_workspace.grafanaspace.name
  
}