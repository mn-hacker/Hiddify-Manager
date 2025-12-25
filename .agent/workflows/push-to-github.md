---
description: Before pushing to GitHub - always ask user first
---

# Before Pushing to GitHub

**IMPORTANT:** After making changes and committing locally:

1. **DO NOT push automatically**
2. **Ask the user:**
   - "میخوای الان push کنم و تگ بزنم؟"
   - "اگه آره، **Release** باشه یا **Pre-release**؟"

## Release Types:
- **Release**: Tag without 'b' (e.g., `v11.0.19`) → Stable version for all users
- **Pre-release**: Tag with 'b' (e.g., `v11.0.19b`) → Test version, not downloaded by installer

## Only push after user confirms:
- If user says "Release" → `git tag vX.X.X` then push
- If user says "Pre-release" → `git tag vX.X.Xb` then push
- If user says "No" → Do not push, wait for further instructions
