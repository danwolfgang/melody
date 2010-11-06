# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::ArchiveType::Page;

use strict;
use base qw( MT::ArchiveType::Individual );

sub name {
    return 'Page';
}

sub archive_label {
    return MT->translate("PAGE_ADV");
}

# archive_title proved by MT::ArchiveType::Individual
sub dynamic_template {
    return 'page/<$MTEntryID$>';
}

sub entry_class {
    return 'page';
}

sub template_params {
    return {
             archive_class     => "page-archive",
             page_archive      => 1,
             archive_template  => 1,
             page_template     => 1,
             feedback_template => 1,
    };
}

sub archive_file {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog      = $ctx->{__stash}{blog};
    my $page      = $ctx->{__stash}{entry};

    my $file;
    Carp::croak("archive_file_for Page archive needs a page")
      unless $page && $page->isa('MT::Page');
    unless ($file_tmpl) {
        my $basename = $page->basename();
        my $folder   = $page->folder;
        my $folder_path;
        if ($folder) {
            $folder_path = $folder->publish_path || '';
            $file
              = $folder_path ne ''
              ? $folder_path . '/' . $basename
              : $basename;
        }
        else {
            $file = $basename;
        }
    }
    return $file;
} ## end sub archive_file

sub archive_group_iter {
    my $obj = shift;
    my ( $ctx, $args ) = @_;

    require MT::Page;
    my $blog_id = $ctx->stash('blog')->id;
    my $iter = MT::Page->load_iter( {
                                       blog_id => $blog_id,
                                       status  => MT::Entry::RELEASE()
                                    },
                                    {
                                       sort      => 'title',
                                       direction => 'ascend'
                                    }
    );
    return sub {
        while ( my $entry = $iter->() ) {
            return ( 1, entries => [$entry], entry => $entry );
        }
        undef;
      }
} ## end sub archive_group_iter

sub default_archive_templates {
    return [ {
                label    => MT->translate('folder-path/page-basename.html'),
                template => '%-c/%-f',
                default  => 1
             },
             {
                label =>
                  MT->translate('folder-path/page-basename/index.html'),
                template => '%-c/%-b/%i'
             },
             {
                label    => MT->translate('folder_path/page_basename.html'),
                template => '%c/%f'
             },
             {
                label =>
                  MT->translate('folder_path/page_basename/index.html'),
                template => '%c/%b/%i'
             },
    ];
} ## end sub default_archive_templates

1;

__END__

=head1 NAME

MT::ArchiveType::Page

=head1 METHODS

=head2 archive_file

=head2 archive_group_iter

=head2 archive_label

=head2 default_archive_templates

=head2 dynamic_template

=head2 entry_class

=head2 name

=head2 template_params


=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
