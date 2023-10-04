#####################################################
# powervs service Module
#####################################################

terraform {
  required_version = ">= 1.3, <=1.5.5"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "=1.56.1"
    }
  }
}
