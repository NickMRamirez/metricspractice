variable "subscription_id" {}
variable "service_principal_client_id" {}
variable "service_principal_client_secret" {}
variable "tenant_id" {}

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.service_principal_client_id}"
  client_secret   = "${var.service_principal_client_secret}"
  tenant_id       = "${var.tenant_id}"
}

resource "azurerm_resource_group" "aks" {
  name     = "aks_resourcegroup"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "akscluster1"
  location            = "${azurerm_resource_group.aks.location}"
  resource_group_name = "${azurerm_resource_group.aks.name}"

  linux_profile {
    admin_username = "aksuser"

    ssh_key {
      key_data = "${file("../example_ssh_keypairs/ssh_public_cert.pem")}"
    }
  }

  agent_pool_profile {
    name            = "default"
    count           = 1
    dns_prefix      = "k8stestagent1"
    vm_size         = "Standard_B2ms" # 2 Cores, 8 GB RAM $0.094/hour
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${var.service_principal_client_id}"
    client_secret = "${var.service_principal_client_secret}"
  }

  tags {
    Environment = "Dev"
  }
}

output "id" {
  value = "${azurerm_kubernetes_cluster.aks.id}"
}

output "kube_config" {
  value = "${azurerm_kubernetes_cluster.aks.kube_config_raw}"
}

output "client_key" {
  value = "${azurerm_kubernetes_cluster.aks.kube_config.0.client_key}"
}

output "client_certificate" {
  value = "${azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate}"
}

output "cluster_ca_certificate" {
  value = "${azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate}"
}

output "host" {
  value = "${azurerm_kubernetes_cluster.aks.kube_config.0.host}"
}
