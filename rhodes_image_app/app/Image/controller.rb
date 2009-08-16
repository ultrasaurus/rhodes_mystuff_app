require 'rho/rhocontroller'

class ImageController < Rho::RhoController

  #GET /Image
  def index
    @images = Image.find(:all)
    render
  end
  
  def sync_callback
     WebView.navigate ( url_for :action => :index)
  end

  # GET /Image/{1}
  def show
    @image = Image.find(@params['id'])
    render :action => :show
  end

  # GET /Image/new
  def new
    @image = Image.new
    render :action => :new
  end

  # GET /Image/{1}/edit
  def edit
    @image = Image.find(@params['id'])
    render :action => :edit
  end

  # POST /Image/create
  def create
    @image = Image.new(@params['image'])
    @image.save
    redirect :action => :index
  end

  # POST /Image/{1}/update
  def update
    @image = Image.find(@params['id'])
    @image.update_attributes(@params['image'])
    redirect :action => :index
  end

  # POST /Image/{1}/delete
  def delete
    @image = Image.find(@params['id'])
    @image.destroy
    redirect :action => :index
  end
end
