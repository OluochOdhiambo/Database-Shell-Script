resource "azurerm_kubernetes_cluster" "learningazure_aks" {
    name = var.base_name
    location = var.location
    resource_group_name = azurerm_resource_group.learningazure_rg.name
    dns_prefix = var.base_name
    kubernetes_version = "1.24.9"

    default_node_pool {
            name = "default"
            node_count = 1
            vm_size = "Standard_B2ms"
        }

    service_principal {
            client_id = var.client_id
            client_secret = var.client_secret
        }

    linux_profile {
        admin_username = var.admin_username

        ssh_key {
            key_data = "${trimspace(tls_private_key.key.public_key_openssh)} ${var.admin_username}@azure.com"
        } 
    }
}


output "aks_client_key" {
    value = azurerm_kubernetes_cluster.learningazure_aks.kube_config[0].client_key
    sensitive = true
}

output "aks_client_certificate" {
    value = azurerm_kubernetes_cluster.learningazure_aks.kube_config[0].client_certificate
    sensitive = true
}

output "aks_client_ca_certificate" {
    value = azurerm_kubernetes_cluster.learningazure_aks.kube_config[0].cluster_ca_certificate
    sensitive = true
}

output "aks_client_username" {
    value = azurerm_kubernetes_cluster.learningazure_aks.kube_config[0].username
    sensitive = true
}

output "aks_client_password" {
    value = azurerm_kubernetes_cluster.learningazure_aks.kube_config[0].password
    sensitive = true
}

output "aks_kube_config" {
    value = azurerm_kubernetes_cluster.learningazure_aks.kube_config_raw
    sensitive = true
}

output "aks_host" {
    value = azurerm_kubernetes_cluster.learningazure_aks.kube_config[0].host
    sensitive = true
}