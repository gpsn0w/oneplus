#!/usr/bin/env bash
#
# 🦤 Dodo OS — Linux flash script for OnePlus Nord N100 (BE2013)
# =============================================================
# Записва (флашва) компилираните Dodo OS образи на телефона през fastboot.
#
# ПРЕДИ ДА ПУСНЕШ ТОВА:
#   1. Bootloader-ът на телефона ТРЯБВА да е отключен (fastboot flashing unlock).
#   2. Телефонът трябва да е в bootloader/fastboot режим:
#         - изключи го, после задръж Power + Volume Up (или го свържи и:
#           adb reboot bootloader)
#   3. Трябва да имаш инсталиран 'fastboot' (android platform-tools).
#
# ⚠️  ВНИМАНИЕ: флашването изтрива данни. Прави се на твой риск.
#
# Употреба:
#   ./flash-linux.sh                # търси образите в ../out (или $DODO_OUT)
#   DODO_OUT=/път/към/образите ./flash-linux.sh
#   ./flash-linux.sh --wipe         # + изтрива userdata (пълно нулиране)
#
set -euo pipefail

# --- Цветове за четимост -----------------------------------------------------
RED=$'\e[31m'; GRN=$'\e[32m'; YEL=$'\e[33m'; CYN=$'\e[36m'; RST=$'\e[0m'
info() { echo "${CYN}==>${RST} $*"; }
ok()   { echo "${GRN}✓${RST} $*"; }
warn() { echo "${YEL}⚠ ${RST} $*"; }
err()  { echo "${RED}✗ $*${RST}" >&2; }

# --- Настройки ---------------------------------------------------------------
WIPE=0
[[ "${1:-}" == "--wipe" ]] && WIPE=1

# Къде са образите (.img). По подразбиране: папка out/ до проекта.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="${DODO_OUT:-$SCRIPT_DIR/../out}"

# --- 1. Проверка за fastboot -------------------------------------------------
if ! command -v fastboot >/dev/null 2>&1; then
  err "'fastboot' не е намерен."
  echo "   Инсталирай го с:  sudo apt-get install -y android-tools-fastboot android-tools-adb"
  exit 1
fi
ok "fastboot намерен: $(fastboot --version | head -1)"

# --- 2. Проверка за образите -------------------------------------------------
if [[ ! -d "$OUT" ]]; then
  err "Папката с образи не съществува: $OUT"
  echo "   Тя се появява след успешна компилация (Етап 1-2)."
  echo "   Или посочи ръчно:  DODO_OUT=/път ./flash-linux.sh"
  exit 1
fi

# Дялове, които флашваме, ако съответният .img съществува.
# (Не всички устройства имат всички дялове — затова е "ако съществува".)
PARTITIONS=(boot dtbo vendor_boot vbmeta vbmeta_system \
            super system system_ext vendor product odm)

found_any=0
for p in "${PARTITIONS[@]}"; do
  [[ -f "$OUT/$p.img" ]] && found_any=1
done
if [[ $found_any -eq 0 ]]; then
  err "В $OUT няма нито един .img файл за флашване."
  echo "   Очаквани напр.: boot.img, super.img, vbmeta.img ..."
  exit 1
fi

# --- 3. Проверка, че телефонът е свързан в fastboot режим --------------------
info "Търся телефон в fastboot режим..."
if ! fastboot devices | grep -q .; then
  err "Няма устройство в fastboot режим."
  echo "   Сложи телефона в bootloader режим и опитай пак:"
  echo "     adb reboot bootloader     (ако е включен и с USB debugging)"
  echo "   или изключи и задръж Power + Volume Up."
  exit 1
fi
DEV="$(fastboot devices | head -1 | awk '{print $1}')"
ok "Намерен телефон: $DEV"

# --- 4. Финално потвърждение от потребителя ----------------------------------
echo
warn "На път си да флашнеш Dodo OS на устройство $DEV."
[[ $WIPE -eq 1 ]] && warn "Режим --wipe: ВСИЧКИ данни на телефона ще бъдат изтрити!"
echo "Образи от: $OUT"
read -r -p "Сигурен ли си? Напиши 'yes' за да продължиш: " ans
[[ "$ans" == "yes" ]] || { info "Отказано. Нищо не е променено."; exit 0; }

# --- 5. Флашване -------------------------------------------------------------
flash_if_exists() {
  local part="$1" img="$OUT/$1.img"
  if [[ -f "$img" ]]; then
    info "Флашвам $part ..."
    fastboot flash "$part" "$img"
    ok "$part записан"
  fi
}

# vbmeta първо (за да минат verified boot проверките при dev образ)
for p in vbmeta vbmeta_system; do
  if [[ -f "$OUT/$p.img" ]]; then
    info "Флашвам $p (с disable-verity/verification за dev образ) ..."
    fastboot --disable-verity --disable-verification flash "$p" "$OUT/$p.img"
    ok "$p записан"
  fi
done

for p in boot dtbo vendor_boot super system system_ext vendor product odm; do
  flash_if_exists "$p"
done

# --- 6. Изтриване на данни (по желание) --------------------------------------
if [[ $WIPE -eq 1 ]]; then
  info "Изтривам userdata ..."
  fastboot -w
  ok "Данните са изтрити"
fi

# --- 7. Рестарт --------------------------------------------------------------
info "Рестартирам телефона..."
fastboot reboot
echo
ok "Готово! 🦤 Dodo OS е флашнат. Първото зареждане може да отнеме няколко минути."
