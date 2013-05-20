package Log::Message::Structured::Stringify::AsSereal;
use Moose::Role;
use namespace::autoclean;

use Sereal::Encoder;
use MIME::Base64;

requires 'as_hash';

has '_sereal_encoder' => (
  is => 'ro',
  lazy => 1,
  default => sub { Sereal::Encoder->new( {} ) },
);

=method as_string

Returns the event as a Base64 encoded string representing the Sereal encoded
hash structure of the log message.

=cut

around 'as_string' => sub {
    my $orig = shift;
    my $self = shift;    
    return encode_base64($self->_sereal_encoder->encode($self->as_hash));    
};


1;

__END__

=pod

=head1 NAME

Log::Message::Structured::Stringify::AsSereal - Sereal-encoded base64'ed log lines

=head1 SYNOPSIS

    package MyLogEvent;
    use Moose;
    use namespace::autoclean;

    with qw/
        Log::Message::Structured
        Log::Message::Structured::Stringify::AsSereal
    /;

    has foo => ( is => 'ro', required => 1 );

    ... elsewhere ...

    use aliased 'My::Log::Event';

    $logger->log(message => Event->new( foo => "bar" ));
    # Logs:
    "some_base_64_string"

=head1 DESCRIPTION

Augments the C<as_string> method provided by L<Log::Message::Structured>, by delegating to
the C<encode> from L<Sereal::Encoder> module, then encoding it using MIME::Base64. Thus, the return value is a base64 string of the Sereal encoded version of the hash structure of the log message.

See L<Log::Message::Structured> for more information.

=cut
