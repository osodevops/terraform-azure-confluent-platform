# -----------------------------------------------------------------------------
# MDS token key pair (RSA 2048) for RBAC token signing
# -----------------------------------------------------------------------------
resource "tls_private_key" "mds" {
  count     = var.rbac_enabled ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 2048
}

# -----------------------------------------------------------------------------
# MDS token secret – contains the public key and the full key pair
# -----------------------------------------------------------------------------
resource "kubernetes_secret" "mds_token" {
  count = var.rbac_enabled ? 1 : 0

  metadata {
    name      = "${var.name_prefix}-mds-token"
    namespace = kubernetes_namespace.confluent.metadata[0].name
  }

  type = "Opaque"

  data = {
    mdsPublicKey    = tls_private_key.mds[0].public_key_pem
    mdsTokenKeyPair = tls_private_key.mds[0].private_key_pem
  }
}

# -----------------------------------------------------------------------------
# MDS client credentials – per-component bearer tokens
# -----------------------------------------------------------------------------
resource "kubernetes_secret" "mds_client_kafka" {
  count = var.rbac_enabled ? 1 : 0

  metadata {
    name      = "${var.name_prefix}-mds-client-kafka"
    namespace = kubernetes_namespace.confluent.metadata[0].name
  }

  type = "Opaque"

  data = {
    "bearer.txt" = "kafka-secret"
  }
}

resource "kubernetes_secret" "mds_client_sr" {
  count = var.rbac_enabled ? 1 : 0

  metadata {
    name      = "${var.name_prefix}-mds-client-sr"
    namespace = kubernetes_namespace.confluent.metadata[0].name
  }

  type = "Opaque"

  data = {
    "bearer.txt" = "sr-secret"
  }
}

resource "kubernetes_secret" "mds_client_connect" {
  count = var.rbac_enabled ? 1 : 0

  metadata {
    name      = "${var.name_prefix}-mds-client-connect"
    namespace = kubernetes_namespace.confluent.metadata[0].name
  }

  type = "Opaque"

  data = {
    "bearer.txt" = "connect-secret"
  }
}

resource "kubernetes_secret" "mds_client_ksqldb" {
  count = var.rbac_enabled ? 1 : 0

  metadata {
    name      = "${var.name_prefix}-mds-client-ksqldb"
    namespace = kubernetes_namespace.confluent.metadata[0].name
  }

  type = "Opaque"

  data = {
    "bearer.txt" = "ksqldb-secret"
  }
}

resource "kubernetes_secret" "mds_client_c3" {
  count = var.rbac_enabled ? 1 : 0

  metadata {
    name      = "${var.name_prefix}-mds-client-c3"
    namespace = kubernetes_namespace.confluent.metadata[0].name
  }

  type = "Opaque"

  data = {
    "bearer.txt" = "c3-secret"
  }
}

resource "kubernetes_secret" "mds_client_krp" {
  count = var.rbac_enabled ? 1 : 0

  metadata {
    name      = "${var.name_prefix}-mds-client-krp"
    namespace = kubernetes_namespace.confluent.metadata[0].name
  }

  type = "Opaque"

  data = {
    "bearer.txt" = "krp-secret"
  }
}

# -----------------------------------------------------------------------------
# REST credential secret – used for REST-based authentication
# -----------------------------------------------------------------------------
resource "kubernetes_secret" "rest_credential" {
  count = var.rbac_enabled ? 1 : 0

  metadata {
    name      = "${var.name_prefix}-rest-credential"
    namespace = kubernetes_namespace.confluent.metadata[0].name
  }

  type = "Opaque"

  data = {
    "bearer.txt" = "kafka-secret"
    "basic.txt"  = "kafka:kafka-secret"
  }
}
