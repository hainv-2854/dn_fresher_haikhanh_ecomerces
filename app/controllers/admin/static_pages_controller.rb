class Admin::StaticPagesController < Admin::BaseController
  def home
    authorize! :read, current_user
  end
end
