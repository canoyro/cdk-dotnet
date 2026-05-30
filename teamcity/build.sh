#!/usr/bin/env bash
set -euo pipefail

configuration="${CONFIGURATION:-Release}"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$repo_root"

npm ci
npm run build
npm test -- --runInBand

dotnet restore src/CheapDotnetWeb/CheapDotnetWeb.csproj
dotnet publish src/CheapDotnetWeb/CheapDotnetWeb.csproj \
  -c "$configuration" \
  -o .publish

rm -rf website-dist
mkdir -p website-dist
cp -R .publish/wwwroot/. website-dist/

npx cdk synth
