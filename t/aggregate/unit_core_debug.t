use Test::More 'no_plan';
use strict;
use warnings;

use_ok('Catalyst');

no warnings 'redefine';
local *Catalyst::Log::debug = sub { };
local *Catalyst::Log::info = sub { };

{
    package DefaultTestApp;

    use Catalyst;

    __PACKAGE__->setup;
}

ok( !DefaultTestApp->debug, 'debug mode is off by default' );

{
    package DebugTestApp;

    use Catalyst '-Debug';

    __PACKAGE__->setup;
}

ok( DebugTestApp->debug, 'debug mode is on' );
ok( DebugTestApp->log->is_debug, 'log debug mode is on' );

{
    package ModernTestApp;

    use Catalyst;

    __PACKAGE__->config(
			log => 'debug'
	 );

    __PACKAGE__->setup;
}

ok( !ModernTestApp->debug, 'debug mode is off' );
ok( ModernTestApp->log->is_debug, '... but the logger does turn on the debug mode' );

{
    package AncientTestApp;

    use Catalyst '-Log=debug';

    __PACKAGE__->setup;
}

ok( AncientTestApp->debug, 'debug mode is on' );
ok( AncientTestApp->log->is_debug, '... and the logger does turn on the debug mode' );
