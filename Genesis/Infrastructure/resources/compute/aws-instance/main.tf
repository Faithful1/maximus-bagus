locals {
  eip_enabled = var.associate_public_ip_address && var.assign_eip_address && var.enabled
}

data "aws_ami" "ubuntu" {
  count = var.enabled && var.ami == null ? 1 : 0

  most_recent = "true"

  dynamic "filter" {
    for_each = var.ami_filter
    content {
      name   = filter.key
      values = filter.value
    }
  }

  owners = var.ami_owners
}

resource "aws_instance" "this" {
  count                       = var.enabled ? 1 : 0
  ami                         = var.ami //data.aws_ami.ubuntu[count.index].id
  instance_type               = var.instance_type
  monitoring                  = var.enable_monitoring
  subnet_id                   = var.subnets[0]
  key_name                    = var.key_name
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  tags                        = var.tags

  root_block_device {
    encrypted   = var.root_block_device_encrypted
    volume_size = var.root_block_device_volume_size
  }
}

resource "aws_eip" "default" {
  count    = local.eip_enabled ? 1 : 0
  instance = join("", aws_instance.this.*.id)
  vpc      = true
  tags     = var.tags
}
