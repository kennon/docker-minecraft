#!/bin/bash

TARGET_DIR=/data/minecraft

JSON=`curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json`
LATEST_RELEASE=`echo $JSON | jq -r '.latest.release'`
RELEASE_URL=`echo $JSON | jq -r ".versions[] | select(.id == \"$LATEST_RELEASE\") | .url"`
RELEASE_JSON=`curl -s $RELEASE_URL`

SERVER_URL=`echo $RELEASE_JSON | jq -r ".downloads.server.url"`
CLIENT_URL=`echo $RELEASE_JSON | jq -r ".downloads.client.url"`

echo "Latest release: $LATEST_RELEASE"
echo "ServerURL: $SERVER_URL"
echo "ClientURL: $CLIENT_URL"


echo "About to update jars in $TARGET_DIR. Press ctrl-c to cancel or any other key to continue..."
read

curl -s $SERVER_URL -o $TARGET_DIR/minecraft_server.$LATEST_RELEASE.jar
curl -s $CLIENT_URL -o $TARGET_DIR/minecraft_client.$LATEST_RELEASE.jar

echo "About to symlink jars. Press ctrl-c to cancel or any other key to continue..."
read

(
  cd $TARGET_DIR
  ln -sf minecraft_server.$LATEST_RELEASE.jar minecraft_server.jar
  ln -sf minecraft_client.$LATEST_RELEASE.jar minecraft_client.jar
)
