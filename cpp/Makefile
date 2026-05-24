CXX = g++
CXXFLAGS = -std=c++17 -Wall -O2
TARGET = game
SOURCE = game.cpp
OBJ = $(SOURCE:.cpp=.o)

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(OBJ)

$(OBJ): $(SOURCE)
	$(CXX) $(CXXFLAGS) -c $(SOURCE)

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(OBJ) $(TARGET)

.PHONY: all run clean
