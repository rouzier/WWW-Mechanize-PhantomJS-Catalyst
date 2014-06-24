#! /usr/bin/perl
use warnings;
use strict;

package TestApp::Controller::Root;
use base 'Catalyst::Controller';
$INC{'TestApp/Controller/Root.pm'} = 1;

__PACKAGE__->config->{namespace} = '';

sub test :Path('test.html')
{
	my ( $self, $c) = @_;
	$c->response->body(<<'HTML');
<html><body>
<div id="foo">no</div>
<script type="text/javascript">
var foo = document.getElementById('foo');
foo.innerHTML = "yes";
</script>
</body></html>
HTML
}

package TestApp;
use Catalyst qw/Server/;
TestApp->setup;

package Test;
use strict;
use warnings;
use Test::More tests => 3;
use Test::WWW::Mechanize::PhantomJS::Catalyst 'TestApp';

my $mech = Test::WWW::Mechanize::PhantomJS::Catalyst->new(
	debug => 0,
);
ok( $mech, 'Created mechanize object' );
$mech->get_ok("/test.html", "HTML page served ok");
$mech->content_contains('<div id="foo">yes</div>', 'JavaScript works');
