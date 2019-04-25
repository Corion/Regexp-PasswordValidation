#!perl -w
use strict;
use Regexp::PasswordValidation 'password_validation_regexp';
use Test::More tests => 14;
use Data::Dumper;
$Data::Dumper::Useqq = 1;

use charnames ':full';

my ($str,$re);

$re = password_validation_regexp(
    min_length  => 3,
    max_length  => 4,
    'A-Za-z0-9' => 3,
);

$str = "abcde";
if(! ok $str !~ /$re/, 'String too long') {
    diag $re;
    diag $str;
    diag length $str;
};
$str = "ab";
if(! ok $str !~ /$re/, 'String too short') {
    diag $re;
    diag $str;
    diag length $str;
};
$str = "!abc";
if(! ok $str =~ /$re/, 'Unspecified character gets accepted') {
    diag $re;
    diag $str;
    diag length $str;
};

$str = "\N{THOUGHT BALLOON}abc";
if(! ok $str =~ /$re/, 'Unspecified Unicode character gets accepted') {
    diag $re;
    diag $str;
    diag length $str;
};

$re = password_validation_regexp(
    min_length => 3,
    max_length => 4,
    emoji => 1,
);

#binmode STDOUT, ':encoding(UTF-8)';
#binmode STDERR, ':encoding(UTF-8)';
$str = "\N{THINKING FACE}\N{THOUGHT BALLOON}!!";

if(! ok $str =~ /$re/, 'An emoji passes') {
    diag $re;
    diag $str;
    diag length $str;
};

$re = password_validation_regexp(
    min_length => 3,
    max_length => 4,
    'A-Ya-y'   => 3,
);
$str = 'zzzZ';

if(! ok $str !~ /$re/, 'Unknown options are character ranges') {
    diag $re;
    diag $str;
    diag length $str;
};

$str = 'Ayay';

if(! ok $str =~ /$re/, 'Unknown options are character ranges') {
    diag $re;
    diag $str;
    diag length $str;
};

$re = password_validation_regexp(
    'sphinx of black quartz, judge my vow.' => 8,
);
for my $word ("obsidian dagger", "blood ichor") {
    if(! ok $word =~ /$re/, "Unknown options are character ranges ($word)") {
        diag $re;
        diag $word;
        diag length $word;
    };
};


for my $set ('[',']','[[','foo-','-bar') {
    $re = password_validation_regexp(
        $set => 8,
    );
    local $_ = 'abcdef';
    my $lives = eval { /$re/;1 };
    is $lives, 1, "We survive creating a regexp for '$set'";
};

