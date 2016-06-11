package CardGame::Match;

use Moose;

use namespace::autoclean;
use true;

use feature 'switch';

use CardGame::Types::Card qw( 
    ArrayRefOfPlayers
    Pile
);

use CardGame::Types::Utils qw(
    MatchingCond
    NumberOfGamePlayers
);

use CardGame::Model::Player;
use CardGame::Model::Set::Pile;


=head1 NAME

CardGame::Match - The great new CardGame::Match!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

    use CardGame::Match;

    my $game = CardGame::Match->new(
        number_of_players => 2
        number_of_decks   => 4,
    );

    $game->play;

=head1 ATTRIBUTES

=head2 number_of_players

Integer representing the number of players that we want
to play the current game

=cut

has number_of_players => (
    is      => 'ro',
    isa     => NumberOfGamePlayers,
    default => 2,
);

=head2 number_of_decks

Integer representing number of decks necessary for the current game

=cut

has number_of_decks => (
    is      => 'ro',
    isa     => 'Int',
    default => 1,
);

=head2 matching_condition

String that represents the condition on which the cards 
should match: value, suit or both

=cut

has matching_condition => (
    is      => 'ro',
    isa     => MatchingCond,
    default => 'value'
);

=head2 game_finished

Mark the game as finished

=cut

has finished => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0
);

=head2 players

Private attribute that is build based on the
number of players. Each element of the list
represents a Player object

=cut

has players => (
    is       => 'rw',
    isa      => ArrayRefOfPlayers,
    init_arg => undef,
    lazy     => 1,
    builder  => '_build_players'
);

=head2 pile

Current pile of the game

=cut

has pile => (
    is       => 'ro',
    isa      => Pile,
    init_arg => undef,
    lazy     => 1,
    builder  => '_build_pile',
);

sub _build_players {
    my $self = shift;

    my @players = ();

    for my $id ( 1..$self->number_of_players ) {
        push @players, CardGame::Model::Player->new( id => $id );
    }

    return \@players;
}

sub _build_pile {
    my $self = shift;

    return CardGame::Model::Set::Pile->new( number_of_decks => $self->number_of_decks );
}

=head1 METHODS

=head2 play

Algorithm for the match game. 
#TODO: improve the algorithm. How it works: take the top card from the pile 
and compare it to the previous one and so on...

=cut

sub play {
    my $self = shift;

    my $players = $self->players;

    # Shuffle the cards
    $self->pile->shuffle_cards;

    my @hand;
    my $previous_card;

    while ( $self->pile->count ) {
        foreach my $player ( @$players ) {

            my $player_card = $self->pile->remove_card;

            last unless $player_card;

            push @hand, $player_card;

            unless ( $previous_card ) {
                $previous_card = $player_card;
                next;
            }

            my $cards_match = 0;
            given ( $self->matching_condition ) {
                when ('value') { $cards_match = !!( $previous_card->rank->value eq $player_card->rank->value ) }
                when ('color') { $cards_match = !!( $previous_card->color eq $player_card->color ) }
                when ('both')  {
                    $cards_match = !!(
                        ( $previous_card->rank->value eq $player_card->rank->value )
                        && 
                        ( $previous_card->color eq $player_card->color )
                    );
                }  
            }

            if ( $cards_match ) {
                $self->assign_cards_to_random_player($players, \@hand);
                # Empty the hand
                @hand = ();
                undef $previous_card;
            } else {
                $previous_card = $player_card;
            }
        }

        # What we do if the pile has no cards but there are
        # still cards in the current hand. Put them 
        # back into the pile and shuffle them
        if ( !$self->pile->count && @hand ) {
            # Check if there are matches in the hand left:
            my $cards_matches_still_exist = $self->check_matches(\@hand);

            if ( $cards_matches_still_exist ) {
                $self->pile->cards(\@hand); 

                $self->pile->shuffle_cards;

                @hand = ();
                undef $previous_card;
            # I am not sure what is the ending condition if there
            # are still a hand of cards that have no match
            # so I am just gonna assign the last ones 
            # to a random user...cuz it is just a game :)
            } else {
                $self->assign_cards_to_random_player($players,\@hand);
            }         
        }
    }

    $self->finished(1);
}

sub winner {
    my $self = shift;

    return 
        unless $self->finished;

    my @players_scoring = sort { $a->hand_of_cards->count <=> $b->hand_of_cards->count } @{$self->players};

    return pop @players_scoring;
}

sub check_matches {
    my ( $self, $cards ) = @_;

    my %seen;

    map { 
        my $match_value = ( $self->matching_condition eq 'both' )
            ? $_->rank->value . $_->color
            : ( $self->matching_condition eq 'value' )
                ? $_->rank->value
                : $_->color;
        $seen{$match_value}++ 
    } @$cards;

    return !!(grep { $_ > 1 } values %seen );
}

sub assign_cards_to_random_player {
    my ( $self, $players ,$cards ) = @_;

    # Select player to which it goes this hand
    my $index = rand scalar(@{$self->players});
    my $lucky_player = $players->[$index];

    push @{$lucky_player->hand_of_cards->cards}, @$cards;
}

=head1 AUTHOR

Mirela Iclodean, C<< <imirela at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-cardgame-match at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=CardGame-Match>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc CardGame::Match


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=CardGame-Match>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/CardGame-Match>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/CardGame-Match>

=item * Search CPAN

L<http://search.cpan.org/dist/CardGame-Match/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2016 Mirela Iclodean.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut:
