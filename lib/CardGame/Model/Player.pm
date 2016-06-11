package CardGame::Model::Player;

use Moose;
use namespace::autoclean;

use CardGame::Model::Set::Hand;
use CardGame::Types::Card qw( 
    Hand
);

use true;

=head1 NAME

CardGame::Model::Player

=cut

has id => (
    is  => 'ro',
    isa => 'Int',
);

has name => (
    is      => 'rw',
    isa     => 'Str',
    default => sub { ( qw(Batman Superman IronMan Thor CatWoman Hulk SpiderMan) )[ int (rand 7) ] }
);

has hand_of_cards => (
    is  => 'rw',
    isa => Hand,
    default => sub { CardGame::Model::Set::Hand->new() },
);

__PACKAGE__->meta->make_immutable;
