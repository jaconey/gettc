GETTC_HOME ?= $(HOME)/.gettc
BUILD_D = ../../../build

all: $(BUILD_D)/check

$(BUILD_D)/check: check.cpp 
	# $(BUILD_D)
	g++ -I$(GETTC_HOME)/include/cpp -o $@ $<

$(BUILD_D):
	mkdir -p $(BUILD_D)

clean:
	rm -rf $(BUILD_D)/check

.PHONY: clean all

