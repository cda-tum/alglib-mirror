#!/usr/bin/env bash
# add_version.sh - Add a new ALGLIB version to the mirror repository
#
# Usage: ./add_version.sh <version> [edition]
#
# Examples:
#   ./add_version.sh 4.08.0
#   ./add_version.sh 4.08.0 cpp
#   ./add_version.sh 3.14.0 csharp

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
MIRROR_ORG="${ALGLIB_MIRROR_ORG:-cda-tum}"
MIRROR_REPO="alglib-mirror"

# Show usage
usage() {
    cat << 'EOF'
Usage: ./add_version.sh <version> [edition]

Add a new ALGLIB version to the mirror repository.

Arguments:
  version     ALGLIB version number (e.g., 3.14.0, 4.00.0)
  edition     Edition type (optional, default: cpp)
              Options: cpp, csharp, vbnet, delphi, java, cpython, ipython

Examples:
  ./add_version.sh 4.08.0                  # C++ GPL edition (default)
  ./add_version.sh 4.08.0 cpp              # C++ GPL edition
  ./add_version.sh 3.14.0 csharp           # C# GPL edition
  ./add_version.sh 4.00.0 java             # Java Free edition

Environment Variables:
  ALGLIB_MIRROR_ORG    GitHub organization (default: cda-tum)

Requirements:
  - GitHub CLI (gh) must be installed and authenticated
  - wget or curl for downloading files

EOF
    exit 1
}

# Parse arguments
if [ $# -lt 1 ]; then
    usage
fi

ALGLIB_VERSION="$1"
EDITION="${2:-cpp}"

# Validate version format
if ! [[ "${ALGLIB_VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}Error: Invalid version format '${ALGLIB_VERSION}'${NC}"
    echo "Expected format: X.Y.Z (e.g., 3.14.0 or 4.00.0)"
    exit 1
fi

# Determine file extension and license type based on edition
case "${EDITION}" in
    cpp)
        FILE_EXTENSION="cpp.gpl.tgz"
        LICENSE_TYPE="GPL"
        EDITION_NAME="C++ GPL"
        ;;
    csharp)
        FILE_EXTENSION="csharp.gpl.tgz"
        LICENSE_TYPE="GPL"
        EDITION_NAME="C# GPL"
        ;;
    vbnet)
        FILE_EXTENSION="vbnet.gpl.tgz"
        LICENSE_TYPE="GPL"
        EDITION_NAME="VB.NET GPL"
        ;;
    delphi)
        FILE_EXTENSION="delphi.free.tgz"
        LICENSE_TYPE="Free"
        EDITION_NAME="Delphi Free"
        ;;
    java)
        FILE_EXTENSION="java.free.tgz"
        LICENSE_TYPE="Free"
        EDITION_NAME="Java Free"
        ;;
    cpython)
        FILE_EXTENSION="cpython.tgz"
        LICENSE_TYPE="Free"
        EDITION_NAME="CPython"
        ;;
    ipython)
        FILE_EXTENSION="ipython.tgz"
        LICENSE_TYPE="Free"
        EDITION_NAME="IPython"
        ;;
    *)
        echo -e "${RED}Error: Unknown edition '${EDITION}'${NC}"
        echo "Supported editions: cpp, csharp, vbnet, delphi, java, cpython, ipython"
        exit 1
        ;;
esac

ALGLIB_FILE="alglib-${ALGLIB_VERSION}.${FILE_EXTENSION}"
ALGLIB_URL="http://www.alglib.net/translator/re/${ALGLIB_FILE}"

echo -e "${BLUE}==================================="
echo "ALGLIB Mirror - Add New Version"
echo "===================================${NC}"
echo ""
echo "Version:      ${ALGLIB_VERSION}"
echo "Edition:      ${EDITION_NAME}"
echo "File:         ${ALGLIB_FILE}"
echo "Organization: ${MIRROR_ORG}/${MIRROR_REPO}"
echo ""

# Check for gh CLI
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) is not installed.${NC}"
    echo "Install from: https://cli.github.com/"
    echo ""
    echo "Installation:"
    echo "  macOS:   brew install gh"
    echo "  Linux:   See https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
    echo "  Windows: See https://github.com/cli/cli#windows"
    exit 1
fi

echo -e "${GREEN}✓${NC} GitHub CLI found"

# Check authentication
if ! gh auth status &> /dev/null; then
    echo -e "${YELLOW}⚠${NC}  Not authenticated with GitHub"
    echo "Authenticating..."
    gh auth login
fi

echo -e "${GREEN}✓${NC} GitHub authenticated"

# Check if repository exists
if ! gh repo view "${MIRROR_ORG}/${MIRROR_REPO}" &> /dev/null; then
    echo -e "${RED}Error: Repository ${MIRROR_ORG}/${MIRROR_REPO} does not exist${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} Repository accessible"

