BIN_NAME = <%= prob.name %>
include ../../../common/Makefile
OUTPUT_D =$(ROOT_D)/build/$(BIN_NAME)/go

run = $(RUNNER) $1 $2 $(OUTPUT_D) $(BIN_NAME) 

default : usage

$(OUTPUT_D):
	@mkdir -p $(OUTPUT_D)

main : $(OUTPUT_D)/$(BIN_NAME)   

$(OUTPUT_D)/$(BIN_NAME): $(BIN_NAME)Runner.go $(OUTPUT_D) $(BIN_NAME)/$(BIN_NAME).go 
	export GOPATH="$$GOPATH:`pwd`/$(COMMON_D)/include/go" && go build -o $(OUTPUT_D)/$(BIN_NAME) $(BIN_NAME)Runner.go 

clean :
	rm -rf $(OUTPUT_D)
