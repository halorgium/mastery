module Mastery
  class SpikesController < ApplicationController
    def show
      render params[:id]
    end
  end
end