# Check if release already exists
TAG="v${ALGLIB_VERSION}"
if [ "${EDITION}" != "cpp" ]; then
    TAG="v${ALGLIB_VERSION}-${EDITION}"
fi

if gh release view "${TAG}" --repo "${MIRROR_ORG}/${MIRROR_REPO}" &> /dev/null; then
    echo -e "${YELLOW}⚠${NC}  Release ${TAG} already exists"
    read -p "Do you want to delete and recreate it? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Deleting existing release..."
        gh release delete "${TAG}" --repo "${MIRROR_ORG}/${MIRROR_REPO}" --yes
        echo -e "${GREEN}✓${NC} Existing release deleted"
    else
        echo "Aborted by user"
        exit 0
    fi
fi

# Download ALGLIB if not present
if [ -f "${ALGLIB_FILE}" ]; then
    echo -e "${YELLOW}⚠${NC}  File ${ALGLIB_FILE} already exists locally"
    read -p "Use existing file? (Y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo "Removing existing file..."
        rm -f "${ALGLIB_FILE}"
    else
        echo -e "${GREEN}✓${NC} Using existing file"
    fi
fi

if [ ! -f "${ALGLIB_FILE}" ]; then
    echo "Downloading ${ALGLIB_FILE}..."
    echo "Source: ${ALGLIB_URL}"

    DOWNLOAD_SUCCESS=false

    # Try wget first
    if command -v wget &> /dev/null; then
        if wget -q --show-progress --timeout=60 --tries=3 "${ALGLIB_URL}"; then
            DOWNLOAD_SUCCESS=true
        fi
    # Fall back to curl
    elif command -v curl &> /dev/null; then
        if curl -f -L --progress-bar -o "${ALGLIB_FILE}" --max-time 60 --retry 3 "${ALGLIB_URL}"; then
            DOWNLOAD_SUCCESS=true
        fi
    else
        echo -e "${RED}Error: Neither wget nor curl is available${NC}"
        exit 1
    fi

    if [ "$DOWNLOAD_SUCCESS" = false ]; then
        echo -e "${RED}Error: Failed to download ${ALGLIB_FILE}${NC}"
        echo ""
        echo "Please try one of the following:"
        echo "  1. Download manually from: ${ALGLIB_URL}"
        echo "  2. Place the file in the current directory and run this script again"
        echo "  3. Check your internet connection and try again"
        rm -f "${ALGLIB_FILE}"
        exit 1
    fi

    echo -e "${GREEN}✓${NC} Download completed"
fi

# Verify file size
FILE_SIZE=$(stat -f%z "${ALGLIB_FILE}" 2>/dev/null || stat -c%s "${ALGLIB_FILE}" 2>/dev/null)
if [ "${FILE_SIZE}" -lt 100000 ]; then
    echo -e "${RED}Error: Downloaded file is too small (${FILE_SIZE} bytes)${NC}"
    echo "The file may be corrupted or the download failed"
    rm -f "${ALGLIB_FILE}"
    exit 1
fi

FILE_SIZE_MB=$(echo "scale=1; ${FILE_SIZE} / 1048576" | bc)
echo -e "${GREEN}✓${NC} File verified (${FILE_SIZE_MB} MB)"

# Create release notes
RELEASE_NOTES="Mirror of ALGLIB ${ALGLIB_VERSION} ${EDITION_NAME} edition.

Original source: ${ALGLIB_URL}

File: ${ALGLIB_FILE}
Size: ${FILE_SIZE} bytes

This is a mirror to provide reliable downloads for CI/CD environments."

# Create release
echo ""
echo "Creating release ${TAG}..."
if gh release create "${TAG}" \
    "${ALGLIB_FILE}" \
    --repo "${MIRROR_ORG}/${MIRROR_REPO}" \
    --title "ALGLIB ${ALGLIB_VERSION} (${EDITION_NAME})" \
    --notes "${RELEASE_NOTES}"; then
    echo ""
    echo -e "${GREEN}✓ Release created successfully!${NC}"
    echo ""
    echo "Release URL: https://github.com/${MIRROR_ORG}/${MIRROR_REPO}/releases/tag/${TAG}"
    echo "Download URL: https://github.com/${MIRROR_ORG}/${MIRROR_REPO}/releases/download/${TAG}/${ALGLIB_FILE}"
else
    echo -e "${RED}Error: Failed to create release${NC}"
    exit 1
fi

# Clean up
read -p "Delete local file ${ALGLIB_FILE}? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -f "${ALGLIB_FILE}"
    echo -e "${GREEN}✓${NC} Local file deleted"
else
    echo "Keeping local file: ${ALGLIB_FILE}"
fi

echo ""
echo -e "${GREEN}==================================="
echo "✓ All done!"
echo "===================================${NC}"
