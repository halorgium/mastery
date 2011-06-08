module Mastery
  class AuthoritiesController < ApplicationController
    respond_to :json

    def show
      vat = Vat.where(:name => params[:vat_id]).first
      authority = vat.authorities.where(:name => params[:id]).first

      respond_with(authority) do |format|
        #format.html
        format.json { render :json => authority }
      end
    end
  end
end
