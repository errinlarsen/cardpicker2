class CardsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  load_and_authorize_resource
  
  # GET /cards
  # GET /cards.xml
  def index
    @game = params[:game] ||= ""
    if @game.empty?
      @cards = Card.all( :order => "game, expansion, name" )
    else
      @cards = Card.find_all_by_game( @game, :order => "expansion, name" )
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cards }
    end
  end

  # GET /cards/1
  # GET /cards/1.xml
  def show
    @game = params[:game] ||= ""

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @card }
    end
  end

  # GET /cards/random
  # GET /cards/random.xml
  def random
    @game = params[:game] ||= ""
    @card = Card.find_all_by_game( @game ).shuffle.shift

    respond_to do |format|
      format.html do
        if @game.blank?
          redirect_to(@card)
        else
          redirect_to game_card_url( @game, @card )
        end
      end
      format.xml  { render :xml => @card }
    end
  end

  # GET /cards/new
  # GET /cards/new.xml
  def new
    @game = params[:game] ||= ""
    if request.format.xml?
      # Give XML requests sample data for reference
      @card = Card.new(
        :game => "Sample: the Game",
        :expansion => "Base",
        :name => "Sample Name",
        :card_type => "Sample",
        :cost => "1",
        :card_text => "This is a sample card"
      )
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @card.to_xml( :except => [:id, :created_at, :updated_at] )}
    end
  end

  # GET /cards/1/edit
  def edit
    @game = params[:game] ||= ""
  end

  # POST /cards
  # POST /cards.xml
  def create
    @game = params[:game] ||= ""
    @card.creator = current_user
    @card.game = @card.game.dehumanize

    respond_to do |format|
      if @card.save
        flash[:notice] = 'Card was successfully created.'
        format.html do
          if @game.blank?
            redirect_to(@card)
          else
            redirect_to game_card_url @game, @card
          end
        end
        format.xml  { render :xml => @card, :status => :created, :location => @card }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @card.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cards/1
  # PUT /cards/1.xml
  def update
    @game = params[:game] ||= ""

    respond_to do |format|
      if @card.update_attributes(params[:card])
        flash[:notice] = 'Card was successfully updated.'
        format.html do
          if @game.blank?
            redirect_to(@card)
          else
            redirect_to game_card_url @game, @card
          end
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @card.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.xml
  def destroy
    @game = params[:game] ||= ""
    @card.destroy

    respond_to do |format|
      format.html do
        if @game.blank?
          redirect_to(cards_url)
        else
          redirect_to game_cards_url @game
        end
      end
      format.xml  { head :ok }
    end
  end
end
