class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task

  def create
    @comment = @task.comments.new(comment_params.merge(user: current_user))

    if @comment.save
      redirect_to project_task_path(id: @task), notice: 'Comment was successfully posted.'
    else
      redirect_to project_task_path(id: @task), alert: "Don't submit empty comments!"
    end
  end

  private

  def set_task
    @task ||= Task.find(params[:task_id])
  end

  def comment_params
    params.require(:comment).permit(:text)
  end
end
