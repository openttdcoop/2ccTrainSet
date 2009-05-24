# Makefile for the 2cc train set
#

MAKEFILELOCAL=Makefile.local

GRF_NAME     = 2cc Train Set
GRF_VERSION  = 1.0.1 (pre-release)
GRF_FILENAME = 2cc_trainset

NFORENUM_FLAGS = -w 141
GRFCODEC_FLAGS = -e -p 2

SHELL = /bin/sh
# OS detection: Cygwin vs Linux
ISCYGWIN = $(shell [ ! -d /cygdrive/ ]; echo $$?)
# NFORENUM = $(shell [ \( $(ISCYGWIN) -eq 1 \) ] && echo renum.exe || echo renum)
GRFCODEC =  $(shell [ \( $(ISCYGWIN) -eq 1 \) ] && echo grfcodec.exe || echo grfcodec)
GRFDIR = $(shell [ \( $(OSTYPE) -eq linux \) ] && echo ~/.openttd/data || echo ~/Documents/OpenTTD/data

NFORENUM = renum
GRFCODEC = grfcodec

SPRITEDIR   = ./sprites
NFODIR      = $(SPRITEDIR)/nfo
REGION_DIRS = 2africa 3asia 4e-eu 5n-am 6s-am 7ocean 8scandinavia 9s-eu 10w-eu
LANG_DIR    = strings
HEADER      = 00header
OTHER		= 01wagons 00sounds
FOOTER      = regsel


# this overrides definitions from above:
-include ${MAKEFILELOCAL}

NAME = $(GRF_FILENAME)

# Now, the fun stuff:

# Target for all:
all : renumber grf

test : 
	@echo $(NFORENUM) $(NFORENUM_FLAGS)
	@echo $(GRFCODEC) $(GRFCODEC_FLAGS)
	@echo $(GRFDIR)

# Compile GRF
grf : renumber
	@echo "Compiling GRF:"
	$(GRFCODEC) ${GRFCODEC_FLAGS} ${GRF_FILENAME}.nfo
	@echo
	
# NFORENUM process copy of the NFO
renumber : nfo
	@echo "NFORENUM processing:"
	-$(NFORENUM) ${NFORENUM_FLAGS} $(GRF_FILENAME).nfo
	@echo
	
# Prepare the nfo file	
nfo : regions lang
	@echo "Generating the nfo:"
	-cat $(NFODIR)/*.nfo > $(SPRITEDIR)/$(GRF_FILENAME).nfo.pre
	sed -f scripts/nfo.sed $(SPRITEDIR)/$(GRF_FILENAME).nfo.pre > $(SPRITEDIR)/$(GRF_FILENAME).nfo
	@echo	
	
regions:
	@echo "Compiling regions:"
	for i in $(REGION_DIRS); do cat $(NFODIR)/$$i/*.nfo > $(NFODIR)/$$i.nfo; done
	@echo

lang:
	@echo "Compiling languages:"
	-cat $(NFODIR)/$(LANG_DIR)/*.nfo > $(NFODIR)/$(LANG_DIR).nfo
	@echo
	
# Clean the source tree
clean:
	@echo "Cleaning source tree:"
	@echo "Remove backups:"
	-rm $(SPRITEDIR)/*.bak *~
	@echo
	@echo "Remove .nfo:"
	-rm $(SPRITEDIR)/*.nfo
	-rm $(NFODIR)/$(LANG_DIR).nfo
	-rm $(NFODIR)/*.orig
	-rm $(NFODIR)/$(LANG_DIR)/*.orig
	for i in $(REGION_DIRS); do rm $(NFODIR)/$$i.nfo; done
	@echo
	@echo "Remove compiled .grf:"
	-rm *.grf

# Installation process
install:
	@echo Installing .grf files to $(GRFDIR).
	@echo "Windows GRF:"
	-cp $(GRF_FILENAME).grf $(INSTALLDIR)/$(GRF_FILENAME).grf
	@echo
#	@echo "DOS GRF:"
#	-cp $(NAME).grf $(GRFDIR)/$(NAME).grf

