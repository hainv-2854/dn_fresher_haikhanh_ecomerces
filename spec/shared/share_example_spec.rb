RSpec.shared_examples "share presence attribute" do |attributes|
  attributes.each do |attr|
    it { should validate_presence_of(attr) }
  end
end

RSpec.shared_examples "share update order fail" do |old, new|
  let(:order) {FactoryBot.create :order, status: old}
  it "when update fail" do
    patch :update, params: {id: order.id, status: new}
    expect(flash[:danger]).to eq I18n.t("admin.orders.update.update_status_fail")
  end
end
