use strict;
use warnings;

use File::Temp qw( tempdir );
use Git::Helpers qw( checkout_root );
use Test::Fatal;
use Test::Git 1.313;
use Test::Requires::Git;
use Test::More;

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
}

{
    my $dir = tempdir( CLEANUP => 1 );
    like(
        exception { checkout_root($dir) }, qr/Error in/,
        'dies on missing git repository'
    );
}

done_testing();
