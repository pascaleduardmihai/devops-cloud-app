resource "aws_db_subnet_group" "rds_sg" {
  name       = "task-manager-rds-subnet-group"
  subnet_ids = module.vpc.private_subnets # Punem DB-ul în subnete private pentru securitate

  tags = { Name = "My RDS Subnet Group" }
}

resource "aws_security_group" "rds_security_group" {
  name   = "rds-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id] # Permitem acces doar de la nodurile EKS
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "15"
  instance_class       = "db.t3.micro" # Ieftin, pentru testare
  db_name              = "taskdb"
  username             = "postgres"
  password             = "parola_secreta_123" # Recomandat: folosirea AWS Secrets Manager mai târziu
  parameter_group_name = "default.postgres15"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.rds_sg.name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}
