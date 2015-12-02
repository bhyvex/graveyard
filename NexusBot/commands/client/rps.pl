# COMMAND NAME:
#	RPS
# DESCRIPTION:
#	Rock, Paper, Scissors!
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub rps {
	my ($self,$client,$msg,$listener) = @_;

	# If they are challenging us.
	if ($msg) {
		# Only three values accepted.
		my $value;

		$value = "rock" if $msg eq "rock";
		$value = "rock" if $msg eq "r";
		$value = "paper" if $msg eq "paper";
		$value = "paper" if $msg eq "p";
		$value = "scissors" if $msg eq "scissors";
		$value = "scissors" if $msg eq "s";

		if ($value) {
			# Our value.
			my $choice = int(rand(3)) + 1;
			$choice = "rock" if $choice == 1;
			$choice = "paper" if $choice == 2;
			$choice = "scissors" if $choice == 3;

			$reply = "<b>Rock, Paper, Scissors</b>\n\n"
				. "You chose: $value\n"
				. "I chose: $choice\n\n";

			# See who wins.
			if ($value eq $choice) {
				$reply .= "Draw!";
			}
			elsif ($value eq "rock" && $choice eq "paper") {
				$reply .= "Paper defeats rock. I win!";
			}
			elsif ($value eq "paper" && $choice eq "rock") {
				$reply .= "Paper defeats rock. You win!";
			}
			elsif ($value eq "rock" && $choice eq "scissors") {
				$reply .= "Rock smashes scissors. You win!";
			}
			elsif ($value eq "scissors" && $choice eq "rock") {
				$reply .= "Rock smashes scissors. I win!";
			}
			elsif ($value eq "paper" && $choice eq "scissors") {
				$reply .= "Scissors cut paper. I win!";
			}
			elsif ($value eq "scissors" && $choice eq "paper") {
				$reply .= "Scissors cut paper. You win!";
			}
			else {
				$reply .= "(Error in deciding the winner!)";
			}
		}
		else {
			$reply = "Value options are: rock, paper, or scissors.";
		}
	}
	else {
		$reply = "<b>Rock, Paper, Scissors</b>\n\n"
			. "To play, type !rps [your choice]\n\n"
			. "Valid choices (shortcuts)\n"
			. "rock (r)\n"
			. "paper (p)\n"
			. "scissors (s)";
	}

	return $reply;
}
1;