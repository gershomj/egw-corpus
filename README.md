# EGW Corpus — Chunked Backup

Ellen G. White writings corpus database for use with [egw-tools](https://github.com/gershomj/egw-tools).

**Not for the Hermes nightly backup** — this is a separate, purpose-built repo for the 4.4GB corpus database.

## What's here

- `egw-corpus.db.zst.part-*` — Zstandard-compressed SQLite database split into 45MB chunks

## How to download and reassemble

```bash
./pull.sh
```

Or specify a custom output path:
```bash
./pull.sh /path/to/egw-corpus.db
```

## How to update (Gershom only)

After rebuilding the corpus DB:
```bash
./upload.sh
```

## Technical details

- Source: `~/.hermes/egw-corpus.db` (4.4GB SQLite, FTS5-indexed)
- **Compression:** zstd level 10 (4.4GB → 3.1GB)
- **Chunk count:** 68 chunks
- **Chunk size:** 45MB each
- Required by: [egw-tools](https://github.com/gershomj/egw-tools) v3.1.0+
