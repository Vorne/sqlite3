####################################################################################################
#
# Make SQLite library
#
####################################################################################################

BUILD_DIR ?= ../xl
include $(BUILD_DIR)/makefile.d/base.mk

################################################################################
## Internals ###################################################################
################################################################################
SQLITE3_DIR := .
SQLITE3_LIB_NAME := libsqlite3.a
SILENCE_WARNINGS := -Wno-deprecated-declarations

SQLITE3_LIBRARY := $(OUTPUT_DIR)/$(SQLITE3_LIB_NAME)

SQLITE3_FILES = $(shell find . -name "*.c" -or -name "*.h")
SQLITE3_FILES += Makefile

# From http://beets.io/blog/sqlite-nightmare.html
CFLAGS += -DHAVE_USLEEP=1

################################################################################
## SQLite3 Target ##############################################################
################################################################################
$(SQLITE3_LIBRARY): $(SQLITE3_FILES)

	@if [[ ! -d $(SQLITE3_DIR) ]] ;            \
	then                                       \
	    echo "$(SQLITE3_DIR) not found" ;      \
	    exit 1 ;                               \
	fi

	@echo Building SQLite3 library...
	@mkdir -p $(dir $@)
	$(VERBOSE)$(CC) $(CFLAGS) -g -static -c -o $@ $(SILENCE_WARNINGS) -I. sqlite3.c

	@if [[ ! -e $(SQLITE3_LIBRARY) ]] ;                 \
	then                                                \
	    echo "Failed to generate $(SQLITE3_LIBRARY)" ;  \
	    exit 1 ;                                        \
	fi

	@echo Done building SQLite3.
	@echo 

sqlite3: $(SQLITE3_LIBRARY)
all: sqlite3

clean:
	rm -rf $(OUTPUT_DIR)
