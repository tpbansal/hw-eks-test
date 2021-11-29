# ---------------------------------------------------------------------------------------------------------------------
# K8 Deployment and Service - Using K8 provider
# ---------------------------------------------------------------------------------------------------------------------

## K8 Deployment
resource "kubernetes_deployment" "app" {
  metadata {
    name = "my-app-deployment"
    labels = {
      app  = "my-app-hw"
    }
  }
spec {
    replicas = 2
selector {
      match_labels = {
        app  = "my-app-hw"
      }
    }
template {
      metadata {
        labels = {
          app  = "my-app-hw"
        }
      }
spec {
        container {
          image = "170278396916.dkr.ecr.eu-central-1.amazonaws.com/dribing:my-app-hw"
          name  = "my-app-hw-container"
          port {
            container_port = 80
         }
        }
      }
    }
  }
}

## K8 Service - LB
resource "kubernetes_service" "app" {
  depends_on = [kubernetes_deployment.app]
  metadata {
    name = "my-app-hw-service"
  }
  spec {
    selector = {
      app = "my-app-hw"
    }
    port {
      port        = 80
      target_port = 80
    }
type = "LoadBalancer"
}
}