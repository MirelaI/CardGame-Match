package CardGame::Model::Set::Hand;

use Moose;
extends 'CardGame::Model::Set';

use namespace::autoclean;
use true;

=head1 NAME

CardGame::Model::Set::Hand

=head1 SYNOPSIS
    # Instantiate a deck of cards
    my $deck = CardGame::Model::Set::Hand->new();

    # Empty list of cards
    $deck->cards;

=head1 DESCRIPTION

Represents a card hand of a player. The builder can be extended 
so the cards in the pile will be split between players. 
But for this game, this should just be enough

=cut


sub _build_card_list {
    return [];
}

__PACKAGE__->meta->make_immutable;
