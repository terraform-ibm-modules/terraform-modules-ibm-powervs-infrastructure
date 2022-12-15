#####################################################
# IBM Cloud PowerVS cloud connection create Module
#####################################################

terraform {
  required_version = ">=1.2"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.48.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.1"
    }
  }
}
