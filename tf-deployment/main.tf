##################################################
# Datadog
##################################################

module "datadog" {
  source = "git::https://github.com/the-bob/helm-module.git"

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
  source = "git::https://github.com/the-bob/helm-module.git"

  name = "ingress-nginx"

  namespace = "default"

  repository    = "https://kubernetes.github.io/ingress-nginx"
  chart_name    = "ingress-nginx"
  chart_version = "4.0.18"
  wait          = false
}

##################################################
# Maria DB Database
##################################################

module "database" {
  source = "git::https://github.com/the-bob/helm-module.git"

  name = "database"

  namespace        = "database"
  create_namespace = true

  repository    = "https://charts.bitnami.com/bitnami/"
  chart_name    = "mariadb"
  chart_version = "11.0.2"

  secret_files = [base64decode(data.external.helm-secrets-db.result.content_base64)]
}

##################################################
# API Server
##################################################

module "api" {

  source = "git::https://github.com/the-bob/helm-module.git"

  name = "api"

  namespace        = "api"
  create_namespace = true

  repository    = "https://the-bob.github.io/chartmuseum/"
  chart_name    = "api"
  chart_version = "0.1.9"

  values_files = ["charts/api/values.yaml"]
  secret_files = [base64decode(data.external.helm-secrets-api.result.content_base64)]

}

##################################################
# Argo CD
##################################################

module "argocd" {
  source = "git::https://github.com/the-bob/helm-module.git"

  name = "argocd"

  namespace        = "argocd"
  create_namespace = true

  repository    = "https://argoproj.github.io/argo-helm/"
  chart_name    = "argo-cd"
  chart_version = "4.5.11"

  values_files = ["charts/argocd/values.yaml"]
}


##################################################
# DB Tunneller for DEV
##################################################

module "db_tunneller" {
  count  = var.install_db_tunneller ? 1 : 0
  source = "git::https://github.com/the-bob/helm-module.git"

  name = "db-tunneller"

  namespace        = "database"
  create_namespace = true

  repository    = "https://charts.helm.sh/stable/"
  chart_name    = "socat-tunneller"
  chart_version = "0.1.2"

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


