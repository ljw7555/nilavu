##
## Copyright [2013-2015] [Megam Systems]
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
class PasswordResetsController < ApplicationController

  skip_before_action :require_signin, only: [:edit, :create, :update]

  ##if the email doesn't exist in our system we ask to signup.
  ##if not, we pull the info of the user and do an account update.
  def create
    my_account = Accounts.new
    #redirect_to signup_path, :flash => { :error => "Your email has gone fishing! Please sign up."} and return if !my_account.dup?(params[:email])
    puts params[:email]
    my_account.send_password_reset(params[:email]) do
    end
  end

  def edit
    account = Accounts.new
    @account = account.find_by_password_reset_key(params[:id], params[:email])
    @account
  end

  def update
    acc_obj = Accounts.new
    @acc = acc_obj.find_by_password_reset_key(params[:id], params[:email])

    if @acc['password_reset_sent_at'] < 2.hours.ago
      redirect_to signin_path, :alert => "Password reset has expired."
    elsif true
      update_options = { "password" => acc_obj.password_encrypt(params[:password]), "password_confirmation" => user_obj.password_encrypt(params[:password_confirmation]) }
      #res_update = acc_obj.update_columns(update_options, params[:email])
      update = acc_obj.update(update_options, params[:email])

      ######ALERT: YET TO BE TESTED -  SINCE MAIL FUNCTIONALITY WAS BROKEN!!!!#######

      redirect_to root_url, :notice => "Password has been reset!"
    else
      render :edit
    end
  end
end
