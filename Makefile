# Compiler flags
AS       = rgbasm
LINK     = rgblink
FIX      = rgbfix
FIXFLAGS = -f g

# Project files
SRCS = main.asm
OBJS = $(SRCS:.asm=.o)
DEPS = data-stereo.bin song.inc
EXE  = loud.gb
SYM  = loud.sym

# Release build settings
RELDIR = release
RELEXE = $(RELDIR)/$(EXE)
RELSYM = $(RELDIR)/$(SYM)
RELOBJS = $(addprefix $(RELDIR)/, $(OBJS))

.PHONY: all clean prep release

# Default build
all: release

# Release rules
release: $(RELEXE)

$(RELEXE): $(RELOBJS) $(DEPS) | prep 
	$(LINK) -n $(RELSYM) -o $(RELEXE) $(RELOBJS)
	$(FIX) $(FIXFLAGS) $(RELEXE)

$(RELDIR)/%.o: %.asm $(DEPS) | prep 
	$(AS) -o $@ $<

song.inc: data-stereo.bin songInclude.c
	tcc -run songInclude.c >song.inc

data-stereo.bin: data-stereo.raw raw2bin.c
	tcc -run raw2bin.c <data-stereo.raw >data-stereo.bin

# Other rules
prep:
	@mkdir -p $(RELDIR)

clean:
	rm -f $(RELEXE) $(RELSYM) $(RELOBJS)
