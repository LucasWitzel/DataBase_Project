# Compilation settings
CXX = clang++
CXXFLAGS = -std=c++17 -Wall -Wextra -O2 -I.
LDFLAGS = -lpqxx -lpq

# Database credentials
DATABASE = banco_de_dados
USER = user
PASSWORD = password

# Files
SOURCES = interface.cpp operations.cpp tables.cpp
HEADERS = operations.hpp tables.hpp
OBJECTS = $(SOURCES:.cpp=.o)
EXECUTABLE = app

# Rules
all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

run: $(EXECUTABLE)
	./$(EXECUTABLE) $(DATABASE) $(USER) $(PASSWORD)

clean:
	rm -f $(OBJECTS) $(EXECUTABLE)
