module DominionCardSetsHelper

  def list_for( options = {}, tag_options = nil, open = false, escape = true )
    options.delete(:excludes) if options[:excludes].empty?
    options.delete(:includes) if options[:includes].empty?
    str = "<ul>"
    options.keys.sort_by { |k| k.to_s }.each do |key|
      value = options[key]
      if options[key]
        str << "<li>"
        str << "#{key.to_s.humanize}: "
        if key == :excludes or key == :includes
          value = options[key].collect { |card_id| Card.find( card_id ).name }
        end
        if value.class == Array
          str << "#{value.to_sentence}"
        else
          str << "#{value}"
        end
        str << "</li>"
      end
    end
    str << "</ul>"
  end

  def check_boxes_for_card_set( card_set )
    card_sets_card_ids = card_set.card_ids
    str = '<table><tr><th>include?</th><th>Game</th><th>Expansion</th><th>Name</th></tr>'

    for card in Card.dominion
      str << '<tr><td>'
      str << check_box_tag( 'card_set[card_ids][]', card.id, card_sets_card_ids.include?( card.id ))
      str << '</td><td>'
      str << h( card.game )
      str << '</td><td>'
      str << h( card.expansion )
      str << '</td><td>'
      str << link_to( card.name, card )
      str << '</td></tr>'
    end

    str << '</table>'
    return str
  end

  def check_boxes_for_card_set_options( options )
    included_card_ids = options[:includes] || []
    included_card_ids.collect! { |id| id.to_i }
    excluded_card_ids = options[:excludes] || []
    excluded_card_ids.collect! { |id| id.to_i }
    str = '<table><tr><th>include?</th><th>exclude?</th><th>Expansion</th><th>Name</th></tr>'

    for card in Card.dominion
      str << '<tr><td>'
      str << check_box_tag( 'rds_options[includes][]', card.id, included_card_ids.include?( card.id ))
      str << '</td><td>'
      str << check_box_tag( 'rds_options[excludes][]', card.id, excluded_card_ids.include?( card.id ))
      str << '</td><td>'
      str << h( card.expansion )
      str << '</td><td>'
      str << link_to( card.name, card )
      str << '</td></tr>'
    end

    str << '</table>'
    return str
  end

  def check_boxes_for_mobile_card_set_options( options )
    included_card_ids = options[:includes] || []
    included_card_ids.collect! { |id| id.to_i }
    excluded_card_ids = options[:excludes] || []
    excluded_card_ids.collect! { |id| id.to_i }
    str = '<table><tr><th>include?</th><th>exclude?</th><th>Expansion</th><th>Name</th></tr>'

    for card in Card.dominion
      str << '<tr><td>'
      str << check_box_tag( 'rds_options[includes][]', card.id, included_card_ids.include?( card.id ))
      str << '</td><td>'
      str << check_box_tag( 'rds_options[excludes][]', card.id, excluded_card_ids.include?( card.id ))
      str << '</td><td>'
      str << h( card.expansion )
      str << '</td><td>'
      str << link_to( card.name, card, :class => "grayButton" )
      str << '</td></tr>'
    end

    str << '</table>'
    return str
  end

end
