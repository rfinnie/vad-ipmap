NAME=ipv4

all: ${NAME}.png

${NAME}.data: ${NAME}-snapshot.bz2
	bzcat ${NAME}-snapshot.bz2 | ./parse-bgp > $@

${NAME}.png: ${NAME}.data ${NAME}.annotations ${NAME}.shade
	./ipv4-heatmap -s ${NAME}.shade -a ${NAME}.annotations -f "Source Sans Pro:style=Regular" -o $@ < ${NAME}.data

clean:
	rm -f ${NAME}.data ${NAME}.png
