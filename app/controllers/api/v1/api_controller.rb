class Api::V1::CallbackController < ApplicationController

  def callback
    render json: {test: "test"}
  end

end
