

resource "aws_amplify_app" "app" {
  name = "furnai"
}

import {
  to = aws_amplify_app.app
  id = "d20a62988crvri"
}

resource "aws_cognito_identity_pool" "idp" {
  identity_pool_name = "furnai31095bad_identitypool_31095bad__dev"
  cognito_identity_providers {
    client_id               = "1n8p8ghnj7jn7813k8qm4do3c"
    provider_name           = "cognito-idp.us-east-1.amazonaws.com/us-east-1_OPEDc85iG"
    server_side_token_check = false
  }
}

import {
  to = aws_cognito_identity_pool.idp
  id = "us-east-1:69fa70cd-ef08-4231-ac4c-9cf1bfcd7a4e"
}

resource "aws_appsync_graphql_api" "graphql_api" {
  name                = "furnai-dev"
  authentication_type = "AMAZON_COGNITO_USER_POOLS"
  tags = {
    "user:Application" = "furnai"
    "user:Stack"       = "dev"
  }
  tags_all = {
    "user:Application" = "furnai"
    "user:Stack"       = "dev"
  }
  user_pool_config {
    aws_region     = "us-east-1"
    default_action = "ALLOW"
    user_pool_id   = "us-east-1_OPEDc85iG"
  }
}

import {
  to = aws_appsync_graphql_api.graphql_api
  id = "rpbp534y3bedbeb4kbwkj4zcym"
}

resource "aws_cognito_user_pool" "user_pool" {
  name                     = "furnai31095bad_userpool_31095bad-dev"
  auto_verified_attributes = ["email"]
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }

  user_attribute_update_settings {
    attributes_require_verification_before_update = [
      "email",
    ]
  }

  username_configuration {
    case_sensitive = false
  }
}

import {
  to = aws_cognito_user_pool.user_pool
  id = "us-east-1_OPEDc85iG"
}

resource "aws_s3_bucket" "image_bucket" {
  tags = {
    "user:Application" = "furnai"
    "user:Stack"       = "dev"
  }
  tags_all = {
    "user:Application" = "furnai"
    "user:Stack"       = "dev"
  }
}

import {
  to = aws_s3_bucket.image_bucket
  id = "furnai96e6d571565f41af84ee3e9878fba030215019-dev"
}
data "aws_lambda_function" "on_image_upload" {
  function_name = "S3Trigger5d88f219-dev"
}
