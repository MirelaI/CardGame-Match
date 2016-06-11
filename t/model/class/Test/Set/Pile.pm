package Test::Set::Pile;

use parent qw(Test::Class);

use Test::More;

use CardGame::Model::Set::Pile;

use true;

=head1 NAME

=cut

sub test_basic: Tests {
    my $self = shift;

    my $pile_object = CardGame::Model::Set::Pile->new( number_of_decks => 2 );

    my @cards = @{$pile_object->cards};

    is( @cards, 52 * 2, "Number of cards as expected");

    $pile_object->shuffle_cards;

    my $is_eq = eq_set(\@cards, $pile_object->cards);

    is( $is_eq, 0, 'Cards were shuffled');
}