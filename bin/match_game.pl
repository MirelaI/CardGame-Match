use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;

use CardGame::Match;

=head1 NAME

match_game - Cards game 'Match' played between 2 or more players
    with multiple deck

=head1 SYNOPSIS

    perl match_game.pl [-d|-p|-c]

=head1 OPTIONS

=over

=item decks|d

Number of decks in the game. By default is set to 1

=item players|p

Number of players to play this game. By default is set to 2

=item condition|c

Condition on which cards should match. Should be value, color or both

=back

=cut

GetOptions (
    "players|p=i"   => \(my $num_players),
    "decks|d=i"     => \(my $num_decks),
    "condition|c=s" => \(my $condition),
    "help|h"        => \(my $help),
) or die("Error in command line arguments\n");

pod2usage(1) if $help;

# Setup game
my $game = CardGame::Match->new(
    (number_of_players  => $num_players)x!! $num_players,
    (number_of_decks    => $num_decks)x!! $num_decks,
    (matching_condition => $condition)x!! $condition,
);

printf(
    "About to start new game with %s number of players and %i decks. Cards will match on %s!\n", 
    $game->number_of_players,
    $game->number_of_decks,
    $game->matching_condition
);

$game->play;

if ( $game->finished ) {
    printf(
        "Winner is %s with total cards in hand %s\n", 
        $game->winner->name,
        $game->winner->hand_of_cards->count,
    )
}