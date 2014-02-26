module RailsApi
  class ArticlesController < ApplicationController
    before_filter :authenticate_api_user!

    respond_to :json

    def index
      respond_with(Article.all)
    end
  end
end
