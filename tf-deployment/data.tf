data "external" "helm-secrets-api" {
  program = ["helm", "secrets", "terraform", "charts/api/secrets.yaml"]
}

data "external" "helm-secrets-db" {
  program = ["helm", "secrets", "terraform", "charts/mariadb/secrets.yaml"]
}

data "external" "helm-secrets-dd" {
  program = ["helm", "secrets", "terraform", "charts/datadog/secrets.yaml"]
}