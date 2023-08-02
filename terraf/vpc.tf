provider "aws" {
  region = "ap-south-1"  # Set the region to "ap-south-1" for South India
}

resource "aws_eks_cluster" "example_cluster"{
  name     = "example-eks-cluster"
  role_arn = "arn:aws:iam::875667920160:user/terraform"  # Replace with your EKS cluster IAM role ARN
  version  = "1.21"  # Replace with your desired Kubernetes version

 provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "example_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Example VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = var.public_subnet_cidr

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    Name = "Example Internet Gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_eks_cluster" "example_cluster" {
  name     = var.cluster_name
  role_arn = var.cluster_iam_role_arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids = [aws_subnet.public_subnet.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster,
  ]
}

resource "aws_iam_role" "eks_cluster" {
  name = var.cluster_iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}
}