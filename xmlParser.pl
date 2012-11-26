#!/usr/bin/perl -w

use XML::Parser;
use XML::SimpleObject;

my $parser = XML::Parser->new(ErrorContext => 2, Style => "Tree");
my $xml = XML::SimpleObject->new( $parser->parsefile("weathermap.xml") );

print "=================== GLOBAL =================\n";
# Variables 
my $background_node 	= $xml->child('weathermap')->child('global')->child('background');
my $background_type	= $background_node->attribute('type');
my $background_url	= $background_node->attribute('href');

my $scale_pos 		= $xml->child('weathermap')->child('global')->child('scales_postion');
my $scale_pos_x 	= $scale_pos->attribute('x');
my $scale_pos_y 	= $scale_pos->attribute('y');

my $title 		= $xml->child('weathermap')->child('global')->child('title');
my $title_text		= $title->value;
my $title_pos_x		= $title->attribute('x');
my $title_pos_y		= $title->attribute('y');

# Print
print "Background[[1;32m$background_type[0m] = [1;31m$background_url[0m\n";
print "Scales position = [1;31m{$scale_pos_x,$scale_pos_y}[0m\n";
print "Title {[1;32m$title_pos_x,$title_pos_y[0m} = [1;31m$title_text[0m\n";

print "\n\n";

print "=================== SCALES =================\n";
foreach my $scale ($xml->child('weathermap')->child('scales')->children('scale')) {
	# Variables
	my $scale_low 		= $scale->child('low')->value;
	my $scale_high 		= $scale->child('high')->value;
	my $scale_color 	= $scale->child('color');
	my $scale_red 		= $scale_color->attribute('red');
	my $scale_green 	= $scale_color->attribute('green');
	my $scale_blue 		= $scale_color->attribute('blue');
	
	# Print
	print "Low : $scale_low \t";
	print "High: $scale_high \t";
	print "($scale_red,$scale_green,$scale_blue)\n";
}
print "\n\n";

print "==================== NODES =================\n";
foreach my $node ($xml->child('weathermap')->child('nodes')->children('node')) {
        # Variables
	my $node_name 		= $node->attribute('name');
	my $node_label 		= $node->child('label')->value;
	my $node_pos 		= $node->child('position');
	my $node_pos_x		= $node_pos->attribute('x');
	my $node_pos_y		= $node_pos->attribute('y');

	# Print
	print "[[1;32m$node_name[0m] ";
	print "{$node_pos_x,$node_pos_y} ";
	print "Label : $node_label\n";
}
print "\n\n";

print "==================== LINKS =================\n";
foreach my $link ($xml->child('weathermap')->child('links')->children('link')) {
        # Variables
	my $link_name		= $link->attribute('name');
	my $link_target		= $link->child('target');
	my $link_target_type	= $link_target->attribute('type');
	my $link_target_url	= $link_target->attribute('href');
	my $link_bandwidth	= $link->child('bandwidth')->value;
	my $link_mb_bandwidth	= $link_bandwidth/1000;
	my $link_members="";
	foreach my $member ($link->child('members')->children('member')) {
		$link_members.=$member->value." ";
	}

	# Print
	print "[[1;32m$link_name[0m] ( [31m$link_mb_bandwidth Mbit/s[0m ) $link_members ";
	print "target[$link_target_type] = $link_target_url\n";
}
print "\n\n";

print "=================== COMMENTS ===============\n";
foreach my $comment ($xml->child('weathermap')->child('comments')->children('comment')) {
	# Variables 
	my $comment_text	= $comment->child('text')->value;
	my $comment_pos		= $comment->child('position');
	my $comment_pos_x	= $comment_pos->attribute('x');
	my $comment_pos_y	= $comment_pos->attribute('y');

	print "Comment at {$comment_pos_x,$comment_pos_y} = $comment_text\n";
}
