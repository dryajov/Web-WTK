package Web::WTK::Printers::Html;

use namespace::autoclean;

use Moose;

use Web::WTK::Markup::Element;

with 'Web::WTK::Printers::Roles::Printable';

has 'indent' => (
	is  => 'rw',
	isa => 'Bool'
);

has '_indent_level' => (
	is  => 'rw',
	isa => 'Int',
);

sub print {
	my ( $self, $markup ) = @_;
	
	return $self->_to_html( $markup );
}

sub _to_html {
	my ( $self, $elm ) = @_;

	my $markup;
	if ( Web::WTK::Markup::Element->isa_elm($elm) ) {

		return    # skip this element from rendering
		  if ($Web::WTK::Markup::Element::RENDER_NONE);

		# render the start of a tag including any attributes
		# NOTE: this might be disabled from rendering
		if ( $elm->render_flag & $Web::WTK::Markup::Element::RENDER_TAG ) {
			$markup .= "<" . $elm->name;
			my %attrs = %{ $elm->attrs };
			if (%attrs) {
				$markup .= " ";
				$markup .= $_ . "=\"" . $attrs{$_} . "\" " for keys %attrs;
				$markup =~ s/\s$//g;    # remove trailing space
			}
		}

		my $child_markup;

		# render the child markup
		# NOTE: this might be disabled from rendering
		if ( $elm->render_flag & $Web::WTK::Markup::Element::RENDER_BODY ) {
			my $iterator = $elm->iterator;
			while ( my $child = $iterator->() ) {
				if ( Web::WTK::Markup::Element->isa_elm($child) ) {
					my $text = $self->_to_html($child);
					$child_markup .= $text if $text;
				}
				else {
					$child_markup .= $child;
				}

			}
		}

		# render the end of the tag,
		# depending on the presence of child markup
		# it might be a <tag/> or a <tag></tag>
		# NOTE: this might be disabled from rendering
		if ( $elm->render_flag & $Web::WTK::Markup::Element::RENDER_TAG ) {
			if ($child_markup) {
				$markup       .= ">";
				$child_markup .= "</" . $elm->name . ">";
				$markup       .= $child_markup;
			}
			else {
				$markup .= "/>";
			}
		}
		else {
			$markup = $child_markup;
		}
	}
	else {
		return $elm;
	}

	return $markup;
}

__PACKAGE__->meta->make_immutable;
1;
