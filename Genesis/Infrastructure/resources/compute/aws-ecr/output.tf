# USE THIS FOR STAGING

# output "repository_url" {
#     value = aws_ecr_repository.this[0].repository_url
# }

# //change this to * when on staging while choose [0] when deploying to prod
# output "prod_repository_url" {
#     value = aws_ecr_repository.this_task_prod[*].repository_url
# }




// USE THIS FOR PROD

# output "repository_url" {
#     value = aws_ecr_repository.this[*].repository_url
# }

# output "prod_repository_url" {
#     value = aws_ecr_repository.this_task_prod[0].repository_url
# }




# UNDO FOR CMS DEPLOY

output "repository_url" {
  value = aws_ecr_repository.this[*].repository_url
}

//change this to * when on staging while choose [0] when deploying to prod
output "prod_repository_url" {
  value = aws_ecr_repository.this_task_prod[*].repository_url
}