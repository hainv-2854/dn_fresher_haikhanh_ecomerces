class Admin::BaseController < ApplicationController
  include Pagy::Backend
  layout "admin/layouts/application"
  before_action :check_admin

  private
  def check_admin
    return if current_user&.admin?

    flash[:danger] = t "admin.permission_denied"
    redirect_to root_path
  end
end
