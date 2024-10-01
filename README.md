# Tool for Testing Camunda 8 SaaS Connections

Camunda internal project: https://jira.camunda.com/browse/ACADEMY-3286

## Purpose

You need to ensure that you can connect to Camunda 8 SaaS as a prerequisite for a Camunda 8 training for developers.
This tool provides a script that will verify the connection.

## Prerequisites

- Running Camunda 8 cluster (either provided by Camunda training team or created by you).
- Api client created

If you already have a file "CamundaCloudMgmtAPI-Client-\*.txt" then you are all set and you can proceed.
Otherwise you need to:

1. [Create a Camunda 8 trial account](https://academy.camunda.com/c8-h2-create-account)
2. [Create a Camunda 8 cluster](https://academy.camunda.com/c8-h2-create-cluster)
3. [Obtain client credentials: "CamundaCloudMgmtAPI-Client-\*.txt"](https://academy.camunda.com/c8-h2-create-client-credentials)

Click on the above links to access **How To** guides on Camunda Academy.

## How to Use

1. Clone / download the project
2. Copy the client credential file in the project. (i.e. `CamundaCloudMgmtAPI.txt`)
3. Run the script:
   - **Windows**: Open PowerShell at the project root directory and run `./testConnection.ps1 CamundaCloudMgmtAPI.txt `
   - **Mac/Unix**: Open the terminal at the project root directory and run `./testConnection.sh CamundaCloudMgmtAPI.txt`
4. Review the result for success or failure.

## Connection Result

The script will test your connection to Camunda 8 SaaS and provide one of the following outcomes:

- **Success**: If a valid response is received from Camunda 8 SaaS and 3 brokers (with nodeId 0, 1, and 2) are detected, the script will print `***** OK *****` along with connection details.
  This confirms a successful connection.
  You'll be able to do the training exercises.
- **Failure**: If the connection cannot be established, or fewer than 3 brokers are detected, the script will print `***** CONNECTION FAILED *****`.
  Potential causes of failure include:

  - Missing or incorrect environment variables.
  - Invalid access token or authorization issues.
  - Network or endpoint connectivity problems.

  In case of failure, please contact your training manager with the error details.

## Script Dependencies

These scripts are designed for ease of use without requiring additional software installation.
They use built-in functions that are standard in Unix and Windows systems.

## Tested Environments

These tools have been tested in these environments:

- Macbook Pro Sonoma 14.7
- Windows Server 2022 Datacenter Version 21H2
- Ubuntu 22
- Amazon Linux AWS
- Red Hat
