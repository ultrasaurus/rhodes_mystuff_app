require 'rho'
require 'rho/rhocontroller'
require 'rho/rhoerror'

class SettingsController < Rho::RhoController
  
  def index
    @msg = @params['msg']
    render
  end

  def login
    @msg = @params['msg']
    render :action => :login
  end

  def start
      @logged_in = SyncEngine::logged_in
      if @logged_in == 0
        @logged_in = SyncEngine.login("admin", "password", (url_for :action => :login_callback) )
        render :action => :wait
      else
        WebView.navigate ( url_for :action => :login_callback, :params => 'error_code=0')
      end
  end

  def login_callback
    err_code = @params['error_code'].to_i
    if err_code == 0
      Image.set_notification( (url_for :controller => 'Image'), '')
      SyncEngine::dosync 
      render :controller => 'Image'
    else
      @msg = @params['error_message']
      if @msg == nil or @msg.length == 0 
        @msg = Rho::RhoError.new(err_code).message
      end
      WebView.navigate ( url_for :action => :login, :query => {:msg => @msg} )
    end  
  end

  def do_login
    if @params['login'] and @params['password']
      begin
        SyncEngine.login(@params['login'], @params['password'], (url_for :action => :login_callback) )
        render :action => :wait
      rescue Rho::RhoError => e
        @msg = e.message
        render :action => :login, :query => {:msg => @msg}
      end
    else
      @msg = "You entered an invalid login/password, please try again." unless @msg.length    
      render :action => :login, :query => {:msg => @msg}
    end
  end
  
  def logout
    SyncEngine.logout
    @msg = "You have been logged out."
    render :action => :login, :query => {:msg => @msg}
  end
  
  def reset
    render :action => :reset
  end
  
  def do_reset
    Rhom::Rhom.database_full_reset
    SyncEngine.dosync
    @msg = "Database has been reset."
    redirect :action => :index, :query => {:msg => @msg}
  end
  
  def do_sync
    SyncEngine.dosync
    @msg =  "Sync has been triggered."
    redirect :action => :index, :query => {:msg => @msg}
  end
end
