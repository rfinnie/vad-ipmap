NAME=ipv4-2015-01

all: ${NAME}.png

${NAME}.data: oix-full-snapshot.bz2
	bzcat oix-full-snapshot.bz2 | perl parse-oix.pl | sort -V > $@

${NAME}.png: ${NAME}.data ${NAME}.annotations ${NAME}.shade
	./ipv4-heatmap -s ${NAME}.shade -a ${NAME}.annotations -f "Source Sans Pro:style=Regular" -h < ${NAME}.data
	mv map.png $@

clean:
	rm -f ${NAME}.data ${NAME}.png
