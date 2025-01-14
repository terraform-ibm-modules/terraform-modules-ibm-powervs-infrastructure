#####################################################
# IBM Cloud PowerVS workspace Module
#####################################################

terraform {
  required_version = ">= 1.9"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">=1.65.1"
    }
  }
}
