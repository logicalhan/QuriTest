module Admin::PagesHelper
  def percentage_title(options)
    if options[:optional_filter]
      "#{options[:filter].titleize} after #{options[:optional_filter].titleize}"
    else 
      options[:filter].titleize
    end
  end
end
