class UsersController < ApplicationController
  def index
    @test = "nothing"
    @test = "can read" if can? :read, User
  end
end
