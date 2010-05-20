class CardSetsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource


  # GET /card_sets
  def index
    @card_sets = CardSet.all

    respond_to do |format|
      format.html
    end
  end


  # GET /card_sets/1
  def show

    respond_to do |format|
      format.html
    end
  end


  # GET /card_sets/new
  def new
    @card_set.custom = can?( :edit, CardSet ) ? false : true
    @all_cards = Card.all

    respond_to do |format|
      format.html
    end
  end


  # GET /card_sets/1/edit
  def edit

    respond_to do |format|
      format.html
    end
  end

  # POST /card_sets
  def create
    @card_set.creator = current_user

    respond_to do |format|
      if @card_set.save
        flash[:notice] = 'CardSet was successfully created.'
        format.html { redirect_to(@card_set) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /card_sets/1
  def update

    respond_to do |format|
      if @card_set.update_attributes(params[:card_set])
        flash[:notice] = 'CardSet was successfully updated.'
        format.html { redirect_to(@card_set) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /card_sets/1
  # DELETE /card_sets/1.xml
  def destroy
    @card_set.destroy

    respond_to do |format|
      format.html { redirect_to card_sets_url }
    end
  end
end