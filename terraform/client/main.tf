terraform {
  cloud {
    organization = "FloRulLab"

    workspaces {
      name = "furnai-client"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_amplify_app" "furnai_client" {
  name = "furnai"
}

import {
  to = aws_amplify_app.furnai_client
  id = "d3tpxlgs0rlcx6"
}
