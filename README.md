# Velociraptor Aerospace Dynamics IP Map

This archive contains code and data used to produce the map portion of the [Velociraptor Aerospace Dynamics IP Map](http://vad.solutions/ipmap/).

## Requirements

  * [ipv4-heatmap](http://maps.measurement-factory.com/software/index.html), with the optional patch here against ipv4-heatmap-20140203 which modifies some of the visual aspects of the image output (transparency, perceptual rainbow, etc).
  * A source of "sh ip bgp" data, e.g. from the [University of Oregon Route Views project](http://archive.routeviews.org/oix-route-views/)
    * MRT RIB dumps ([IPv4](http://archive.routeviews.org/bgpdata/), [IPv6](http://archive.routeviews.org/route-views6/bgpdata/)) can be converted to machine-readable single-line [bgpdump](http://www.ris.ripe.net/source/bgpdump/) format, which can then be converted to "sh ip bgp" format using `bgpdump-to-shipbgp`

## IPv6 Data

`ipv4-heatmap` is, as you can guess from the name, limited to working with IPv4 data.
It works (by default) by displaying IPv4 /24 networks' color indexes in a 4096x4096 table.
To work with IPv6 data, we aggregate the target IPv6 range down to 24 bits worth of networks, and pretend they are IPv4 networks.
Currently, this means working with 2000::/4.

Beginning with 2000::/4, we are masking off and shifting 4 bits, so each IPv6 /28 corresponds to a fake IPv4 /24.
For example, 2000::/28 becomes 0.0.0.0, and 2001:470:1f05:22e::/64 becomes 0.16.71.0 and the IPv6 /64 would be indicated in 0.16.71.0/24.
2001:c00::/23 becomes 0.16.192.0, and since we are aggregating to /24s, the IPv6 /23 (fake IPv4 /19) would be indicated in 0.16.192.0/24, 0.16.192.1/24, 0.16.192.2/24, etc, a total of 64 times.

## Data Sources

`parse-bgp`, which feeds `ipv4-heatmap`, works with "sh ip bgp" data.  By default, Route Views publishes binary MRT RIB dumps.

"So wait, we're going from MRT to bgpdump to 'sh ip bgp' to ipv4-heatmap?  Why can't parse-bgp just read the MRT RIB dumps directly?"

A few reasons:

 1. There are a few Python MRT libraries (for example, [mrtparse](https://github.com/YoshiyukiYamauchi/mrtparse)), but they are approximately two orders of magnitute slower than parsing the equivalent "sh ip bgp" data.
    [bgpdump](http://www.ris.ripe.net/source/bgpdump/) is faster, but only gets you to single-line bgpdump format, and is still an order of magnitude slower.
    (`bgpdump-to-shipbgp` is fast enough that the further speed loss is negligable.)
 2. Route Views also publishes dumps in "sh ip bgp" format, but only for the IPv4 data.
    IPv6 data is only in MRT format.
 3. Route Views MRT data only goes back to 2001, while "sh ip bgp" data goes back to 1996.

Since both MRT and "sh ip bgp" sources are needed, we use "sh ip bgp" as the common denominator for a conversion base.

## License

Copyright (C) 2015 [Ryan Finnie](http://www.finnie.org/)

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
