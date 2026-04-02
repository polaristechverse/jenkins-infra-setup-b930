vpc_cidr         = "10.15.0.0/16"
vpc_name         = "PolJenkins"
publicsubnetcidr = ["10.15.1.0/24", "10.15.2.0/24", "10.15.3.0/24"]
az               = ["us-east-1a", "us-east-1b", "us-east-1c"]
env              = "Dev"
ami              = 
key_name         = "Desktop_key"
type             = "t3.micro"
