require 'rails_helper'

RSpec.describe MembersController, type: :controller do  

  before(:each) do    
    # @campaign = FactoryGirl.create(:campaign)    
    @campaign = attributes_for(:campaign)    
  end

  describe "POST #create" do
    before(:each) do
      post :create, params: {campaign: @campaign}
      member = create(:member, campaign: @campaign)
    end

    it "Redirect to new member" do
      expect(response).to have_http_status(302)
      expect(response).to redirect_to("/members/#{Member.last.id}")
    end

    it 'Create member with right attributes' do
      expect(Member.last.campaign).to eql(@campaign)
      expect(Member.last.email).to eql(@campaign[:email])
      expect(Member.last.name).to  eql(@campaign[:name])
    end
    
  end

  describe "GET #destroy" do

    before(:each) do
      request.env["HTTP_ACCEPT"] = 'application/json'
    end

    it 'returns http success - member deleted campaign' do
      campaign = create(:campaign)
      member = create(:member, campaign: campaign)
      # dúvida em tirar um membro de uma campaign
    end

    it "returns http success - member deleted" do
      member = create(:member, campaign: @campaign)
      delete :destroy, params: {id: member.id}
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #update" do
    before(:each) do      
      request.env["HTTP_ACCEPT"] = 'application/json'
      @new_member_attributes = attributes_for(:member)            
      member = create(:member)
      put :update, params: {id: member.id, member: attributes_for(:member)}
    end    

    it "returns http success" do      
      expect(response).to have_http_status(:success)
    end

    it 'Member have the new attributes' do
      expect(Member.last.name).to eq(@new_member_attributes[:name])
      expect(Member.last.email).to eq(@new_member_attributes[:email])
    end
  end

end