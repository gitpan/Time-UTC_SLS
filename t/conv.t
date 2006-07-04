use Test::More tests => 1 + 2*18 + 9;

BEGIN { use_ok "Time::UTC_SLS", qw(utc_to_utcsls utcsls_to_utc); }

use Math::BigRat;

sub br { Math::BigRat->new(@_) }

sub check($$$) {
	my($day, $secs, $mjd) = map { br($_) } @_;
	is utc_to_utcsls($day, $secs), $mjd;
	is_deeply [ utcsls_to_utc($mjd) ], [ $day, $secs ];
}

check(5113,     0, "41317");
check(5113, 43200, "41317.5");
check(5114,     0, "41318");
check(5115,   864, "41319.01");
check(5115, 85536, "41319.99");
check(5115, 86399, (41319*86400+86399)."/86400");
check(5294,     0, "41498");
check(5294,   864, "41498.01");
check(5294, 85398, (41498*86400+85398)."/86400");
check(5294, 85399, (41498*86400+85399)."/86400");
check(5294, 85400, (41498*86400+85400)."/86400");
check(5294, 85401, (41498*86400+85401)."/86400");
check(5294, 85402, (41498*86400+85401)."999/86400000");
check(5294, 85403, (41498*86400+85402)."998/86400000");
check(5294, 85404, (41498*86400+85403)."997/86400000");
check(5294, 86399, (41498*86400+86398)."002/86400000");
check(5294, 86400, (41498*86400+86399)."001/86400000");
check(5295,     0, "41499");

eval { utc_to_utcsls(br(5112), br(86300)); };
like $@, qr/\Aday 5112 precedes the start of UTC-SLS /;
eval { utc_to_utcsls(br(5112), br(0)); };
like $@, qr/\Aday 5112 precedes the start of UTC-SLS /;
eval { utc_to_utcsls(br(5112), br(-1)); };
like $@, qr/\Aday 5112 precedes the start of UTC-SLS /;
eval { utc_to_utcsls(br(5112), br(86500)); };
like $@, qr/\Aday 5112 precedes the start of UTC-SLS /;

eval { utc_to_utcsls(br(5115), br(-1)); };
like $@, qr/\A\S+ seconds is out of range for a 86400 second day /;
eval { utc_to_utcsls(br(5115), br(86400)); };
like $@, qr/\A\S+ seconds is out of range for a 86400 second day /;
eval { utc_to_utcsls(br(5294), br(-1)); };
like $@, qr/\A\S+ seconds is out of range for a 86401 second day /;
eval { utc_to_utcsls(br(5294), br(86401)); };
like $@, qr/\A\S+ seconds is out of range for a 86401 second day /;

eval { utcsls_to_utc(br("41316.5")); };
like $@, qr/\Aday 5112 precedes the start of UTC-SLS /;
