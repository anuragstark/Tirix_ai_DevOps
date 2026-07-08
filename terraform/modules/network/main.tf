# ─────────────────────────────────────────────────────────────
# Tirix AI — OCI Network Module
# Creates VCN, Subnet, Internet Gateway, Route Table, Security List
# ─────────────────────────────────────────────────────────────

# ── VCN ─────────────────────────────────────────────────────
resource "oci_core_vcn" "main" {
  compartment_id = var.compartment_id
  display_name   = "${var.project_name}-vcn"
  cidr_blocks    = [var.vcn_cidr]
  dns_label      = var.dns_label

  freeform_tags = var.tags
}

# ── Internet Gateway ────────────────────────────────────────
resource "oci_core_internet_gateway" "main" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.project_name}-igw"
  enabled        = true

  freeform_tags = var.tags
}

# ── Route Table (default route → IGW) ──────────────────────
resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.project_name}-public-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.main.id
    description       = "Route all traffic to Internet Gateway"
  }

  freeform_tags = var.tags
}

# ── Security List ───────────────────────────────────────────
resource "oci_core_security_list" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.project_name}-public-sl"

  # ── Egress: Allow ALL outbound ────────────────────────────
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    description = "Allow all outbound traffic (S3, APIs, GHCR)"
  }

  # ── Ingress: SSH (port 22) ───────────────────────────────
  ingress_security_rules {
    protocol    = "6" # TCP
    source      = var.ssh_allowed_cidr
    description = "SSH access"

    tcp_options {
      min = 22
      max = 22
    }
  }

  # ── Ingress: HTTP (port 80) ──────────────────────────────
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "HTTP access"

    tcp_options {
      min = 80
      max = 80
    }
  }

  # ── Ingress: HTTPS (port 443) ────────────────────────────
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "HTTPS access"

    tcp_options {
      min = 443
      max = 443
    }
  }

  # ── Ingress: ICMP (ping) for diagnostics ─────────────────
  ingress_security_rules {
    protocol    = "1" # ICMP
    source      = "0.0.0.0/0"
    description = "ICMP ping"

    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    protocol    = "1"
    source      = var.vcn_cidr
    description = "ICMP from VCN"

    icmp_options {
      type = 3
    }
  }

  freeform_tags = var.tags
}

# ── Public Subnet ───────────────────────────────────────────
resource "oci_core_subnet" "public" {
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.main.id
  display_name               = "${var.project_name}-public-subnet"
  cidr_block                 = var.subnet_cidr
  dns_label                  = "pub"
  route_table_id             = oci_core_route_table.public.id
  security_list_ids          = [oci_core_security_list.public.id]
  prohibit_public_ip_on_vnic = false

  freeform_tags = var.tags
}
