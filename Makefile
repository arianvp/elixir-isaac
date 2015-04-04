MIX = mix
CFLAGS = -g -O3 -ansi -pedantic -Wall -Wextra -Wno-unused-parameter

ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS += -I$(ERLANG_PATH)

ifeq ($(wildcard deps/isaac_c),)
	ISAAC_C_PATH = ../isaac_c
else
	ISAAC_C_PATH = deps/isaac_c
endif

CFLAGS += -I$(ISAAC_C_PATH)

ifneq ($(OS),Windows_NT)
	CFLAGS += -fPIC

	ifeq ($(shell uname),Darwin)
		LDFLAGS += -dynamiclib -undefined dynamic_lookup
	endif
endif

.PHONY: all markdown clean

all: isaac

isaac:
	$(MIX) compile

priv/isaac.so: src/isaac.c
	$(MAKE) -C $(ISAAC_C_PATH) libisaac.a
	$(CC) $(CFLAGS) -shared $(LDFLAGS) -o $@ src/isaac.c $(ISAAC_C_PATH)/libisaac.a

clean:
	$(MIX) clean
	$(MAKE) -C $(ISAAC_C_PATH) clean
	$(RM) priv/isaac.so
