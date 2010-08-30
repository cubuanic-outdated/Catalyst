package Catalyst::Action;

=head1 NAME

Catalyst::Action - Catalyst Action

=head1 SYNOPSIS

    <form action="[%c.uri_for(c.action)%]">

    $c->forward( $action->private_path );

=head1 DESCRIPTION

This class represents a Catalyst Action. You can access the object for the
currently dispatched action via $c->action. See the L<Catalyst::Dispatcher>
for more information on how actions are dispatched. Actions are defined in
L<Catalyst::Controller> subclasses.

=cut

use Moose;
use Scalar::Util 'looks_like_number';
with 'MooseX::Emulate::Class::Accessor::Fast';
use namespace::clean -except => 'meta';

has class => (is => 'rw');
has component => (is => 'ro'); #, required => 1);

# 18:08 @t0m:» edenc: Why not change action construction in other places also
#              so that the controller instance is always passed in
# 18:09 @t0m:» And you can make the new attribute ro, right?
# 18:13 @t0m:» edenc: yy, the 'forward to component' case, where an action is
#              pulled out of the dispatcher's ass, on request.. Sets the
#              component instance
# 18:14 @t0m:» But 'normal' actions, constructed in a controller, don't.
# 18:14 @edenc:» oh, right
# 18:15 @edenc:» yeah well, I wanted to stick to minimal disruption of the
#                current code
# 18:17 @t0m:» I get you, but I'm thinking we should try to keep actions
#              having the same state in all cases.. The fall back to the
#              component name you added entirely needs to stay for compat, but
#              I think it'd be nice if all 'normal' cases have the same state.
#              The (small) extra disruption is worth the simplification in
#              terms of the attribute always being filled .
# 18:17 @t0m:» Does that make sense?
# 18:17 @edenc:» yes
# 18:18 @t0m:» cool. I'd like to say 'make it required', but that'll entirely
#              break someone, somewhere :)
# 18:20 @t0m:» right, lets assume we would if we could, and make the tests
#              pass with it required, but not actually turn required on?
# 18:22 @edenc:» t0m++

has namespace => (is => 'rw');
has 'reverse' => (is => 'rw');
has attributes => (is => 'rw');
has name => (is => 'rw');
has code => (is => 'rw');
has private_path => (
  reader => 'private_path',
  isa => 'Str',
  lazy => 1,
  required => 1,
  default => sub { '/'.shift->reverse },
);

use overload (

    # Stringify to reverse for debug output etc.
    q{""} => sub { shift->{reverse} },

    # Codulate to execute to invoke the encapsulated action coderef
    '&{}' => sub { my $self = shift; sub { $self->execute(@_); }; },

    # Make general $stuff still work
    fallback => 1,

);



no warnings 'recursion';

sub dispatch {    # Execute ourselves against a context
    my ( $self, $c ) = @_;
    return $c->execute( ($self->component || $self->class), $self );
}

sub execute {
  my $self = shift;
  $self->code->(@_);
}

sub match {
    my ( $self, $c ) = @_;
    #would it be unreasonable to store the number of arguments
    #the action has as its own attribute?
    #it would basically eliminate the code below.  ehhh. small fish
    return 1 unless exists $self->attributes->{Args};
    my $args = $self->attributes->{Args}[0];
    return 1 unless defined($args) && length($args);
    return scalar( @{ $c->req->args } ) == $args;
}

sub compare {
    my ($a1, $a2) = @_;

    my ($a1_args) = @{ $a1->attributes->{Args} || [] };
    my ($a2_args) = @{ $a2->attributes->{Args} || [] };

    $_ = looks_like_number($_) ? $_ : ~0
        for $a1_args, $a2_args;

    return $a1_args <=> $a2_args;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 METHODS

=head2 attributes

The sub attributes that are set for this action, like Local, Path, Private
and so on. This determines how the action is dispatched to.

=head2 class

Returns the name of the component where this action is defined.
Derived by calling the L<Catalyst::Component/catalyst_component_name|catalyst_component_name>
method on each component.

=head2 code

Returns a code reference to this action.

=head2 dispatch( $c )

Dispatch this action against a context.

=head2 execute( $controller, $c, @args )

Execute this action's coderef against a given controller with a given
context and arguments

=head2 match( $c )

Check Args attribute, and makes sure number of args matches the setting.
Always returns true if Args is omitted.

=head2 compare

Compares 2 actions based on the value of the C<Args> attribute, with no C<Args>
having the highest precedence.

=head2 namespace

Returns the private namespace this action lives in.

=head2 reverse

Returns the private path for this action.

=head2 private_path

Returns absolute private path for this action. Unlike C<reverse>, the
C<private_path> of an action is always suitable for passing to C<forward>.

=head2 name

Returns the sub name of this action.

=head2 meta

Provided by Moose.

=head1 AUTHORS

Catalyst Contributors, see Catalyst.pm

=head1 COPYRIGHT

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
