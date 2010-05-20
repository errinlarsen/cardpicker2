class CardsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource


  # GET /cards
  def index
    @cards = Card.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end


  # GET /cards/1
  def show

    respond_to do |format|
      format.html # show.html.erb
    end
  end


  # GET /cards/new
  def new

    respond_to do |format|
      format.html # new.html.erb
    end
  end


  # GET /cards/1/edit
  def edit

    respond_to do |format|
      format.html # edit.html.erb
    end
  end


  # POST /cards
  def create
    @card.creator = current_user
    @card.game = @card.game.dehumanize

    respond_to do |format|
      if @card.save
        flash[:notice] = 'Card was successfully created.'
        format.html { redirect_to(@card) }
      else
        format.html { render :action => "new" }
      end
    end
  end


  # PUT /cards/1
  def update

    respond_to do |format|
      if @card.update_attributes(params[:card])
        flash[:notice] = 'Card was successfully updated.'
        format.html { redirect_to(@card) }
      else
        format.html { render :action => "edit" }
      end
    end
  end


  # DELETE /cards/1
  def destroy
    @card.destroy

    respond_to do |format|
      format.html { redirect_to(cards_url) }
    end
  end
end
