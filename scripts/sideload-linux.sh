#!/usr/bin/env bash
#
# 🦤 Dodo OS — adb sideload flasher for OnePlus Nord N100 (BE2013)
# ==============================================================
# Installs a Dodo OS OTA/update .zip via recovery using `adb sideload`.
# Use this when you flash from recovery instead of fastboot.
#
# ПРЕДИ ДА ПУСНЕШ:
#   1. Телефонът трябва да е в RECOVERY режим, на екрана "Apply update from ADB"
#      (в стоково recovery) или "Apply update > Apply from ADB" (в custom recovery).
#   2. Свържи с USB кабел.
#   3. Трябва да имаш инсталиран 'adb'.
#
# Употреба:
#   ./sideload-linux.sh                      # търси dodo-os-*.zip до скрипта
#   ./sideload-linux.sh path/to/update.zip   # конкретен файл
#
set -euo pipefail

RED=$'\e[31m'; GRN=$'\e[32m'; YEL=$'\e[33m'; CYN=$'\e[36m'; RST=$'\e[0m'
info() { echo "${CYN}==>${RST} $*"; }
ok()   { echo "${GRN}✓${RST} $*"; }
warn() { echo "${YEL}⚠ ${RST} $*"; }
err()  { echo "${RED}✗ $*${RST}" >&2; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- 1. adb наличен? ---------------------------------------------------------
if ! command -v adb >/dev/null 2>&1; then
  err "'adb' не е намерен."
  echo "   Инсталирай:  sudo apt-get install -y android-tools-adb"
  exit 1
fi
ok "adb намерен: $(adb --version | head -1)"

# --- 2. Кой .zip да флашнем? -------------------------------------------------
ZIP="${1:-}"
if [[ -z "$ZIP" ]]; then
  # Търсим dodo-os-*.zip до скрипта или в ../out
  ZIP="$(ls -1t "$SCRIPT_DIR"/dodo-os-*.zip "$SCRIPT_DIR"/../out/dodo-os-*.zip 2>/dev/null | head -1 || true)"
fi
if [[ -z "$ZIP" || ! -f "$ZIP" ]]; then
  err "Не намерих Dodo OS .zip за флашване."
  echo "   Посочи го ръчно:  ./sideload-linux.sh /път/до/dodo-os-update.zip"
  echo "   (Този .zip се създава след успешна компилация за устройството — Етап 2.)"
  exit 1
fi
ok "Ще флашна: $ZIP  ($(du -h "$ZIP" | cut -f1))"

# --- 3. Телефон в sideload режим? --------------------------------------------
info "Търся телефон в recovery/sideload режим..."
STATE="$(adb get-state 2>/dev/null || true)"
if ! adb devices | grep -qE "sideload|recovery"; then
  warn "Не виждам телефон в sideload режим."
  echo "   На телефона: Recovery > Apply update from ADB (Apply from ADB)."
  echo "   Текущо състояние: ${STATE:-няма устройство}"
  read -r -p "Влезе ли в 'Apply update from ADB'? Натисни Enter да опитам пак, или Ctrl+C за изход."
fi

# --- 4. Финално потвърждение -------------------------------------------------
echo
warn "На път си да инсталираш Dodo OS през sideload."
read -r -p "Продължавам? Напиши 'yes': " ans
[[ "$ans" == "yes" ]] || { info "Отказано."; exit 0; }

# --- 5. Sideload -------------------------------------------------------------
info "Флашвам... (не вади кабела!)"
adb sideload "$ZIP"
echo
ok "Готово! 🦤 На телефона избери Reboot system now."
