#!/usr/bin/env bash

PROJECTS_DIR="$HOME/projects"
TARGET_USER="mariononyango30-ctrl"

cd "$PROJECTS_DIR" || exit 1

for dir in */; do
    dir_name="${dir%/}"
    
    [ -d "$PROJECTS_DIR/$dir_name" ] || continue

    echo "=========================================="
    echo "Processing: $dir_name"
    echo "=========================================="
    
    cd "$PROJECTS_DIR/$dir_name" || continue

    git init -b main 2>/dev/null || true
    git add .
    git commit -m "Initial commit" 2>/dev/null || true
    git branch -M main

    # Remove stale origin remote to prevent conflict
    git remote remove origin 2>/dev/null || true

    # Create GitHub repository (silently continues if already created)
    gh repo create "$TARGET_USER/$dir_name" --public 2>/dev/null || true

    # Set new remote and push main branch
    git remote add origin "https://github.com/$TARGET_USER/$dir_name.git" 2>/dev/null || git remote set-url origin "https://github.com/$TARGET_USER/$dir_name.git"
    git push -u origin main --force

    cd "$PROJECTS_DIR" || exit 1
done

echo "--------------------------------------------------------"
echo "Completed! Verification list from GitHub:"
gh repo list "$TARGET_USER" --limit 50
