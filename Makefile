#!/usr/bin/make -f

# Source files and target
TARGET := file-watchdog
C_FILES := $(wildcard src/*.c)
HEADERS := $(wildcard include/*.h)
OBJS := ${C_FILES:.c=.c.o}

SYSTEMD_UNIT := src/$(TARGET)@.service
EXAMPLE_CONF := src/devnull.conf
OTHER_FILES := $(SYSTEMD_UNIT) $(EXAMPLE_CONF)
INSTALLED_FILES := $(TARGET) $(OTHER_FILES)

all: $(TARGET)
.PHONY: all clean install uninstall purge

# Compiler selection
CC = gcc
CCLD := gcc
CPPFLAGS += -Iinclude

# Optimization and debugging
ifeq ($(debug),1)
# Debug mode.
OPTFLAGS := -Og -g3
else
OPTFLAGS := -Os
endif

$(TARGET): $(OBJS)
	$(CCLD) $(LDFLAGS) $(OBJS) $(LIBS) -o $(TARGET)

%.c.o: %.c
	$(CC) -std=gnu11 $< $(OPTFLAGS) $(CPPFLAGS) $(CFLAGS) -o $@

clean:
	-rm -rf $(TARGET) $(OBJS)

install: $(INSTALLED_FILES)
	install -d -t /usr/sbin -m 755 $(TARGET)
	install -d -t /lib/systemd/system -m 644 $(SYSTEMD_UNIT)
	install -d -t /etc/file-watchdog -m 644 $(EXAMPLE_CONF)
	-systemctl daemon-reload

uninstall:
	rm -f /usr/sbin/$(notdir $(TARGET))
	rm -f /lib/systemd/system/$(notdir $(SYSTEMD_UNIT))
	-systemctl daemon-reload

purge: uninstall
	rm -rf /etc/file-watchdog
