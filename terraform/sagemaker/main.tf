terraform {
  cloud {
    organization = "FloRulLab"

    workspaces {
      name = "furnai-sagemaker"
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

resource "aws_sagemaker_model" "inpain_model" {
  name               = "furnai-inpaint-model"
  execution_role_arn = aws_iam_role.example.arn

  primary_container {
    # https://docs.aws.amazon.com/sagemaker/latest/dg-ecr-paths/ecr-us-east-1.html#huggingface-us-east-1.title
    image = data.aws_sagemaker_prebuilt_ecr_image.test.registry_path
  }
}

resource "aws_iam_role" "example" {
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

data "aws_sagemaker_prebuilt_ecr_image" "inpaint_model_image" {
  repository_name = "kmeans"
}
