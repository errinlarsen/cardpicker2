class StartPlayerCardsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index, :random]
  load_and_authorize_resource :resource => 'Card'


  # GET /start_player/cards
  def index
    @start_player_cards = Card.start_player

    respond_to do |format|
      format.html # index.html.erb
    end
  end


  # GET /start_player/cards/1
  def show

    respond_to do |format|
      format.html # show.html.erb
    end
  end


  # GET /start_player/cards/random
  def random
    @start_player_card = Card.random_start_player_card

    respond_to do |format|
      format.html { redirect_to(start_player_card_path(@start_player_card)) }
    end
  end


  # GET /start_player/cards/new
  def new

    respond_to do |format|
      format.html # new.html.erb
    end
  end


  # GET /start_player/cards/1/edit
  def edit

    respond_to do |format|
      format.html # edit.html.erb
    end
  end


  # POST /start_player/cards
  def create
    @start_player_card.creator = current_user
    @start_player_card.game = @start_player_card.game.dehumanize

    respond_to do |format|
      if @start_player_card.save
        flash[:notice] = 'Card was successfully created.'
        format.html { redirect_to(start_player_card_path(@start_player_card)) }
      else
        format.html { render :action => "new" }
      end
    end
  end


  # PUT /start_player/cards/1
  def update

    respond_to do |format|
      if @start_player_card.update_attributes(params[:card])
        flash[:notice] = 'Card was successfully updated.'
        format.html { redirect_to(start_player_card_path(@start_player_card)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end


  # DELETE /start_player/cards/1
  def destroy
    @start_player_card.destroy

    respond_to do |format|
      format.html { redirect_to start_player_cards_path }
    end
  end
end
