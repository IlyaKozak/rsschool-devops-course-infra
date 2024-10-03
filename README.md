## RS School AWS DevOps Course

**Project Structure:**

```
├── .github
│   └── workflows
│       └── terraform.yml   <- github actions workflow
├── remote-state            <- remote state TF files
│       └── ...                to create S3 state bucket
├── .gitignore
├── main.tf
├── provider.tf             <- provider configuration
├── variables.tf            <- input variables
├── iam.tf                  <- resources files for iam
├── vpc-....tf              <- resources files for vpc/subnets/rt
└── ...
```

### Task 2 - Basic Infrastructure Configuration

- Terraform code resources are added to create networking infrastructure in AWS. The infrastructure will be used for housing K8s cluster components - 1 VPC, 2 public & 2 private subnets spread across two AZs
- Internet Gateway and NAT Instance created
- Proper routing configured

**Networking Diagram:**

### Task 1 - AWS Account Configuration

- Created a remote backend for Terraform (AWS S3 bucket)
- Configured OpenID Connect (OIDC) for GitHub Actions
- Created a Github Actions workflow for deployment of resources to AWS via Terraform with temporarily credentials

**OIDC Diagram:**

![Diagram](tasks-images/task1-diagram.png)

**Usage:**

1. Create S3 remote state backend bucket (`remote-state` folder) and DynamoDB for state lock _[one-time setup]_:

- `aws configure`
- `cd remote-state`
- `terraform init`
- `terraform apply`

2. Fill out S3 bucket and DynamoDB info in `provider.tf` in `backend` block and run commands to create GithubActions role in AWS to be able create AWS resources from GitHub Actions workflow with OIDC temporarily credentials and GithubActions role to assume _[one-time setup]_:

- `cd ..`
- `terraform init`
- `terraform apply`

3. Add secret `AWS_ROLE_TO_ASSUME` and environment variable `AWS_REGION` in GitHub repo for GitHub Actions workflow run

4. Create Pull Request/Push to `main` branch for starting GitHub Actions workflow job `terraform` to deploy AWS resources with Terraform

5. `terraform destroy` to destroy AWS resources
