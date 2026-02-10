#!/bin/bash

# =============================================================================
# JGI ECC Guide Installer
# =============================================================================
# Usage: curl -fsSL https://raw.githubusercontent.com/JGIsup-dev/jgi-ecc-guide/main/install.sh | bash
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Repository URLs
JGI_REPO="JGIsup-dev/jgi-ecc-guide"
ECC_REPO="affaan-m/everything-claude-code"
BRANCH="main"

# Base URLs
JGI_RAW="https://raw.githubusercontent.com/${JGI_REPO}/${BRANCH}"
ECC_TARBALL="https://github.com/${ECC_REPO}/archive/${BRANCH}.tar.gz"

# =============================================================================
# Helper Functions
# =============================================================================

print_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  JGI ECC Guide Installer${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}→${NC} $1"
}

# Check if file exists and prompt for confirmation
check_existing_file() {
    local file_path="$1"
    if [ -f "$file_path" ]; then
        echo ""
        print_warning "File already exists: $file_path"
        read -p "  Overwrite? (y/n): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Skipped: $file_path"
            return 1
        fi
    fi
    return 0
}

# Download file with error handling
download_file() {
    local url="$1"
    local dest="$2"
    local name="$3"

    if check_existing_file "$dest"; then
        if curl -fsSL "$url" -o "$dest" 2>/dev/null; then
            print_success "$name"
        else
            print_error "Failed to download: $name"
            return 1
        fi
    fi
}

# =============================================================================
# Main Installation
# =============================================================================

print_header

# Check for curl
if ! command -v curl &> /dev/null; then
    print_error "curl is required but not installed."
    exit 1
fi

print_info "Installing to: $(pwd)"
echo ""

# -----------------------------------------------------------------------------
# Create directory structure
# -----------------------------------------------------------------------------
print_info "Creating directory structure..."

mkdir -p .claude/commands
mkdir -p .claude/skills/ecc-guide/reference
mkdir -p .claude/rules

print_success "Directory structure created"
echo ""

# -----------------------------------------------------------------------------
# Download files from jgi-ecc-guide
# -----------------------------------------------------------------------------
print_info "Downloading JGI ECC Guide files..."

# CLAUDE.md (project root)
download_file "${JGI_RAW}/CLAUDE.md" "./CLAUDE.md" "CLAUDE.md"

# settings.json
download_file "${JGI_RAW}/settings.json" "./.claude/settings.json" ".claude/settings.json"

# commands/guide.md
download_file "${JGI_RAW}/commands/guide.md" "./.claude/commands/guide.md" ".claude/commands/guide.md"

# skills/ecc-guide/
download_file "${JGI_RAW}/skills/ecc-guide/SKILL.md" "./.claude/skills/ecc-guide/SKILL.md" ".claude/skills/ecc-guide/SKILL.md"
download_file "${JGI_RAW}/skills/ecc-guide/reference/commands.md" "./.claude/skills/ecc-guide/reference/commands.md" ".claude/skills/ecc-guide/reference/commands.md"
download_file "${JGI_RAW}/skills/ecc-guide/reference/prompts.md" "./.claude/skills/ecc-guide/reference/prompts.md" ".claude/skills/ecc-guide/reference/prompts.md"
download_file "${JGI_RAW}/skills/ecc-guide/reference/workflows.md" "./.claude/skills/ecc-guide/reference/workflows.md" ".claude/skills/ecc-guide/reference/workflows.md"

echo ""

# -----------------------------------------------------------------------------
# Download rules from everything-claude-code
# -----------------------------------------------------------------------------
print_info "Downloading rules from everything-claude-code..."

ECC_TEMP_DIR=$(mktemp -d)

if curl -fsSL "${ECC_TARBALL}" -o "${ECC_TEMP_DIR}/ecc.tar.gz"; then
    tar -xzf "${ECC_TEMP_DIR}/ecc.tar.gz" -C "${ECC_TEMP_DIR}" --strip-components=1 "everything-claude-code-${BRANCH}/rules" 2>/dev/null
    if [ -d "${ECC_TEMP_DIR}/rules" ]; then
        rules_count=0
        for rule_file in "${ECC_TEMP_DIR}"/rules/*.md; do
            if [ -f "$rule_file" ]; then
                filename=$(basename "$rule_file")
                if check_existing_file "./.claude/rules/${filename}"; then
                    cp "$rule_file" "./.claude/rules/${filename}"
                    print_success ".claude/rules/${filename}"
                fi
                rules_count=$((rules_count + 1))
            fi
        done
        print_info "Rules: ${rules_count} files processed"
    else
        print_error "Rules directory not found in archive"
    fi
else
    print_error "Failed to download everything-claude-code"
fi

rm -rf "${ECC_TEMP_DIR}"

echo ""

# -----------------------------------------------------------------------------
# Complete
# -----------------------------------------------------------------------------
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Installation Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Installed files:"
echo "  ./CLAUDE.md"
echo "  ./.claude/settings.json"
echo "  ./.claude/commands/guide.md"
echo "  ./.claude/skills/ecc-guide/"
echo "  ./.claude/rules/ (from everything-claude-code)"
echo ""
echo "Usage:"
echo "  Run Claude Code in this directory and use:"
echo "  ${BLUE}/guide${NC} - Get ECC command recommendations"
echo ""
