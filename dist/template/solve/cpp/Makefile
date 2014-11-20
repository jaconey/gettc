ROOT_D = ../../..
COMMON_D = $(ROOT_D)/common
DATA_D = ../../data
COMPILER = g++ -std=gnu++0x -I$(COMMON_D)/include/cpp
RUNNER = bash $(COMMON_D)/bin/runner.sh
BIN_NAME = $(shell echo `find *Runner.cpp|cut -d "." -f 1`)
OUTPUT_D =$(ROOT_D)/build/cpp/$(BIN_NAME)

run = $(RUNNER) $1 $(OUTPUT_D)/$(BIN_NAME) $(DATA_D)/$2 $(OUTPUT_D)/$2

.PHONY: default, usage, main, demo, sys, sysv, clean

default : usage

usage :
	@cat $(COMMON_D)/usage

main : $(OUTPUT_D)/$(BIN_NAME)   

demo : main
	$(call run,verbose,demo) 

sys : main
	$(call run,quiet,sys)

sysv : main
	$(call run,verbose,sys)

clean :
	rm -rf $(OUTPUT_D)

$(OUTPUT_D):
	@mkdir -p $(OUTPUT_D)

$(OUTPUT_D)/$(BIN_NAME): $(BIN_NAME).cpp $(OUTPUT_D)
	@$(COMPILER) -o $(OUTPUT_D)/$(BIN_NAME) $<

