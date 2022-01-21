require "rails_helper"

RSpec.describe Product, type: :model do
  describe "associations" do
    it "must belong to category" do
      is_expected.to belong_to :category
    end
    it "has many order_details" do
      is_expected.to have_many :order_details
    end
    it "has many comments" do
      is_expected.to have_many :comments
    end
  end

  describe "validate" do
    context "name" do
      it "when nil is invalid" do
        expect validate_presence_of(:name).with_message I18n.t("activerecord.errors.models.product.attributes.name.blank")
      end
    end

    context "quantity" do
      it "when quantity valid" do
        should validate_numericality_of(:quantity).is_greater_than_or_equal_to(0)
      end
      it "when nil is invalid" do
        expect validate_presence_of(:quantity).with_message I18n.t("activerecord.errors.models.product.attributes.quantity.blank")
      end
    end
  end

  describe "scope" do
    let!(:product){FactoryBot.create :product, name: "a", price: 10}
    let!(:product_2){FactoryBot.create :product, name: "b", price: 20}
    let!(:product_3){FactoryBot.create :product, name: "c", price: 30}

    context "sort product" do
      it "sort by name" do
        expect(Product.order_by_name).to eq [product, product_2, product_3]
      end
      it "sort by price" do
        expect(Product.sort_by_price).to eq [product, product_2, product_3]
      end
    end
  end
end
