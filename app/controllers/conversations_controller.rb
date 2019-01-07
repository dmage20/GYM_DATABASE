class ConversationsController < ApplicationController
  def index
    @users = User.all
    # @conversations = Conversation.all
    @conversations = Conversation.where("(conversations.sender_id = ? OR conversations.recipient_id =?)", current_user.id, current_user.id)
  end
  def create
    if Conversation.between(params[:sender_id],params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    redirect_to conversation_messages_path(@conversation)
    end


  end
  def destroy

      @conversation = Conversation.where(conversation_params)
      @conversation.destroy_all

      redirect_to conversations_path
  end

  private

  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end

end
