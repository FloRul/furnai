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
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "sagemaker_module" {
  source  = "philschmid/sagemaker-huggingface/aws"
  version = "0.8.1"
  #   required
  hf_task              = "stable-diffusion-inpainting"
  name_prefix          = "furnai-inpainting"
  transformers_version = "4.26.0"
  pytorch_version      = "1.13.1"
  instance_type        = "ml.p2.xlarge"
  hf_model_id          = "model-inpainting-stabilityai-stable-diffusion-2-inpainting-fp16"

}
