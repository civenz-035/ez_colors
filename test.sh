#!/usr/bin/env bash
# QA smoke test for ez_colors plugin
set -euo pipefail

PLUGIN="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PASS=0
FAIL=0

pass() { echo "✅ PASS: $*"; PASS=$(( PASS + 1 )); }
fail() { echo "❌ FAIL: $*"; FAIL=$(( FAIL + 1 )); }

echo "==================================================="
echo "  ez_colors — QA Smoke Test"
echo "==================================================="

# Source
source "$PLUGIN/colors.sh" 2>&1 && pass "source colors.sh" || { fail "source colors.sh"; exit 1; }

# 00-escapes: basic escape functions exist
declare -f _c >/dev/null 2>&1 && pass "_c() defined" || fail "_c() missing"
declare -f _bg >/dev/null 2>&1 && pass "_bg() defined" || fail "_bg() missing"
declare -f _r  >/dev/null 2>&1 && pass "_r() defined"  || fail "_r() missing"

# 01-palette: RC_PALETTE_DEFAULT is set
[[ -n "${RC_PALETTE_DEFAULT:-}" ]] && pass "RC_PALETTE_DEFAULT set" || fail "RC_PALETTE_DEFAULT empty"
result=$(palettes_ --fire)
[[ "$result" == *196* ]] && pass "palettes_ --fire returns 196" || fail "palettes_ --fire broken"

# 02-render: c / cn / psc defined
declare -f c    >/dev/null 2>&1 && pass "c() defined"   || fail "c() missing"
declare -f cn   >/dev/null 2>&1 && pass "cn() defined"  || fail "cn() missing"
declare -f cbg  >/dev/null 2>&1 && pass "cbg() defined" || fail "cbg() missing"

# 02-render: actually renders without error
out=$(cn 208 b "orange bold" 2>&1) && pass "cn 208 b renders" || fail "cn 208 b crashed"

# 03-rainbow
declare -f mc  >/dev/null 2>&1 && pass "mc() defined"  || fail "mc() missing"
out=$(mc 'Hello' 2>&1) && pass "mc renders" || fail "mc crashed"
out=$(jmc 'Hello' 2>&1) && pass "jmc renders" || fail "jmc crashed"

# 04-random
declare -f random_core  >/dev/null 2>&1 && pass "random_core() defined" || fail "random_core() missing"
declare -f rc           >/dev/null 2>&1 && pass "rc() defined"          || fail "rc() missing"
out=$(rc 'test' 2>&1) && pass "rc renders" || fail "rc crashed"

# 05-rcc
declare -f rcc  >/dev/null 2>&1 && pass "rcc() defined" || fail "rcc() missing"
out=$(rcc 'test' 2>&1) && pass "rcc renders" || fail "rcc crashed"

# 06-table
declare -f ctab      >/dev/null 2>&1 && pass "ctab() defined"      || fail "ctab() missing"
declare -f box_card  >/dev/null 2>&1 && pass "box_card() defined"  || fail "box_card() missing"
declare -f hline     >/dev/null 2>&1 && pass "hline() defined"     || fail "hline() missing"
out=$(ctab "82:15 244:20" "cmd" "desc" 2>&1) && pass "ctab renders" || fail "ctab crashed"
out=$(box_card "Title" "---" "Line A" 2>&1) && pass "box_card renders" || fail "box_card crashed"

# 07-utils
declare -f _warn >/dev/null 2>&1 && pass "_warn() defined" || fail "_warn() missing"
declare -f _sc   >/dev/null 2>&1 && pass "_sc() defined"   || fail "_sc() missing"
out=$(_warn "test" 2>&1) && pass "_warn renders" || fail "_warn crashed"
out=$(_sc   "test" 2>&1) && pass "_sc renders"   || fail "_sc crashed"

# install.sh exists and is executable
[[ -f "$PLUGIN/install.sh" ]] && pass "install.sh present" || fail "install.sh missing"
[[ -f "$PLUGIN/uninstall.sh" ]] && pass "uninstall.sh present" || fail "uninstall.sh missing"
[[ -f "$PLUGIN/README.md" ]] && pass "README.md present" || fail "README.md missing"

echo ""
echo "==================================================="
echo "  Results: $PASS passed, $FAIL failed"
echo "==================================================="
(( FAIL == 0 )) && echo "🎉 ALL TESTS PASSED" || { echo "❌ SOME TESTS FAILED"; exit 1; }
