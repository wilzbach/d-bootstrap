DMD_VERSION=2.079.0
LDC_VERSION=1.8.0
DFLAGS=-g
LFLAGS=-g -O4 -mcpu=native -release -L--export-dynamic
PLATFORM=x86_64

DMD=bin/dmd-$(DMD_VERSION)/dmd2/linux/bin64/dmd
RDMD=bin/dmd-$(DMD_VERSION)/dmd2/linux/bin64/rdmd
DUB=bin/dmd-$(DMD_VERSION)/dmd2/linux/bin64/dub

LDC=bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM)/bin/ldc2
LDMD=bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM)/bin/ldmd2
LDUB=bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM)/bin/dub
LRDMD=bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM)/bin/rdmd

LDC_BUILD_RT=bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM)/bin/ldc-build-runtime
LDC_LTO=bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM)/runtime
LDC_LTO_FLAGs=-flto=full -linker=gold -L-L$(LDC_LTO)/lib

################################################################################
# Auto-bootstrap DMD & LDC
#
# This also sets convenience symlinks like bin/dmd or bin/ldc
# for usage outside of Make
################################################################################

bin:
	@mkdir -p $@

bin/dmd-$(DMD_VERSION)/dmd2: | bin
	@mkdir -p $(dir $@)
	curl -fSL --retry 10 "http://downloads.dlang.org/releases/2.x/$(DMD_VERSION)/dmd.$(DMD_VERSION).linux.tar.xz" | tar -Jxf - -C $(dir $@)
	@rm -f bin/{dmd,rdmd,dub}
	@for l in dmd rdmd dub ; do ln -s ./$(dir $(DMD:bin/%=%))$$l bin/$$l ; done

$(DMD): | bin/dmd-$(DMD_VERSION)/dmd2
$(RDMD): | bin/dmd-$(DMD_VERSION)/dmd2
$(DUB): | bin/dmd-$(DMD_VERSION)/dmd2
setup-dmd: $(DMD)
setup-dub: $(DMD)

bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM): | bin
	curl -fSL --retry 10 "https://github.com/ldc-developers/ldc/releases/download/v$(LDC_VERSION)/ldc2-$(LDC_VERSION)-linux-$(PLATFORM).tar.xz" \
	| tar -Jxf - -C $(dir $@)
	@rm -f bin/{ldc,ldmd,ldub,lrdmd}
	@ln -s ./$(LDC:bin/%=%) bin/ldc && ln -s ./$(LDMD:bin/%=%) bin/ldmd
	@ln -s ./$(LRDMD:bin/%=%) bin/lrdmd && ln -s ./$(LDUB:bin/%=%) bin/ldub

$(LDC): | bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM)
$(LDMD): | bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM)
$(LDUB): | bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM)
$(LRDMD): | bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM)
$(LDC_BUILD_RT): | bin/ldc2-$(LDC_VERSION)-linux-$(PLATFORM)
setup-ldc: $(LDC)

$(LDC_LTO): | $(LDC_BUILD_RT)
	$| --buildDir $@

################################################################################
# Define your programs here
################################################################################
D=source

bin/hello: $D/hello.d $(DMD)
	$(DMD) $(DFLAGS) $< -of$@

bin/hello_opt: $D/hello.d $(LDC)
	$(LDC) $(LFLAGS) $< -of$@

bin/hello_lto: $D/hello.d $(LDC_LTO)
	$(LDC) $(LFLAGS) $(LDC_LTO_FLAGS) $< -of$@

dub: $(DUB)
	$(DUB)

dub_opt: $(LDUB)
	$(LDUB) -b release

.DEFAULT_GOAL=bin/hello

################################################################################
# Other targets
################################################################################

test: $(DUB)
	$(DUB) test

clean:
	rm -rf bin
