##########
# params #
##########
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

# dependency on the makefile itself
ifeq ($(DO_ALLDEP),1)
.EXTRA_PREREQS+=$(foreach mk, ${MAKEFILE_LIST},$(abspath ${mk}))
endif # DO_ALLDEP

ALL_SH:=$(shell find src -name "*.sh")
ALL_STAMP:=$(addprefix out/, $(addsuffix .stamp, $(ALL_SH)))

ifeq ($(DO_CHECK_SYNTAX),1)
ALL+=$(ALL_STAMP)
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
	$(info ALL_SH is $(ALL_SH))
	$(info ALL_STAMP is $(ALL_STAMP))

.PHONY: first_line_stats
first_line_stats:
	$(info doing [$@])
	$(Q)head -1 -q $(ALL_SH) | sort -u

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
$(ALL_STAMP): out/%.stamp: % .shellcheckrc
	$(info doing [$@])
	$(Q)shellcheck --shell=bash --external-sources --source-path="$$HOME" $<
	$(Q)pymakehelper touch_mkdir $@
