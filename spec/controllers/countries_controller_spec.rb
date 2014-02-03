require 'spec_helper'

describe CountriesController do

  describe "GET 'russia'" do
    it "returns http success" do
      get 'russia'
      response.should be_success
    end
  end

end
