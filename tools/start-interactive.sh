#/bin/bash

echo "Note: This setup uses Google Drive download instead of Steam."
echo "Steam credentials are not required."
echo ""
# Steam credentials disabled - using Google Drive download
# read -p "Enter your Steam username: " STEAM_USER
# echo ""
# read -sp "Enter your Steam password: " STEAM_PASS
STEAM_USER=""
STEAM_PASS=""
echo ""
echo ""

# Create a temporary file
TEMP_ENV_FILE=$(mktemp)

# Trap to ensure the temporary file is deleted on exit,
# even in case of errors before manual deletion
trap 'rm -f "$TEMP_ENV_FILE"' EXIT

# Write credentials to the temporary file
cat <<EOF > "$TEMP_ENV_FILE"
STEAM_USER=$STEAM_USER
STEAM_PASS=$STEAM_PASS
EOF

# Append the existing .env file to the temporary file
if [ -f ".env" ]; then
  cat .env >> "$TEMP_ENV_FILE"
fi

# Finally, start docker with the .env file which is immediately deleted afterwards
docker compose --env-file "$TEMP_ENV_FILE" up -d --force-recreate 

# Immediately delete the temp env file
rm -f "$TEMP_ENV_FILE"