# === Vars ===
buildDir := build
objDir := $(buildDir)/objs
binDir := $(buildDir)/bin

srcDir := src

SRC := $(wildcard $(srcDir)/*.s)
OBJS := $(patsubst $(srcDir)/%.s,$(objDir)/%.o,$(SRC))

TARGET := $(binDir)/dax

# === Config ===
LD := ld
ASM := as

ASFLAGS := -g -c -I $(srcDir)
LDFLAGS := -T linker.ld -static -nostdlib

# === Build Rules ===

all: $(TARGET)

# Override Built in rules
.SUFFIXES:
.SUFFIXES: .s .o

# Assemble
$(objDir)/%.o: $(srcDir)/%.s
	@echo "[AS] Assembling $< -> $@"
	$(ASM) $(ASFLAGS) -o $@ $<

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
