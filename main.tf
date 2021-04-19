variable "name" {}

resource "azurerm_kubernetes_cluster" "main" {
  name                = var.name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = var.name

  default_node_pool {
    name       = var.name
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
    service_cidr       = "172.100.0.0/24"
    dns_service_ip     = "172.100.0.10"
    docker_bridge_cidr = "172.101.0.1/16"
    load_balancer_sku  = "standard"
  }

  role_based_access_control {
    enabled = true
  }
}

output "azurerm_kubernetes_cluster" {
  value = azurerm_kubernetes_cluster.main
}

output "kubeconfig" {
  value     = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive = true
}

output "k8s_host" {
  value = azurerm_kubernetes_cluster.main.kube_config[0].host
}

output "k8s_client_certificate" {
  value     = azurerm_kubernetes_cluster.main.kube_config[0].client_certificate
  sensitive = true
}

output "k8s_client_key" {
  value     = azurerm_kubernetes_cluster.main.kube_config[0].client_key
  sensitive = true
}

output "k8s_cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate
  sensitive = true
}
