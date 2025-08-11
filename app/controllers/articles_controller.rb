class ArticlesController < ApplicationController
  before_action :set_article, only: [ :show, :edit, :update, :destroy ]
  before_action :require_user, except: [ :show, :index ]
  before_action :require_same_user, only: [ :edit, :update, :destroy ]

  def show
  end

  def index
    @articles = Article.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = current_user.articles.build(article_params)

    if @article.save
      process_tags(@article, params[:article][:tag_list])
      flash[:notice] = "Article was created successfully."
      redirect_to @article
    else
      render "new", status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params)
      process_tags(@article, params[:article][:tag_list])
      flash[:notice] = "Article was updated successfully."
      redirect_to @article
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description)
  end

  def process_tags(article, tag_string)
    return if tag_string.blank?

    tag_names = tag_string.split(",").map(&:strip).reject(&:blank?)
    tag_names.each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name)
      article.tags << tag unless article.tags.include?(tag)
    end
  end

  def require_same_user
    if current_user != @article.user && !current_user.admin?
      flash[:alert] = "You can only edit or delete your own article"
      redirect_to @article
    end
  end
end
