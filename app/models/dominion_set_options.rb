class DominionSetOptions
  attr_reader :excludes, :includes, :max_attacks, :expansions

  def initialize( options = {} )
    # TODO validate expansions input
    @expansions = options[:expansions] || Card.find_all_by_custom( false ).collect { |card| card.expansion }.uniq
    # TODO validate include fileter input
    @includes = options[:includes] || []
    # TODO validate exclude filer input
    @excludes = options[:excludes] || []
    # TODO validate max_attacks_toggle input
    @max_attacks_toggle = options[:max_attacks_toggle]
    # TODO validate max_attack_cards input
    if @max_attacks_toggle
      @max_attacks = options[:max_attacks] == '' ? nil : options[:max_attacks]
      @max_attacks_toggle = false if @max_attacks.nil?
    else
      @max_attacks = nil
    end
    # TODO validate minimums input
    @minimums = options[:minimums]
    #TODO validate defense_required input
    @defense_required = options[:defense_required]
    # TODO validate allchemy_reqs bookean input
    @alchemy_requirements = options[:alchemy_requirements]
    # TODO validate bsw boolean  input
    @bsw_style = options[:bsw_style]
  end

  def max_attacks?
    @max_attacks_toggle
  end

  def minimums?
    @minimums
  end

  def defense_required?
    @defense_required
  end

  def alchemy_requirements?
    @alchemy_requirements
  end

  def bsw_style?
    @bsw_style
  end

  def to_hash
    { :expansions => @expansions,
      :excludes => @excludes.collect { |card| card.id },
      :includes => @includes.collect { |card| card.id },
      :max_attacks_toggle => @max_attacks_toggle,
      :max_attacks => @max_attacks,
      :minimums =>@minimums,
      :defense_required => @defense_required,
      :alchemy_requirements => @alchemy_requirements,
      :bsw_style => @bsw_style
    }
  end
end
