package Test::Set::Hand;

use parent qw(Test::Class);

use Test::More;
use Test::Exception;

use CardGame::Model::Set::Hand;
use CardGame::Model::Card;

use true;

=head1 NAME

=cut

sub test_basic: Tests {
    my $self = shift;

    my $hand_object = CardGame::Model::Set::Hand->new();

    is( $hand_object->count, 0, 'Empty list of cards as expected' );

    # Add new card and expect not to die
    lives_ok {
        $hand_object->add_card( CardGame::Model::Card->new( rank => 2, suit => 'Hearts' ) );
    } 'Add cards does not fail';

    is ( $hand_object->count, 1, "Card added to the hand");

    # Add new card and expect not to die
    lives_ok {
        $hand_object->remove_card();
    } 'Remove card does not fail';
}