class CardsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  
  # GET /cards
  # GET /cards.xml
  def index
    @cards = Card.all( :order => "game, expansion, name" )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cards }
    end
  end

  # GET /cards/1
  # GET /cards/1.xml
  def show
    @card = Card.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @card }
    end
  end

  # GET /cards/new
  # GET /cards/new.xml
  def new
    unless request.format.xml?
      @card = Card.new

    # Give XML requests sample data for reference
    else
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
    @card = Card.find(params[:id])
  end

  # POST /cards
  # POST /cards.xml
  def create
    @card = Card.new(params[:card])

    respond_to do |format|
      if @card.save
        flash[:notice] = 'Card was successfully created.'
        format.html { redirect_to(@card) }
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
    @card = Card.find(params[:id])

    respond_to do |format|
      if @card.update_attributes(params[:card])
        flash[:notice] = 'Card was successfully updated.'
        format.html { redirect_to(@card) }
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
    @card = Card.find(params[:id])
    @card.destroy

    respond_to do |format|
      format.html { redirect_to(cards_url) }
      format.xml  { head :ok }
    end
  end
end
