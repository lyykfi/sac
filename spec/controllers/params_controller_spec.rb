require 'spec_helper'

describe ParamsController do

  describe "GET 'names_by_level'" do
    it "returns http success" do
      get 'names_by_level'
      response.should be_success
    end
  end

  describe "GET 'vals_by_param_id_and_year'" do
    it "returns http success" do
      get 'vals_by_param_id_and_year'
      response.should be_success
    end
  end

end
