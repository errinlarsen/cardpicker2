module CardSetsHelper
  def card_set_path( options = [] )
    if @game.nil? || @game.empty?
      super( options )
    else
      game_card_set_path( @game, options )
    end
  end

  def card_sets_path
    if @game.nil? || @game.empty?
      super
    else
      game_card_sets_path
    end
  end

  def edit_card_set_path( options = [] )
    if @game.nil? || @game.empty?
      super( options )
    else
      edit_game_card_set_path( @game, options )
    end
  end

  def new_card_set_path
    if @game.nil? || @game.empty?
      super
    else
      new_game_card_set_path
    end
  end
end
