class DominionCardSetsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index, :random, :random_options]
  before_filter :get_dominion_card_sets, :only => [:index]
  load_and_authorize_resource :resource => 'CardSet'


  # GET /dominion/card_sets
  def index

    respond_to do |format|
      format.html # index.html.erb
    end
  end


  # GET /dominion/card_sets/1
  def show

    respond_to do |format|
      format.html # show.html.erb
    end
  end


  # GET /dominion/card_sets/random
  def random
    options = parse_params!
    @rds = RandomDominionSet.new( options )
    flash.now[:notice] = @rds.replacement_message if params[:replace]
    session[:new_rds] = Hash[@rds.options].update( { :replace_includes => @rds.card_ids} )
  end


  # GET /dominion/card_sets/random
  def random_options
    @all_expansions = Card.all_dominion_expansions
    @options = Hash[session[:rds_options]] || RandomDominionSet::DEFAULT_OPTIONS
  end


  # GET /dominion/card_sets/new
  def new
    @dominion_card_set.game = 'dominion'
    @dominion_card_set.custom = can?( :edit, CardSet ) ? false : true

    if session[:new_rds]
      @rds = RandomDominionSet.new( session[:new_rds] )
      @dominion_card_set.attributes = {
              :set_type => 'Set of 10',
              :custom => true,
              :comments => "Options used:\n #{@rds.options.reject { |k, v| v.blank? }.to_yaml}" }
      session.delete( :new_rds )
    end

    respond_to do |format|
      format.html
    end
  end


  # GET /dominion/card_sets/1/edit
  def edit

    respond_to do |format|
      format.html
    end
  end

  # POST /dominion/card_sets
  def create
    @dominion_card_set.attributes = params[:card_set]
    @dominion_card_set.creator = current_user

    respond_to do |format|
      if @dominion_card_set.save
        flash[:notice] = 'CardSet was successfully created.'
        format.html { redirect_to( dominion_card_set_url(@dominion_card_set) )}
      else
        format.html { render :template => "dominion_card_sets/new" }
      end
    end
  end


  # PUT /dominion/card_sets/1
  def update
    @dominion_card_set.attributes = params[:card_set]
    params[:card_set][:card_ids] ||= []

    respond_to do |format|
      if @dominion_card_set.update_attributes(params[:card_set])
        flash[:notice] = 'CardSet was successfully updated.'
        format.html { redirect_to( dominion_card_set_url(@dominion_card_set) )}
      else
        format.html { render :template => "dominion_card_sets/edit" }
      end
    end
  end

  
  # DELETE /card_sets/1
  # DELETE /card_sets/1.xml
  def destroy
    @dominion_card_set.destroy

    respond_to do |format|
      format.html { redirect_to dominion_card_sets_url }
    end
  end


  private

  def get_dominion_card_sets
    if can? :edit, CardSet
      @dominion_card_sets = CardSet.dominion
    else
      @dominion_card_sets = CardSet.dominion.sets_of_10
    end
  end

  def parse_params!
    if params[:rds_options]
      # Fix stupid :max_attacks_toggle/:max_attacks sync-up issue
      if params[:rds_options][:max_attacks].blank?
        params[:rds_options].delete( 'max_attacks_toggle' )
      elsif params[:rds_options][:max_attacks_toggle].nil?
        params[:rds_options][:max_attacks] = ""
      else
        params[:rds_options][:max_attacks_toggle] = 'yes'
      end

      # incoming options from params = new options; save to session
      options = session[:rds_options] = symbolize_keys( params[:rds_options] )
      flash.now[:notice] = 'New options have been applied.'

    elsif session[:rds_options]
      # no incoming params and previously saved options from session; merge in replace request
      options = Hash[session[:rds_options]]
      options.merge!(symbolize_keys(params[:replace])) if params[:replace]

    else
      # Create new options from defaults and save to the session
      options = session[:rds_options] = RandomDominionSet::DEFAULT_OPTIONS

    end

    return options
  end

  def symbolize_keys( hash )
    hash.inject( {} ) do |result, (key, value)|
      new_key = case key
        when String then
          key.to_sym
        else
          key
      end

      new_value = case value
        when Hash then
          symbolize_keys(value)
        else
          value
      end

      result[new_key] = new_value
      result
    end
  end
end
