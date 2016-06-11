package CardGame::Types::Card;

use MooseX::Types -declare => [
    qw(
        ArrayRefOfCards
        ArrayRefOfCardSuits
        ArrayRefOfCardValues
        ArrayRefOfPlayers
        CardColor
        CardOrder
        CardRank
        CardSuit
        CardValue
        Deck
        Hand
        Pile
        Player
    )
];

use Carp;
use Class::Load qw( load_class );

use Data::Dump qw(pp);
use MooseX::Types::Moose qw/Str ArrayRef Maybe/;

use true;

subtype CardSuit,
    as enum( [ qw(Clubs Diamonds Hearts Spades) ] ),
    message { "Invalid card suit" };

subtype CardValue,
    as enum( [ 2..10, qw( Ace Jack Queen King ) ] ),
    message { "Invalid card value" };

subtype CardOrder,
    as enum( [ 1..13 ] ),
    message { "Invalid card order" };

subtype CardOrder,
    as enum( [ qw( black red ) ] ),
    message { "Invalid card color" };

class_type CardRank, { class => 'CardGame::Model::Rank' };
coerce CardRank,
    from Str,
    via {
        load_class('CardGame::Model::Rank');
        CardGame::Model::Rank->new( value => $_ );
    };

class_type Deck, { class => 'CardGame::Model::Set::Deck' };
class_type Hand, { class => 'CardGame::Model::Set::Hand' };
class_type Pile, { class => 'CardGame::Model::Set::Pile' };
class_type Player, { class => 'CardGame::Model::Player' };

# with parameterized constraints.
 
subtype ArrayRefOfCardValues,
  as ArrayRef[CardValue];

subtype ArrayRefOfCardSuits,
    as ArrayRef[CardSuit];

subtype ArrayRefOfPlayers,
  as ArrayRef[Player];

subtype ArrayRefOfCards, as ArrayRef['CardGame::Model::Card'];

coerce ArrayRefOfCards,
    from ArrayRef,
    via {
        load_class('CardGame::Model::Card');
        [
            map {
                CardGame::Model::Card->new($_)
                or confess "Couldn't create new card with arguments" . pp($_)  
            } @{$_ }
        ]
    }; 