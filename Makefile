# Build the three binary puzzles from 09-Machine_Data.pptx.
#
# Flags match the binarylab build (cso-labs-staff/binarylab-staff/Makefile):
# Ubuntu 24.04 GCC 13.3, -Og, no frame pointer, no stack protector, non-PIE.
#
# Target x86-64 Linux.  On an Apple-silicon Mac use an Ubuntu 24.04 image
# (cso_x86:gcc13 = ubuntu:24.04 + gcc, built locally; the lab images are 22.04/gcc 11):
#   make CC="docker run --rm --platform linux/amd64 -v $$PWD:/src -w /src cso_x86:gcc13 gcc"

CC       = gcc
CFLAGS   = -Werror -Og -std=gnu11 -fomit-frame-pointer -fno-stack-protector
LDFLAGS  = -no-pie
OBJDUMP ?= objdump

OBJS = main.o mystery1.o mystery2.o mystery3.o
SOL_OBJS = main.o mystery1-sol.o mystery2-sol.o mystery3-sol.o

all: mystery mystery-sol

mystery: $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS)

mystery-sol: $(SOL_OBJS)
	$(CC) $(LDFLAGS) -o $@ $(SOL_OBJS)

%.o: %.c
	$(CC) $(CFLAGS) -c $<

# assembly listings, e.g. `make mystery1.s`
%.s: %.c
	$(CC) $(CFLAGS) -S $<

# disassemble each puzzle
disas: mystery1-sol.o mystery2-sol.o mystery3-sol.o
	$(OBJDUMP) -d $<

clean:
	rm -f mystery $(OBJS) mystery1.s mystery2.s mystery3.s

.PHONY: all disas clean
