#!/bin/bash
set -e

GOOGLE_CREDS_DIR="/data/.openclaw/credentials/google"
GOOGLE_CREDS_FILE="$GOOGLE_CREDS_DIR/client_secret.json"

mkdir -p "$GOOGLE_CREDS_DIR"

if [ -n "$GOOGLE_CLIENT_ID" ] && [ -n "$GOOGLE_CLIENT_SECRET" ]; then
    echo "[google-setup] Creating Google OAuth credentials from environment variables..."
    cat > "$GOOGLE_CREDS_FILE" << EOF
{
  "installed": {
    "client_id": "$GOOGLE_CLIENT_ID",
    "project_id": "openclaw-integration-487807",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_secret": "$GOOGLE_CLIENT_SECRET",
    "redirect_uris": ["http://localhost", "urn:ietf:wg:oauth:2.0:oob"]
  }
}
EOF
    chmod 600 "$GOOGLE_CREDS_FILE"
    echo "[google-setup] Credentials file created at $GOOGLE_CREDS_FILE"
else
    echo "[google-setup] GOOGLE_CLIENT_ID or GOOGLE_CLIENT_SECRET not set, skipping credentials setup"
fi
