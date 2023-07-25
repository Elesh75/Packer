packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.6"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "cocktail" {
  ami_name      = "cocktail-$(local.timestamp)"   # this will enable us generate diff ami each time we build using time stamp to differentiate them
  instance_type = "t2.micro"                # or ami_name      = "${var.ami_prefix}-${local.timestamp}"  but you need to define your var.ami_prefix block
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
  ssh_username = "ubuntu"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}


build {
  name = "my-packer1"
  sources = [
    "source.amazon-ebs.cocktail"
  ]

  provisioner "file" { # we use this file provisioner to move file to machine built by packer
    source      = "../cocktails.zip"
    destination = "/home/ubuntu/cocktails.zip"
  }
  provisioner "file" { # we use this file provisioner to move file to machine built by packer
    source      = "./cocktails.service"
    destination = "/tmp/cocktails.service"
  }

  provisioner "shell" { # we are using shell to run this script this could be any type of provisioner used in packer
    script = "./app.sh"
  }
}