
BEGIN { $| = 1; print "1..28\n"; }
END {print "not ok 1\n" unless $loaded;}

use Lingua::AR::MacArabic ();
$loaded = 1;
print "ok 1\n";

####

print 1
   && "" eq Lingua::AR::MacArabic::encode("")
   && "" eq Lingua::AR::MacArabic::decode("")
   && "Perl" eq Lingua::AR::MacArabic::encode("Perl")
   && "Perl" eq Lingua::AR::MacArabic::decode("Perl")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

$ampLR = "\x{202D}\x2B\x{202C}";
$ampRL = "\x{202E}\x2B\x{202C}";

print $ampLR eq Lingua::AR::MacArabic::decode("\x2B")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print $ampRL eq Lingua::AR::MacArabic::decode("\xAB")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x2B" eq Lingua::AR::MacArabic::encode($ampLR)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\xAB" eq Lingua::AR::MacArabic::encode($ampRL)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x{C4}" eq Lingua::AR::MacArabic::decode("\x80")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x80" eq Lingua::AR::MacArabic::encode("\x{C4}")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x{6D2}" eq Lingua::AR::MacArabic::decode("\xFF")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\xFF" eq Lingua::AR::MacArabic::encode("\x{6D2}")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

$longEnc = "\x24\x20\x28\x29";
$longUni = "\x{202D}\x{0024}\x{0020}\x{0028}\x{0029}\x{202C}";

print $longUni eq Lingua::AR::MacArabic::decode($longEnc)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print $longEnc eq Lingua::AR::MacArabic::encode($longUni)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print 1
   && "\0" eq Lingua::AR::MacArabic::encode("\0")
   && "\0" eq Lingua::AR::MacArabic::decode("\0")
   && "\cA" eq Lingua::AR::MacArabic::encode("\cA")
   && "\cA" eq Lingua::AR::MacArabic::decode("\cA")
   && "\t" eq Lingua::AR::MacArabic::encode("\t")
   && "\t" eq Lingua::AR::MacArabic::decode("\t")
   && "\x7F" eq Lingua::AR::MacArabic::encode("\x7F")
   && "\x7F" eq Lingua::AR::MacArabic::decode("\x7F")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print 1
   && "\n" eq Lingua::AR::MacArabic::encode("\n")
   && "\n" eq Lingua::AR::MacArabic::decode("\n")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print 1
   && "\r" eq Lingua::AR::MacArabic::encode("\r")
   && "\r" eq Lingua::AR::MacArabic::decode("\r")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print 1
   && "0123456789" eq Lingua::AR::MacArabic::encode("0123456789")
   && "0123456789" eq Lingua::AR::MacArabic::decode("0123456789")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

#####

$macDigitRL = "\xB0\xB1\xB2\xB3\xB4\xB5\xB6\xB7\xB8\xB9"; # RL only
$uniDigit = "\x{660}\x{661}\x{662}\x{663}\x{664}\x{665}\x{666}\x{667}\x{668}\x{669}";
$uniDigitRL = "\x{202E}$uniDigit\x{202C}";

print "0123456789" eq Lingua::AR::MacArabic::encode($uniDigit)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print 1
   && $uniDigitRL eq Lingua::AR::MacArabic::decode($macDigitRL)
   && $macDigitRL eq Lingua::AR::MacArabic::encode($uniDigitRL)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

# round-trip convetion for single-character strings

$allchar = map chr, 0..255;
print $allchar eq Lingua::AR::MacArabic::encode
	(Lingua::AR::MacArabic::decode($allchar))
   ? "ok" : "not ok", " ", ++$loaded, "\n";

$NG = 0;
for ($char = 0; $char <= 255; $char++) {
    $bchar = chr $char;
    $uchar = Lingua::AR::MacArabic::encode
	(Lingua::AR::MacArabic::decode($bchar));
    $NG++ unless $bchar eq $uchar;
}
print $NG == 0
   ? "ok" : "not ok", " ", ++$loaded, "\n";

# to be downgraded on decoding.
print "\x{C4}" eq Lingua::AR::MacArabic::decode("\x{80}")
   && "\x{C4}" eq Lingua::AR::MacArabic::decode(pack 'U', 0x80)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x30" eq Lingua::AR::MacArabic::encode("\x{0660}") # ARABIC-INDIC DIGIT ZERO
   && "\x30" eq Lingua::AR::MacArabic::encode("\x{202D}\x{0660}") # with LRO
   && "\xB0" eq Lingua::AR::MacArabic::encode("\x{202E}\x{0660}") # with RLO
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x39" eq Lingua::AR::MacArabic::encode("\x{0669}") # ARABIC-INDIC DIGIT NINE
   && "\x39" eq Lingua::AR::MacArabic::encode("\x{202D}\x{0669}") # with LRO
   && "\xB9" eq Lingua::AR::MacArabic::encode("\x{202E}\x{0669}") # with RLO
   ? "ok" : "not ok", " ", ++$loaded, "\n";

$hexNCR = sub { sprintf("&#x%x;", shift) };
$decNCR = sub { sprintf("&#%d;" , shift) };

print "a\xC7" eq Lingua::AR::MacArabic::encode
	(pack 'U*', 0x100ff, 0x61, 0x3042, 0x0627)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "a\xC7" eq Lingua::AR::MacArabic::encode
	(\"", pack 'U*', 0x100ff, 0x61, 0x3042, 0x0627)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "?a?\xC7" eq Lingua::AR::MacArabic::encode
	(\"?", pack 'U*', 0x100ff, 0x61, 0x3042, 0x0627)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "&#x100ff;a&#x3042;\xC7" eq Lingua::AR::MacArabic::encode
	($hexNCR, pack 'U*', 0x100ff, 0x61, 0x3042, 0x0627)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "&#65791;a&#12354;\xC7" eq Lingua::AR::MacArabic::encode
	($decNCR, pack 'U*', 0x100ff, 0x61, 0x3042, 0x0627)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

