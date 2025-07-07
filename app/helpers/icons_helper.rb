# frozen_string_literal: true

module IconsHelper
  def icon(name, options = {})
    # Read the SVG file from the assets pipeline
    file = Rails.root.join("app", "assets", "icons", "#{name}.svg").read
    # Create a new Nokogiri document from the SVG file
    doc = Nokogiri::HTML::DocumentFragment.parse(file)
    # Get the svg element
    svg = doc.at_css "svg"

    # Add any additional classes to the svg element
    svg["class"] = "#{svg['class']} #{options[:class]}" if options[:class].present?

    # Add any additional data attributes to the svg element
    if options[:data].present?
      options[:data].each do |key, value|
        svg["data-#{key}"] = value
      end
    end

    # Return the svg element as a string
    doc.to_html.html_safe
  end
end
