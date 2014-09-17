# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
# http://guides.rubyonrails.org/asset_pipeline.html
# The default matcher for compiling files includes application.js, application.css and all non-JS/CSS files
# (i.e., .coffee and .scss files are not automatically included as they compile to JS/CSS)

Rails.application.config.assets.precompile +=
    %w(print_pdf.css application_print.css jquery.ui.datepicker-de.js jquery.ui.datepicker-en.js)