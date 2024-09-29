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
├── ...                     <- resources files (iam, ...)
└──
```

### Task 1 - AWS Account Configuration

- Created a remote backend for Terraform (AWS S3 bucket)
- Configured OpenID Connect (OIDC) for GitHub Actions
- Created a Github Actions workflow for deployment of resources to AWS via Terraform with temporarily credentials

**Infrastructure Setup Diagram:**

![Diagram](tasks-images/task1-diagram.png)

**Usage:**

1. Create S3 remote state backend bucket (`remote-state` folder):

- `cd remote-state`
- `terraform init`
- `terraform apply`

2. Fill out bucket id in `provider.tf` in `backend` block and run:

- `cd ..`
- `terraform init`
- `terraform apply`

3. Add secret `AWS_ROLE_TO_ASSUME` and environment variable `AWS_REGION` in GitHub repo for GitHub Actions workflow.

4. Create Pull Request/Push to `main` branch for starting GitHub Actions workflow jobs `terraform-check`, `terraform-plan` and `terraform-apply` to deploy AWS resources with Terraform
