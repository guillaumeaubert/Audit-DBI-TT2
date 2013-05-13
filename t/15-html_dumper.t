#!perl -T

use strict;
use warnings;

use Audit::DBI::TT2;
use Test::FailWarnings -allow_deps => 1;
use Test::More tests => 2;


can_ok(
	'Audit::DBI::TT2',
	'html_dumper',
);

my $tests =
[
	{
		name     => 'Dump hashref.',
		input    =>
		{
			'test1' => 'value1',
			'test2' => 'value2',
		},
		expected => '{<br/>&nbsp;&nbsp;test1&nbsp;=&gt;&nbsp;&#39;value1&#39;,<br/>'
			. '&nbsp;&nbsp;test2&nbsp;=&gt;&nbsp;&#39;value2&#39;<br/>}<br/>',
	},
];

foreach my $test ( @$tests )
{
	is(
		Audit::DBI::TT2::html_dumper( $test->{'input'} ),
		$test->{'expected'},
		$test->{'name'},
	);
}

