package GODOT::CUFTS::Result;
##
## Copyright (c) 2003, Kristina Long, Simon Fraser University
##

use Exporter;
use GODOT::Debug;
use GODOT::String;
use GODOT::CUFTS::Object;

@ISA = qw(Exporter GODOT::CUFTS::Object);

use strict;

my $FALSE = 0;
my $TRUE  = 1;

##
## (12-jan-2009 kl) -- added vol_ft_start, vol_ft_end, iss_ft_start and iss_ft_end
## (08-jan-2009 kl) -- added source, issn and e_issn
## (08-aug-2008 kl) -- added ft_start_date, ft_end_date, coverage and cjdb_note for upei
##
my @FIELDS = qw(url
                title
                source
                issn
                e_issn
                ft_start_date
                ft_end_date
                vol_ft_start
                vol_ft_end
                iss_ft_start
                iss_ft_end
                coverage
                cjdb_note
                _error_message
               );

sub new {
    my ($self, $fields, $values) = @_;

    my $class = ref($self) || $self;

    if (ref($fields) eq 'HASH')  { $values = $fields; }
    if (ref($fields) ne 'ARRAY') { $fields = [];      }

    return $class->SUPER::new([@FIELDS, @{$fields}], $values);
}


sub result {
    my($self) = @_;

    return (($self->{'_error_message'}) ? $FALSE : $TRUE);    
}

sub error_message {
    my($self) = @_;    

    return $self->{'_error_message'};
}

sub xml_input {
    my($self, $string) = @_;

    ##
    ## -allow for a match on attributes, but ignore them as we aren't expecting any for <result>, <url> or <title> 
    ##

    if ($string =~ m#<result\s*.*?>(.+?)</result>#s) {

	 my $content = $1;
  
         foreach my $field qw(url title source issn e_issn ft_start_date ft_end_date vol_ft_start vol_ft_end iss_ft_start iss_ft_end coverage cjdb_note) {       

             if ($content =~ m#<$field\s*.*?>(.*?)</$field>#s) {
                 my $value = $1;
                 $self->{$field} = $value if naws($value);
             }        
         }
    } 
    else {

        $self->{'_error_message'} = "unexpected response from CUFTS";
        debug "\nunexpected response from CUFTS (no '<result>' and '</result>')\n" . $string . "\n";

        return undef;                      
    }
       
    return $TRUE;
} 

1;

__END__


-----------------------------------------------------------------------------------------

=head1 NAME

GODOT::XXX - 

=head1 METHODS

=head2 Constructor

=over 4

=item new([$dbase])

=back

Returns a reference to Citation object. I<$dbase> is a refenerce
to Database object.

=head2 ACCESSOR METHODS

=over 4

=item mysubroutine([$value])

Accessor methods for checking $self->{'req_type'} for a specific type of
document, or for setting the Citation object to be a certain type of
document.  These methods are similar to the req_type(), but use boolean
values for each document type rather than returning or setting the actual
req_type value which req_type() does.


=back

=head1 AUTHORS / ACKNOWLEDGMENTS

Kristina Long


=cut
