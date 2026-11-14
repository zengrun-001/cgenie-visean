#!/usr/bin/env bash
# 由 251 Ma 模板生成 320 Ma（最接近 330 Ma 维宪期）配置
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CFG_DIR="$ROOT/cgenie.muffin/genie-main/configs"
TMPL=$(ls "$CFG_DIR"/*p0251b*.config | head -1)
NEW="$CFG_DIR/cgenie.eb_go_gs_ac_bg.p0320c.BASES.config"

echo "模板: $TMPL"
cp "$TMPL" "$NEW"

# 1) 古地理文件前缀 251 -> 320 Ma
sed -i 's/p0251b/320ebP2_/g' "$NEW"

# 2) 维宪期边界条件
sed -i 's/^\(ini_pCO2[[:space:]]*=\).*$/\1 560/'        "$NEW" || true
sed -i 's/^\(solconst[[:space:]]*=\).*$/\1 1338/'       "$NEW" || true
sed -i 's/^\(ini_O2[[:space:]]*=\).*$/\1 1.0/'          "$NEW" || true

# 3) 把本文的 330 Ma 古地理放进 inputdata（供敏感性实验用）
mkdir -p "$ROOT/cgenie.muffin/genie-main/inputdata"
cp "$ROOT/inputs/seddem_330Ma_36x36.txt"        "$ROOT/cgenie.muffin/genie-main/inputdata/" || true
cp "$ROOT/inputs/shelf_frac_330Ma_36x36.txt"    "$ROOT/cgenie.muffin/genie-main/inputdata/" || true
cp "$ROOT/inputs/cgenie_forcing_visean.csv"     "$ROOT/cgenie.muffin/genie-main/inputdata/" || true

echo "---- 生成结果检查 ----"
grep -nE "320ebP2_|ini_pCO2|solconst|ini_O2" "$NEW" | head -12 || true
