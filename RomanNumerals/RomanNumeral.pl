use warnings;
use strict;
use 5.010;

my %Values = (
    'M' => 1000,
    'D' => 500,
    'C' => 100,
    'L' => 50,
    'X' => 10,
    'V' => 5,
    'I' => 1
);

# Because Perl hashes aren't ordered properly
my @Integers = (1000, 500, 100, 50, 10, 5, 1);
my @Numerals = ('M', 'D', 'C', 'L', 'X', 'V', 'I');

sub GetPossibleSubtractions {
    my @newValues;
    for(my $i = 0; $i < scalar(@Integers); $i++) {
        if(substr($Integers[$i], 0, 1) == '1'
            && $_[0] > $Integers[$i]
            && $_[0] >= $Integers[$i] / 10) {
            push @newValues, $Integers[$i];
        }
    }
    
    return @newValues;
}

sub ToRomanNumeral {
    my $numberToConvert = $_[0];
    my $romanString = '';
    my %reverseValues = reverse %Values;

    while($numberToConvert > 0) {
        for(my $i = 0; $i < scalar(@Integers); $i++) {
            if($numberToConvert >= $Integers[$i]) {
                if($i > 0 && $numberToConvert != $Integers[$i]) {
                    my $biggerNumber = $Integers[$i - 1];
                    my @subtractionArray = &GetPossibleSubtractions($biggerNumber);
                    my $oldNumber = $numberToConvert;

                    for(my $j = 0; $j < scalar(@subtractionArray); $j++) {
                        my $newSum = $biggerNumber - $subtractionArray[$j];

                        if ($newSum <= $numberToConvert) {
                            $numberToConvert -= $newSum;
                            $romanString = $romanString . $reverseValues{$subtractionArray[$j]} . $Numerals[$i - 1];
                            last;
                        }
                    }

                    if($oldNumber != $numberToConvert) {
                        last;
                    }
                }

                $romanString = $romanString . $Numerals[$i];
                $numberToConvert -= $Integers[$i];
                last;
            }
        }
    }
    
    return $romanString;
}

sub ToInteger {
    my @romanArray = split('', $_[0]);
    my $sumNum = 0;

    while(scalar @romanArray > 0) {
        my $num1 = $Values{shift @romanArray};
        if(scalar(@romanArray) > 0 && $num1 < $Values{$romanArray[0]}) {
            my $num2 = $Values{shift @romanArray};
            $sumNum += ($num2 - $num1);
        } else {
            $sumNum += $num1;
        }
    }

    return $sumNum;
}

say &ToInteger("I");
say &ToInteger("IV");
say &ToInteger("IX");
say &ToInteger("MCMVII");
say &ToInteger("MCMXCIX");
say &ToInteger("MMXVII");
say &ToInteger("MMMCMXCIX");

say &ToRomanNumeral(1);
say &ToRomanNumeral(4);
say &ToRomanNumeral(9);
say &ToRomanNumeral(1907);
say &ToRomanNumeral(1999);
say &ToRomanNumeral(2017);
say &ToRomanNumeral(3999);