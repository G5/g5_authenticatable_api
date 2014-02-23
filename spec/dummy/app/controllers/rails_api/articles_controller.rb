module RailsApi
  class ArticlesController < ApplicationController
    respond_to :json

    def index
      respond_with(Article.all)
    end
  end
end
