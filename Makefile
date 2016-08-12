# Settings for local environment
include make.inc

# Add assert level to compile command
MPICC += -DASSERT_ON=$(ASSERT_ON) -DUSE_PETSC=$(USE_PETSC)

# Include directories
INC = -Isrc $(PETSC_INC) 

LIBS = $(PETSC_LIB)



# List of sources, header files, and object files
SOURCE = $(wildcard src/*.cc)
HEADERS = $(wildcard src/*.hh)
OBJECTS = $(patsubst src%.cc, build%.o, $(SOURCE))


# Link object files
sweep.x: $(OBJECTS)
	@echo Linking $@
	$(MPICC) $(OBJECTS) -o sweep.x ${LIBS}
	@echo " "

# Make object files
build/%.o: src/%.cc $(HEADERS) make.inc
	@echo Making $@
	$(MPICC) $(INC) -c $< -o $@
	@echo " "

# Delete object files
.PHONY: clean
clean:
	@echo Delete object files
	rm build/*.o
	@echo " "

# Delete object files
.PHONY: doc
doc:
	@echo Creating documentation
	doxygen doc/doxygen/Doxyfile
	@echo " "
