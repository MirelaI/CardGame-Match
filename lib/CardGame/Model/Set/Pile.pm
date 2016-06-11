package CardGame::Model::Set::Pile;

use Moose;
extends 'CardGame::Model::Set';

use namespace::autoclean;
use true;

use CardGame::Types::Card qw( 
    ArrayRefOfCards
    Deck
);

use CardGame::Model::Set::Deck;

=head1 NAME

CardGame::Model::Set::Pile

=head1 DESCRIPTION

A pile is formed by multiple decks

=cut 

has deck => (
    is      => 'ro',
    isa     => Deck,
    default => sub { return CardGame::Model::Set::Deck->new() }
);

has number_of_decks => (
    is      => 'rw',
    isa     => 'Int',
    default => 1,
);

sub _build_card_list {
    my $self = shift;

    return [ ( @{$self->deck->cards} ) x $self->number_of_decks ];
}

__PACKAGE__->meta->make_immutable();