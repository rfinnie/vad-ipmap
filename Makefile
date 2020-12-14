export PATH := $(CURDIR)/bin:$(PATH)

HEATMAP_FONT = Source Sans Pro:style=Regular
SNAPSHOTS = $(patsubst sources/%.rib.bz2,sources/%.snapshot.bz2,$(wildcard sources/*.rib.bz2))
HEATMAPS = $(patsubst sources/%.snapshot.bz2,sources/%.heatmap.bz2,$(SNAPSHOTS) $(wildcard sources/*.snapshot.bz2))
PNGS = $(patsubst sources/%.heatmap.bz2,png/%.png,$(HEATMAPS) $(wildcard sources/*.heatmap.bz2))

sources/%.snapshot.bz2: sources/%.rib.bz2
	bgpdump -m -v $< | bgpdump-to-shipbgp | bzip2 -c > $@

sources/%.heatmap.bz2: sources/%.snapshot.bz2
	bzcat $< | parse-bgp -c $(patsubst sources/%.snapshot.bz2,heatmap-data/%.config.yaml,$<) | bzip2 -c > $@

heatmap-data/%.annotations: heatmap-data/%.annotations.in
	build-fakev4 -c $(patsubst heatmap-data/%.annotations.in,heatmap-data/%.config.yaml,$<) < $< >$@

heatmap-data/%.shade: heatmap-data/%.shade.in
	build-fakev4 -c $(patsubst heatmap-data/%.shade.in,heatmap-data/%.config.yaml,$<) < $< >$@

png/%.png: sources/%.heatmap.bz2 heatmap-data/%.annotations heatmap-data/%.shade
	bzcat $< | ipv4-heatmap -s $(patsubst png/%.png,heatmap-data/%.shade,$@) -a $(patsubst png/%.png,heatmap-data/%.annotations,$@) -f "$(HEATMAP_FONT)" -o $@

png: $(PNGS)

heatmap: $(HEATMAPS)

snapshot: $(SNAPSHOTS)

all: snapshot heatmap png

.PHONY: all snapshot heatmap png
