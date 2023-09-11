provider "ncloud" {
  support_vpc = true
  region      = "KR"
  access_key  = var.access_key
  secret_key  = var.secret_key
}

resource "ncloud_vpc" "vpc" {
    ipv4_cidr_block = "10.0.0.0/16"
}

resource "ncloud_subnet" "pub-sub" {  
  vpc_no         = ncloud_vpc.vpc.id
  subnet         = "10.0.1.0/24"
  zone           = "KR-2"
  network_acl_no = ncloud_vpc.vpc.default_network_acl_no
  subnet_type    = "PUBLIC"
}

resource "ncloud_public_ip" "master_ip" {
  server_instance_no = ncloud_server.master_node.id
}

resource "ncloud_public_ip" "node1_ip" {
  server_instance_no = ncloud_server.worker_node1.id
}

resource "ncloud_public_ip" "node2_ip" {
  server_instance_no = ncloud_server.worker_node2.id
}

resource "ncloud_login_key" "key" {
  key_name = "ncp-token-key"
}

resource "ncloud_server" "master_node" {
  subnet_no                 = ncloud_subnet.pub-sub.id
  name                      = "m-k8s"
  server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
  server_product_code       = "SVR.VSVR.STAND.C002.M008.NET.SSD.B050.G002"
  login_key_name            = ncloud_login_key.key.key_name
}

resource "ncloud_server" "worker_node1" {
  subnet_no                 = ncloud_subnet.pub-sub.id
  name                      = "w1-k8s"
  server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
  server_product_code       = "SVR.VSVR.STAND.C002.M008.NET.SSD.B050.G002"
  login_key_name            = ncloud_login_key.key.key_name
}

resource "ncloud_server" "worker_node2" {
  subnet_no                 = ncloud_subnet.pub-sub.id
  name                      = "w2-k8s"
  server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
  server_product_code       = "SVR.VSVR.STAND.C002.M008.NET.SSD.B050.G002"
  login_key_name            = ncloud_login_key.key.key_name
}

# 키 파일을 생성하고 로컬에 다운로드.
resource "local_file" "ssh_key" {
  filename = "${ncloud_login_key.key.key_name}.pem"
  content = ncloud_login_key.key.private_key
}

data "ncloud_root_password" "m-k8s-pwd" {
  server_instance_no = ncloud_server.master_node.id 
  private_key = ncloud_login_key.key.private_key
}

data "ncloud_root_password" "w1-k8s-pwd" {
  server_instance_no = ncloud_server.worker_node1.id 
  private_key = ncloud_login_key.key.private_key
}

data "ncloud_root_password" "w2-k8s-pwd" {
  server_instance_no = ncloud_server.worker_node2.id 
  private_key = ncloud_login_key.key.private_key
}


resource "terraform_data" "connect-m-k8s" {

  provisioner "remote-exec" {
     scripts = [ "./scripts/install_pkg.sh", "./scripts/k8s_setup.sh", "./scripts/master_node.sh"] 

      connection {
          type = "ssh"
          user = "root"
          password = data.ncloud_root_password.m-k8s-pwd.root_password
          host = ncloud_public_ip.master_ip.public_ip
      }
  }
}

resource "terraform_data" "connect-w1-k8s" {

  provisioner "remote-exec" {
     scripts = [ "./scripts/install_pkg.sh", "./scripts/k8s_setup.sh"] 

      connection {
          type = "ssh"
          user = "root"
          password = data.ncloud_root_password.w1-k8s-pwd.root_password
          host = ncloud_public_ip.node1_ip.public_ip
      }
  }
}

resource "terraform_data" "connect-w2-k8s" {

  provisioner "remote-exec" {
     scripts = [ "./scripts/install_pkg.sh", "./scripts/k8s_setup.sh"] 

      connection {
          type = "ssh"
          user = "root"
          password = data.ncloud_root_password.w2-k8s-pwd.root_password
          host = ncloud_public_ip.node2_ip.public_ip
      }
  }
}
