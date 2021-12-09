terraform {
  backend "gcs" {
    bucket = "jsa-terraformstate"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.1.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }

  required_version = ">=1.0.11"
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

module "showcase_databases" {
  source = "./showcase_databases"

  environment        = var.environment
  region             = var.region
  database_admin_pwd = var.database_admin_pwd
}