package CardGame::Types::Utils;

use MooseX::Types -declare => [
    qw(
        MatchingCond
        NumberOfGamePlayers
    )
];

use true;

use MooseX::Types::Moose qw(Int);

subtype MatchingCond,
    as enum([ qw( value color both ) ]),
    message{ "Please check if the matching condition is on of: " . join('/', qw( value color both ))};

subtype NumberOfGamePlayers,
    as Int,
    where { $_ > 1 },
    message { "This game cannot be played in <forever alone> mode" };
