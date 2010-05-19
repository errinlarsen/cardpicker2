class StartPlayerCardSetsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :resource => 'CardSet'

  # GET /start_player/card_sets
  def index
    @start_player_card_sets = CardSet.start_player

    respond_to do |format|
      format.html
    end
  end

  # GET /start_player/card_sets/1
  def show
    respond_to do |format|
      format.html
    end
  end


  # GET /start_player/card_sets/new
  def new
    @start_player_card_set.game = 'start_player'
    @start_player_card_set.custom = can?( :edit, CardSet ) ? false : true
    @all_cards = Card.start_player

    respond_to do |format|
      format.html
    end
  end


  # GET /start_player/card_sets/1/edit
  def edit
    @all_cards = Card.start_player
  end

  # POST /start_player/card_sets
  def create
    @start_player_card_set.creator = current_user

    respond_to do |format|
      if @start_player_card_set.save
        flash[:notice] = 'CardSet was successfully created.'
        format.html { redirect_to start_player_card_set_url @start_player_card_set }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /start_player/card_sets/1
  def update

    respond_to do |format|
      if @start_player_card_set.update_attributes(params[:card_set])
        flash[:notice] = 'CardSet was successfully updated.'
        format.html { redirect_to start_player_card_set_url @start_player_card_set }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /card_sets/1
  # DELETE /card_sets/1.xml
  def destroy
    @start_player_card_set.destroy

    respond_to do |format|
      format.html { redirect_to start_player_card_sets_url }
    end
  end
end
