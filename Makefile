##########
# params #
##########
# do you want to see the commands executed ?
DO_MKDBG:=0
# do you want to check bash syntax?
DO_CHECK_SYNTAX:=1
# do you want dependency on the Makefile itself ?
DO_ALLDEP:=1
# do you want to do tools?
DO_TOOLS:=1

########
# code #
########
ALL:=
TOOLS:=tools.stamp

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

ifeq ($(DO_TOOLS),1)
.EXTRA_PREREQS+=$(TOOLS)
ALL+=$(TOOLS)
endif # DO_TOOLS

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

$(TOOLS): packages.txt config/deps.py
	$(info doing [$@])
	$(Q)xargs -a packages.txt sudo apt-get -y install > /dev/null
	$(Q)pymakehelper touch_mkdir $@

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
	$(Q)rm -f $(ALL_STAMP)

.PHONY: clean_hard
clean_hard:
	$(info doing [$@])
	$(Q)git clean -qffxd

############
# patterns #
############
$(ALL_STAMP): out/%.stamp: % .shellcheckrc
	$(info doing [$@])
	$(Q)mkdir -p $(dir $@)
	$(Q)shellcheck --shell=bash --external-sources --source-path="$$HOME" $<
	$(Q)pymakehelper touch_mkdir $@
