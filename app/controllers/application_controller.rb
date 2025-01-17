class ApplicationController < ActionController::Base
  before_action :set_locale, :load_cart
  protect_from_forgery with: :exception
  include SessionsHelper
  include Pagy::Backend

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def load_cart
    session[:cart] ||= {}
  end
end
