class FakeSelectInput < SimpleForm::Inputs::CollectionSelectInput
  # This method only create a basic input without reading any value from object
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    puts template
    template.select_tag(attribute_name, template.options_for_select(collection.reverse), merged_input_options)
  end
end