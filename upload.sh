#!/bin/bash
# EGW Corpus — Upload chunks to GitHub
# Run this after compression + splitting is done
# Usage: ./upload.sh

set -e

REPO_DIR="$HOME/egw-corpus-repo"
cd "$REPO_DIR"

# Initialize git if not already
if [ ! -d .git ]; then
    git init
    git remote add origin https://github.com/gershomj/egw-corpus.git
fi

# Stage chunks in batches to avoid giant commits
echo "Staging chunks..."
git add egw-corpus.db.zst.part-*

# Commit
CHUNK_COUNT=$(ls egw-corpus.db.zst.part-* | wc -l)
TOTAL_SIZE=$(du -sh . | cut -f1)
git commit -m "EGW corpus v1 — ${CHUNK_COUNT} chunks, ${TOTAL_SIZE} total"

# Push (may need multiple attempts for large repos)
echo "Pushing to GitHub..."
git push -u origin master 2>&1 || {
    echo "Push failed — trying in smaller batches..."
    # Push in batches of 10 chunks
    PARTS=$(ls egw-corpus.db.zst.part-*)
    COUNT=0
    for PART in $PARTS; do
        git add "$PART"
        COUNT=$((COUNT + 1))
        if [ $((COUNT % 10)) -eq 0 ]; then
            git commit -m "EGW chunks batch $((COUNT / 10))"
            git push origin master
        fi
    done
    # Push remaining
    git add egw-corpus.db.zst.part-*
    git commit -m "EGW chunks final batch"
    git push origin master
}

echo "Done — ${CHUNK_COUNT} chunks pushed to GitHub."
