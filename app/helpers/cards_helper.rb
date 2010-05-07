module CardsHelper
  def card_path( options = [] )
    if @game.nil? || @game.empty?
      super( options )
    else
      game_card_path( @game, options )
    end
  end

  def cards_path
    if @game.nil? || @game.empty?
      super
    else
      game_cards_path
    end
  end

  def edit_card_path( options = [] )
    if @game.nil? || @game.empty?
      super( options )
    else
      edit_game_card_path( @game, options )
    end
  end

  def new_card_path
    if @game.nil? || @game.empty?
      super
    else
      new_game_card_path
    end
  end
end
