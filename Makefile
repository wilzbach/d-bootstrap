DMD_VERSION=2.078.1
LDC_VERSION=1.7.1
DFLAGS=-g
PLATFORM=x86_64

DMD=bin/dmd-$(DMD_VERSION)/dmd2/linux/bin64/dmd
LDC=bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM)/bin/ldc2
DUB=bin/dmd-$(DMD_VERSION)/dmd2/linux/bin64/dub

################################################################################
# Auto-bootstrap DMD & LDC
################################################################################

bin:
	@mkdir -p $@

bin/dmd-$(DMD_VERSION)/dmd2: | bin
	@mkdir -p $(dir $@)
	curl -fSL --retry 3 "http://downloads.dlang.org/releases/2.x/$(DMD_VERSION)/dmd.$(DMD_VERSION).linux.tar.xz" | tar -Jxf - -C $(dir $@)
bin/dmd-$(DMD_VERSION)/dmd2/linux/bin64/dmd: | bin/dmd-$(DMD_VERSION)/dmd2

bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM): | bin
	curl -fSL --retry 3 "https://github.com/ldc-developers/ldc/releases/download/v$(LDC_VERSION)/ldc2-$(LDC_VERSION)-linux-$(PLATFORM).tar.xz" \
	| tar -Jxf - -C $(dir $@)

bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM)/bin/ldc2: | bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM)

################################################################################
# Define your programs here
################################################################################
D=source

bin/hello: $D/hello.d $(DMD)
	$(DMD) $(DFLAGS) $< -of$@

bin/hello_opt: $D/hello.d $(LDC)
	$(LDC) -g -O4 -mcpu=native -release $(DFLAGS) $< -of$@

dub: $(DMD)
	$(DUB)

.DEFAULT_GOAL=bin/hello

################################################################################
# Other targets
################################################################################

clean:
	rm -rf bin
