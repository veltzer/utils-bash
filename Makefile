##############
# parameters #
##############
# do you want to see the commands executed ?
DO_MKDBG:=0
# do you want to check bash syntax?
DO_CHECK_SYNTAX:=1
# do you want dependency on the Makefile itself ?
DO_ALLDEP:=1

########
# code #
########
ALL:=

# silent stuff
ifeq ($(DO_MKDBG),1)
Q:=
# we are not silent in this branch
else # DO_MKDBG
Q:=@
#.SILENT:
endif # DO_MKDBG

ALL_SH_SRC:=$(shell find src -type f -and -name "*.sh" 2>/dev/null)
ALL_SH_CHECK:=$(addprefix out/, $(addsuffix .check, $(ALL_SH_SRC)))

ifeq ($(DO_CHECK_SYNTAX),1)
ALL+=$(ALL_SH_CHECK)
endif # DO_CHECK_SYNTAX

#########
# rules #
#########
.PHONY: all
all: $(ALL)
	@true

.PHONY: install
install:
	$(info doing [$@])
	$(Q)pymakehelper symlink_install --source_folder src --target_folder ~/install/bin

.PHONY: debug
debug:
	$(info doing [$@])
	$(info ALL_SH_SRC is $(ALL_SH_SRC))
	$(info ALL_SH_CHECK is $(ALL_SH_CHECK))

.PHONY: first_line_stats
first_line_stats:
	$(info doing [$@])
	$(Q)head -1 -q $(ALL_SH_SRC) | sort -u

.PHONY: clean
clean:
	$(info doing [$@])
	$(Q)rm -f $(ALL)

.PHONY: clean_hard
clean_hard:
	$(info doing [$@])
	$(Q)git clean -qffxd

############
# patterns #
############
$(ALL_SH_CHECK): out/%.check: % .shellcheckrc
	$(info doing [$@])
	$(Q)shellcheck --shell=bash --external-sources --source-path="$${HOME}" $<
	$(Q)pymakehelper touch_mkdir $@

##########
# alldep #
##########
ifeq ($(DO_ALLDEP),1)
.EXTRA_PREREQS+=$(foreach mk, ${MAKEFILE_LIST},$(abspath ${mk}))
endif # DO_ALLDEP
