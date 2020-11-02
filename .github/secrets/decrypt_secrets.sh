#!/bin/sh
set -eo pipefail

gpg --quiet --batch --yes --decrypt --passphrase="$IOS_KEYS" --output ./.github/secrets/Execushield_dev_profile.mobileprovision ./.github/secrets/Execushield_dev_profile.mobileprovision.gpg
gpg --quiet --batch --yes --decrypt --passphrase="$IOS_KEYS" --output ./.github/secrets/ES_ios_Certificates.p12 ./.github/secrets/ES_ios_Certificates.p12.gpg

mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles

cp ./.github/secrets/Execushield_dev_profile.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/Execushield_dev_profile.mobileprovision


security create-keychain -p "1010" build.keychain
security import ./.github/secrets/ES_ios_Certificates.p12 -t agg -k ~/Library/Keychains/build.keychain -P "1010" -A

security list-keychains -s ~/Library/Keychains/build.keychain
security default-keychain -s ~/Library/Keychains/build.keychain
security unlock-keychain -p "1010" ~/Library/Keychains/build.keychain

security set-key-partition-list -S apple-tool:,apple: -s -k "" ~/Library/Keychains/build.keychain
