package CardGame::Model::Rank;

use Moose;
use namespace::autoclean;

use Carp;
use true;

use CardGame::Types::Card qw( CardOrder CardValue );

=head1 NAME

CardGame::Model::Card

=head1 DESCRIPTION

CardGame::Model::Card - Object data structure representing
a card in a deck

=head1 ATTRIBUTES

=cut

has value => (
    is => 'ro',
    isa => CardValue
);

has order => (
    is      => 'ro',
    isa     => CardOrder,
    lazy    => 1,
    builder => '_build_order',
);

sub _build_order {
    my $self = shift;

    return {
        Ace   => 1,
        2     => 2,
        4     => 4,
        5     => 5,
        6     => 6,
        7     => 7,
        8     => 8,
        9     => 9,
        10    => 10,
        Jack  => 11,
        Queen => 12,
        King  => 13,
    }->{$self->value} || croak "No order found for value: " . $self->value;
}
