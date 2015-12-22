NAME=ipv4

all: ${NAME}.png

${NAME}-snapshot.bz2: ${NAME}-rib.bz2 bgpdump
	./bgpdump -m -v ${NAME}-rib.bz2 | ./bgpdump-to-shipbgp | bzip2 -c > $@

${NAME}.data: ${NAME}-snapshot.bz2 parse-bgp
	bzcat ${NAME}-snapshot.bz2 | ./parse-bgp > $@

${NAME}.png: ${NAME}.data ${NAME}.annotations ${NAME}.shade ipv4-heatmap
	./ipv4-heatmap -s ${NAME}.shade -a ${NAME}.annotations -f "Source Sans Pro:style=Regular" -o $@ < ${NAME}.data

clean:
	rm -f ${NAME}.data ${NAME}.png
