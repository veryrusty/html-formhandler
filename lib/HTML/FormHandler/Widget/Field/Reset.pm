package HTML::FormHandler::Widget::Field::Reset;
# ABSTRACT: reset field rendering widget

use Moose::Role;
use namespace::autoclean;
use HTML::FormHandler::Render::Util ('process_attrs');

has 'no_render_label' => ( is => 'ro', isa => 'Bool', default => 1 );

sub render {
    my ( $self, $result ) = @_;

    $result ||= $self->result;
    my $output = '<input type="reset" name="';
    $output .= $self->html_name . '"';
    $output .= ' id="' . $self->id . '"';
    $output .= ' value="' . $self->html_filter($self->value) . '"';
    $output .= process_attrs($self->attributes);
    $output .= ' />';
    return $self->wrap_field( $result, $output );
}

1;
