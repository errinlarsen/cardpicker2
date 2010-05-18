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
      if params[:rds_options]
        # incoming options from params = new options; save to session
        puts "params = #{params.inspect}"
        # FIXME params[:max_attacks_toggle] is not being handled correctly
        options = session[:rds_options] = symbolize_params_keys( params[:rds_options] )
      elsif session[:rds_options]
        # no incoming params and previously saved options from session; merge in replace request
        options = Hash[session[:rds_options]]
        options.merge!( symbolize_params_keys(  params[:replace] )) unless params[:replace].nil?
      else
        # Create new options from defaults and save to the session
        options = session[:rds_options] = RandomDominionSet::DEFAULT_OPTIONS
      end
      
      @rds = RandomDominionSet.new( options )
    end

    respond_to do |format|
      format.html
      # TODO create sample data for xml rendering above
      format.xml  { render :xml => @card_set }
    end
  end


  def random_options
    @game = params[:game] ||= ""
    case @game
    when 'dominion'
      @all_expansions = Card.dominion.all_expansions
      @options = Hash[session[:rds_options]] || RandomDominionSet::DEFAULT_OPTIONS
    end

    respond_to do |format|
      format.html #random_options.html.erb
      # TODO confirm that the following code works as intended
      format.xml  { render :xml => @options }
    end
  end


  # GET /card_sets/new
  # GET /card_sets/new.xml
  def new
    @game = params[:game] ||= ""
    case @game
    when 'dominion'      
      if @random_set = session[:new_random_dominion_set]
        @card_set.attributes = {
          :game => @game,
          :set_type => 'Set of 10',
          :comments => "Options used:\n #{@random_set[:options].reject { |k, v| v.nil? || v.empty? }.to_yaml}" }
        session[:new_random_dominion_set] = nil
      end
    end
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

  private
  def symbolize_params_keys(hash)
    hash.inject({}){|result, (key, value)|
      new_key = case key
                when String then key.to_sym
                else key
                end
      new_value = case value
                  when Hash then symbolize_keys(value)
                  else value
                  end
      result[new_key] = new_value
      result
    }
  end
end