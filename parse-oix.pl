#!/usr/bin/perl

use Socket;

while($l = <STDIN>) {
    chomp $l;
    next unless($l =~ /^\*\s+(\d+)\.(\d+)\.(\d+)\.(\d+)\/(\d+)\s+/);
    $a = $1; $b = $2; $c = $3; $d = $4; $cidr = $5;
    $c24 = unpack("N", inet_aton("$a.$b.$c.0")) / 256;
    if($cidr > 24) {
        if($x{$c24}) {
            if($cidr > $x{$c24}) {
                $x{$c24} = $cidr;
            }
        } else {
            $x{$c24} = $cidr;
        }
    } else {
        # This is terribly inefficient, but it works
        for($i = 0; $i < (2**(24-$cidr)); $i++) {
            $nc24 = $c24 + $i;
            if($x{$nc24}) {
                if($cidr > $x{$nc24}) {
                    $x{$nc24} = $cidr;
                }
            } else {
                $x{$nc24} = $cidr;
            }
        }
    }
}

foreach $i (keys %x) {
    next if $x{$i} < 8;
    $ip = inet_ntoa(pack("N", $i * 256));
    $idx = $x{$i} - 8;
    print "$ip $idx\n";
}
