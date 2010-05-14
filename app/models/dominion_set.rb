class DominionSet
  attr_reader :options
  
  def initialize( options = {} )
    @options = options.is_a?( DominionSetOptions ) ? options : DominionSetOptions.new( options )    
    @deck = Card.find_all_by_game_and_expansion( 'dominion', @options.expansions )
    @deck = @deck - @options.excludes
    @cards = @options.includes ? Array.new( @options.includes ) : []
  end
  
  def generate
    # if it is impossible to draw 10 cards, throw the Base set into the deck
    # TODO This should throw an error instead of overwriting the user's intentions
    if @deck.length + @cards.length < 10
      @deck.concat Card.find_all_by_game_and_expansion( 'Dominion', 'Base' )
    end
    
    until @cards.length >= 10
      @deck = @deck - @cards
      check_max_attacks unless @options.max_attacks.nil?

      if @options.minimums?
        if card = do_minimums
          @cards << card
          next
        end
      end

      if @options.defense_required?
        if card = do_defense_required
          @cards << card
          next
        end
      end

      if @options.alchemy_requirements?
        if card = do_alchemy_requirements
          @cards << card
          next
        end
      end

      pick_a_card
    end

    return @cards
  end


  def pick_a_card
    if @options.bsw_style?
      case @cards.select{ |card| card.computed_cost < 4 }.length
      when 0..3
        @cards << @deck.reject { |card| card.computed_cost > 3 }.shuffle.shift
      when 4
        @cards << @deck.reject { |card| card.computed_cost < 4 }.shuffle.shift
      when 5..10
        @cards.clear
        @cards = Array.new( @options.includes || [] )
      end
    else
      @cards << @deck.shuffle.shift
    end
  end


private
  def check_max_attacks
    unless @options.max_attacks.nil?
      if @cards.select { |card| card.card_type =~ /Attack/ }.length >= @options.max_attacks.to_i
        @deck.reject! { |card| card.card_type =~ /Attack/ }
      end
    end
  end


  def do_minimums
    unless @cards.any? { |card| card.computed_cost == 2 }
      return @deck.reject { |card| card.computed_cost != 2 }.shuffle.shift
    end

    unless @cards.any? { |card| card.computed_cost == 3 }
      return @deck.reject { |card| card.computed_cost != 3 }.shuffle.shift
    end

    unless @cards.any? { |card| card.computed_cost == 4 }
      return @deck.reject { |card| card.computed_cost != 4 }.shuffle.shift
    end

    unless @cards.any? { |card| card.computed_cost == 5 }
      return @deck.reject { |card| card.computed_cost != 5 }.shuffle.shift
    end

    return nil
  end


  def do_defense_required
    if @cards.select { |card| card.card_type =~ /Attack/ }.length > 0
      if @cards.select { |card| card.card_type =~ /Reaction/ }.length == 0
        return @deck.select { |card| card.card_type =~ /Reaction/ }.shuffle.shift
      end
    end

    return nil
  end


  def do_alchemy_requirements
    count = @cards.select { |card| card.expansion == 'Alchemy' }.length
    if count > 0 && count < 3
      return @deck.select { |card| card.expansion == 'Alchemy' }.shuffle.shift
    elsif count >= 5
      @deck.reject! { |card| card.expansion == 'Alchemy' }
    end

    return nil
  end
end
