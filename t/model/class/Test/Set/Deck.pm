package Test::Set::Deck;

use parent qw(Test::Class);

use Test::More;

use CardGame::Model::Set::Deck;

use true;

=head1 NAME

=cut

sub test_basic: Tests {
    my $self = shift;

    my $deck_object = CardGame::Model::Set::Deck->new();

    my @cards = @{$deck_object->cards};

    is( @cards, 52, "Number of cards as expected");

    $deck_object->shuffle_cards;

    my $is_eq = eq_set(\@cards, $deck_object->cards);

    is( $is_eq, 0, 'Cards were shuffled');
}