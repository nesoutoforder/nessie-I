TEST       ?= simple
TEST_SUITE ?= smoke
UNIT_TEST  ?= alu

BUILD_DIR := build
ASM_DIR   := tests/asm/$(TEST_SUITE)

ELF_FILE  := $(BUILD_DIR)/$(TEST).elf
HEX_FILE  := $(BUILD_DIR)/$(TEST).hex

SMOKE_TESTS := simple
ISA_TESTS   := arithmetic logic branches load_store
UNIT_TESTS  := alu branch_compare

.PHONY: run build-program compile sim \
        unit unit-compile unit-sim \
        regress regress-smoke regress-isa regress-unit \
        clean

run: build-program compile sim

build-program:
	./sim/scripts/build_program.sh \
		$(ASM_DIR)/$(TEST).S \
		$(ELF_FILE) \
		$(HEX_FILE)

compile:
	vlib work
	vlog -sv -f sim/filelists/core.f

sim:
	vsim -c tb_core_program \
		+PROGRAM=$(HEX_FILE) \
		-do "run -all; quit"


regress: regress-smoke regress-isa

regress-smoke:
	@for test in $(SMOKE_TESTS); do \
		echo ""; \
		echo "========== SMOKE: $$test =========="; \
		$(MAKE) run TEST=$$test TEST_SUITE=smoke || exit 1; \
	done

regress-isa:
	@for test in $(ISA_TESTS); do \
		echo ""; \
		echo "========== ISA: $$test =========="; \
		$(MAKE) run TEST=$$test TEST_SUITE=isa || exit 1; \
	done

clean:
	rm -rf build work transcript vsim.wlf *.vcd