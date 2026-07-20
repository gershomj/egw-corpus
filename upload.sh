#!/bin/bash
# EGW Corpus — Upload chunks to GitHub in small batches
set -e
REPO_DIR="$HOME/egw-corpus-repo"
cd "$REPO_DIR"

PARTS=($(ls egw-corpus.db.zst.part-* | sort))
TOTAL=${#PARTS[@]}
BATCH=5
echo "Pushing ${TOTAL} chunks in batches of ${BATCH}..."

for ((i=0; i<TOTAL; i+=BATCH)); do
    BATCH_NUM=$((i / BATCH + 1))
    echo "[Batch ${BATCH_NUM}] Pushing chunks $((i+1))-$((i+BATCH > TOTAL ? TOTAL : i+BATCH))..."
    
    # Stage this batch
    for ((j=i; j<i+BATCH && j<TOTAL; j++)); do
        git add "${PARTS[$j]}"
    done
    
    git commit -m "EGW chunks batch ${BATCH_NUM}/$(( (TOTAL + BATCH - 1) / BATCH ))" --allow-empty
    git push origin master 2>&1
    echo ""
done

# Push scripts/README too
git add README.md pull.sh upload.sh
git commit -m "EGW corpus: scripts and docs" --allow-empty
git push origin master

echo "Done — all ${TOTAL} chunks pushed."
