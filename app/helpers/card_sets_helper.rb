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

  def list_for( options = {}, tag_options = nil, open = false, escape = true )
    options.delete(:excludes) if options[:excludes].empty?
    options.delete(:includes) if options[:includes].empty?
    val = tag( "ul", tag_options, true, escape )
    options.each do |key, value|
      if value 
        val << tag( "li", tag_options, true, escape )
        val << "#{key.to_s.humanize}: "
        if value.class == Array
          val << "#{value.to_sentence}"
        else
          val << "#{value}"
        end
        val << "</li>"
      end
    end
    val << "</ul>"
  end
end
