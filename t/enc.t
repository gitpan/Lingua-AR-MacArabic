
BEGIN { $| = 1; print "1..28\n"; }
END {print "not ok 1\n" unless $loaded;}

use Lingua::AR::MacArabic qw(decode encode);
$loaded = 1;
print "ok 1\n";

####

print 1
   && "" eq encode("")
   && "" eq decode("")
   && "Perl" eq encode("Perl")
   && "Perl" eq decode("Perl")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

$ampLR = "\x{202D}\x2B\x{202C}";
$ampRL = "\x{202E}\x2B\x{202C}";

print $ampLR eq decode("\x2B")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print $ampRL eq decode("\xAB")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x2B" eq encode($ampLR)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\xAB" eq encode($ampRL)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x{C4}" eq decode("\x80")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x80" eq encode("\x{C4}")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x{6D2}" eq decode("\xFF")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\xFF" eq encode("\x{6D2}")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

$longEnc = "\x24\x20\x28\x29";
$longUni = "\x{202D}\x{0024}\x{0020}\x{0028}\x{0029}\x{202C}";

print $longUni eq decode($longEnc)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print $longEnc eq encode($longUni)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print 1
   && "\0" eq encode("\0")
   && "\0" eq decode("\0")
   && "\cA" eq encode("\cA")
   && "\cA" eq decode("\cA")
   && "\t" eq encode("\t")
   && "\t" eq decode("\t")
   && "\x7F" eq encode("\x7F")
   && "\x7F" eq decode("\x7F")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print 1
   && "\n" eq encode("\n")
   && "\n" eq decode("\n")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print 1
   && "\r" eq encode("\r")
   && "\r" eq decode("\r")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print 1
   && "0123456789" eq encode("0123456789")
   && "0123456789" eq decode("0123456789")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

#####

$macDigitRL = "\xB0\xB1\xB2\xB3\xB4\xB5\xB6\xB7\xB8\xB9"; # RL only
$uniDigit = "\x{660}\x{661}\x{662}\x{663}\x{664}\x{665}\x{666}\x{667}\x{668}\x{669}";
$uniDigitRL = "\x{202E}$uniDigit\x{202C}";

print "0123456789" eq encode($uniDigit)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print 1
   && $uniDigitRL eq decode($macDigitRL)
   && $macDigitRL eq encode($uniDigitRL)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

# round-trip convetion for single-character strings

$allchar = map chr, 0..255;
print $allchar eq encode(decode($allchar))
   ? "ok" : "not ok", " ", ++$loaded, "\n";

$NG = 0;
for ($char = 0; $char <= 255; $char++) {
    $bchar = chr $char;
    $uchar = encode(decode($bchar));
    $NG++ unless $bchar eq $uchar;
}
print $NG == 0
   ? "ok" : "not ok", " ", ++$loaded, "\n";

# to be downgraded on decoding.
print "\x{C4}" eq decode("\x{80}")
   && "\x{C4}" eq decode(pack 'U', 0x80)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x30" eq encode("\x{0660}") # ARABIC-INDIC DIGIT ZERO
   && "\x30" eq encode("\x{202D}\x{0660}") # with LRO
   && "\xB0" eq encode("\x{202E}\x{0660}") # with RLO
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x39" eq encode("\x{0669}") # ARABIC-INDIC DIGIT NINE
   && "\x39" eq encode("\x{202D}\x{0669}") # with LRO
   && "\xB9" eq encode("\x{202E}\x{0669}") # with RLO
   ? "ok" : "not ok", " ", ++$loaded, "\n";

$hexNCR = sub { sprintf("&#x%x;", shift) };
$decNCR = sub { sprintf("&#%d;" , shift) };

print "a\xC7" eq
	encode(pack 'U*', 0x100ff, 0x61, 0x3042, 0x0627)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "a\xC7" eq
	encode(\"", pack 'U*', 0x100ff, 0x61, 0x3042, 0x0627)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "?a?\xC7" eq
	encode(\"?", pack 'U*', 0x100ff, 0x61, 0x3042, 0x0627)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "&#x100ff;a&#x3042;\xC7" eq
	encode($hexNCR, pack 'U*', 0x100ff, 0x61, 0x3042, 0x0627)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "&#65791;a&#12354;\xC7" eq
	encode($decNCR, pack 'U*', 0x100ff, 0x61, 0x3042, 0x0627)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

