package Audit::DBI::TT2;

use strict;
use warnings;

use base 'Template::Plugin';

use Data::Dumper;
use HTML::Entities qw();
use POSIX qw();
use Template::Stash;


=head1 NAME

Audit::DBI::TT2 - A Template Toolkit plugin to display audit events recorded by L<Audit::DBI>.


=head1 VERSION

Version 2.1.0

=cut

our $VERSION = '2.1.0';


=head1 SYNOPSIS

In your Perl code:

	use Audit::DBI::TT2;
	use Template;
	
	my $template = Template->new(
		{
			PLUGINS =>
			{
				audit => 'Audit::DBI::TT2',
			},
		}
	) || die $Template::ERROR;

In your TT2 template:

	[% USE audit %]
	[% FOREACH result IN audit.format_results( results ) %]
		...
	[% END %]

Note: a fully operational example of a search interface for Audit::DBI events
using this module for the display of the results is available in the
C<examples/> directory of this distribution.


=head1 FUNCTIONS

=head2 format_results()

Format the following fields for display as HTML:

=over 4

=item * diff

(accessible as diff_formatted)

=item * information

(accessible as information_formatted)

=item * event_time

(accessible as event_time_formatted)

=back

	[% FOREACH result IN audit.format_results( results ) %]
		<div>
			Formatted information: [% result.information_formatted %]<br/>
			Formatted diff: [% result.diff_formatted %]<br/>
			Formatted event time: [% result.event_time_formatted %]
		</div>
	[% END %]

=cut

sub format_results
{
	my ( $self, $results ) = @_;
	
	foreach my $result ( @$results )
	{
		$result->{information_formatted} = html_dumper( $result->get_information() );
		$result->{diff_formatted} = html_dumper( $result->get_diff() );
		$result->{event_time_formatted} = POSIX::strftime(
			"%Y-%m-%d %H:%M:%S",
			POSIX::localtime( $result->{event_time} ),
		);
	}
	
	return $results;
}


=head2 html_dumper()

Format a data structure for display as HTML.

	my $formatted_data = Audit::DBI::TT2::html_dumper( $data );

=cut

sub html_dumper
{
	my ( $data ) = @_;
	return undef
		if !defined( $data );
	
	my $string;
	{
		# Skip "$VAR1 = ".
		local $Data::Dumper::Terse = 1;
		# Don't quote hash keys.
		local $Data::Dumper::Quotekeys = 0;
		# Sort hash keys.
		local $Data::Dumper::Sortkeys = 1;
		
		$string = Dumper( $data );
	}
	
	$string =~ s/\$VAR1 = //;
	$string = HTML::Entities::encode_entities( $string );
	$string =~ s/ /&nbsp;/g;
	$string =~ s/\n/<br\/>/g;
	
	return $string;
}


=head1 AUTHOR

Guillaume Aubert, C<< <aubertg at cpan.org> >>.


=head1 BUGS

Please report any bugs or feature requests through the web interface at
L<https://github.com/guillaumeaubert/Audit-DBI-TT2/issues/new>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Audit::DBI::TT2


You can also look for information at:

=over 4

=item * GitHub's request tracker

L<https://github.com/guillaumeaubert/Audit-DBI-TT2/issues>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Audit-DBI-TT2>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Audit-DBI-TT2>

=item * MetaCPAN

L<https://metacpan.org/release/Audit-DBI-TT2>

=back


=head1 ACKNOWLEDGEMENTS

Thanks to ThinkGeek (L<http://www.thinkgeek.com/>) and its corporate overlords
at Geeknet (L<http://www.geek.net/>), for footing the bill while I write code
for them!


=head1 COPYRIGHT & LICENSE

Copyright 2010-2013 Guillaume Aubert.

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License version 3 as published by the Free
Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see http://www.gnu.org/licenses/

=cut

1;
