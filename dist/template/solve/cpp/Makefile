BIN_NAME = <%= prob.name %>
include ../../../common/Makefile
COMPILER = g++ -std=gnu++0x -I$(COMMON_D)/include/cpp
OUTPUT_D =$(ROOT_D)/build/$(BIN_NAME)/cpp

run = $(RUNNER) $1 $2 $(OUTPUT_D) $(BIN_NAME) 

default : usage

main : $(OUTPUT_D)/$(BIN_NAME)   

clean :
	rm -rf $(OUTPUT_D)

$(OUTPUT_D):
	@mkdir -p $(OUTPUT_D)

$(OUTPUT_D)/$(BIN_NAME): $(BIN_NAME)Runner.cpp $(BIN_NAME).hpp $(OUTPUT_D) 
	$(COMPILER) -o $(OUTPUT_D)/$(BIN_NAME) $<

