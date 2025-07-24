# === Vars ===
buildDir := build
objDir := $(buildDir)/objs
binDir := $(buildDir)/bin

srcDir := src

SRC := $(wildcard $(srcDir)/*.asm)
OBJS := $(patsubst $(srcDir)/%.asm,$(objDir)/%.o,$(SRC))

TARGET := $(binDir)/dax

# === Config ===
LD := ld
ASM := nasm

ASMFLAGS := -f elf64 -g -I $(srcDir)
LDFLAGS := -T linker.ld -static -nostdlib

# === Build Rules ===

all: $(TARGET)

# Override Built in rules
.SUFFIXES:
.SUFFIXES: .s .o

# Assemble
$(objDir)/%.o: $(srcDir)/%.asm
	@echo "[NASM] Assembling $< -> $@"
	$(ASM) $(ASMFLAGS) -o $@ $<

# Link obj files into final target
$(TARGET): $(OBJS)
	@echo "[LD] Linking to create $(TARGET)..."
	$(LD) $(LDFLAGS) -o $@ $^

# === Utility Targets ===
clean:
	@echo "[CLEAN] Doing its job..."
	rm -f $(OBJS) $(TARGET)

# === Phony Targets ===
.PHONY: all clean 
