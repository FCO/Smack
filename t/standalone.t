#!perl6

use v6;

use Test;
use lib 't/lib';
use HTTP::Headers;
use Smack::Test;

my @tests =
    -> $c, $u {
        my $response = $c.get($u);
        ok($response.success, 'successfully made a request');

        is($response.status, 200, 'returned 200');
        my $headers = HTTP::Headers.new: $response.headers, :quiet;

        is $headers.elems, 1, 'only one header set';
        is $headers.Content-Type, 'text/plain', 'Content-Type: text/plain';

        is $response.content, 'Hello World', 'Content is Hello World';
    };

for <hello hello-supply hello-psgi> -> $name {
    my $app = $name ~ ".p6w";
    my $test-server = Smack::Test.new(:$app, :@tests,
        cmd => [ 't/server.pl6', '--port={port}', '--app=t/apps/{app}' ],
    );
    $test-server.run;
}

done-testing;
