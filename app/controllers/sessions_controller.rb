class SessionsController < ApplicationController
    def new
        if logged_in?
            redirect_to root_url
        end
    end

    def create
        account = Account.find_by(name: params[:name])
        if account && account.authenticate(params[:password])
            # 認証成功

            # セッションを再作成
            login(account)

            # トップへリダイレクト
            redirect_to root_url
        else
            # 認証失敗
            flash.now[:danger] = "アカウント名かパスワードが間違っています"
            render :new
        end
    end

    def destroy
        logout
        redirect_to root_url
    end
end
