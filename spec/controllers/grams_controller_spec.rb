require 'rails_helper'

RSpec.describe GramsController, type: :controller do

  describe "grams#index action" do

    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end

  end

  describe "grams#new action" do

    it "grams#new action" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#create action" do
    it "should successfully create a new gram in our database" do
      post :create, gram: {message: 'Hello'}
      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.message).to eq("Hello")
    end

    it "should properly deal with validation errors" do
      post :create, gram: { message: ' ' }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq 0
    end



  end


end
