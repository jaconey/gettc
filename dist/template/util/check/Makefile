BUILD_D = ../../../build/<%= prob.name %>

all: $(BUILD_D)/check

$(BUILD_D)/check: check.cpp 
	@g++ -I../../../common/include/cpp -o $@ $<

$(BUILD_D):
	mkdir -p $(BUILD_D)

clean:
	rm -rf $(BUILD_D)/check

.PHONY: clean all

