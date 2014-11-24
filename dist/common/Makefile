ROOT_D = ../../..
COMMON_D = $(ROOT_D)/common
RUNNER = bash $(COMMON_D)/bin/runner.sh
OUTPUT_D =$(ROOT_D)/build/$(BIN_NAME)/cpp

.PHONY: default, usage, main, demo, sys, sysv, clean
usage :
	@cat $(COMMON_D)/usage

demo : main
	$(call run,verbose,demo) 

sys : main
	$(call run,quiet,sys)

sysv : main
	$(call run,verbose,sys)

