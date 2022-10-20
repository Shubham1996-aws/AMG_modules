module "Grafana" {
    source = "./AMG"
    name = "Demo"
    account_id = [ "" ]
    account_access_type = "CURRENT_ACCOUNT"
    authentication_providers = ["AWS_SSO"]
    permission_type = "CUSTOMER_MANAGED"
    Admin_permission = "ADMIN"

}
