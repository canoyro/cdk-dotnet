#!/usr/bin/env bash
set -euo pipefail

iis_web_root="${IIS_WEB_ROOT:-}"

if [[ -z "$iis_web_root" ]]; then
  echo "IIS_WEB_ROOT is required. Example: /c/inetpub/wwwroot"
  exit 1
fi

if [[ ! -d "website-dist" ]]; then
  echo "website-dist was not found in the extracted package."
  exit 1
fi

mkdir -p "$iis_web_root"
find "$iis_web_root" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
cp -R website-dist/. "$iis_web_root/"

echo "Copied website-dist to $iis_web_root"
