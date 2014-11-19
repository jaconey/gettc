GETTC_HOME ?= $(HOME)/.gettc
DATA_D = ../../data
COMPILER = g++ -std=gnu++0x -I$(GETTC_HOME)/include/cpp
RUNNER = sh ../../bin/runner.sh
BIN_NAME = $(shell echo `find *Runner.cpp|cut -d "." -f 1`)
OUTPUT_D =../../../build/cpp/$(BIN_NAME)

run = $(RUNNER) $1 $(OUTPUT_D)/$(BIN_NAME) $(DATA_D)/$2 $(OUTPUT_D)/$2

default : usage

usage :
	@cat $(GETTC_HOME)/usage

$(OUTPUT_D):
	mkdir -p $(OUTPUT_D)

main : $(BIN_NAME).cpp $(OUTPUT_D)
	$(COMPILER) -o $(OUTPUT_D)/$(BIN_NAME) $<

demo : main
	$(call run,verbose,demo) 

sys : main
	$(call run,quiet,sys)

sysv : main
	$(call run,verbose,sys)

clean :
	rm -rf $(OUTPUT_D)
