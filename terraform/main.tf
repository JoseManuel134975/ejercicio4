resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-server"
  }
}

# resource "aws_security_group" "allow_http_and_ssh" {
#   name = "allow_http_and_ssh"
#   description = "Allow input traffic of HTTP & SSH"
#   vpc_id = aws_vpc.my_vpc.id

#   ingress {
#     from_port = 80
#     to_port = 80
#     protocol = "tcp"
#     cidr_blocks = [ "0.0.0.0/0" ]
#   }

#   ingress {
#     from_port = 22
#     to_port = 22
#     protocol = "tcp"
#     cidr_blocks = [ "0.0.0.0/0" ]
#   }

#   ingress {
#     from_port = 8990
#     to_port = 8990
#     protocol = "tcp"
#     cidr_blocks = [ "0.0.0.0/0" ]
#   }

#   # Reglas de salida
#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = [ "0.0.0.0/0" ]
#   }
# }

resource "aws_subnet" "my_public_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-for-server"
  }
}

resource "aws_internet_gateway" "my_router" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "router-for-server"
  }
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  # Rutas
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_router.id
  }

  tags = {
    Name = "route_table-for-server"
  }
}

resource "aws_route_table_association" "my_association_with_route_table" {
  route_table_id = aws_route_table.my_route_table.id
  subnet_id = aws_subnet.my_public_subnet.id
}

# resource "aws_key_pair" "keys_of_server" {
#   key_name = "server-web"
#   public_key = file("publicKey-test.pub")
# }

resource "aws_instance" "mi_servidor_web_debian" {
#   key_name = aws_key_pair.keys_of_server.id
  ami = "ami-064519b8c76274859"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.my_public_subnet.id
#   vpc_security_group_ids = [ aws_security_group.allow_http_and_ssh.id ]
#   user_data = file("user_data.sh")

  tags = {
    Name = "server"
  }
}