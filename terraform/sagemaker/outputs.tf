output "iam" {
  value = module.sagemaker_module.iam_role
}
output "endpoint" {
  value = module.sagemaker_module.sagemaker_endpoint
}
output "endpoint_name" {
  value = module.sagemaker_module.sagemaker_endpoint_name
}
output "model" {
  value = module.sagemaker_module.sagemaker_model
}
