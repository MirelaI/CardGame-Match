package CardGame::Model::Card;

use Moose;

use namespace::autoclean;

use Carp;
use true;

use CardGame::Types::Card qw( 
    CardColor 
    CardRank 
    CardSuit 
);

=head1 NAME

CardGame::Model::Card

=head1 DESCRIPTION

CardGame::Model::Card: Object data structure representing
a card in a deck

=head1 ATTRIBUTES

=cut

has suit => (
	is  	 => 'ro',
	isa 	 => CardSuit,
	required => 1,
);

has rank => (
	is       => 'ro',
	isa      => CardRank,
	required => 1,
	coerce   => 1,
);

has color => (
	is => 'ro',
	isa => CardColor,
	lazy => 1,
	builder => '_build_card_color',
);

sub _build_card_color {
	my $self = shift;

	return {
        Diamonds => 'red',
        Hearts   => 'red',
        Spades   => 'black',
        Clubs    => 'black',
	}->{$self->suit} || croak 'Unknown color for suit: ' . $self->suit;

}

__PACKAGE__->meta->make_immutable;
