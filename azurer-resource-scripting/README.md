# Terraform Scripts for Azure

## About

This Terraform project provides scripts to create and delete Azure resources including a resource group, container registry, and an AKS cluster. These scripts are useful for deploying a containerized application to Azure using Kubernetes.

## Technical Requirements

The project requires the following technical requirements:

- Terraform
- Azure CLI
- Service Principal (must be created before running the scripts)

## Installation and Setup

To use the Terraform Azure scripts, follow these steps:

1. Clone the repository to your local machine.
2. Ensure that Terraform and the Azure CLI are installed on your machine.
3. Create a service principal in your Azure account.
4. Set the following environment variables:

- CLIENT_ID
- CLIENT_SECRET

Run the following commands to initialize and apply the Terraform scripts:
`terraform init`
`terraform apply`

To destroy the resources, run:
`terraform destroy`

## Usage

The Terraform Azure scripts create and manage Azure resources. Once the scripts have been applied, you can use the Azure Portal or Azure CLI to interact with these resources.

## Credits

I would like to credit the following sources:

- Terraform documentation
- Azure documentation
- Bootstrapping Microservices with Docker, Kubernetes, and Terraform by Ashley Davis

## License

This project is licensed under the MIT License.

## Contact

If you have any questions or concerns about the Terraform scripts, please contact me at oluochodhiambo11@gmail.com.
