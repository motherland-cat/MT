# -*- coding: utf-8 -*-
require "spec_helper"

describe "actualities/_index.html.erb", type: :view, actuality: true do

  subject { rendered }

  let(:admin) { FactoryGirl.create(:admin) }
  let(:user) { FactoryGirl.create(:user) }
  let!(:actuality) { FactoryGirl.create(:actuality) }
  
  before { assign(:actualities, Actuality.paginate(:page => 1, :per_page => 5)) }
  
  context "if the user is an admin" do
    before { assign(:current_user, admin) }
    
    it "renders the actuality and the add button" do
      render partial: "actualities/index"
      expect(response).to render_template(:partial => "actualities/_show", :locals => {actuality: actuality})
      should have_button("Ajouter une actualité")
    end
  end
  
  context "if the user is not an admin" do
    before { assign(:current_user, user) }
    
    it "renders the actuality and not the add button" do
      render partial: "actualities/index"
      expect(response).to render_template(:partial => "actualities/_show", :locals => {actuality: actuality})
      should have_no_button("Ajouter une actualité")
    end
  end
  
  context "if the user is not signed in" do    
    it "renders the actuality and not the add button" do
      render partial: "actualities/index"
      expect(response).to render_template(:partial => "actualities/_show", :locals => {actuality: actuality})
      should have_no_button("Ajouter une actualité")
    end
  end
end
