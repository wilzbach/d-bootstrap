DMD_VERSION=2.079.0
LDC_VERSION=1.8.0
DFLAGS=-g
PLATFORM=x86_64

DMD=bin/dmd-$(DMD_VERSION)/dmd2/linux/bin64/dmd
LDC=bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM)/bin/ldc2
DUB=bin/dmd-$(DMD_VERSION)/dmd2/linux/bin64/dub
LDUB=bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM)/bin/dub

################################################################################
# Auto-bootstrap DMD & LDC
################################################################################

bin:
	@mkdir -p $@

bin/dmd-$(DMD_VERSION)/dmd2: | bin
	@mkdir -p $(dir $@)
	curl -fSL --retry 10 "http://downloads.dlang.org/releases/2.x/$(DMD_VERSION)/dmd.$(DMD_VERSION).linux.tar.xz" | tar -Jxf - -C $(dir $@)
$(DMD): | bin/dmd-$(DMD_VERSION)/dmd2
$(DUB): | bin/dmd-$(DMD_VERSION)/dmd2

bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM): | bin
	curl -fSL --retry 10 "https://github.com/ldc-developers/ldc/releases/download/v$(LDC_VERSION)/ldc2-$(LDC_VERSION)-linux-$(PLATFORM).tar.xz" \
	| tar -Jxf - -C $(dir $@)

$(LDC): | bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM)
$(LDUB): | bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM)

################################################################################
# Define your programs here
################################################################################
D=source

bin/hello: $D/hello.d $(DMD)
	$(DMD) $(DFLAGS) $< -of$@

bin/hello_opt: $D/hello.d $(LDC)
	$(LDC) -g -O4 -mcpu=native -release $(DFLAGS) $< -of$@

dub: $(DUB)
	$(DUB)

dub_opt: $(LDUB)
	$(LDUB) -b release

.DEFAULT_GOAL=bin/hello

################################################################################
# Other targets
################################################################################

clean:
	rm -rf bin
