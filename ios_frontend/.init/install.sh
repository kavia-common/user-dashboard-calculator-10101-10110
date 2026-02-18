#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/user-dashboard-calculator-10101-10110/ios_frontend"
SWIFT_VER_STR="5.9.7"
SWIFT_BASE_DIR="/usr/share"
SWIFT_INSTALL_DIR="${SWIFT_BASE_DIR}/swift-${SWIFT_VER_STR}"
SWIFT_SYMLINK="${SWIFT_BASE_DIR}/swift"
TMPDIR=$(mktemp -d)
cd "$TMPDIR"
mkdir -p "$WORKSPACE"
# Install runtime deps quietly
sudo apt-get update -q && sudo apt-get install -y -qq ca-certificates curl wget tar sqlite3 libsqlite3-dev cmake pkg-config libatomic1 libicu-dev libssl-dev libcurl4 jq >/dev/null
# Disk space preflight (~200MB required in /usr)
FREE_KB=$(df --output=avail /usr | tail -n1 || echo 0)
if [ "$FREE_KB" -lt 200000 ]; then
  echo "ERROR: insufficient disk space in /usr (need ~200MB)" >&2
  exit 10
fi
# If swift exists and meets >= required version, ensure shim and exit
if command -v swift >/dev/null 2>&1; then
  EXIST_VER_RAW=$(swift --version 2>/dev/null | head -n1 || true)
  if echo "$EXIST_VER_RAW" | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' >/dev/null 2>&1; then
    EXIST_VER=$(echo "$EXIST_VER_RAW" | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
    if dpkg --compare-versions "$EXIST_VER" ge "$SWIFT_VER_STR"; then
      # ensure shim exists for non-login shells
      if [ ! -x /usr/local/bin/swift ]; then
        sudo bash -c 'cat >/usr/local/bin/swift <<"SH"\n#!/usr/bin/env bash\nexec /usr/share/swift/usr/bin/swift "$@"\nSH'
        sudo chmod +x /usr/local/bin/swift
      fi
      echo "INFO: existing swift $EXIST_VER satisfies >= $SWIFT_VER_STR" >&2
      exit 0
    fi
  fi
fi
# Fetch releases.json and choose tarball (resilient matching with fallbacks)
METADATA_URL="https://download.swift.org/releases.json"
RETRY_ARGS=(--retry 3 --retry-delay 5 --fail --silent --show-error)
curl "${RETRY_ARGS[@]}" -o releases.json "$METADATA_URL"
TARBALL_NAME=$(jq -r --arg v "$SWIFT_VER_STR" '.releases[] | select(.version==$v) | .files[]?.filename' releases.json 2>/dev/null | grep -E "${SWIFT_VER_STR}.*(ubuntu24.04|ubuntu22.04|ubuntu20.04|linux).*\.tar\.gz" | head -n1 || true)
if [ -z "$TARBALL_NAME" ]; then
  TARBALL_NAME="swift-${SWIFT_VER_STR}-RELEASE-ubuntu24.04.tar.gz"
fi
SWIFT_URL="https://download.swift.org/${TARBALL_NAME}"
# Obtain checksum from metadata
SWIFT_SHA256=$(jq -r --arg f "$TARBALL_NAME" '.releases[]?.files[]? | select(.filename==$f) | .checksum // .sha256 // empty' releases.json 2>/dev/null || true)
if [ -z "$SWIFT_SHA256" ]; then
  echo "ERROR: could not determine SHA256 for $TARBALL_NAME from releases.json" >&2
  rm -rf "$TMPDIR"
  exit 2
fi
ARCHIVE="$TMPDIR/$TARBALL_NAME"
curl "${RETRY_ARGS[@]}" -o "$ARCHIVE" "$SWIFT_URL" || { echo "ERROR: download failed $SWIFT_URL" >&2; rm -rf "$TMPDIR"; exit 3; }
# Verify checksum
echo "${SWIFT_SHA256}  ${ARCHIVE}" | sha256sum -c - >/dev/null || { echo "ERROR: checksum mismatch for $ARCHIVE" >&2; rm -rf "$TMPDIR"; exit 4; }
# Extract into temp and then move atomically
EXTRACT_DIR="$TMPDIR/swift-extract"
mkdir -p "$EXTRACT_DIR"
tar -xzf "$ARCHIVE" -C "$EXTRACT_DIR" || { echo "ERROR: tar extraction failed" >&2; rm -rf "$TMPDIR"; exit 5; }
# Normalize layout: some distributions include a top-level dir; detect and choose appropriate source
# If extraction produced a single top-level directory, use its contents
TOP_DIR_COUNT=$(find "$EXTRACT_DIR" -maxdepth 1 -mindepth 1 -type d | wc -l || echo 0)
SRC_DIR="$EXTRACT_DIR"
if [ "$TOP_DIR_COUNT" -eq 1 ]; then
  SRC_DIR=$(find "$EXTRACT_DIR" -maxdepth 1 -mindepth 1 -type d | head -n1)
fi
# Prepare target: remove old, move new atomically
sudo rm -rf "$SWIFT_INSTALL_DIR" || true
sudo mv "$SRC_DIR" "$SWIFT_INSTALL_DIR"
# If binaries are under bin instead of usr/bin, normalize
if [ -d "$SWIFT_INSTALL_DIR/usr/bin" ]; then
  true
else
  if [ -d "$SWIFT_INSTALL_DIR/bin" ]; then
    sudo mkdir -p "$SWIFT_INSTALL_DIR/usr" && sudo mv "$SWIFT_INSTALL_DIR/bin" "$SWIFT_INSTALL_DIR/usr/bin" || true
  fi
fi
sudo chown -R root:root "$SWIFT_INSTALL_DIR"
# Update stable symlink atomically
sudo ln -sfn "$SWIFT_INSTALL_DIR" "$SWIFT_SYMLINK"
# Persist PATH via /etc/profile.d
PROFILE_FILE="/etc/profile.d/swift.sh"
sudo bash -c "cat > ${PROFILE_FILE}" <<'EOF'
# Swift toolchain
if [ -d /usr/share/swift/usr/bin ]; then
  export PATH=/usr/share/swift/usr/bin:$PATH
fi
EOF
sudo chmod +x ${PROFILE_FILE}
# Create shim for non-login shells
sudo bash -c 'cat >/usr/local/bin/swift <<"SH"\n#!/usr/bin/env bash\nexec /usr/share/swift/usr/bin/swift "$@"\nSH'
sudo chmod +x /usr/local/bin/swift
# Ensure current shell can use swift
export PATH=/usr/share/swift/usr/bin:/usr/local/bin:$PATH
if ! command -v swift >/dev/null 2>&1; then
  echo "ERROR: swift not on PATH after install" >&2
  rm -rf "$TMPDIR"
  exit 6
fi
swift --version >/dev/null || { echo "ERROR: swift --version failed" >&2; rm -rf "$TMPDIR"; exit 7; }
swiftc --version >/dev/null || { echo "ERROR: swiftc --version failed" >&2; rm -rf "$TMPDIR"; exit 8; }
rm -rf "$TMPDIR"
exit 0
