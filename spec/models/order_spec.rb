require "rails_helper"

RSpec.describe Order, type: :model do
  describe "associations" do
    it "must belong to user" do
      is_expected.to belong_to :user
    end
    it "must belong to address" do
      is_expected.to belong_to :address
    end
    it "has many order_details" do
      is_expected.to have_many(:order_details).dependent(:destroy)
    end
  end

  describe "scope" do
    let!(:user){FactoryBot.create :user, name: "Hai nguyenn1 van"}
    let!(:order_0){FactoryBot.create :order,id: 1, status: 0}
    let!(:order_1){FactoryBot.create :order,id: 2, status: 1}
    let!(:order_2){FactoryBot.create :order, status: 2, user_id: user.id}
    let!(:order_3_1){FactoryBot.create :order, status: 3, created_at: "2022-01-25"}
    let!(:order_3_2){FactoryBot.create :order, status: 3}
    let!(:order_4){FactoryBot.create :order, status: 4}
    let!(:order_4_1){FactoryBot.create :order, status: 4, deleted_at: Date.current}

    context "sort recent_orders" do
      it "recent_orders" do
        expect(Order.recent_orders).to eq [order_0, order_1, order_2, order_3_2, order_3_1, order_4]
      end
      it "filter_by_name" do
        expect(Order.filter_by_name("nguyenn1")).to eq [order_2]
      end
      it "filter_by_name empty" do
        expect(Order.filter_by_name("nguyenn1saddad")).to eq []
      end
      it "load_by_ids" do
        expect(Order.load_by_ids([1,2])).to eq [order_0, order_1]
      end
      it "load_by_ids empty" do
        expect(Order.load_by_ids([-1,-2])).to eq []
      end
      it "not_rejected_canceled" do
        expect(Order.not_rejected_canceled).to eq [order_0, order_1, order_2]
      end
      it "not_deleted" do
        expect(Order.not_deleted).to eq [order_0, order_1, order_2, order_3_1, order_3_2, order_4]
      end
    end
  end

  describe "Methods" do
    let!(:orders_0){FactoryBot.create_list(:order, 10, status: 0)}
    let!(:orders_1){FactoryBot.create_list(:order, 11, status: 1)}
    let!(:orders_2){FactoryBot.create_list(:order, 12, status: 2)}
    let!(:orders_3){FactoryBot.create_list(:order, 10, status: 3, deleted_at: Date.current)}
    let!(:order_3_0){FactoryBot.create :order, status: 3}
    let!(:order_3_1){FactoryBot.create :order, status: 3}
    let!(:order_4_0){FactoryBot.create :order, status: 4}
    let!(:order_4_1){FactoryBot.create :order, status: 4, deleted_at: Date.current}

    context "#permit_delete?" do
      it "permit delete when status rejected" do
        expect(order_3_0.permit_delete?).to eq true
      end
      it "permit delete when status cancel" do
        expect(order_4_0.permit_delete?).to eq true
      end
    end

    context ".count_orders_by_status" do
      it "count orders by status" do
        expect(Order.count_orders_by_status).to eq [{"pending"=>10}, {"accept"=>11}, {"resolved"=>12}, {"rejected"=>2}, {"canceled"=>1}]
      end
    end

    context ".count_orders_deleted_by_status" do
      it "count orders deleted by status" do
        expect(Order.count_orders_deleted_by_status).to eq [{"pending"=>0}, {"accept"=>0}, {"resolved"=>0}, {"rejected"=>10}, {"canceled"=>1}]
      end
    end
  end
end
