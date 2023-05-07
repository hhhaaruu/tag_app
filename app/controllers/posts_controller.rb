class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update]

  def index
    @posts = Post.all
  end

  def new
    @post_form = PostForm.new
  end

  def create
    @post_form = PostForm.new(post_form_params)
    if @post_form.valid?
      @post_form.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    post_attributes = @post.attributes
    @post_form = PostForm.new(post_attributes)
    @post_form.tag_name = @post.tags.first&.tag_name
  end

  def update
    @post_form = PostForm.new(post_form_params)
    @post_form.image ||= @post.image.blob

    if @post_form.valid? 
      @post_form.update(post_form_params, @post)
      redirect_to root_path
    else
      render :edit
    end
  end

  def search
    ## フォーム入力が空の場合nilを返す
    return nil if params[:keyword] == ""

    ## Tagモデルより入力されたtag_nameより逐次検索を行いtagへ代入する
    tag = Tag.where(['tag_name LIKE ?', "%#{params[:keyword]}%"] )

    ## renderメソッドを使用してjsonの情報を返す
    render json:{ keyword: tag }
  end

  private
  def post_form_params
    params.require(:post_form).permit(:text, :image, :tag_name)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
