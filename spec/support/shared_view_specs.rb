shared_examples_for "strict xhtml" do
  it "according to nokogiri" do
    xml = render
    xml = (xml =~ /^\s*<[^a-zA-Z]/) ? xml : "<root>#{xml}</root>"
    Nokogiri::XML.parse(xml, nil, nil, Nokogiri::XML::ParseOptions::STRICT)
  end
end