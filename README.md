<!-- BEGIN MODULE HOOK -->

# IBM Power Virtual Server with VPC landing zone

[![Graduated (Supported)](https://img.shields.io/badge/status-Graduated%20(Supported)-brightgreen?style=plastic)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-powervs-infrastructure?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-infrastructure/releases/latest)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)

## Summary
This repository contains deployable architecture solutions which helps in provisioning VPC landing zone, PowerVS workspace and interconnecting them. The solutions are available in IBM Cloud Catalog and also can be deployed with catalog as well.

Three solutions are offered:
1. [PowerVS full-stack variation](soltuions/full-stack)
    - Creates three vpcs with RHEL or SLES instances, Power Virtual Server workspace, interconnects them and configures os network management services.
2. [PowerVS extension variation](soltuions/extension)
    - Extends the full-stack solution by creating a new Power Virtual Server workspace in different zone and interconnects with the previous solution. This solution is typically used for High Availability scenarios where a single management VPCs can be used to reach both PowerVS workspaces.
3. [PowerVS quickstart variation](soltuions/quickstart)
    - Creates 1VPC and a Power Virtual Server workspace, interconnects them and configures os network management services. Additionally creates a Power Virtual Server Instance of selected t-shirt size. This solution is typically used for Pocs, demos and quick onboarding to Power Infrastructure.

## Reference architectures
- [PowerVS full-stack variation](reference-architectures/full-stack/deploy-arch-ibm-pvs-inf-full-stack.md)
- [PowerVS extension variation](reference-architectures/extension/deploy-arch-ibm-pvs-inf-extension.md)
- [PowerVS quickstart variation](reference-architectures/quickstart/deploy-arch-ibm-pvs-inf-quickstart.md)

## Solutions
| Variation  | Available on IBM Catalog  |  Requires IBM Schematics Workspace ID | Creates VPC Landing Zone | Performs VPC VSI OS Config | Creates PowerVS Infrastructure | Creates PowerVS Instance | Performs PowerVS OS Config |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| [Full-Stack](solutions/full-stack)  | :heavy_check_mark:  | N/A  | :heavy_check_mark:  | :heavy_check_mark:  |  :heavy_check_mark: | N/A | N/A |
| [Extension](solutions/extension)    | :heavy_check_mark:  |  :heavy_check_mark: |  N/A | N/A | :heavy_check_mark:  | N/A | N/A |
| [Quickstart](solutions/quickstart)    | :heavy_check_mark:  |   N/A  | :heavy_check_mark:| :heavy_check_mark: | :heavy_check_mark:  | :heavy_check_mark: | N/A |

<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-powervs-infrastructure](#terraform-ibm-powervs-infrastructure)
* [Submodules](./modules)
    * [ansible-configure-network-services](./modules/ansible-configure-network-services)
    * [powervs-vpc-landing-zone](./modules/powervs-vpc-landing-zone)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->

## Required IAM access policies

You need the following permissions to run this module.

- Account Management
    - **Resource Group** service
        - `Viewer` platform access
    - IAM Services
        - **Workspace for Power Virtual Server** service
        - **Power Virtual Server** service
            - `Editor` platform access
        - **VPC Infrastructure Services** service
            - `Editor` platform access
        - **Transit Gateway** service
            - `Editor` platform access
        - **Direct Link** service
            - `Editor` platform access

<!-- END MODULE HOOK -->

<!-- BEGIN CONTRIBUTING HOOK -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
<!-- END CONTRIBUTING HOOK -->
