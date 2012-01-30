use strict;
use warnings;
use Test::More;
use HTML::FormHandler::Test;

{
    package MyApp::Form::InLine::Theme;
    use Moose::Role;

    # wrap the form in a header and close the div. Probably better done in a template
    sub render_before_form {
       '<h3>Inline form</h3>
        <div class="row">
        <div class="span3">
          <p>Inputs are block level to start. For <code>.form-inline</code> and <code>.form-horizontal</code>, we use inline-block.</p>
        </div>'
    }
    sub render_after_form { '</div>' }

    # form tag classes
    sub build_html_attr { { class => ['well', 'form-search'] } }
    # form wrapper class
    sub build_wrapper_attr { { class => 'span9' } }
    # turn on form wrapper, set the tag to 'div' (default is fieldset)
    sub build_widget_tags {
        { form_wrapper => 1, form_wrapper_tag => 'div' }
    }
    # update individual fields
    sub build_update_fields {{
        email => { html_attr => { class => 'input-small', placeholder => 'Email' } },
        password => { html_attr => { class => 'input-small', placeholder => 'Password' },
            widget_tags => { wrapper_tag => 0 } },
        go => { html_attr => { class => 'btn' } },
    }}

}

{
    package MyApp::Form::InLine;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler';
    with 'MyApp::Form::InLine::Theme';

    has '+name' => ( default => 'inline_form' );
    has '+widget_wrapper' => ( default => 'None' );

    has_field 'email' => ( type => 'Email' );
    has_field 'password' => ( type => 'Password' );
    has_field 'go' => ( type => 'Submit', widget => 'ButtonTag', value => 'Go' )
}

my $form = MyApp::Form::InLine->new;
$form->process;
my $rendered = $form->render;

my $expected =  '<h3>Inline form</h3>
  <div class="row">
    <div class="span3">
      <p>Inputs are block level to start. For <code>.form-inline</code> and <code>.form-horizontal</code>, we use inline-block.</p>
    </div>
    <div class="span9">
      <form class="well form-search" id="inline_form" method="post">
        <input type="text" class="input-small" placeholder="Email" name="email" id="email" value="" />
        <input type="password" class="input-small" placeholder="Password" name="password" id="password" value="" />
        <button type="submit" class="btn" name="go" id="go">Go</button>
      </form>
    </div>
  </div>';

is_html( $rendered, $expected, 'form renders correctly' );

done_testing;
