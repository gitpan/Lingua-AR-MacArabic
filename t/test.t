
BEGIN { $| = 1; print "1..28\n"; }
END {print "not ok 1\n" unless $loaded;}

use Lingua::AR::MacArabic;
$loaded = 1;
print "ok 1\n";

####

print 1
   && "" eq encodeMacArabic("")
   && "" eq decodeMacArabic("")
   && "Perl" eq encodeMacArabic("Perl")
   && "Perl" eq decodeMacArabic("Perl")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

$ampLR = "\x{202D}\x2B\x{202C}";
$ampRL = "\x{202E}\x2B\x{202C}";

print $ampLR eq decodeMacArabic("\x2B")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print $ampRL eq decodeMacArabic("\xAB")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x2B" eq encodeMacArabic($ampLR)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\xAB" eq encodeMacArabic($ampRL)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x{C4}" eq decodeMacArabic("\x80")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x80" eq encodeMacArabic("\x{C4}")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x{6D2}" eq decodeMacArabic("\xFF")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\xFF" eq encodeMacArabic("\x{6D2}")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

$longEnc = "\x24\x20\x28\x29";
$longUni = "\x{202D}\x{0024}\x{0020}\x{0028}\x{0029}\x{202C}";

print $longUni eq decodeMacArabic($longEnc)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print $longEnc eq encodeMacArabic($longUni)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print 1
   && "\0" eq encodeMacArabic("\0")
   && "\0" eq decodeMacArabic("\0")
   && "\cA" eq encodeMacArabic("\cA")
   && "\cA" eq decodeMacArabic("\cA")
   && "\t" eq encodeMacArabic("\t")
   && "\t" eq decodeMacArabic("\t")
   && "\x7F" eq encodeMacArabic("\x7F")
   && "\x7F" eq decodeMacArabic("\x7F")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print 1
   && "\n" eq encodeMacArabic("\n")
   && "\n" eq decodeMacArabic("\n")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print 1
   && "\r" eq encodeMacArabic("\r")
   && "\r" eq decodeMacArabic("\r")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print 1
   && "0123456789" eq encodeMacArabic("0123456789")
   && "0123456789" eq decodeMacArabic("0123456789")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

#####

$macDigitRL = "\xB0\xB1\xB2\xB3\xB4\xB5\xB6\xB7\xB8\xB9"; # RL only
$uniDigit = "\x{660}\x{661}\x{662}\x{663}\x{664}\x{665}\x{666}\x{667}\x{668}\x{669}";
$uniDigitRL = "\x{202E}$uniDigit\x{202C}";

print "0123456789" eq encodeMacArabic($uniDigit)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print 1
   && $uniDigitRL eq decodeMacArabic($macDigitRL)
   && $macDigitRL eq encodeMacArabic($uniDigitRL)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

# round-trip convetion for single-character strings

$allchar = map chr, 0..255;
print $allchar eq encodeMacArabic(decodeMacArabic($allchar))
   ? "ok" : "not ok", " ", ++$loaded, "\n";

$NG = 0;
for ($char = 0; $char <= 255; $char++) {
    $bchar = chr $char;
    $uchar = encodeMacArabic(decodeMacArabic($bchar));
    $NG++ unless $bchar eq $uchar;
}
print $NG == 0
   ? "ok" : "not ok", " ", ++$loaded, "\n";

# to be downgraded on decoding.
print "\x{C4}" eq decodeMacArabic("\x{80}")
   && "\x{C4}" eq decodeMacArabic(pack 'U', 0x80)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x30" eq encodeMacArabic("\x{0660}") # ARABIC-INDIC DIGIT ZERO
   && "\x30" eq encodeMacArabic("\x{202D}\x{0660}") # with LRO
   && "\xB0" eq encodeMacArabic("\x{202E}\x{0660}") # with RLO
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x39" eq encodeMacArabic("\x{0669}") # ARABIC-INDIC DIGIT NINE
   && "\x39" eq encodeMacArabic("\x{202D}\x{0669}") # with LRO
   && "\xB9" eq encodeMacArabic("\x{202E}\x{0669}") # with RLO
   ? "ok" : "not ok", " ", ++$loaded, "\n";

$hexNCR = sub { sprintf("&#x%x;", shift) };
$decNCR = sub { sprintf("&#%d;" , shift) };

print "a\xC7" eq
	encodeMacArabic(pack 'U*', 0x100ff, 0x61, 0x3042, 0x0627)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "a\xC7" eq
	encodeMacArabic(\"", pack 'U*', 0x100ff, 0x61, 0x3042, 0x0627)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "?a?\xC7" eq
	encodeMacArabic(\"?", pack 'U*', 0x100ff, 0x61, 0x3042, 0x0627)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "&#x100ff;a&#x3042;\xC7" eq
	encodeMacArabic($hexNCR, pack 'U*', 0x100ff, 0x61, 0x3042, 0x0627)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "&#65791;a&#12354;\xC7" eq
	encodeMacArabic($decNCR, pack 'U*', 0x100ff, 0x61, 0x3042, 0x0627)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

