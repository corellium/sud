-include Makefile.local

CFLAGS := -O2 -Wall -Wextra
CFLAGS += -I./include/
LDFLAGS := -llog

BIN_DIR := bin
SRC_DIR := src

OBJS =
OBJS += $(sort $(patsubst %.c,%.o,$(wildcard $(SRC_DIR)/*.c)))

.PHONY: all clean

all: su

clean:
	/bin/rm --force $(OBJS)
	/bin/rm --force $(BIN_DIR)/su

su: $(OBJS)
	$(CC) -o $(BIN_DIR)/$@ $^ $(LDFLAGS) $(EXTRA_LDFLAGS)

%.o: %.c
	$(CC) -o $@ $^ -c $(CFLAGS) $(EXTRA_CFLAGS)
