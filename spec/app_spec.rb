require "spec_helper"
require "factories/factories"

context "Application routes" do
  describe "/token" do
    let(:user) { create(:user) }

    it "return 400 if guid is not provided" do
      get "/token"
      expect(last_response.status).to eq 400
      expect(last_response.body).to eq "GUID is required"
    end

    it "return 403 if user is not exist" do
      get "/token?guid=1234"
      expect(last_response.status).to eq 403
      expect(last_response.body).to eq "User not found"
    end

    it "accepts a guid and returns a pair access token and refresh token" do
      get "/token?", {guid: user.guid}
      expect(last_response.status).to eq 200
      response_body = JSON.parse(last_response.body)

      expect(response_body).to have_key("access_token")
      expect(response_body["access_token"]).not_to be_nil

      expect(response_body).to have_key("refresh_token")
      expect(response_body["refresh_token"]).not_to be_nil
    end
  end

  describe "/refresh" do
    let(:user) { create(:user) }
    let(:refresh_token) { create(:refresh_token, user_guid: user.guid, ip: "127.0.0.1") }

    it "return 400 if refresh token is not provided" do
      get "/refresh"
      expect(last_response.status).to eq 400
      expect(last_response.body).to eq "Refresh token is required"
    end

    it "return 403 if refresh token is nil" do
      get "/refresh?refresh_token=$2a$12$d"
      expect(last_response.status).to eq 403
      expect(last_response.body).to eq "Token not found"
    end

    it "return 403 if refresh token is expired" do
      refresh_token.update(expire: Time.now - 10.days)

      get "/refresh?refresh_token=#{refresh_token.refresh_token_hash}"
      expect(last_response.status).to eq(403)
      expect(last_response.body).to eq("Token expired")
    end

    it "return 403 if refresh token is expired" do
      refresh_token.update(expire: Time.now - 10.days)

      get "/refresh?refresh_token=#{refresh_token.refresh_token_hash}"
      expect(last_response.status).to eq(403)
      expect(last_response.body).to eq("Token expired")
    end

    it "send warning email if ip address has changed" do
      allow(SendMailJob).to receive(:perform_async)
      get "/refresh?refresh_token=#{refresh_token.refresh_token_hash}", {}, {"REMOTE_ADDR" => "0.0.0.0"}
      expect(SendMailJob).to have_received(:perform_async).with(user.email)
    end

    it "return new access token if refresh is successful" do
      get "/refresh?refresh_token=#{refresh_token.refresh_token_hash}"
      expect(last_response.status).to eq(200)

      response_body = JSON.parse(last_response.body)
      expect(response_body).to have_key("access_token")
      expect(response_body["access_token"]).not_to be_nil

      expect(response_body).to have_key("refresh_token")
      expect(response_body["refresh_token"]).not_to be_nil
    end
  end
end
