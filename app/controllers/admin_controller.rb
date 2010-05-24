class AdminController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource :resource => :user

  # GET /admin
  # GET /admin.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /admin/1
  # GET /admin/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /admin/new
  # GET /admin/new.xml
  def new
    unless request.format.xml?
      @user = User.new

    # Give XML requests sample data for reference
    else
      @user = User.new(
        :email => "sample@sample.com",
        :role => "consumer",
        :password => "sample"
      )
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /admin/1/edit
  def edit
    @user = User.find(params[:id])
  end
  
  ## GET /admin/1/reset
  ## PUT /admin/1/reset
  def reset
    if request.method == :put
      @user = User.find(params[:id])

      respond_to do |format|
        if @user.update_attributes(params[:user])
          flash[:notice] = 'User was successfully reset.'
          format.html { redirect_to(admin_path(@user)) }
          format.xml  { head :ok }
        else
          format.html { render :action => "reset" }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
      end

    else
      @user = User.find(params[:id])

    end
  end

  # POST /admin
  # POST /admin.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(admin_path(@user)) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/1
  # PUT /admin/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(admin_path(@user)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/1
  # DELETE /admin/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(admin_index_url) }
      format.xml  { head :ok }
    end
  end
end
