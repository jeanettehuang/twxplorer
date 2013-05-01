class TestController < ApplicationController
  def index
    @test = params[:id]
  end
end