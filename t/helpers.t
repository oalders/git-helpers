use strict;
use warnings;

use Capture::Tiny qw( capture_stderr );
use File::Temp    qw( tempdir );
use File::Touch   qw( touch );
use Git::Helpers  qw(
    checkout_root
    current_branch_name
    https_remote_url
    ignored_files
    is_inside_work_tree
    remote_url
);
use Git::Version ();
use Git::Sub;
use Path::Tiny      qw( path );
use Test::Deep      qw( cmp_deeply );
use Test::Fatal     qw( exception );
use Test::Git 1.313 qw( test_repository );
use Test::More import => [qw( diag done_testing is like ok skip subtest )];
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

    my $v = Git::Version->new(`git --version`);

SKIP: {
        skip "$v is lower than 2.7", 2, unless $v ge 2.7;
        my $remote_url  = 'git@github.com:oalders/git-helpers.git';
        my $remote_name = 'foobarbaz';
        git::remote( 'add', $remote_name, $remote_url );
        is(
            remote_url($remote_name), $remote_url,
            'remote_url is ' . $remote_url
        );
        is(
            https_remote_url($remote_name),
            'https://github.com/oalders/git-helpers',
            'https_remote_url'
        );
        is(
            https_remote_url('foobar'),
            undef,
            'https_remote_url with remote which does not exist'
        );
    }

    # Do some bootstrapping so that we have a branch with an arbitrary name.
    git::config( 'user.email', 'fdrebin@policesquad.org' );
    git::config( 'user.name',  'Frank Drebin' );

    my $file = 'README';
    touch($file);
    git::add($file);
    git::commit( '-m', $file );

    my $stderr = capture_stderr {
        git::checkout( '-b', $file );
    };
    diag $stderr;

    is( current_branch_name(), $file, 'current branch is ' . $file );

    ok( is_inside_work_tree(), 'is_inside_work_tree' );

    subtest 'ignored_files' => sub {
        my $gitignore = path('.gitignore');
        $gitignore->touch;
        cmp_deeply( ignored_files(), [], 'no ignored files' );

        my $first = 'FOO.HTML';

        path('.gitignore')->append("$first\n");
        path($first)->touch;
        cmp_deeply( ignored_files(), [$first], 'one ignored file' );

        my $second = 'GOO.HTML';
        path('.gitignore')->append("$second\n");
        path($second)->touch;

        cmp_deeply(
            ignored_files(), [ $first, $second ],
            'two ignored files'
        );

        my $dir = 'empty-dir';
        path($dir)->mkpath;
        cmp_deeply(
            ignored_files($dir), [],
            'no ignored files in empty dir'
        );

        like(
            exception {
                cmp_deeply(
                    ignored_files('..'), [],
                    'no ignored files in empty dir'
                );
            },
            qr{Cannot find ignored files in dir},
            'dies on check outside repository'
        );

        chdir('..');
        ok( !is_inside_work_tree(), 'not is_inside_work_tree' );
    }
};

{
    my $dir = tempdir( CLEANUP => 1 );
    like(
        exception { checkout_root($dir) }, qr/Error in/,
        'dies on missing git repository'
    );
}

done_testing();
