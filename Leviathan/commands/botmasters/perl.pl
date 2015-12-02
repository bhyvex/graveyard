#      .   .               <Leviathan>
#     .:...::     Command Name // !reload
#    .::   ::.     Description // Reload the bot's files and replies.
# ..:;;. ' .;;:..        Usage // !reload
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2005 AiChaos Inc.

sub perl {
	my ($self,$client,$msg) = @_;

	# Credits:
	#	Keenie - Helped me capture STDOUT from eval(), through Eric
	#	Eric - Indirectly helped me through Keenie
	# (Confusing, huh? It's like a soap opera ;) )

	# Filter things.
	$msg =~ s/\&amp\;/\&/ig;
	$msg =~ s/\&lt\;/</ig;
	$msg =~ s/\&gt\;/>/ig;
	$msg =~ s/\&quot\;/"/ig;
	$msg =~ s/\&apos\;/'/ig;

	# Some globals for use later.
	my $sn;
	$sn = $self->{Msn}->{Handle} if $listener eq "MSN";
	$sn = $self->screenname() if $listener eq "AIM";
	$sn = $self->nick() if $listener eq "IRC";
	$sn = $self->{username} if $listener eq "JABBER";
	$sn = '_http' if $listener eq "HTTP";
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Variables.
	my $msn = $chaos->{$sn}->{client} if $listener eq "MSN";
	my $chat = $chaos->{$sn}->{current_user}->{chat} if $listener eq "AIM";

	if (&isMaster($client)) {
		# Save STDOUT.
		open (OUTPUT, ">./data/temp/output.txt");
		select OUTPUT;
		my $success = eval ($msg) || $@;
		select STDOUT;
		close (OUTPUT);

		my $output;
		if ($success == 1) {
			# Get the output.
			open (REPLY, "./data/temp/output.txt");
			$output = <REPLY>;
			close (REPLY);
		}
		else {
			$output = $success;
		}

		# Eval the function.
		return "Perl executed; Ouput:\n\n$output";
	}
	else {
		return "This command can only be used by the botmaster.";
	}
}

{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Execute Perl codes.',
	Usage => '!perl <codes>',
	Listener => 'All',
};