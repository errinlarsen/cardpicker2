class RandomDominionSet
  attr_reader :cards, :options

  DEFAULT_OPTIONS = {
    :expansions => Card.all_dominion_expansions,
    :includes => [],
    :excludes => [],
    :max_attacks_toggle => false,
    :max_attacks => nil,
    :minimums => false,
    :defense_required => false,
    :alchemy_requirements => false,
    :bsw_style => false
  }
  
  def initialize( options = {} )
    initialize_options!( options )
    @deck = Card.dominion.with_expansions( @options[:expansions] )
    excludes = Card.dominion.find( @options[:excludes] )
    includes = Card.dominion.find( @options[:includes] )
    if @replace[:card] || @replace[:includes]
      @replace[:includes].delete( @replace[:card] )
      excludes = (excludes + Card.dominion.find(@replace[:excludes]) ).uniq
      includes = (includes + Card.dominion.find(@replace[:includes]) ).uniq
    end
    @deck -= (excludes + includes).uniq
    @cards = Array.new( includes || [] )
    generate!
  end
  
  def generate!
    # if it is impossible to draw 10 cards, throw the Base set into the deck
    # TODO This should throw an error instead of overwriting the user's intentions
    if @deck.length + @cards.length < 10
      @deck.concat( Card.dominion( 'Base' ))
    end

    until @cards.length >= 10
      @deck = @deck - @cards
      check_max_attacks if @options[:max_attacks]

      if @options[:minimums]
        if card = do_minimums
          @cards << card
          next
        end
      end

      if @options[:defense_required]
        if card = do_defense_required
          @cards << card
          next
        end
      end

      if @options[:alchemy_requirements]
        if card = do_alchemy_requirements
          @cards << card
          next
        end
      end

      pick_a_card
    end

    @cards = sort_cards
    return self
  end


  def pick_a_card
    if @options[:bsw_style]
      case @cards.select{ |card| card.dominion_cost_for_randomization < 4 }.length
      when 0..3
        @cards << @deck.reject { |card| card.dominion_cost_for_randomization > 3 }.shuffle.shift
      when 4
        @cards << @deck.reject { |card| card.dominion_cost_for_randomization < 4 }.shuffle.shift
      when 5..10
        @cards.clear
        @cards = Array.new( @options[:includes] )
      end
    else
      @cards << @deck.shuffle.shift
    end
  end


  def card_ids
    @cards.collect { |card| card.id }
  end


  def replacement_message
    replaced_card = Card.find( @replace[:card] )
    cards_ids = @cards.collect { |card| card.id }
    replacement_card = Card.find( (cards_ids - @replace[:includes]).first )
    "#{replaced_card.name} was replaced by #{replacement_card.name}"
  end

  
private
  def initialize_options!( options )
    @options = Hash[options]
    @options[:replace_this] = @options[:replace_this].to_i if @options[:replace_this]
    @options[:replace_includes].collect! { |cid| cid.to_i } if @options[:replace_includes]
    @options[:replace_excludes].collect! { |cid| cid.to_i } if @options[:replace_excludes]
    @replace = {
      :card =>  @options.delete(:replace_this) || nil,
      :includes => @options.delete(:replace_includes) || [],
      :excludes => @options.delete(:replace_excludes) || [],
    }
    @options[:expansions] ||= Card.all_dominion_expansions
    @options[:includes] ||= []
    @options[:excludes] ||= []
    if @options[:max_attacks].nil? || @options[:max_attacks].empty?
      @options[:max_attacks_toggle] = @options[:max_attacks] = nil
    end
  end


  def check_max_attacks
    if @options[:max_attacks]
      if @cards.count { |card| card.card_type =~ /Attack/ } >= @options[:max_attacks].to_i
        @deck.reject! { |card| card.card_type =~ /Attack/ }
      end
    end
  end


  def do_minimums
    unless @cards.any? { |card| card.dominion_cost_for_randomization == 2 }
      return @deck.reject { |card| card.dominion_cost_for_randomization != 2 }.shuffle.shift
    end

    unless @cards.any? { |card| card.dominion_cost_for_randomization == 3 }
      return @deck.reject { |card| card.dominion_cost_for_randomization != 3 }.shuffle.shift
    end

    unless @cards.any? { |card| card.dominion_cost_for_randomization == 4 }
      return @deck.reject { |card| card.dominion_cost_for_randomization != 4 }.shuffle.shift
    end

    unless @cards.any? { |card| card.dominion_cost_for_randomization == 5 }
      return @deck.reject { |card| card.dominion_cost_for_randomization != 5 }.shuffle.shift
    end

    return nil
  end


  def do_defense_required
    @cards << @deck.shuffle.shift
    if @cards.count { |card| card.card_type =~ /Attack/ } > 0
      if @cards.count { |card| card.card_type =~ /Reaction/ } == 0
        return @deck.select { |card| card.card_type =~ /Reaction/ }.shuffle.shift
      end
    elsif @cards.length == 9
      return @deck.reject { |card| card.card_type =~ /Attack/ }.shuffle.shift
    end

    return nil
  end


  def do_alchemy_requirements
      count = @cards.count { |card| card.expansion == 'Alchemy' }
      if count > 0 && count < 3
        return @deck.select { |card| card.expansion == 'Alchemy' }.shuffle.shift
      elsif count >= 5 || @cards.length > 7
        @deck.reject! { |card| card.expansion == 'Alchemy' }
      end
    
    return nil
  end
  

  def sort_cards
    @cards.sort_by { |c| [c.dominion_cost_for_sort, c.name] }
  end
end
