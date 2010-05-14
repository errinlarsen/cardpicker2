class CardSetsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index, :random, :random_options]
  load_and_authorize_resource
  
  # GET /card_sets
  # GET /card_sets.xml
  def index
    @game = params[:game] ||= ""
    if @game.empty?
      @card_sets = CardSet.all( :order => 'game, set_type, name' )
    else
      @card_sets = CardSet.find_all_by_game( @game, :order => 'set_type, name' )
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @card_sets }
    end
  end

  # GET /card_sets/1
  # GET /card_sets/1.xml
  def show
    @game = params[:game] ||= ""

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @card_set }
    end
  end

  # GET /card_sets/random
  # GET /card_sets/random.xml
  def random
    @game = params[:game] ||= ""
    case @game
    when 'dominion'
      @card_set = CardSet.new( :game => @game, :name => "New Set of 10", :set_type => "Set of 10" )
      @dsoptions = DominionSetOptions.new( params[:dominion_set_options] || session[:dominion_set_options] || {} )
      session[:dominion_set_options] = @dsoptions.to_hash
      dominion_set = DominionSet.new( @dsoptions )
      @cards = dominion_set.generate
      @cards.sort! { |a,b| a.sort_cost <=> b.sort_cost }
    end


    respond_to do |format|
      format.html
      # TODO create sample data for xml rendering above
      format.xml  { render :xml => @card_set }
    end
  end

  def random_options
    @game = params[:game] ||= ""
    @all_expansions = Card.find_all_by_custom( false ).collect { |card| card.expansion }.uniq
    @dsoptions = DominionSetOptions.new( session[:dominion_set_options] || {} )

    respond_to do |format|
      format.html #random_options.html.erb
      # TODO confirm that the following code works as intended
      format.xml  { render :xml => @dsoptions.to_hash }
    end
  end


  # GET /card_sets/new
  # GET /card_sets/new.xml
  def new
    @game = params[:game] ||= ""
    if request.format.xml?
      # Give XML requests sample data for reference
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
  end

  # POST /card_sets
  # POST /card_sets.xml
  def create
    @game = params[:game] ||= ""
    @card_set.creator = current_user

    respond_to do |format|
      if @card_set.save
        flash[:notice] = 'CardSet was successfully created.'
        format.html do
          if @game.blank?
            redirect_to(@card_set)
          else
            redirect_to game_card_set_url @game, @card_set
          end
        end
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
    # Why is the following necessary?
#    params[:card_set][:card_ids] ||= []

    respond_to do |format|
      if @card_set.update_attributes(params[:card_set])
        flash[:notice] = 'CardSet was successfully updated.'
        format.html do
          if @game.blank?
            redirect_to(@card_set)
          else
            redirect_to game_card_set_url @game, @card_set
          end
        end
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
    @card_set.destroy

    respond_to do |format|
      format.html do
        if @game.blank?
          redirect_to(card_sets_url)
        else
          redirect_to game_card_sets_url @game
        end
      end
      format.xml  { head :ok }
    end
  end
end