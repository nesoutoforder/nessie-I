#!/usr/bin/env bash
set -euo pipefail

ASM_FILE="$1"
ELF_FILE="$2"
HEX_FILE="$3"

RISCV_PREFIX=${RISCV_PREFIX:-riscv64-unknown-elf}

RISCV_GCC="${RISCV_PREFIX}-gcc"
RISCV_OBJCOPY="${RISCV_PREFIX}-objcopy"
RISCV_OBJDUMP="${RISCV_PREFIX}-objdump"

mkdir -p "$(dirname "$ELF_FILE")"

"$RISCV_GCC" \
  -march=rv32i \
  -mabi=ilp32 \
  -nostdlib \
  -T tests/linker/link.ld \
  tests/crt/start.S \
  "$ASM_FILE" \
  -o "$ELF_FILE"

"$RISCV_OBJCOPY" \
  -O verilog \
  "$ELF_FILE" \
  "$HEX_FILE"

"$RISCV_OBJDUMP" \
  -d "$ELF_FILE" \
  > "${ELF_FILE%.elf}.dump"
  