class CommentsController < ApplicationController

  before_action :authenticate_user!

  def create
    find_commentable
  	@comment = @commentable.comments.new comment_params
    @comment.user = current_user
    @comment.save
    redirect_to @commentable
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end

    def find_commentable
      @commentable = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
      @commentable = Product.find_by_id(params[:product_id]) if params[:product_id]
    end

end
