#!/bin/bash
# EGW Corpus — Download and reassemble from GitHub
# Usage: ./pull.sh [output_path]
# Default output: ~/.hermes/egw-corpus.db

set -e

OUTPUT="${1:-$HOME/.hermes/egw-corpus.db}"
REPO_URL="https://github.com/gershomj/egw-corpus.git"
TMP_DIR="$HOME/egw-corpus-pull-tmp"

echo "=== EGW Corpus Pull & Reassembly ==="
echo ""

# Clean up any previous temp dir
rm -rf "$TMP_DIR"

# Shallow clone to get just the chunks (no history)
echo "Downloading chunks from GitHub..."
git clone --depth 1 "$REPO_URL" "$TMP_DIR" 2>&1 | tail -1

cd "$TMP_DIR"
CHUNK_COUNT=$(ls egw-corpus.db.zst.part-* | wc -l)
echo "Found ${CHUNK_COUNT} chunks."

# Concatenate and decompress
echo "Reassembling..."
cat egw-corpus.db.zst.part-* | zstd -d -o "$OUTPUT" 2>&1

# Verify
SIZE=$(ls -lh "$OUTPUT" | awk '{print $5}')
echo ""
echo "Done — ${OUTPUT} (${SIZE})"
echo ""

# Cleanup
rm -rf "$TMP_DIR"
echo "Temp files cleaned up."
