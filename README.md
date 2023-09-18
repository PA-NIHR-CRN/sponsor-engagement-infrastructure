# sponsor-engagement-infrastructure
**Description**: Terraform code for sponsor-engagement-Infrastructure



**Resources**
Amazon ECS (Fargate)
Amazon ECR
AWS WAF (Recommended)
AWS Application/Network Load Balancer
AWS Aurora
AWS SES
AWS CloudWatch

# sponsor-engagement-infrastrucutre

This is the main Repo for the sponsor-engagement infrastucture code.

The backend code lives over in https://github.com/PA-NIHR-CRN/sponsor-engagement-web

---


## GitHub Actions

A handful of GitHub Actions workflows are defined. These are described below:

* deploy-all-env.yml - will deploy dev/test/uat/oat/prod in that order with an approval step after the terraform plan for PROD
* deploy-env.yml - Manual deployment of any environment with an option to 'Terraform apply' or not.


![Architecture](./docs/images/architecture.png)

1. Install docker (for tests)