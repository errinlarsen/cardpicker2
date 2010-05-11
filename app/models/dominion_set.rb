class DominionSet

  def initialize( options = {} )
    # TODO validate expansions input
    @expansions = options[:expansions] ||= [ 'Base', 'Envoy', 'Intrigue', 'Black Market', 'Seaside' ]
    # TODO validate include fileter input
    @includes = options[:include] ||= []
    # TODO validate exclude filer input
    @excludes = options[:exclude] ||= []
    # TODO validate max_attack_cards input
    @max_attacks = options[:max_attacks] ||= nil
    # TODO validate minimums input
    @minimums = options[:minimums] ||= false
    #TODO validate defense_required input
    @defense_required = options[:defense_required] ||= false
    # TODO validate allchemy_reqs bookean input
    @alchemy_requirements = options[:alchemy_requirments] ||= true
    # TODO validate bsw boolean  input
    @bsw_style = options[:bsw_style] ||= false

    @deck = Card.find_all_by_game_and_expansion( 'Dominion', @expansions )
    @cards = @includes ||= []
  end
  
  def generate
    until @cards.length == 10
      @deck = @deck - @cards
      check_max_attacks if @max_attacks

      if @minimums
        if card = do_minimums
          @cards << card
          next
        end
      end

      if @defense_required
        if card = do_defense_required
          @cards << card
          next
        end
      end

      if @alchemy_requirements
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
    if @bsw_style
      case @cards.select{ |card| card.cost.to_i < 4 }.length
      when 0..3
        @cards << @deck.reject { |card| card.cost.to_i > 3 }.shuffle.shift
      when 4
        @cards << @deck.reject { |card| card.cost.to_i < 4 }.shuffle.shift
      when 5..10
        @cards.clear
        @cards = @includes ||= []
      end
    else
      @cards << @deck.shuffle.shift
    end
  end


private
  def alchemy_min( reroll = false )
    if @alchemy_min.nil? || reroll
      @alchemy_min = (Array.new( 10, 3) + Array.new( 16, 4) + Array.new( 10, 5)).shuffle.shift
    else
      @alchemy_min
    end
  end

  def check_max_attacks
    unless @max_attacks.nil?
      if @cards.select { |card| card.card_type =~ /Attack/ }.length >= @max_attacks
        @deck.reject! { |card| card.card_type =~ /Attack/ }
      end
    end
  end


  def do_minimums
    unless @cards.any? { |card| card.cost == 2 }
      return @deck.reject { |card| card.cost != 2 }.shuffle.shift
    end

    unless @cards.any? { |card| card.cost == 3 }
      return @deck.reject { |card| card.cost != 3 }.shuffle.shift
    end

    unless @cards.any? { |card| card.cost == 4 }
      return @deck.reject { |card| card.cost != 4 }.shuffle.shift
    end

    unless @cards.any? { |card| card.cost == 5 }
      return @deck.reject { |card| card.cost != 5 }.shuffle.shift
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
