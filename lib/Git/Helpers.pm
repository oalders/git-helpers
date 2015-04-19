use strict;
use warnings;

package Git::Helpers;

use Carp qw( croak );
use File::pushd qw( pushd );
use Git::Sub;
use Sub::Exporter -setup => { exports => ['checkout_root'] };
use Try::Tiny;

sub checkout_root {
    my $dir = shift;

    my $new_dir;
    $new_dir = pushd($dir) if $dir;

    my $root;
    try {
        $root = scalar git::rev_parse qw(--show-toplevel);
    }
    catch {
        $dir ||= '.';
        croak "Error in $dir $_";
    };
    return $root;
}

1;

#ABSTRACT: Shortcuts for common Git commands

=pod

=head1 SYNOPSIS

    use Git::Helpers qw( checkout_root );
    my $root = checkout_root();

=head2 checkout_root( $dir )

Gives you the root level of the git checkout which you are currently in.
Optionally accepts a directory parameter.  If you provide the directory
parameter, C<checkout_root> will temporarily C<chdir> to this directory and
find the top level of the repository.

This method will throw an exception if it cannot find a git repository at the
directory provided.

=cut
