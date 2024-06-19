#!/bin/sh

# Check if Vault is already running
if [ "$(vault status -format=json | jq -r .initialized)" = "true" ]; then
    echo "Vault is already initialized. Skipping initialization."
    exit 0
fi

# Clean up any existing Vault data
echo "Cleaning up existing Vault data..."
rm -rf /vault/file/*

# Start Vault in development mode
echo "Starting Vault in development mode..."
vault server -dev -dev-root-token-id=root &

# Capture the Vault server process ID
VAULT_PID=$!

# Wait for Vault to be ready
echo "Waiting for Vault to be ready..."
while ! nc -z localhost 8200; do
    echo "Waiting for Vault..."
    sleep 1
done

# Now Vault is ready, proceed with initialization
echo "Vault is ready. Proceeding with initialization..."

# Run the apply-policies script
/apply-policies.sh

# Keep the script running to prevent container from exiting
wait $VAULT_PID
