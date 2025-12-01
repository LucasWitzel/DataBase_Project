# Compilation settings
CXX = clang++
CXXFLAGS = -std=c++17 -Wall -Wextra -O2 -I.
LDFLAGS = -lpqxx -lpq

# Database credentials
DATABASE = projetobd
USER = lucas
PASSWORD = moulaga

# Files
SOURCES = interface.cpp operations.cpp tables.cpp
HEADERS = operations.hpp tables.hpp
OBJECTS = $(SOURCES:.cpp=.o)
EXECUTABLE = app

# Rules
check: 
	@systemctl status postgresql

all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

run: $(EXECUTABLE)
	./$(EXECUTABLE) $(DATABASE) $(USER) $(PASSWORD)

clean:
	rm -f $(OBJECTS) $(EXECUTABLE)
