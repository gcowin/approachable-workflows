#!/usr/bin/env bash
# Verify harness-local skill mirrors match the canonical source of truth.
# Canonical: skills/workflow-runtime/  Mirrors: .opencode/skill/workflow-runtime/
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
canonical="$root/skills/workflow-runtime"
mirror="$root/.opencode/skill/workflow-runtime"
status=0
if [ -d "$mirror" ]; then
  if diff -r "$canonical" "$mirror"; then
    echo "OK: workflow-runtime mirror matches canonical skill."
  else
    echo "FAIL: mirror drift detected (see diff above)."
    status=1
  fi
else
  echo "INFO: no local mirror at $mirror (nothing to check)."
fi
exit $status
