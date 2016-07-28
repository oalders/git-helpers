use strict;
use warnings;

use File::Temp qw( tempdir );
use Git::Helpers qw( checkout_root remote_url travis_url );
use Test::Fatal;
use Test::Git 1.313;
use Test::More;
use Test::Requires::Git 1.005;

test_requires_git();

my $r = test_repository();

{
    my $root = checkout_root( $r->work_tree );
    ok( $root, "got root $root" );
}

{
    chdir( $r->work_tree );
    my $root = checkout_root;
    ok( $root, "got root $root" );
    is( $root, $r->work_tree, 'root matches work_tree' );
    my $remote_url = 'git@github.com:oalders/git-helpers.git';
    git::remote( 'add', 'origin', $remote_url );
    is( remote_url(), $remote_url, 'remote_url is ' . $remote_url );
    is(
        travis_url(), 'https://travis-ci.org/oalders/git-helpers',
        'travis_url'
    );
}

{
    my $dir = tempdir( CLEANUP => 1 );
    like(
        exception { checkout_root($dir) }, qr/Error in/,
        'dies on missing git repository'
    );
}

done_testing();
