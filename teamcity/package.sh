#!/usr/bin/env bash
set -euo pipefail

package_name="${PACKAGE_NAME:-cheap-dotnet-web}"
package_version="${PACKAGE_VERSION:-${BUILD_NUMBER:-0.0.0-local}}"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
artifact_root="$repo_root/.artifacts"
# staging_root="$artifact_root/$package_name.$package_version"
# package_path="$artifact_root/$package_name.$package_version.zip"
staging_root="$artifact_root/$package_name.$package_version"
package_path="$artifact_root/$package_name.$package_version.zip"

cd "$repo_root"

rm -rf "$staging_root" "$package_path"
mkdir -p "$staging_root"

cp -R \
  octopus \
  website-dist \
  "$staging_root/"

(
  cd "$staging_root"
  zip -r "$package_path" .
)

echo "Created package: $package_path"
