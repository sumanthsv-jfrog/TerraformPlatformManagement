terraform {
  required_providers {
    artifactory = {
      source  = "jfrog/artifactory"
      version = "~> 12.0"
    }
    platform = {
      source  = "jfrog/platform"
      version = "~> 2.0"
    }
    xray = {
      source  = "jfrog/xray"
      version = "~> 3.1"
    }
    project = {
      source  = "jfrog/project"
      version = "~> 1.9.9"
    }
  }
}

provider "artifactory" {
  url          = "http://sum2.jfps.team"
  access_token = var.jfrog_token
}

provider "platform" {
  url          = "http://sum2.jfps.team"
  access_token = var.jfrog_token
}

provider "xray" {
  url          = "http://sum2.jfps.team"
  access_token = var.jfrog_token
}

provider "project" {
  url          = "http://sum2.jfps.team"
  access_token = var.jfrog_token
}
