use strict;
use warnings;

package Git::Helpers;

use Carp qw( croak );
use File::pushd qw( pushd );
use Git::Sub;
use Sub::Exporter -setup => { exports => [ 'checkout_root', 'remote_url', ] };
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

sub remote_url {
    my $remote = shift || 'origin';
    return git::remote( 'get-url', $remote );
}

1;

#ABSTRACT: Shortcuts for common Git commands

=pod

=head1 SYNOPSIS

    use Git::Helpers qw( checkout_root remote_url);
    my $root = checkout_root();

    my $remote_url = remote_url('upstream');

=head2 checkout_root( $dir )

Gives you the root level of the git checkout which you are currently in.
Optionally accepts a directory parameter.  If you provide the directory
parameter, C<checkout_root> will temporarily C<chdir> to this directory and
find the top level of the repository.

This method will throw an exception if it cannot find a git repository at the
directory provided.

=head2 remote_url( $remote_name )

Returns a URL for the upstream you've requested by name.  Defaults to 'origin'.

    # defaults to 'origin'
    my $remote_url = remote_url();

    # get URL for upstream remote
    my $remote_url = remote_url('upstream');

=cut
