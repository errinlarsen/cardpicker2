class CardSetsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  load_and_authorize_resource
  
  # GET /card_sets
  # GET /card_sets.xml
  def index
    @game = params[:game] ||= ""
    @card_sets = CardSet.all( :order => 'set_type, name' )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @card_sets }
    end
  end

  # GET /card_sets/1
  # GET /card_sets/1.xml
  def show
    @game = params[:game] ||= ""
    @card_set = CardSet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @card_set }
    end
  end

  # GET /card_sets/random
  # GET /card_sets/random.xml
  def random
    @game = params[:game] ||= ""
    @card_set = CardSet.new( :name => "New Set of 10", :set_type => "Set of 10" )
    dominion_set = DominionSet.new( :bsw_style => true )
    @cards = dominion_set.generate.sort { |a,b| a.sort_cost <=> b.sort_cost }

    respond_to do |format|
      format.html
      format.xml  { render :xml => @card_set }
    end
  end

  # GET /card_sets/new
  # GET /card_sets/new.xml
  def new
    @game = params[:game] ||= ""
    unless request.format.xml?
      @card_set = CardSet.new

    # Give XML requests sample data for reference
    else
      @card_set = CardSet.new(
        :name => "Sample Set",
        :set_type => "Sample",
        :comments => "This is a Card Set sample."
      )

      @card_set.cards.build(
        :game => "Sample: the Game",
        :expansion => "Base",
        :name => "First Sample",
        :card_type => "Sample",
        :cost => "1",
        :card_text => "This is sample card #1"
      )

      @card_set.cards.build(
        :game => "Sample: the Game",
        :expansion => "Base",
        :name => "Second Sample",
        :card_type => "Sample",
        :cost => "1",
        :card_text => "This is sample card #2"
      )
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @card_set.to_xml( :include => :cards, :except => [:id, :created_at, :updated_at] ).gsub( /<(\/?cards)(.*)>/, '<\1-attributes\2>')}
    end
  end

  # GET /card_sets/1/edit
  def edit
    @game = params[:game] ||= ""
    @card_set = CardSet.find(params[:id])
  end

  # POST /card_sets
  # POST /card_sets.xml
  def create
    @game = params[:game] ||= ""
    @card_set = CardSet.new(params[:card_set])
    @card_set.creator = current_user

    respond_to do |format|
      if @card_set.save
        flash[:notice] = 'CardSet was successfully created.'
        format.html { redirect_to game_card_set_url @game, @card_set }
        format.xml  { render :xml => @card_set, :status => :created, :location => @card_set }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @card_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /card_sets/1
  # PUT /card_sets/1.xml
  def update
    @game = params[:game] ||= ""
    params[:card_set][:card_ids] ||= []
    @card_set = CardSet.find(params[:id])

    respond_to do |format|
      if @card_set.update_attributes(params[:card_set])
        flash[:notice] = 'CardSet was successfully updated.'
        format.html { redirect_to game_card_set_url @game, @card_set }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @card_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /card_sets/1
  # DELETE /card_sets/1.xml
  def destroy
    @game = params[:game] ||= ""
    @card_set = CardSet.find(params[:id])
    @card_set.destroy

    respond_to do |format|
      format.html { redirect_to game_card_sets_url @game }
      format.xml  { head :ok }
    end
  end
end