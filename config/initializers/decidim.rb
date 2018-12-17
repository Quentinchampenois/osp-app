# frozen_string_literal: true

Decidim.configure do |config|

  config.release = {
    commit: `git rev-parse --short HEAD`.strip,
    branch: `git rev-parse --abbrev-ref HEAD`.strip,
    repo: `basename \`git rev-parse --show-toplevel\``.strip
  }

  config.skip_first_login_authorization = ENV["SKIP_FIRST_LOGIN_AUTHORIZATION"] ? ActiveRecord::Type::Boolean.new.cast(ENV["SKIP_FIRST_LOGIN_AUTHORIZATION"]) : true
  config.application_name = "Ville de Nancy"
  config.mailer_sender = "Ville de Nancy <ne-pas-repondre@opensourcepolitics.eu>"
  # config.mailer_sender = "Ville de Nancy <web@mairie-nancy.fr>"

  # Change these lines to set your preferred locales
  config.default_locale = :fr
  config.available_locales = [:fr]

  config.maximum_attachment_height_or_width = 6000

  # Geocoder configuration
  if !Rails.application.secrets.geocoder[:here_app_id].blank?
    config.geocoder = {
      static_map_url: "https://image.maps.cit.api.here.com/mia/1.6/mapview",
      here_app_id: Rails.application.secrets.geocoder[:here_app_id],
      here_app_code: Rails.application.secrets.geocoder[:here_app_code]
    }
  end

  if defined?(Decidim::Initiatives) && defined?(Decidim::Initiatives.do_not_require_authorization)
    # puts "Decidim::Initiatives are loaded"
    Decidim::Initiatives.do_not_require_authorization = true
  end


  # Custom resource reference generator method
  # config.resource_reference_generator = lambda do |resource, feature|
  #   # Implement your custom method to generate resources references
  #   "1234-#{resource.id}"
  # end

  # Currency unit
  # config.currency_unit = "€"

  # The number of reports which an object can receive before hiding it
  # config.max_reports_before_hiding = 3

  # Custom HTML Header snippets
  #
  # The most common use is to integrate third-party services that require some
  # extra JavaScript or CSS. Also, you can use it to add extra meta tags to the
  # HTML. Note that this will only be rendered in public pages, not in the admin
  # section.
  #
  # Before enabling this you should ensure that any tracking that might be done
  # is in accordance with the rules and regulations that apply to your
  # environment and usage scenarios. This feature also comes with the risk
  # that an organization's administrator injects malicious scripts to spy on or
  # take over user accounts.
  #
  config.enable_html_header_snippets = true

  if ENV["HEROKU_APP_NAME"].present?
    config.base_uploads_path = ENV["HEROKU_APP_NAME"] + "/"
  end
end

Rails.application.config.i18n.available_locales = Decidim.available_locales
Rails.application.config.i18n.default_locale = Decidim.default_locale
