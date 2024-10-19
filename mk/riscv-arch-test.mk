ARCH_TEST_DIR ?= tests/riscv-arch-test
ARCH_TEST_SUITE ?= $(ARCH_TEST_DIR)/riscv-test-suite
export RISCV_TARGET := tests/arch-test-target
export TARGETDIR := $(shell pwd)
export WORK := $(TARGETDIR)/build/arch-test
export RISCV_DEVICE ?= IMACFZicsrZifencei

ifeq ($(RISCV_DEVICE),FCZicsr)
ARCH_TEST_SUITE := tests/rv32fc-test-suite
endif

arch-test: $(BIN) artifact
ifeq ($(CROSS_COMPILE),)
	$(error GNU Toolchain for RISC-V is required to build architecture tests. Please check package installation)
endif
	git clone https://github.com/riscv-non-isa/riscv-arch-test $(dir $(ARCH_TEST_DIR)) --depth=1
	$(Q)cp $(OUT)/sail_cSim/riscv_sim_RV32 tests/arch-test-target/sail_cSim/riscv_sim_RV32
	$(Q)python3 -B $(RISCV_TARGET)/setup.py --riscv_device=$(RISCV_DEVICE)
	$(Q)riscof run --work-dir=$(WORK) \
			--config=$(RISCV_TARGET)/config.ini \
			--suite=$(ARCH_TEST_SUITE) \
			--env=$(ARCH_TEST_DIR)/riscv-test-suite/env
