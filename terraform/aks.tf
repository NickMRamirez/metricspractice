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
  dns_prefix          = "dev"

  linux_profile {
    admin_username = "aksuser"

    ssh_key {
      key_data = "${file("../example_ssh_keypairs/ssh_public_cert.pem")}"
    }
  }

  agent_pool_profile {
    name            = "default"
    count           = 1
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
