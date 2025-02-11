#!/bin/bash
set -ex

rm -rf TinfoilVerifier.xcframework verifier

LATEST_TAG=$(curl -sL https://api.github.com/repos/tinfoilsh/verifier/releases/latest | jq -r ".tag_name")

git clone https://github.com/tinfoilanalytics/verifier -b "$LATEST_TAG"

cd verifier
go get golang.org/x/mobile/cmd/gomobile
gomobile bind -target=ios -o ../TinfoilVerifier.xcframework github.com/tinfoilsh/verifier/pkg/client
go mod tidy
cd ..

git add TinfoilVerifier.xcframework
git commit -m "chore: add verifier $LATEST_TAG"
git tag "$LATEST_TAG"
git push --tags
