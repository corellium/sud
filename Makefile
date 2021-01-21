-include Makefile.local

CFLAGS := -O2 -Wall -Wextra
CFLAGS += -I./include/
LDFLAGS := -llog

OBJS =
OBJS += $(sort $(patsubst %.c,%.o,$(wildcard src/*.c)))

.PHONY: all clean

all: su

clean:
	/bin/rm --force $(OBJS)
	/bin/rm --force su

su: $(OBJS)
	$(CC) -o bin/$@ $^ $(LDFLAGS) $(EXTRA_LDFLAGS)

%.o: %.c
	$(CC) -o $@ $^ -c $(CFLAGS) $(EXTRA_CFLAGS)
