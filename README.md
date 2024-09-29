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
Push to `main` branch results in AWS resources deployment with Terraform
