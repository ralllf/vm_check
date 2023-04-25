Azure VM Autocheck
This repository contains a Bash script and a GitHub Actions pipeline that retrieves information about Azure virtual machines (VMs) with a specific tag and generates a CSV file with the collected data.

Prerequisites
An Azure account with access to virtual machines and a configured service principal.
A Key Vault containing the service principal ID, password, and tenant.
GitHub repository with the Bash script and GitHub Actions workflow file.
Script
The vm_check.sh script logs into an Azure account using service principal credentials stored in a Key Vault, iterates through all the subscriptions the service principal has access to, and retrieves a list of virtual machines (VMs) with the tag "gpcms_managed" set to true. The script then generates a CSV file containing information about the VMs, such as the name, operating system, private IP address, GPCMS_ENV tag, and subscription ID.

Pipeline
The pipeline is a GitHub Actions workflow that triggers on a push event. It consists of the following steps:

Azure Login: Logs into the Azure account using the provided Azure credentials stored as a GitHub secret.
Checkout: Checks out the repository containing the script.
Azure CLI script file: Executes the Bash script (vm_check.sh) using the Azure CLI action. The action runs the script in the context of the specified Azure CLI version (2.30.0) and passes the required environment variables from the GitHub secrets.
Diagram
+----------------+       +------------------+        +-----------------+
| GitHub Actions | ----> | Azure Login      |  ----> | Azure Key Vault |
+----------------+       +------------------+        +-----------------+
                                                |
                                                |
                                                V
                                    +-----------------------+
                                    | Azure Subscriptions   |
                                    +-----------------------+
                                                |
                                                |
                                                V
                                 +--------------------------+
                                 | Virtual Machines (VMs)   |
                                 +--------------------------+
                                                |
                                                |
                                                V
                                     +---------------------+
                                     | CSV File (Output)   |
                                     +---------------------+
Usage
Store your Azure credentials, service principal ID, password, tenant, and Key Vault name as secrets in your GitHub repository.
Add the Bash script vm_check.sh and the GitHub Actions workflow file to your repository.
On every push event, the pipeline will automatically run the script, retrieve VM information, and generate a CSV file with the collected data.
