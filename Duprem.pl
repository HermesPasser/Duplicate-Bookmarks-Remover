# By Hermes Passer in 20/06/2017
use strict;
use warnings;

sub load_html{
	my $filename = $_[0];

	if (-e $filename) { 
		open (my $fh, '<', $filename) or die "error opening $filename: $!";
		my $doc = do { local $/; <$fh> };
		close($fh);
		return split(/\n/, $doc);
	}
	return;
}

sub save_html{
	my ($doc_ref, $filename) = @_;
	my @doc = @$doc_ref;
	open (my $file, ">$filename.html");
	foreach (@doc) {
		print $file $_ . "\n";
	}
	close ($file);  
}

sub get_href{
	my $str = $_[0];
	if (index($str, "HREF") == -1) { return "!Error!"; }
	
	$str = substr($str, index($str, '"') + 1, length($str));
	return substr($str, 0, index($str, '"'));	
}

sub check_if_exits{
	my ($array_ref, $str) = @_;
	my @array = @$array_ref;

	foreach (@array) {
		if (index($_, $str) != -1) { 
			return 1; 
		}
	}
	return 0;
}

sub remove_duplicates{
	my @doc = @_;
	my @output;
	foreach (@doc) {	
		if (index($_, "<DT>") != -1) {
			if (not check_if_exits(\@output, get_href($_))){
				@output[scalar(@output)] = $_;
			}
		} else {
			@output[scalar(@output)] = $_;
		}
	}
	return @output;
}

print "\tDuprem - duplicate bookmarks remover 0.1\n";
print "\tby Hermes Passer (gladiocitrico.blogspot.com)\n";

if (scalar(@ARGV) > 0){
	my $file_name = $ARGV[0];
	my @doc = load_html($file_name);
	
	if (@doc != 0){
		@doc = remove_duplicates();
		print "File saved as new_" . $file_name . "\n";
		save_html(\@doc, "new_" . $file_name);
	} else {
		print "This file cannot be accessed or does exist"; 
	}
} else {
	print "\nWrong number of arguments.\nFirst and Only Argument: <file_name.html>\n";
}