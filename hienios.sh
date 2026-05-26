#!/bin/bash

# ================================
#      HIENIOS DELTA TOOL
#         by hienios
# ================================

SECRET_KEY="hienios_secret_2024"
REPO="https://raw.githubusercontent.com/dustsans123123/hienios/main"
SAVE_DIR="/sdcard/hienios"
UGCLONER_PKG="com.xfein.ugcloner"

R='\033[0;31m'
G='\033[0;32m'
Y='\033[1;33m'
C='\033[0;36m'
B='\033[1m'
NC='\033[0m'

# Tên hiển thị
VER_LABELS=("Global" "Global Lite" "VNG" "VNG Lite")
VER_KEYS=("global" "global_lite" "vng" "vng_lite")
VER_NAMES=("Global" "GlobalLite" "Vng" "VngLite")

CLI_LABELS=("Delta" "Codex" "Arceus")
CLI_KEYS=("delta" "codex" "arceus")

show_banner() {
  clear
  echo -e "${C}${B}"
  echo "  ╔══════════════════════════════════════╗"
  echo "  ║   ██╗  ██╗██╗███████╗███╗  ██╗      ║"
  echo "  ║   ███████║██║█████╗  ██╔██╗██║      ║"
  echo "  ║   ██╔══██║██║██╔══╝  ██║╚████║      ║"
  echo "  ║   ██║  ██║██║███████╗██║ ╚███║      ║"
  echo "  ║       UG Cloner Settings Tool       ║"
  echo "  ╚══════════════════════════════════════╝"
  echo -e "${NC}"
}

setup() {
  echo -e "${Y}  [*] Đang setup...${NC}"
  if [ ! -e "/data/data/com.termux/files/home/storage" ]; then
    termux-setup-storage
    sleep 3
  fi
  yes | pkg install -q python wget 2>/dev/null
  pip install -q cryptography 2>/dev/null
  mkdir -p "$SAVE_DIR"
  echo -e "${G}  ✓ Xong!${NC}\n"
  sleep 1
}

# ── Bước 1: Chọn phiên bản ─────────────────────
step_version() {
  show_banner
  echo -e "${C}${B}  ╔══════════════════════════════════════╗${NC}"
  echo -e "${C}${B}  ║     [ BƯỚC 1 ] CHỌN PHIÊN BẢN       ║${NC}"
  echo -e "${C}${B}  ╠══════════════════════════════════════╣${NC}"
  for i in "${!VER_LABELS[@]}"; do
    printf "  ${C}║${NC}   ${Y}${B}%s.${NC}  %-31s${C}║${NC}\n" "$((i+1))" "${VER_LABELS[$i]}"
  done
  echo -e "${C}${B}  ║                                      ║${NC}"
  echo -e "${C}${B}  ║   ${R}0.  Thoát                          ${C}║${NC}"
  echo -e "${C}${B}  ╚══════════════════════════════════════╝${NC}"
  echo ""
  read -p "  Chọn: " V

  [[ "$V" == "0" ]] && echo -e "\n${Y}  Tạm biệt!${NC}\n" && exit 0
  if ! [[ "$V" =~ ^[1-4]$ ]]; then
    echo -e "${R}  [!] Không hợp lệ!${NC}"; sleep 1; return 1
  fi

  IDX_V=$((V-1))
  SEL_VER_LABEL="${VER_LABELS[$IDX_V]}"
  SEL_VER_KEY="${VER_KEYS[$IDX_V]}"
  SEL_VER_NAME="${VER_NAMES[$IDX_V]}"
  return 0
}

# ── Bước 2: Chọn client ────────────────────────
step_client() {
  show_banner
  echo -e "${C}${B}  ╔══════════════════════════════════════╗${NC}"
  echo -e "${C}${B}  ║     [ BƯỚC 2 ] CHỌN CLIENT           ║${NC}"
  echo -e "${C}${B}  ╠══════════════════════════════════════╣${NC}"
  printf   "  ${C}║${NC}   Phiên bản: ${Y}${B}%-26s${NC}${C}║${NC}\n" "$SEL_VER_LABEL"
  echo -e "${C}${B}  ╠══════════════════════════════════════╣${NC}"
  for i in "${!CLI_LABELS[@]}"; do
    printf "  ${C}║${NC}   ${Y}${B}%s.${NC}  %-31s${C}║${NC}\n" "$((i+1))" "${CLI_LABELS[$i]}"
  done
  echo -e "${C}${B}  ║                                      ║${NC}"
  echo -e "${C}${B}  ║   ${R}0.  Quay lại                       ${C}║${NC}"
  echo -e "${C}${B}  ╚══════════════════════════════════════╝${NC}"
  echo ""
  read -p "  Chọn: " C_

  [[ "$C_" == "0" ]] && return 1
  if ! [[ "$C_" =~ ^[1-3]$ ]]; then
    echo -e "${R}  [!] Không hợp lệ!${NC}"; sleep 1; return 1
  fi

  IDX_C=$((C_-1))
  SEL_CLI_LABEL="${CLI_LABELS[$IDX_C]}"
  SEL_CLI_KEY="${CLI_KEYS[$IDX_C]}"
  return 0
}

