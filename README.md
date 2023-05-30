# iapd

Cloud Run Identity Aware Proxy demo, illustrating how to off-load user authentication outside your application.

> WIP: this demo is still being developed. Do not use it yet. 

## deployment

### prerequisites

The deploy this solution you will need:

* [Terraform CLI](https://www.terraform.io/downloads)
* [GCP Project](https://cloud.google.com/resource-manager/docs/creating-managing-projects)
* [gcloud CLI](https://cloud.google.com/sdk/gcloud) (aka Google Cloud SDK)

### prep

Few manual steps:

https://cloud.google.com/iap/docs/enabling-compute-howto

### setup

Start by cloning this repo, and navigate into it:

```shell
git clone git@github.com:mchmarny/iapd.git
cd iapd
```

Next, authenticate to GCP:

```shell
gcloud auth application-default login
```

Initialize the Terraform configuration: 

```shell
terraform init
```

### deployment

When done, deploy the solution:

```shell
terraform apply
```

## cleanup

To clean all the resources provisioned by this setup run:

```shell
terraform destroy
```

> Note, some resources like the database, are set to prevent accidental deletes. That setting will have to be disabled manually before `terraform` will be able to delete them.

## Disclaimer

This is my personal project and it does not represent my employer. While I do my best to ensure that everything works, I take no responsibility for issues caused by this code.
