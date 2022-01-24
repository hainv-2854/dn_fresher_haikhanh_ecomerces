RSpec.shared_examples "share presence attribute" do |attributes|
  attributes.each do |attr|
    it { should validate_presence_of(attr) }
  end
end

RSpec.shared_examples "share check current user is admin" do
  before {get :index}

  it "redirect to home page" do
    should redirect_to(root_path)
  end
  it "display flash danger permission denied" do
    expect(flash[:danger]).to eq I18n.t("admin.permission_denied")
  end
end

RSpec.shared_examples "share update order fail" do |old, new|
  let(:order) {FactoryBot.create :order, status: old}
  it "when update fail" do
    patch :update, params: {id: order.id, status: new}
    expect(flash[:danger]).to eq I18n.t("admin.orders.update.update_status_fail")
  end
end
