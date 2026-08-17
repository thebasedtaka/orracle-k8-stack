terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">=4.12.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_id
  user_ocid        = var.user_id
  fingerprint      = var.api_fingerprint
  private_key_path = var.api_private_key_path
  region           = var.region
}

provider "oci" {
  alias            = "home"
  tenancy_ocid     = var.tenancy_id
  user_ocid        = var.user_id
  fingerprint      = var.api_fingerprint
  private_key_path = var.api_private_key_path
  region           = var.region
}

module "k8s_setup" {
  source = "ystory/always-free-oke/oci"

  tenancy_id     = var.tenancy_id
  home_region    = var.region
  region         = var.region
  node_pool_size = 1

  control_plane_type = "public"

  control_plane_allowed_cidrs = [
    var.public_ip
  ]

  ssh_public_key_path  = "~/.ssh/id_rsa.pub"
  ssh_private_key_path = "~/.ssh/id_rsa"

  providers = {
    oci.home = oci.home
  }

  kubernetes_version   = "v1.36.1"
  node_pool_os_version = "8.10"
}