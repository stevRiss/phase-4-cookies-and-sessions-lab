class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    article = Article.find(params[:id])
    # views = session[:page_views]

    session[:page_views] ||= 0

    if session[:page_views] <= 3

      session[:page_views] += 1

      render json: article
    else
      render json: article.errors("Maximum pageviews exceeded"), status: 401
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
