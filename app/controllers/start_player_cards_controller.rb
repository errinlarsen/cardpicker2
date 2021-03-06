class StartPlayerCardsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index, :random]
  load_and_authorize_resource :resource => 'Card'


  # GET /start_player/cards
  def index
    @start_player_cards = Card.start_player
  end


  # GET /start_player/cards/1
  def show
  end


  # GET /start_player/cards/new
  def new
    @start_player_card.attributes = {
            :game => 'start_player',
            :custom => true,
            :expansion => 'Custom Cards'
            }
  end


  # GET /start_player/cards/1/edit
  def edit
  end


  # POST /start_player/cards
  def create
    @start_player_card.attributes = params[:card]
    @start_player_card.creator = current_user
    @start_player_card.game = @start_player_card.game.dehumanize

    respond_to do |format|
      if @start_player_card.save
        flash[:notice] = 'Card was successfully created.'
        format.html { redirect_to(start_player_card_path(@start_player_card)) }
      else
        format.html { render :template => "start_player_cards/new" }
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
        format.html { render :template => "start_player_cards/edit" }
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
