use ExtUtils::MakeMaker;

WriteMakefile(
	NAME => "Time::UTC_SLS",
	VERSION_FROM => "lib/Time/UTC_SLS.pm",
	PREREQ_PM => {
		"Math::BigRat" => "0.04",
		"Time::UTC" => "0.003",
	},
);
