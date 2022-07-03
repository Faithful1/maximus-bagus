# Output of ecs cluster

output "aws-ecs-cluster-id" {
  value = aws_ecs_cluster.main.id
}

output "aws-ecs-cluster-name" {
  value = aws_ecs_cluster.main.name
}

output "aws-ecs-cluster-arn" {
  value = aws_ecs_cluster.main.arn
}


output "aws-ecs-service-name" {
  value = aws_ecs_service.main.name
}
