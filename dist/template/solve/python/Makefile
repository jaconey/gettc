BIN_NAME = <%= prob.name %>
include ../../../common/Makefile
OUTPUT_D =$(ROOT_D)/build/$(BIN_NAME)/python

run = $(RUNNER) $1 $2 $(OUTPUT_D) $(BIN_NAME)

default : usage

main : $(OUTPUT_D)/$(BIN_NAME)

clean :
	rm -rf $(OUTPUT_D)

$(OUTPUT_D):
	@mkdir -p $(OUTPUT_D)

$(OUTPUT_D)/$(BIN_NAME): $(BIN_NAME).py $(BIN_NAME)Runner.py $(OUTPUT_D)
	cp $(BIN_NAME)Runner.py $(OUTPUT_D)/$(BIN_NAME)
	cp $(BIN_NAME).py $(OUTPUT_D)/$(BIN_NAME).py
	chmod +x $(OUTPUT_D)/$(BIN_NAME)
