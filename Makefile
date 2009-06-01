# Makefile for the 2cc train set

# Name of the Makefile which contains all the settings which describe
# how to make this newgrf. It defines all the paths, the grf name,
# the files for a bundle etc.
MAKEFILECONFIG=Makefile.config

# Name of the Makefile which contains the local settings. It overrides
# the global settings in Makefile.config.
MAKEFILELOCAL=Makefile.local

SHELL = /bin/sh

# Get the Repository revision, tags and the modified status
GRF_REVISION = $(shell hg parent --template="{rev}")
GRF_MODIFIED = $(shell [ -n "`hg status \"." | grep -v '^?'`" ] && echo "M" || echo "")
# " \" (syntax highlighting line
REPO_TAGS    = $(shell hg parent --template="{tags}" | grep -v "tip" | cut -d\  -f1)

# Include the global configuration file
include ${MAKEFILECONFIG}

# this overrides definitions from above by individual settings:
-include ${MAKEFILELOCAL}

BLUB = $(notdir $(FILES_BUNDLE))
# Targets:
# all, test, tar, install

# Target for all:
all : grf

# Print the output for a number of variables which define this newgrf.
test : 
	@echo "Call of nforenum:             $(NFORENUM) $(NFORENUM_FLAGS)"
	@echo "Call of grfcodec:             $(GRFCODEC) $(GRFCODEC_FLAGS)"
	@echo "Local installation directory: $(INSTALLDIR)"
	@echo "Repository revision:          r$(GRF_REVISION)"
	@echo "GRF title:                    $(GRF_TITLE)"
	@echo "Bundled files:				 $(FILES_BUNDLE)"
	@echo "Bundle filenames:             Tar=$(TAR_FILENAME) Zip=$(ZIP_FILENAME) Bz2=$(BZIP_FILENAME)"

# Compile GRF
grf : renumber
	# pipe all nfo files through grfcodec and produce the grf(s)
	@echo "Compiling GRF:"
	$(GRFCODEC) ${GRFCODEC_FLAGS} ${NFO_FILENAME}
	@echo
	
# NFORENUM process copy of the NFO
renumber : nfo
	@echo "NFORENUM processing:"
	-$(NFORENUM) ${NFORENUM_FLAGS} $(NFO_FILENAME)
	@echo
	
# Prepare the nfo file	
nfo : unify
	# replace the place holders for version and name by the respective variables:
	@echo "Setting title to $(GRF_TITLE)"
	@sed s/{{GRF_TITLE}}/'$(GRF_TITLE)'/ $(SPRITEDIR)/$(PNFO_FILENAME) > $(SPRITEDIR)/$(NFO_FILENAME)
	@echo	
	
unify:
	@echo
	@echo "Generating the nfo:"
	# The header file has to go first, the footer file has to go last. The others may in principle
	# be juggled in between as seen fi.
	@-rm $(SPRITEDIR)/$(PNFO_FILENAME)
	@echo "Header..."
	@cat $(NFODIR)/$(HEADER) > $(SPRITEDIR)/$(PNFO_FILENAME)
	@echo "...other stuff..."
	@for i in $(OTHERS); do cat $(NFODIR)/$$i >> $(SPRITEDIR)/$(PNFO_FILENAME); done
	@echo "...engines by region..."
	@for i in $(SUB_DIRS); do cat $(NFODIR)/$$i/*.$(NFO_SUFFIX) >> $(SPRITEDIR)/$(PNFO_FILENAME); done
	@echo "...languages..."
	@cat $(NFODIR)/$(LANG_DIR)/*.$(NFO_SUFFIX) >> $(SPRITEDIR)/$(PNFO_FILENAME)
	@echo "... and footer."
	@cat $(NFODIR)/$(FOOTER) >> $(SPRITEDIR)/$(PNFO_FILENAME)
		
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
	-for i in $(SUB_DIRS); do rm $(NFODIR)/$$i.nfo; done
	@echo
	@echo "Remove compiled .grf:"
	-rm *.grf
	@echo
	@echo "Removing old logs:"
	-rm *.log
	
# Create the release bundle with all files in one tar
tar : $(GRF_FILENAME)
	$(TAR) $(TAR_FLAGS) $(TAR_FILENAME) -P $(FILES_BUNDLE)
	@echo "Creating tar for publication"
	@echo

zip : tar
	@echo "creating zip'ed tar archive"
	cat $(TAR_FILENAME) | $(ZIP) $(ZIP_FLAGS) > $(ZIP_FILENAME)

bzip: tar
	@echo "creating bzip2'ed tar archive"
	$(BZIP) $(BZIP_FLAGS) $(TAR_FILENAME)

# Installation process
install: tar
	@echo "Installing grf to $(INSTALLDIR)"
	-cp $(TAR_FILENAME) $(INSTALLDIR)/$(TAR_FILENAME)
	@echo

bundle: grf tar bzip zip
	@echo creating bundle for grf	