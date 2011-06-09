module Mastery
  class AuthoritiesController < ApplicationController
    respond_to :json

    def show
      respond_with(authority) do |format|
        #format.html
        format.json { render :json => authority }
      end
    end

    def update
      args = params[:args]
      result = {:result => authority.accept(params[:message], *args)}

      respond_with(result) do |format|
        format.json { render :json => result }
      end
    end

    private

    def authority
      @authority ||= vat.authorities.where(:name => params[:id]).first
    end

    def vat
      @vat ||= Vat.where(:name => params[:vat_id]).first
    end
  end
end
