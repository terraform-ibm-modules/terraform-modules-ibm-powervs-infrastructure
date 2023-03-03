locals {
  ibm_powervs_zone_region_map = {
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
    "mon01"    = "mon"
    "wdc06"    = "us-east"
  }

  ibm_powervs_zone_cloud_region_map = {
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
    "mon01"    = "ca-tor"
    "wdc06"    = "us-east"
  }
}

# There are discrepancies between the region inputs on the powervs terraform resource, and the vpc ("is") resources
provider "ibm" {
  alias            = "ibm-pvs"
  region           = lookup(local.ibm_powervs_zone_region_map, var.powervs_zone, null)
  zone             = var.powervs_zone
  ibmcloud_api_key = var.ibmcloud_api_key != null ? var.ibmcloud_api_key : null
}

#####################################################
# VPC landing zone module
#####################################################

module "landing_zone" {
  source               = "git::https://github.com/terraform-ibm-modules/terraform-ibm-landing-zone.git//patterns//vsi?ref=v2.0.0"
  ibmcloud_api_key     = var.ibmcloud_api_key
  ssh_public_key       = var.ssh_public_key
  region               = lookup(local.ibm_powervs_zone_cloud_region_map, var.powervs_zone, null)
  prefix               = var.prefix
  override             = true
  override_json_string = var.override_json_string
}

locals {
  transit_gateway_name = module.landing_zone.transit_gateway_name
  access_host_or_ip    = module.landing_zone.fip_vsi[0].floating_ip
  private_svs_ip       = [for vsi in module.landing_zone.vsi_list : vsi.ipv4_address if vsi.name == "${var.prefix}-private-svs-1"][0]
  inet_svs_ip          = [for vsi in module.landing_zone.vsi_list : vsi.ipv4_address if vsi.name == "${var.prefix}-inet-svs-1"][0]
  squid_port           = "3128"

  ### Squid Proxy will be installed on "${var.prefix}-inet-svs-1" vsi
  squid_config = {
    "squid_enable"      = var.configure_proxy
    "server_host_or_ip" = local.inet_svs_ip
    "squid_port"        = local.squid_port
  }

  ### Proxy client will be configured on "${var.prefix}-private-svs-1" vsi
  perform_proxy_client_setup = {
    squid_client_ips = [local.private_svs_ip]
    squid_server_ip  = local.squid_config["server_host_or_ip"]
    squid_port       = local.squid_config["squid_port"]
    no_proxy_hosts   = "161.0.0.0/8"
  }

  ### DNS Forwarder will be configured on "${var.prefix}-private-svs-1" vsi
  dns_config = merge(var.dns_forwarder_config, {
    "dns_enable"        = var.configure_dns_forwarder
    "server_host_or_ip" = local.private_svs_ip
  })

  ### NTP Forwarder will be configured on "${var.prefix}-private-svs-1" vsi
  ntp_config = {
    "ntp_enable"        = var.configure_ntp_forwarder
    "server_host_or_ip" = local.private_svs_ip
  }

  ### NFS server will be configured on "${var.prefix}-private-svs-1" vsi
  nfs_config = {
    "nfs_enable"        = var.configure_nfs_server
    "server_host_or_ip" = local.private_svs_ip
    "nfs_file_system"   = [{ name = "nfs", mount_path : "/nfs", size : 1000 }]
  }

}

#####################################################
# PowerVS Infrastructure module
#####################################################


module "powervs_infra" {
  source     = "../../../../"
  providers  = { ibm = ibm.ibm-pvs }
  depends_on = [module.landing_zone]

  powervs_zone                = var.powervs_zone
  powervs_resource_group_name = var.powervs_resource_group_name
  powervs_workspace_name      = "${var.prefix}-${var.powervs_zone}-power-workspace"
  tags                        = var.tags
  powervs_image_names         = var.powervs_image_names
  powervs_sshkey_name         = "${var.prefix}-${var.powervs_zone}-ssh-pvs-key"
  ssh_public_key              = var.ssh_public_key
  ssh_private_key             = var.ssh_private_key
  powervs_management_network  = var.powervs_management_network
  powervs_backup_network      = var.powervs_backup_network
  transit_gateway_name        = local.transit_gateway_name
  reuse_cloud_connections     = false
  cloud_connection_count      = var.cloud_connection_count
  cloud_connection_speed      = var.cloud_connection_speed
  cloud_connection_gr         = var.cloud_connection_gr
  cloud_connection_metered    = var.cloud_connection_metered
  access_host_or_ip           = local.access_host_or_ip
  squid_config                = local.squid_config
  dns_forwarder_config        = local.dns_config
  ntp_forwarder_config        = local.ntp_config
  nfs_config                  = local.nfs_config
  perform_proxy_client_setup  = local.perform_proxy_client_setup
}
