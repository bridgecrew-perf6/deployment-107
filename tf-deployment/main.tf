##################################################
# Datadog
##################################################

module "datadog" {
  source = "git::https://github.com/the-bob/helm-module.git?ref=v0.2.0"

  name = "datadog"

  namespace = "default"

  repository    = "https://helm.datadoghq.com"
  chart_name    = "datadog"
  chart_version = "2.33.4"
  wait          = false
  values_files  = ["charts/datadog/values.yaml"]
  secret_files  = [base64decode(data.external.helm-secrets-dd.result.content_base64)]

  set = [
    {
      name  = "datadog.clusterName"
      value = "minikube"
    },
  ]
}

##################################################
# Ingress Nginx
##################################################

module "ingress" {
  source = "git::https://github.com/the-bob/helm-module.git?ref=v0.2.0"

  name = "ingress-nginx"

  namespace = "default"

  repository    = "https://kubernetes.github.io/ingress-nginx"
  chart_name    = "ingress-nginx"
  chart_version = "4.0.18"
  wait          = false

  wait_in_seconds = 180
}


##################################################
# Maria DB Database
##################################################

module "database" {
  source = "git::https://github.com/the-bob/helm-module.git?ref=v0.2.0"

  name = "database"

  namespace        = "database"
  create_namespace = true

  repository    = "https://charts.bitnami.com/bitnami/"
  chart_name    = "mariadb"
  chart_version = var.mariadb_charts_version

  secret_files = [base64decode(data.external.helm-secrets-db.result.content_base64)]
}

##################################################
# API Server
##################################################

module "api" {
  depends_on = [
    module.ingress,
    module.database
  ]
  source = "git::https://github.com/the-bob/helm-module.git?ref=v0.2.0"

  name = "api"

  namespace        = "api"
  create_namespace = true

  repository    = "https://the-bob.github.io/chartmuseum/"
  chart_name    = "api"
  chart_version = var.api_charts_version

  values_files = ["charts/api/values.yaml"]
  secret_files = [base64decode(data.external.helm-secrets-api.result.content_base64)]
  set = [
    {
      name  = "ingress.hosts[0].host"
      value = var.api_host
    },
    {
      name  = "ingress.hosts[1].host"
      value = var.api_host
    }
  ]
}

##################################################
# Argo CD
##################################################

module "argocd" {
  depends_on = [
    module.ingress
  ]
  source = "git::https://github.com/the-bob/helm-module.git?ref=v0.2.0"

  name = "argocd"

  namespace        = "argocd"
  create_namespace = true

  repository    = "https://argoproj.github.io/argo-helm/"
  chart_name    = "argo-cd"
  chart_version = var.argocd_charts_version

  values_files = ["charts/argocd/values.yaml"]
}


##################################################
# DB Tunneller for DEV
##################################################

module "db_tunneller" {
  depends_on = [
    module.database
  ]
  count  = var.install_db_tunneller ? 1 : 0
  source = "git::https://github.com/the-bob/helm-module.git?ref=v0.2.0"

  name = "db-tunneller"

  namespace        = "database"
  create_namespace = true

  repository    = "https://charts.helm.sh/stable/"
  chart_name    = "socat-tunneller"
  chart_version = var.socat_tunneller_charts_version

  set = [
    {
      name  = "tunnel.host"
      value = "apidb.default.svc.cluster.local"
    },
    {
      name  = "tunnel.port"
      value = "3306"
    },
  ]
}


