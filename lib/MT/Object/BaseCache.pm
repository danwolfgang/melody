# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Object::BaseCache;

use strict;
use base qw( Data::ObjectDriver::Driver::BaseCache );

sub is_cacheable {
    my ( $driver, $obj ) = @_;
    return if !defined $obj;

    # default is cacheable
    defined $obj->properties->{cacheable} ? $obj->properties->{cacheable} : 1;
}

1;

__END__

=head1 NAME

MT::Object::BaseCache

=head1 METHODS

TODO

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
