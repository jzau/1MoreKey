#!/bin/sh

KEY_CHAIN=build.keychain
# Create a custom keychain
security create-keychain -p travis-password $KEY_CHAIN

# Make the custom keychain default, so xcodebuild will use it for signing
security default-keychain -s $KEY_CHAIN

# Unlock the keychain
security unlock-keychain -p travis-password $KEY_CHAIN

# Set keychain timeout to 1 hour for long builds
# see http://www.egeek.me/2013/02/23/jenkins-and-xcode-user-interaction-is-not-allowed/
security set-keychain-settings -t 3600 -l ~/Library/Keychains/$KEY_CHAIN

# Add certificates to keychain and allow codesign to access them
security import ./scripts/certs/apple.cer -k $KEY_CHAIN -T /usr/bin/codesign
security import ./scripts/certs/developerID.cer -k $KEY_CHAIN -T /usr/bin/codesign
security import ./scripts/certs/developerID.p12 -k $KEY_CHAIN -P $KEY_PASSWORD -T /usr/bin/codesign

security set-key-partition-list -S apple-tool:,apple: -s -k travis-password build.keychain

echo "Add keychain to keychain-list"
security list-keychains -s build.keychain