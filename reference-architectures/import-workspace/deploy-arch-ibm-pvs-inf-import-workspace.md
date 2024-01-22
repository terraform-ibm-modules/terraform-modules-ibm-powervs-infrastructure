---
copyright:
  years: 2024
lastupdated: "2024-01-17"

keywords:

subcollection: deployable-reference-architectures

authors:
  - name: Arnold Beilmann
  - name: Stafania Saju

version: v4.3.0

production: true

deployment-url: https://cloud.ibm.com/catalog/architecture/deploy-arch-ibm-pvs-inf-2dd486c7-b317-4aaa-907b-42671485ad96-global

docs: https://cloud.ibm.com/docs/powervs-vpc

image_source: https://github.com/terraform-ibm-modules/terraform-ibm-powervs-infrastructure/blob/main/reference-architectures/reference-architectures/import-workspace/deploy-arch-ibm-pvs-inf-import-workspace.svg

related_links:
  - title: 'SAP in IBM Cloud documentation'
    url: 'https://cloud.ibm.com/docs/sap'
    description: 'SAP in IBM Cloud documentation.'
  - title: 'Reference architecture for "Secure infrastructure on VPC for regulated industries" as standard variation'
    url: 'https://cloud.ibm.com/docs/deployable-reference-architectures?topic=deployable-reference-architectures-vsi-ra'
    description: 'Reference architecture for "Secure infrastructure on VPC for regulated industries" as standard variation'

use-case: ITServiceManagement

industry: Technology

compliance:

content-type: reference-architecture

---

{{site.data.keyword.attribute-definition-list}}

# Power Virtual Server with VPC landing zone - as 'Import PowerVS Workspace' deployment
{: toc-content-type="reference-architecture"}
{: toc-industry="Technology"}
{: toc-use-case="ITServiceManagement"}
{: toc-compliance="SAPCertified"}
{: toc-version="4.3.0"}

This solution helps to install the deployable architecture ['Power Virtual Server for SAP HANA'](https://cloud.ibm.com/catalog/architecture/deploy-arch-ibm-pvs-sap-9aa6135e-75d5-467e-9f4a-ac2a21c069b8-global) on top of a pre-existing Power Virtual Server(PowerVS) landscape. 'Power Virtual Server for SAP HANA' automation requires a schematics workspace id for installation. The 'import-workspace' solution creates a schematics workspace by taking pre-existing VPC and PowerVS infrastructure resource details as inputs. The ID of this schematics workspace will be the pre-requisite workspace id required by 'Power Virtual Server for SAP HANA' to create and configure the PowerVS instances for SAP on top of the existing infrastructure.

## Architecture diagram
{: #iw-architecture-diagram}

![Architecture diagram for 'Power Virtual Server with VPC landing zone' - variation 'Import PowerVS Workspace'.](deploy-arch-ibm-pvs-inf-import-workspace.svg "Architecture diagram"){: caption="Figure 1. Power Virtual Server with VPC landing zone 'import-workspace' variation" caption-side="bottom"}{: external download="deploy-arch-ibm-pvs-inf-import-workspace.svg"}