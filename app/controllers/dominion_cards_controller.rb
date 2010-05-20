class DominionCardsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  before_filter :get_dominion_cards, :only => [:index]
  load_and_authorize_resource :resource => 'Card'


  # GET /dominion/cards
  def index

    respond_to do |format|
      format.html # index.html.erb
    end
  end


  # GET /dominion/cards/1
  def show

    respond_to do |format|
      format.html # show.html.erb
    end
  end


  # GET /dominion/cards/new
  def new

    respond_to do |format|
      format.html # new.html.erb
    end
  end


  # GET /dominion/cards/1/edit
  def edit

    respond_to do |format|
      format.html # edit.html.erb
    end
  end


  # POST /dominion/cards
  def create
    @dominion_card.attributes = params[:card]
    @dominion_card.creator = current_user
    @dominion_card.game = @dominion_card.game.dehumanize

    respond_to do |format|
      if @dominion_card.save
        flash[:notice] = 'Card was successfully created.'
        format.html { redirect_to(dominion_card_path(@dominion_card)) }
      else
        format.html { render :template => "dominion_cards/new" }
      end
    end
  end


  # PUT /dominion/cards/1
  def update
    @dominion_card.attributes = params[:card]

    respond_to do |format|
      if @dominion_card.update_attributes(params[:card])
        flash[:notice] = 'Card was successfully updated.'
        format.html { redirect_to(dominion_card_path(@dominion_card)) }
      else
        format.html { render :template => "dominion_cards/edit" }
      end
    end
  end

  # DELETE /dominion/cards/1
  def destroy
    @dominion_card.destroy

    respond_to do |format|
      format.html { redirect_to(dominion_cards_url) }
    end
  end


  private

  def get_dominion_cards
    @dominion_cards = Card.dominion
  end
end
