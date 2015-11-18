require 'spec_helper'

describe Extra::Order do
  describe ".unapproved" do
    it "returns the new orders details" do
      VCR.use_cassette('orders_unapproved') do
        expect(Extra::Order.unapproved.first[1].first['id']).to eql('9087232801')
      end
    end

    it "returns the second page" do
      expect(Extra::Order).to receive(:get) do |url, params|
        expect(params[:_offset]).to eql(50)
      end
      Extra::Order.unapproved(page: 2)
    end
  end

  describe ".approved" do
    it "returns the approved orders details" do
      VCR.use_cassette('orders_approved') do
        expect(Extra::Order.approved.first[1].first["totalAmount"]).to eql(61.15)
      end
    end

    it "returns the second page" do
      expect(Extra::Order).to receive(:get) do |url, params|
        expect(params[:_offset]).to eql(50)
      end
      Extra::Order.approved(page: 2)
    end
  end

  describe ".canceled" do
    it "returns the canceled orders details" do
      VCR.use_cassette('orders_canceled') do
        expect(Extra::Order.canceled.first[1].first["purchasedAt"]).to eql("2015-10-15T08:29:00.000-03:00")
      end
    end

    it "returns the second page" do
      expect(Extra::Order).to receive(:get) do |url, params|
        expect(params[:_offset]).to eql(50)
      end
      Extra::Order.canceled(page: 2)
    end
  end

  describe ".track!" do
    xit "returns the new orders details" do
      VCR.use_cassette('orders_track') do
        expect(Extra::Order.new('id' => "219801").track!(orderItemId: ["21932894-1"], controlPoint: 'EPR', occurenceDt: '2014-05-21 00:00:00.00', carrierName: 'Carrie', originDeliveryId: 'SW896927135BR', accessKeyNfe: '35140513933305000289550010000594411422441779')['status']).to eql('1')
      end
    end
  end

  describe ".find" do
    it "find an order by the id" do
      VCR.use_cassette('orders_find') do
        expect(Extra::Order.find("9087232801")["totalAmount"]).to eql(158.69)
      end
    end
  end

  it "trackings" do
    VCR.use_cassette('tracking') do
      response = Extra::Order.sent(
        9099885601,
        {
          "occurredAt" => "2015-11-17T16:32:42-02:00",
          "url" => "http://",
          "number" => "1",
          "sellerDeliveryId" => "0",
          "cte" => "0",
          "carrier" => {
            "name" => "SjF",
            "cnpj" => "000000000"
          },
          "invoice" => {
            "cnpj" => "000000000000",
            "number" => "0",
            "serie" => "0",
            "issuedAt" => "2015-11-16T16:32:42-02:00",
            "accessKey" => "00000000000000000000000000000000000000000000",
            "linkXml" => "0",
            "linkDanfe" => "0"
          }
        })
      binding.pry
    end
  end
end
