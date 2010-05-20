# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

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
end
