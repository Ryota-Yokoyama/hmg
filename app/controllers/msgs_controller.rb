class MsgsController < ApplicationController
  before_action :logged_in_user, only:[:index,:select_user,:new,:create,:destroy]
  def index
    @msg_users = MsgUser.where("user_id=#{current_user.id}")
  end
  
  def select_user
   
  end

  def query_user
    session[:query_users] = nil
    query_users = query
    session[:query_users] = query
    redirect_to "/msgs/select_user"
  end

  def new
    @msg = Msg.new 
    cid = current_user.id
    @msgs = Msg.where("(sender_id = #{params[:id]} and reciever_id= #{cid}) or (sender_id = #{cid} and reciever_id = #{params[:id]})")
  end

  def create
    msg = Msg.new
    msg.sender_id = current_user.id
    msg.reciever_id = params[:id]
    msg.msg = params[:msg][:msg]
    msg.save!
    redirect_to "/msgs/#{params[:id]}"
  end

  private
    def query
      if params[:user].present? && !params[:user][:name].empty?
        return User.where('name LIKE ?',"%#{params[:user][:name]}%")
      else
        return []
      end
    end
end
