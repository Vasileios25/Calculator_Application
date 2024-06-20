#!/bin/sh

echo "Applying Vault policies..."

# Ensure Vault environment variables are set
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='root'

vault secrets enable -path=my_data kv

# Wait for Vault to be ready for requests
while ! vault status > /dev/null 2>&1; do
    echo "Waiting for Vault to be ready for API requests..."
    sleep 1
done

# Read .env file line by line and store each key-value pair in Vault
# Read .env file line by line and store each key-value pair in Vault
while IFS='=' read -r key value; do
    if [ -n "$key" ]; then
        vault kv put my_data/env/"$key" value="$value"
    fi
done < .env

# Enable the transit secret engine and create keys
vault secrets enable transit
vault write -f transit/keys/key1 type=rsa-2048
vault write -f transit/keys/key2 type=ecdsa-p256



# Encrypt the data from the .env file
while IFS='=' read -r key value; do
    if [ -n "$key" ]; then
	plaintext=$(echo -n "$value" | base64)
        ciphertext=$(vault write -field=ciphertext transit/encrypt/key1 plaintext="$plaintext")
        echo "Encrypted $key: $ciphertext"
    fi
done < .env

# Apply the kv policy
#vault policy write kv-policy /vault/policies/kv-policy.hcl

echo "Vault policies applied successfully."
# List secrets at the my_data/env/ path
echo "Listing secrets at my_data/env/ path:"
vault kv list my_data/env/
