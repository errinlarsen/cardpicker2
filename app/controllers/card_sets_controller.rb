class CardSetsController < ApplicationController
  # GET /card_sets
  # GET /card_sets.xml
  def index
    @card_sets = CardSet.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @card_sets }
    end
  end

  # GET /card_sets/1
  # GET /card_sets/1.xml
  def show
    @card_set = CardSet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @card_set }
    end
  end

  # GET /card_sets/new
  # GET /card_sets/new.xml
  def new
    @card_set = CardSet.new(
      :name => "Sample Set",
      :set_type => "Sample",
      :comments => "This is a Card Set sample."
    )

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @card_set.to_xml( :except => [:id, :created_at, :updated_at] )}
    end
  end

  # GET /card_sets/1/edit
  def edit
    @card_set = CardSet.find(params[:id])
  end

  # POST /card_sets
  # POST /card_sets.xml
  def create
    @card_set = CardSet.new(params[:card_set])

    respond_to do |format|
      if @card_set.save
        flash[:notice] = 'CardSet was successfully created.'
        format.html { redirect_to(@card_set) }
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
    @card_set = CardSet.find(params[:id])

    respond_to do |format|
      if @card_set.update_attributes(params[:card_set])
        flash[:notice] = 'CardSet was successfully updated.'
        format.html { redirect_to(@card_set) }
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
    @card_set = CardSet.find(params[:id])
    @card_set.destroy

    respond_to do |format|
      format.html { redirect_to(card_sets_url) }
      format.xml  { head :ok }
    end
  end
end
