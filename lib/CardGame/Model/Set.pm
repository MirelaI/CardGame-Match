package CardGame::Model::Set;

use Moose;
use namespace::autoclean;

use List::Util qw(shuffle);

use CardGame::Types::Card qw( 
    ArrayRefOfCards
);

use true;

=head1 NAME

CardGame::Model::Set

=head1 SYNOPSIS

=head1 DESCRIPTION

Class that represents a set of cards. Use this 
class to manipulate list of cards. Add and remove cards
from a list of cards. You can also drop all the cards in 
the list

=cut

has cards => (
    is        => 'rw',
    isa       => ArrayRefOfCards,
    coerce    => 1,
    predicate => 'has_cards',
    clearer   => 'clear_cards',
    lazy      => 1,
    builder   => '_build_card_list',
);

sub _build_card_list {
    die 'Abstract method. Please use subclases instead of this class!'
}

=head1 METHODS

=head2 add_card

The pile of cards works on Queue method. We add cards in the beggining of the pile

=cut

sub add_card {
    my $self = shift;
    my $card = shift;

    $self->cards
        ? push @{$self->cards}, $card
        : $self->cards([ $card ])
}

=head2 remove_card

The pile of cards works on Queue method. We remove cards from the top of the pile

=cut

sub remove_card {
    my $self = shift;

    shift @{$self->cards} 
        if $self->has_cards;
}


=head2 shuffle_cards

Suffle the array of cards

=cut 

sub shuffle_cards {
    my $self = shift;

    my @cards = shuffle @{$self->cards};

    $self->cards(\@cards);
}


=head2 empty_set

=cut 

sub empty_set {
    shift->clear_cards;
}

=head2 count 

=cut

sub count {
    return scalar @{$_[0]->cards};
}

__PACKAGE__->meta->make_immutable();
