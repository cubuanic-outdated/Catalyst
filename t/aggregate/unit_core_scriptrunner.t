use strict;
use warnings;
use Test::More;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";

use_ok('Catalyst::ScriptRunner');

is Catalyst::ScriptRunner->run('ScriptTestApp', 'Foo'), 'mooScriptTestApp::Script::Foo42',
    'Script existing only in app got trait applied';
is Catalyst::ScriptRunner->run('ScriptTestApp', 'Bar'), 'mooScriptTestApp::Script::Bar23',
    'Script existing in both app and Catalyst - prefers app';
is Catalyst::ScriptRunner->run('ScriptTestApp', 'Baz'), 'mooCatalyst::Script::Baz',
    'Script existing only in Catalyst';
# +1 test for the params passed to new_with_options in t/lib/Catalyst/Script/Baz.pm
{
    my $warnings = '';
    local $SIG{__WARN__} = sub { $warnings .= shift };
    is Catalyst::ScriptRunner->run('ScriptTestApp', 'CompileTest'), 'mooCatalyst::Script::CompileTest';
    like $warnings, qr/Does not compile/;
    like $warnings, qr/Could not load ScriptTestApp::Script::CompileTest - falling back to Catalyst::Script::CompileTest/;
}

done_testing;
