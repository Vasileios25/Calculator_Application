ui = true

storage "file" {
  path = "/vault/file"
}

listener "tcp" {
  address = "0.0.0.0:8200"  # Main listener port
  tls_disable = 1
}
