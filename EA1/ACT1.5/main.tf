terraform {
  required_version = "~> 1.13.0"

  backend "azurerm" {
    resource_group_name  = "AreaInfraestructura"
    storage_account_name = "infracomocodigoduoc2025"
    container_name       = "terraform-state"
    key                  = "clase-4.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.41.0"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  subscription_id                 = "bb1ccac7-d7f8-47bf-82c2-f223185cfab9"
}

module "infraestructura_azure" {
  source = "git::https://gitlab.com/nicosingh/curso-infra-como-codigo-ago-sep-2025.git//clase-4/modulo-interno-azure?ref=6125164b0ccb27ea2f53c950bbbdda3b539115db"

  nombre_proyecto = "clase-4"
  ubicacion       = "East US 2"
  ambiente        = terraform.workspace

  nombre_grupo_recursos = "AreaInfraestructura"

  crear_cuenta_almacenamiento = true
  crear_maquina_virtual       = true
}

output "nombre_red_virtual" {
  value       = module.infraestructura_azure.nombre_red_virtual
  description = "Nombre de la Red Virtual creada"
}

output "id_red_virtual" {
  value       = module.infraestructura_azure.id_red_virtual
  description = "ID de la Red Virtual creada"
}

output "nombre_cuenta_almacenamiento" {
  value       = module.infraestructura_azure.nombre_cuenta_almacenamiento
  description = "Nombre de la Cuenta de Almacenamiento creada"
}

output "ip_privada_maquina_virtual" {
  value       = module.infraestructura_azure.ip_privada_maquina_virtual
  description = "Dirección IP privada de la Máquina Virtual"
}

output "dns_maquina_virtual" {
  value       = module.infraestructura_azure.dns_maquina_virtual
  description = "DNS de la Máquina Virtual"
}
