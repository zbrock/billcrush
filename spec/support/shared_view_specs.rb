shared_examples_for "strict xhtml" do
  it "according to nokogiri" do
    template = example.example_group.top_level_description
    xml = render :template => template
    xml = (xml =~ /^\s*<[^a-zA-Z]/) ? xml : "<root>#{xml}</root>"
    Nokogiri::XML.parse(xml, nil, nil, Nokogiri::XML::ParseOptions::STRICT)
  end
end