#!perl -T

use strict;
use warnings;

# Override the timezone to be able to format the event's date and have a
# consistent, testable output.
BEGIN
{
	$ENV{'TZ'} = 'America/New_York';
}

use Audit::DBI::TT2;
use Scalar::Util;
use Test::Exception;
use Test::FailWarnings -allow_deps => 1;
use Test::More tests => 7;


# Verify that the function can be called.
can_ok(
	'Audit::DBI::TT2',
	'format_results',
);

# Prepare a set of results to format.
use_ok( 'Audit::DBI::Event' );
my $results =
[
	# TODO: test with defined diff.
	Audit::DBI::Event->new(
		data =>
		{
			'information' => 'BAgIMTIzNDU2NzgECAgIAwIAAAAIgg0AAAB0ZXN0X2V2ZW50X2lkCgdBQkMxMjM0DQAAAHJhbmRvbV9zdHJpbmc=',
			'event_time'  => 1347063261,
			'diff'        => undef,
		},
	),
];

# Instantiate a template plugin object.
my $tt2 = Audit::DBI::TT2->new();

# Format the results.
my $output;
lives_ok(
	sub
	{
		$output = $tt2->format_results( $results );
	},
	'Format the results.',
);
is(
	Scalar::Util::refaddr( $output ),
	Scalar::Util::refaddr( $results ),
	'The formatted information was added to the original arrayref.',
);

# Verify the first event.
my $event = $results->[0];
is(
	$event->{'diff_formatted'},
	undef,
	'The diff is formatted correctly.',
);
is(
	$event->{'information_formatted'},
	'{<br/>&nbsp;&nbsp;random_string&nbsp;=&gt;&nbsp;&#39;ABC1234&#39;,'
		. '<br/>&nbsp;&nbsp;test_event_id&nbsp;=&gt;&nbsp;2<br/>}<br/>',
	'The information is formatted correctly.',
);
is(
	$event->{'event_time_formatted'},
	'2012-09-07 20:14:21',
	'The event time is formatted correctly.',
);
