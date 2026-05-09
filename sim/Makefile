PKG = ../rtl/rv32_pkg.sv

RTL = $(filter-out $(PKG),$(wildcard ../rtl/*.sv))
TB  = $(wildcard ../tb/*.sv)

TESTS = $(basename $(notdir $(wildcard ../tb/tb_*.sv)))

LOG_DIR = logs

all: test

$(LOG_DIR):
	mkdir -p $(LOG_DIR)

test: $(LOG_DIR)
	@for t in $(TESTS); do \
		echo "Running $$t..."; \
		verilator -sv --binary --timing --top-module $$t $(PKG) $(RTL) $(TB) \
			> $(LOG_DIR)/verilator_$$t.log 2>&1 || { \
				echo "Verilator failed for $$t."; \
				echo "---- LOG START ----"; \
				cat $(LOG_DIR)/verilator_$$t.log; \
				echo "---- LOG END ----"; \
				exit 1; \
			}; \
		./obj_dir/V$$t || exit 1; \
	done

lint: $(LOG_DIR)
	@verilator --lint-only -sv $(PKG) $(RTL) \
		> $(LOG_DIR)/lint.log 2>&1 || { \
			echo "Lint failed."; \
			echo "---- LOG START ----"; \
			cat $(LOG_DIR)/lint.log; \
			echo "---- LOG END ----"; \
			exit 1; \
		}

clean:
	rm -rf obj_dir $(LOG_DIR) *.vcd