# ── Bước 3: Chọn số lượng ─────────────────────
step_count() {
  show_banner
  FINAL_NAME="${SEL_CLI_LABEL}${SEL_VER_NAME}SameHwidByHien"
  FINAL_PKG="com.hienios.${SEL_CLI_KEY}.${SEL_VER_KEY}"
  GH_FILE="${SEL_CLI_KEY}_${SEL_VER_KEY}.settings.enc"

  echo -e "${C}${B}  ╔══════════════════════════════════════╗${NC}"
  echo -e "${C}${B}  ║     [ BƯỚC 3 ] SỐ LƯỢNG CLONE        ║${NC}"
  echo -e "${C}${B}  ╠══════════════════════════════════════╣${NC}"
  printf   "  ${C}║${NC}   Client   : ${Y}${B}%-25s${NC}${C}║${NC}\n" "$SEL_CLI_LABEL"
  printf   "  ${C}║${NC}   Phiên bản: ${Y}${B}%-25s${NC}${C}║${NC}\n" "$SEL_VER_LABEL"
  printf   "  ${C}║${NC}   Tên file : ${Y}%-25s${NC}${C}║${NC}\n" "$FINAL_NAME"
  echo -e "${C}${B}  ╠══════════════════════════════════════╣${NC}"
  echo -e "${C}${B}  ║   Tải bao nhiêu bản? ${Y}(1 - 10)${NC}${C}        ║${NC}"
  echo -e "${C}${B}  ╚══════════════════════════════════════╝${NC}"
  echo ""
  read -p "  Nhập số: " COUNT

  if ! [[ "$COUNT" =~ ^([1-9]|10)$ ]]; then
    echo -e "${R}  [!] Nhập 1-10!${NC}"; sleep 1; return 1
  fi
  return 0
}

# ── Tải + giải mã + clone ──────────────────────
run_clone() {
  show_banner
  echo -e "${Y}  Đang xử lý...${NC}\n"

  TMP="$SAVE_DIR/tmp.enc"

  # Tải file .enc (1 lần duy nhất)
  echo -e "${Y}  [1/3] Tải file từ GitHub...${NC}"
  wget -q "$REPO/apps/$GH_FILE" -O "$TMP" 2>/dev/null

  if [ ! -s "$TMP" ]; then
    rm -f "$TMP"
    echo -e "${R}  [!] Tải thất bại!${NC}"
    echo -e "${W}  → File chưa được admin upload hoặc lỗi mạng${NC}"
    sleep 2; return
  fi
  echo -e "${G}  ✓ Tải xong!${NC}"

  echo -e "${Y}  [2/3] Clone ${COUNT} bản...${NC}"
  SUCCESS=0
  DONE_FILES=()

  for (( i=1; i<=COUNT; i++ )); do
    # Nếu chỉ 1 bản → không đánh số
    if [ "$COUNT" -eq 1 ]; then
      OUT_NAME="${FINAL_NAME}.settings"
    else
      OUT_NAME="${FINAL_NAME}_${i}.settings"
    fi
    OUT="$SAVE_DIR/$OUT_NAME"

    # Xóa bản cũ nếu có
    [ -f "$OUT" ] && rm -f "$OUT"

    printf "  ${Y}  Clone #%d/${COUNT}...${NC} " "$i"

    RES=$(python3 - <<EOF 2>&1
from cryptography.fernet import Fernet
import base64, hashlib

key = hashlib.sha256("$SECRET_KEY".encode()).digest()
f = Fernet(base64.urlsafe_b64encode(key))

try:
    with open("$TMP", "rb") as enc:
        data = enc.read()
    decrypted = f.decrypt(data)
    with open("$OUT", "wb") as out:
        out.write(decrypted)
    print("OK")
except Exception as e:
    print(f"ERR:{e}")
EOF
)

    if [[ "$RES" == "OK" ]]; then
      echo -e "${G}✓${NC}"
      ((SUCCESS++))
      DONE_FILES+=("$OUT_NAME")
    else
      echo -e "${R}✗${NC}"
    fi
  done

  rm -f "$TMP"

  echo -e "${G}  ✓ Clone xong ${SUCCESS}/${COUNT} bản!${NC}\n"

  # Kết quả
  echo -e "${G}  ╔══════════════════════════════════════╗${NC}"
  echo -e "${G}  ║           ✅ HOÀN TẤT!               ║${NC}"
  echo -e "${G}  ╠══════════════════════════════════════╣${NC}"
  for f in "${DONE_FILES[@]}"; do
    printf   "${G}  ║${NC}  📄 %-34s${G}║${NC}\n" "$f"
  done
  echo -e "${G}  ╠══════════════════════════════════════╣${NC}"
  echo -e "${G}  ║  📁 /sdcard/hienios/                ║${NC}"
  echo -e "${G}  ╚══════════════════════════════════════╝${NC}"
  echo ""

  # Tự mở UG Cloner
  echo -e "${Y}  [3/3] Đang mở UG Cloner...${NC}"
  sleep 1
  am start -n "$UGCLONER_PKG/$UGCLONER_PKG.MainActivity" \
    --es "import_path" "$SAVE_DIR" \
    > /dev/null 2>&1

  # Fallback: mở UG Cloner bình thường
  if [ $? -ne 0 ]; then
    monkey -p "$UGCLONER_PKG" 1 > /dev/null 2>&1
  fi

  echo -e "${G}  ✓ Đã mở UG Cloner!${NC}"
  echo ""
  echo -e "${C}  📱 Trong UG Cloner:${NC}"
  echo -e "     ${Y}1.${NC} Nhấn ⚙️  → ${B}'Từ tệp cài đặt'${NC}"
  echo -e "     ${Y}2.${NC} Vào ${Y}/sdcard/hienios/${NC}"
  echo -e "     ${Y}3.${NC} Chọn file → ✅ Done!"
  echo ""
  echo -e "  ${R}⚠️  File backup — không share trực tiếp được${NC}"
  echo ""
  read -p "  Nhấn Enter để quay lại menu..." _
}

# ══ MAIN ══════════════════════════════════════
show_banner
setup

while true; do
  step_version || continue
  step_client  || continue
  step_count   || continue
  run_clone
done
