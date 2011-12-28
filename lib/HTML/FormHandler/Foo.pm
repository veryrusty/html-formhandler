package HTML::FormHandler::Foo;
use Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Render::WithTT';

use Config::Any;

use 5.010;

#use overload (
#    '""' => sub { return shift->render },
#    '==' => sub { return blessed($b) ? ( refaddr($a) eq refaddr($b) ) : undef }
#);

has 'form_error_message' => ( isa => 'Str', is => 'rw' );
has 'javascript_src' => ( is => 'Str', is => 'rw' );
has 'javascript' => ( is => 'STr', is => 'rw' );

sub before_build {
    my $self = shift;

    $self->add_tt_include_path('share/templates/foo');
    $self->process_config_file;
    $self->process_config;
}

sub build_tt_template { 'form.tt' }

has 'config_file' => ( isa => 'Str', is => 'rw' );
has 'config' => ( isa => 'HashRef', is => 'rw' );

sub submitted_and_valid { shift->validated }

sub no_label_class { 1 }

sub process_config_file {
    my $self = shift;
    return unless $self->config_file;
    unless ( -e $self->config_file ) {
        die "form config file " . $self->config_file . " . does not exist";
    }
    my $config = Config::Any->load_files({
        files => [$self->config_file],
        use_ext         => 1,
        driver_args => { General => { -UTF8 => 1 }, },
    });
    $config = $config->[0]->{$self->config_file};
    $self->config($config);

}

sub process_config {
    my $self = shift;

    my $config = $self->config;
    while ( my ( $key, $value ) = each %{$config} ) {
        confess "invalid attribute '$key' in form config"
            unless $self->can($key);
        $self->$key($value);
    }
}

1;
