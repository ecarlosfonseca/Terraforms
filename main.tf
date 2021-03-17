terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
  access_key = "*****"
  secret_key = "*****"
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  subnet1_public_cidr = var.subnet1_public_cidr
  subnet2_private_cidr = var.subnet2_private_cidr
  rout_table_cidr = var.rout_table_cidr
  app_name = var.app_name
}

module "rds" {
  source            = "./modules/rds"
  subnet2_private_id = module.vpc.subnet2_private_id
  subnet1_public_id = module.vpc.subnet1_public_id
  security_group = module.vpc.database_security_group_id
  app_name = var.app_name
}

module "ec2"{
  source = "./modules/ec2"
  subnet1_public_id = module.vpc.subnet1_public_id
  vpc_security_group_id = module.vpc.vpc_security_group_id
  app_name = var.app_name
}

