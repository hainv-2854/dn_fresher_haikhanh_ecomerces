class ApplicationController < ActionController::Base
  before_action :set_locale, :load_cart
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

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

  def configure_permitted_parameters
    added_attrs = %i(name email password password_confirmation remember_me)
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def redirect_back_current
    redirect_back fallback_location: root_path
  end

  def load_paramsq
    return if params[:q].blank?

    if params[:q][:category_id_eq].to_i.zero?
      params[:q].delete(:category_id_eq)
      params[:q][:category_id_gteq] = 0
    else
      @value_category = params[:q][:category_id_eq]
    end
  end

  rescue_from CanCan::AccessDenied do
    redirect_to root_path, alert: t("cancancan.permission_denied")
  end
end
