# Security Group para la DB (Solo permite tráfico desde el Cluster EKS)
resource "aws_security_group" "rds_sg" {
  name   = "rds-security-group"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 5432 # Puerto estándar de PostgreSQL
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id] # Solo los nodos del cluster pueden entrar
  }
}

# Instancia de Base de Datos RDS
resource "aws_db_instance" "postgres" {
  allocated_storage      = 20
  db_name                = "devopsdb"
  engine                 = "postgres"
  engine_version         = "15" # Actualizado desde 13.4
  instance_class         = "db.t3.micro"
  username               = "jaimeadmin"
  password               = "PasswordSeguro123!"
  parameter_group_name   = "default.postgres15"
  skip_final_snapshot    = true
  
  # ESTA ES LA PARTE CLAVE:
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  publicly_accessible    = false # Por seguridad SRE, nunca pública
}