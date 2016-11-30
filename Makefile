HILDON_FLAGS := ""

ifeq (1, $(shell pkg-config --exists hildon-1 && echo 1))
	HILDON_FLAGS := $(shell pkg-config --libs --cflags hildon-1)
else
	HILDON_FLAGS := $(shell pkg-config --libs --cflags hildon-3) -DHAVE_GTK3
endif

all: libsystemuiplugin_tklock.so

clean:
	$(RM) libsystemuiplugin_tklock.so

install: libsystemuiplugin_tklock.so
	install -d $(DESTDIR)/usr/lib/systemui
	install -m 644 libsystemuiplugin_tklock.so $(DESTDIR)/usr/lib/systemui
	install -d $(DESTDIR)/usr/share/themes/alpha/backgrounds
	install -m 644 share/themes/alpha-lockslider-portrait.png $(DESTDIR)/usr/share/themes/alpha/backgrounds/lockslider-portrait.png

libsystemuiplugin_tklock.so: osso-systemui-tklock.c eventeater.c
	$(CC) $^ -o $@ -shared -Wall -I./include $(CFLAGS) $(LDFLAGS) $(HILDON_FLAGS) -Wno-deprecated-declarations -fPIC $(shell pkg-config --libs --cflags osso-systemui gconf-2.0 x11 alarm libnotify dbus-1 glib-2.0 sqlite3) -ltime -Wl,-soname -Wl,$@

.PHONY: all clean install
