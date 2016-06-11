package CardGame::Model::Set::Deck;

use Moose;
extends 'CardGame::Model::Set';

use namespace::autoclean;
use true;

use CardGame::Types::Card qw( 
    ArrayRefOfCards 
    ArrayRefOfCardSuits 
    ArrayRefOfCardValues 
);

=head1 NAME

CardGame::Model::Set::Deck

=head1 SYNOPSIS
    # Instantiate a deck of cards
    my $deck = CardGame::Model::Set::Deck->new();

    # Access the cards associated with the current deck
    $deck->cards;

=head1 DESCRIPTION

Deck of a cards. This can differ from game to game, but for 'Match' 
game should be enough

=cut

has values => (
    is      => 'ro',
    isa     => ArrayRefOfCardValues,
    default => sub { [ 2..10, qw( Ace Jack Queen King ) ] }
);

has suits => (
    is      => 'ro',
    isa     => ArrayRefOfCardSuits,
    default => sub { [ qw(Clubs Diamonds Hearts Spades) ] }
);


sub _build_card_list {
    my $self = shift;

    my @deck = map {
        my $value = $_;
        map +{
            rank  => $value,
            suit  => $_,
        }, @{$self->suits}
    } @{$self->values};

    return \@deck;
}

__PACKAGE__->meta->make_immutable;
