# Makefile for the 2cc train set

MAKEFILELOCAL=Makefile.local
MAKEFILECONFIG=Makefile.config

SHELL = /bin/sh

include ${MAKEFILECONFIG}

# OS detection: Cygwin vs Linux
ISCYGWIN = $(shell [ ! -d /cygdrive/ ]; echo $$?)
NFORENUM = $(shell [ \( $(ISCYGWIN) -eq 1 \) ] && echo renum.exe || echo renum)
GRFCODEC =  $(shell [ \( $(ISCYGWIN) -eq 1 \) ] && echo grfcodec.exe || echo grfcodec)
#INSTALLDIR = $(shell [ \( $(OSTYPE) -eq linux \) ] && echo ~/.openttd/data || echo ~/Documents/OpenTTD/data)

# this overrides definitions from above:
-include ${MAKEFILELOCAL}

# Now, the fun stuff:

# Target for all:
all : renumber grf install

test : 
	@echo "Call of nforenum:             $(NFORENUM) $(NFORENUM_FLAGS)"
	@echo "Call of grfcodec:             $(GRFCODEC) $(GRFCODEC_FLAGS)"
	@echo "Local installation directory: $(GRFDIR)"

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
	cat $(NFODIR)/*.nfo > $(SPRITEDIR)/$(GRF_FILENAME).nfo.pre
# replace the place holders for version and name by the respective variables:
	sed s/{{VERSION}}/'$(GRF_VERSION)'/ $(SPRITEDIR)/$(GRF_FILENAME).nfo.pre | sed s/{{NAME}}/'$(GRF_NAME)'/ > $(SPRITEDIR)/$(GRF_FILENAME).nfo
	@echo	
	
regions:
	@echo "Compiling regions:"
	for i in $(REGION_DIRS); do cat $(NFODIR)/$$i/*.nfo > $(NFODIR)/$$i.nfo; done
	@echo

lang:
	@echo "Compiling languages:"
	cat $(NFODIR)/$(LANG_DIR)/*.nfo > $(NFODIR)/$(LANG_DIR).nfo
	@echo
	
# Clean the source tree
clean:
	@echo "Cleaning source tree:"
	@echo "Remove backups:"
	-rm $(NFODIR)/*/*.orig
	-rm $(NFODIR)/*.orig
	-rm $(SPRITEDIR)/*.pre
	-for i in $(MAINDIRS); do rm $$i/*.orig; done
	@echo
	@echo "Remove temporary .nfo:"
	-rm $(SPRITEDIR)/*.nfo
	-rm $(NFODIR)/$(LANG_DIR).nfo
	-rm $(NFODIR)/*.orig
	-rm $(NFODIR)/$(LANG_DIR)/*.orig
	-for i in $(REGION_DIRS); do rm $(NFODIR)/$$i.nfo; done
	@echo
	@echo "Remove compiled .grf:"
	-rm *.grf
	@echo
	@echo "Removing old logs:"
	-rm *.log

# Installation process
install:
#	ifneq ($(flavour INSTALLDIR), "undefined")
		@echo "Installing grf to $(INSTALLDIR)"
		-cp $(GRF_FILENAME).grf $(INSTALLDIR)/$(GRF_FILENAME).grf
#	else
#		@echo "Please edit (or create) your Makefile.local"
#		@echo "and define an installation dir:"
#		@echo "INSTALLDIR=<where the grf goes>"
#	endif
	@echo
