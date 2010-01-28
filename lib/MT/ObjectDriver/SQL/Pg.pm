# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::ObjectDriver::SQL::Pg;

use strict;
use warnings;
use base qw( MT::ObjectDriver::SQL );

*distinct_stmt = \&MT::ObjectDriver::SQL::_subselect_distinct;

#--------------------------------------#
# Instance Methods

sub as_limit {
    my $stmt = shift;
    my $n = $stmt->limit;
    my $o = $stmt->offset || 0;
    $n = 'ALL' if !$n && $o;
    return '' unless $n;
    die "Non-numerics in limit/offset clause ($n, $o)" if ($o =~ /\D/) || (($n ne 'ALL') && ($n =~ /\D/));
    return sprintf "LIMIT %s%s\n", $n,
           ($o ? " OFFSET " . int($o) : "");
}

sub _mk_term {
    my $stmt = shift;
    my ($col, $val) = @_;

    if (ref $val eq 'HASH') {
        if (!exists $val->{op}) {
            if (exists $val->{like}) {
                my $cols = $stmt->binary;
                if (!$cols || !exists $cols->{$col}) {
                    $val = { op => 'ILIKE', value => $val->{like} };
                }
            }
        }
    }

    $stmt->SUPER::_mk_term($col, $val);
}

1;
__END__

=head1 NAME

MT::ObjectDriver::SQL::Pg

=head1 METHODS

=head2 as_limit

=head2 distinct_stmt

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
