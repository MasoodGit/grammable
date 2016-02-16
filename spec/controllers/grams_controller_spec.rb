require 'rails_helper'

RSpec.describe GramsController, type: :controller do


  describe "grams#destroy action" do

    it "should not allow users who didn't create the gram to destroy it" do
      gram = FactoryGirl.create(:gram)
      new_user = FactoryGirl.create(:user)
      sign_in new_user

      delete :destroy, id: gram.id

      expect(response).to have_http_status(:forbidden)

    end

    it "should not let unautheticated users destroy a gram" do
      gram = FactoryGirl.create(:gram)
      delete :destroy, id: gram.id

      expect(response).to redirect_to new_user_session_path
    end

    it "should allow user to delete a gram given id from the database " do
      gram = FactoryGirl.create(:gram)
      sign_in gram.user

      delete :destroy, id: gram.id

      expect(response).to redirect_to root_path

      gram = Gram.find_by_id(gram.id)
      expect(gram).to eq nil

    end

    it "should return a 404 error message if the id is invalid or does not exist in the datbase" do
      user = FactoryGirl.create(:user)
      sign_in user
      delete :destroy, id: "TETERED"

      expect(response).to have_http_status(:not_found)
    end
  end



  describe "grams#update action" do

    it "should not let users who didnt create the gram update it" do
      gram = FactoryGirl.create(:gram)
      new_user = FactoryGirl.create(:user)

      sign_in new_user

      patch :update, id: gram.id, gram: {message: 'changed'}
      expect(response).to have_http_status(:forbidden)
    end


    it "should not let unautheticated users update a gram" do
      gram = FactoryGirl.create(:gram)
      delete :update, id: gram.id

      expect(response).to redirect_to new_user_session_path
    end

    it "should allow users to successfully update the gram" do
      gram = FactoryGirl.create(:gram, message: "Initial Value")

      sign_in gram.user

      patch :update, id: gram.id, gram: { message: 'changed'}

      expect(response).to redirect_to root_path

      gram.reload
      expect(gram.message).to eq("changed")
    end

    it "should return 404 error message if the gram is not found" do
      user = FactoryGirl.create(:user)
      sign_in user
      patch :update, id: "TATERE", gram: {message: "changed"}
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      gram = FactoryGirl.create(:gram, message: "Initial Value")
      sign_in gram.user
      patch :update, id: gram.id, gram: { message: ""}

      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.message).to eq("Initial Value")
    end

  end

  describe "grams#edit action" do

    it "should not let a user who did not create the gram to edit a gram" do
      gram = FactoryGirl.create(:gram)

      new_user = FactoryGirl.create(:user)
      sign_in new_user

      get :edit, id: gram.id
      expect(response).to have_http_status(:forbidden)
    end

    it "should not let unautheticated users edit a gram" do
      gram = FactoryGirl.create(:gram)
      delete :edit, id: gram.id

      expect(response).to redirect_to new_user_session_path
    end

    it "should show the edit form if the gram is found" do
      gram = FactoryGirl.create(:gram)
      sign_in gram.user
      get :edit , id: gram.id

      expect(response).to have_http_status(:success)
    end

    it "should return 404 error message when the gram is not found" do
      user = FactoryGirl.create(:user)
      sign_in user
      get :edit , id: "TAAGET"

      expect(response).to have_http_status(:not_found)
    end

  end

  describe "grams#show action" do
    it "should successfully show the page when gram is found in database" do
      gram = FactoryGirl.create(:gram)
      get :show, id: gram.id

      expect(response).to have_http_status(:success)

    end

    it "should return 404 error if the gram is not found" do
      get :show, id: "TACATO"

      expect(response).to have_http_status(:not_found)
    end
  end


  describe "grams#index action" do

    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end

  end

  describe "grams#new action" do

    it "should require uesrs to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "it should successfully show the new form" do
      user = FactoryGirl.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#create action" do

    it "should require users to be logged in" do
      post :create, gram: {message: "Hello"}
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully create a new gram in our database" do

      user = FactoryGirl.create(:user)
      sign_in user


      post :create, gram: {message: 'Hello'}
      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.message).to eq("Hello")
      expect(gram.user).to eq(user)
    end

    it "should properly deal with validation errors" do

      user = FactoryGirl.create(:user)
      sign_in user

      post :create, gram: { message: ' ' }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq 0
    end



  end


end
