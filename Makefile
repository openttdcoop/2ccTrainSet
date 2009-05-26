# Makefile for the 2cc train set

MAKEFILELOCAL=Makefile.local
MAKEFILECONFIG=Makefile.config

SHELL = /bin/sh

GRF_REVISION = $(shell hg parent --template="{rev}\n")

include ${MAKEFILECONFIG}

# OS detection: Cygwin vs Linux
ISCYGWIN = $(shell [ ! -d /cygdrive/ ]; echo $$?)
NFORENUM = $(shell [ \( $(ISCYGWIN) -eq 1 \) ] && echo renum.exe || echo renum)
GRFCODEC =  $(shell [ \( $(ISCYGWIN) -eq 1 \) ] && echo grfcodec.exe || echo grfcodec)

# this overrides definitions from above:
-include ${MAKEFILELOCAL}

# Now, the fun stuff:

# Targets:
# all, test, bundle, install

# Target for all:
all : renumber grf

test : 
	@echo "Call of nforenum:             $(NFORENUM) $(NFORENUM_FLAGS)"
	@echo "Call of grfcodec:             $(GRFCODEC) $(GRFCODEC_FLAGS)"
	@echo "Local installation directory: $(INSTALLDIR)"
	@echo "Repository revision:          r$(GRF_REVISION)"
	@echo "GRF title:                    $(GRF_TITLE)"

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
nfo : unify
	# replace the place holders for version and name by the respective variables:
	@echo "Setting title to $(GRF_TITLE)"
	@sed s/{{GRF_TITLE}}/'$(GRF_TITLE)'/ $(SPRITEDIR)/$(GRF_FILENAME).nfo.pre > $(SPRITEDIR)/$(GRF_FILENAME).nfo
	@echo	
	
unify:
	@echo
	@echo "Generating the nfo:"
	@-rm $(SPRITEDIR)/$(GRF_FILENAME).nfo.pre
	@echo "Header..."
	@cat $(NFODIR)/$(HEADER).nfo > $(SPRITEDIR)/$(GRF_FILENAME).nfo.pre
	@echo "...other stuff..."
	@for i in $(OTHERS); do cat $(NFODIR)/$$i.nfo >> $(SPRITEDIR)/$(GRF_FILENAME).nfo.pre; done
	@echo "...engines by region..."
	@for i in $(REGION_DIRS); do cat $(NFODIR)/$$i/*.nfo >> $(SPRITEDIR)/$(GRF_FILENAME).nfo.pre; done
	@echo "...languages..."
	@cat $(NFODIR)/$(LANG_DIR)/*.nfo >> $(SPRITEDIR)/$(GRF_FILENAME).nfo.pre
	@echo "... and footer."
	@cat $(NFODIR)/$(FOOTER).nfo >> $(SPRITEDIR)/$(GRF_FILENAME).nfo.pre
	
	
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
	
bundle :
	@echo "Automatic creation of the release bundle is not yet supported"
	@echo

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
