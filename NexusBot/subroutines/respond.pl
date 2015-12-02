#################################################
#                                               #
#     #####    #                                #
#    #     #   #                                #
#   #       #  #                                #
#  #           #            #                   #
#  #           ####     #####     ####    ####  #
#  #           #   #   #    #    #    #  #      #
#   #       #  #    #  #    #    #    #   ###   #
#    #     #   #    #  #    #    #    #      #  #
#     #####    #    #   #### ##   ####   ####   #
#                                               #
#         A . I .      T e c h n o l o g y      #
#-----------------------------------------------#
#  Subroutine: respond                          #
# Description: The bot's chance to respond.     #
#################################################

# Create a hash for the client's last messages, etc.
%users_past;

sub respond {
	# Get all the variables needed from the shift.
	my ($client,$fmsg,$msg) = @_;

	if (lc($msg) eq "connect") {
		return "Hello there $client and thanks for connecting! (1)";
	}

	# First, see if it's a curse.
	return "noreply" if curses($msg);

	# Get their last message.
	my $last_msg = $chaos->{users}->{$client}->{lastmsg};

	my $reply = "";

	my $sentence = sentence($msg);

	# Scan the reply data to see if the message is already in there.
	my $exists_past = 0;
	my $exists_past_p = 0;
	my $exists_present = 0;
	my $exists_greeting = 0;
	open (OLD, "./data/brain.txt");
	my @data = <OLD>;
	close (OLD);
	foreach $line (@data) {
		chomp $line;
		($past,$present) = split(/\]\[/, $line);
		if ($past eq "") {
			# The greetings line. Always on top.
			@present = split(/\|/, $present);
			foreach $item (@present) {
				if ($item eq $sentence) {
					$exists_greeting = 1;
				}
			}
		}
		if ($past eq $fmsg) {
			$exists_past = 1;
		}
		if (lc($last_msg) eq $past) {
			$exists_past_p = 1;
		}
		if ($present eq $sentence) {
			$exists_present = 1;
		}
	}

	# At this point, if both variables equal ONE, the bot
	# will not learn anything.

	# Is this your first message?
	if ($last_msg eq "") {
		# Yes, it is. Did it already exist?
		if ($exists_greeting == 0) {
			# Ok, then, save it.
			$final = "";
			foreach $line (@data) {
				chomp $line;
				($past,$present) = split(/\]\[/, $line);
				$past =~ s/[^\w\s]//g;
				if ($past eq "") {
					$present .= "|$sentence";
				}
				$final .= "$past][$present\n";
			}
			open (NEW, ">./data/brain.txt");
			print NEW $final;
			close (NEW);
		}
		else {
			# Some simple reply matching is all.
			foreach $line (@data) {
				chomp $line;
				($past,$present) = split(/\]\[/, $line);
				if ($fmsg =~ /$past/i) {
					@last = split(/\|/, $present);
					$reply = $last [ int(rand(scalar(@last))) ];
				}
			}
		}
	}
	else {
		# If this isn't their first message, save this new
		# response as what comes after their last one.
		if ($exists_past_p == 1) {
			# Their message will go as a random response to the past one.
			$final = "";
			foreach $line (@data) {
				chomp $line;
				($past,$present) = split(/\]\[/, $line);
				if (lc($past) eq lc($last_msg)) {
					$present .= "|$sentence";
					@last = split(/\|/, $present);
					$reply = $last [ int(rand(scalar(@last))) ];
				}
				$past =~ s/[^\w\s]//g;
				$final .= "$past][$present\n";
			}
			open (NEW, ">./data/brain.txt");
			print NEW $final;
			close (NEW);
		}
		else {
			# This is new.
			$last_msg = filter($last_msg);
			$last_msg = lc($last_msg);
			$last_msg =~ s/[^\w\s]//g;
			open (NEW, ">>./data/brain.txt");
			print NEW "$last_msg][$sentence\n";
			close (NEW);
			$reply = $sentence;
		}
	}

	# If we haven't already gotten a reply, GET one!
	if ($reply eq "") {
		$reply = "Let's change the subject.";
		print "An error occurred while getting the reply.\n";
		print "The error occurred in \"respond.pl\".\n\n";
	}

	# Save the last message.
	$chaos->{users}->{$client}->{lastmsg} = $fmsg;

	return $reply;
}
1;