require 'rails_helper'

RSpec.describe MembersController, type: :controller do  
  include Devise::Test::ControllerHelpers

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @current_user = FactoryBot.create(:user)
    sign_in @current_user
  end

  describe "POST #create" do
    before(:each) do
      request.env["HTTP_ACCEPT"] = 'application/json'
      campaign = create(:campaign)
      @member = attributes_for(:member, campaign_id: campaign.id)
    end

    it "whit valid attributes" do
      expect{ post :create, params: {member: @member} }.to change(Member, :count).by(1)
    end

    it "whit invalid attributes" do
      @member[:campaign_id] = nil
      post :create, params: { member: @member }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      request.env["HTTP_ACCEPT"] = 'application/json'
      campaign = create(:campaign, user: @current_user)
      @member = create(:member, campaign_id: campaign.id)
    end

    context "when user have pemission to remover the member" do

      it "returns http success" do
        delete :destroy, params: { id: @member.id }
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET #update" do
    before(:each) do
      request.env["HTTP_ACCEPT"] = 'application/json'
      campaign = create(:campaign, user: @current_user)
      @member = create(:member, campaign_id: campaign.id)
      @member_attributes = attributes_for(:member, campaign_id: campaign.id)

      put :update, params: { id: @member.id, member: @member_attributes }
    end

    it "returns http success" do
      expect(response).to have_http_status(:successful)
    end

    it "Member should be updated" do      
      @member.reload
      expect(@member.email).to eq(@member_attributes[:email])
    end
  end

end