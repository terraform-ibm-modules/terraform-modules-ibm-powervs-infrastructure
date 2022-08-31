locals {
  ibm_pvs_zone_region_map = {
    "syd04"    = "syd"
    "syd05"    = "syd"
    "eu-de-1"  = "eu-de"
    "eu-de-2"  = "eu-de"
    "lon04"    = "lon"
    "lon06"    = "lon"
    "tok04"    = "tok"
    "us-east"  = "us-east"
    "us-south" = "us-south"
    "dal12"    = "us-south"
    "tor01"    = "tor"
    "osa21"    = "osa"
    "sao01"    = "sao"
  }

  ibm_pvs_zone_cloud_region_map = {
    "syd04"    = "au-syd"
    "syd05"    = "au-syd"
    "eu-de-1"  = "eu-de"
    "eu-de-2"  = "eu-de"
    "lon04"    = "eu-gb"
    "lon06"    = "eu-gb"
    "tok04"    = "jp-tok"
    "us-east"  = "us-east"
    "us-south" = "us-south"
    "dal12"    = "us-south"
    "tor01"    = "ca-tor"
    "osa21"    = "jp-osa"
    "sao01"    = "br-sao"
  }
}

# There are discrepancies between the region inputs on the powervs terraform resource, and the vpc ("is") resources
provider "ibm" {
  alias            = "ibm-pvs"
  region           = lookup(local.ibm_pvs_zone_region_map, var.pvs_zone, null)
  zone             = var.pvs_zone
  ibmcloud_api_key = var.ibmcloud_api_key
}

provider "ibm" {
  alias            = "ibm-is"
  region           = lookup(local.ibm_pvs_zone_cloud_region_map, var.pvs_zone, null)
  zone             = var.pvs_zone
  ibmcloud_api_key = var.ibmcloud_api_key
}

# Security Notice
# The private key generated by this resource will be stored unencrypted in your Terraform state file.
# Use of this resource for production deployments is not recommended.
# Instead, generate a private key file outside of Terraform and distribute it securely to the system where
# Terraform will be run.

resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "ibm_is_ssh_key" "ssh_key" {
  provider   = ibm.ibm-is
  name       = "${var.prefix}-${var.pvs_sshkey_name}"
  public_key = trimspace(tls_private_key.tls_key.public_key_openssh)
}

########################################################################################################################
# Account Resource Group
########################################################################################################################

locals {
  resource_group_name = var.existing_resource_group_name == null ? module.resource_group[0].resource_group_name : module.existing_resource_group[0].resource_group_name
}

module "existing_resource_group" {
  count                        = var.existing_resource_group_name == null ? 0 : 1
  source                       = "git::https://github.com/terraform-ibm-modules/terraform-ibm-resource-group.git?ref=v1.0.0"
  existing_resource_group_name = var.existing_resource_group_name
}

module "resource_group" {
  count               = var.existing_resource_group_name == null ? 1 : 0
  source              = "git::https://github.com/terraform-ibm-modules/terraform-ibm-resource-group.git?ref=v1.0.0"
  resource_group_name = "${var.prefix}-rg"
}

########################################################################################################################
# Instantiate PowerVS infrastructure
########################################################################################################################

module "powervs_infra" {
  # Explicit dependency needed here - likely due to different provider alias used in this example
  depends_on = [
    local.resource_group_name
  ]

  providers = {
    ibm = ibm.ibm-pvs
  }

  source = "../../"

  pvs_zone                   = var.pvs_zone
  pvs_resource_group_name    = local.resource_group_name
  pvs_service_name           = "${var.prefix}-${var.pvs_service_name}"
  tags                       = var.resource_tags
  pvs_image_names            = var.pvs_image_names
  pvs_sshkey_name            = "${var.prefix}-${var.pvs_sshkey_name}"
  ssh_public_key             = ibm_is_ssh_key.ssh_key.public_key
  ssh_private_key            = trimspace(tls_private_key.tls_key.private_key_openssh)
  access_host_or_ip          = var.access_host_or_ip
  pvs_management_network     = var.pvs_management_network
  pvs_backup_network         = var.pvs_backup_network
  transit_gateway_name       = var.transit_gateway_name
  reuse_cloud_connections    = var.reuse_cloud_connections
  cloud_connection_count     = var.cloud_connection_count
  cloud_connection_speed     = var.cloud_connection_speed
  cloud_connection_gr        = var.cloud_connection_gr
  cloud_connection_metered   = var.cloud_connection_metered
  squid_config               = var.squid_config
  dns_forwarder_config       = var.dns_forwarder_config
  ntp_forwarder_config       = var.ntp_forwarder_config
  nfs_config                 = var.nfs_config
  perform_proxy_client_setup = var.perform_proxy_client_setup
}
