# README.md

## Azure VM Autocheck

This repository contains a Bash script and a GitHub Actions pipeline that retrieves information about Azure virtual machines (VMs) with a specific tag and generates a CSV file with the collected data. The generated CSV file is then committed and pushed back to the repository.

### Prerequisites

- An Azure account with access to virtual machines and a configured service principal.
- A Key Vault containing the service principal ID, password, and tenant.
- GitHub repository with the Bash script and GitHub Actions workflow file.

### Script

The `vm_check.sh` script logs into an Azure account using service principal credentials stored in a Key Vault, iterates through all the subscriptions the service principal has access to, and retrieves a list of virtual machines (VMs) with the tag "gpcms_managed" set to true. The script then generates a CSV file containing information about the VMs, such as the name, operating system, private IP address, GPCMS_ENV tag, and subscription ID.

### Pipeline

The pipeline is a GitHub Actions workflow that triggers on a push event. It consists of the following steps:

1. Azure Login: Logs into the Azure account using the provided Azure credentials stored as a GitHub secret.
2. Checkout: Checks out the repository containing the script on the main branch.
3. Azure CLI script file: Executes the Bash script (vm_check.sh) using the Azure CLI action. The action runs the script in the context of the specified Azure CLI version (2.30.0) and passes the required environment variables from the GitHub secrets.
4. Setup Git: Configures the Git user email and name for the commit.
5. Commit and Push CSV file: Commits the generated CSV file (`customer_vms.csv`) to the repository and pushes the changes back to the main branch using the `GITHUB_TOKEN`.

### Usage

1. Store your Azure credentials, service principal ID, password, tenant, and Key Vault name as secrets in your GitHub repository.
2. Add the Bash script `vm_check.sh` and the GitHub Actions workflow file to your repository.
3. On every push event, the pipeline will automatically run the script, retrieve VM information, generate a CSV file with the collected data, and commit and push the file back to the repository.

Note: Make sure to update the tag and any other specific requirements in the script as needed.
