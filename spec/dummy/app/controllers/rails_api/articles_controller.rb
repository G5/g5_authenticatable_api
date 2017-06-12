module RailsApi
  class ArticlesController < ApplicationController
    before_action :authenticate_api_user!

    respond_to :json

    def index
      respond_with(Article.all)
    end
  end
end
