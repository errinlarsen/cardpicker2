# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def create_main_nav_list
    str = "<ul id=\"main_nav_list\" ><li id=\"nav_home\">"
    str << link_to( "Home", welcome_path )
    str << "</li><li id=\"nav_start_player\">"
    str << link_to( "Start Player", start_player_card_path( :random ))
    str << "</li><li id=\"nav_dominion\">"
    str << link_to( "Dominion", random_dominion_card_sets_path )

    if user_signed_in?
      if current_user.editor? || current_user.admin?
        str << "</li><li id=\"nav_edit\">"
        str << link_to( "Edit", cards_path )
      end

      if current_user.admin?
        str << "</li><li id=\"nav_users\">"
        str << link_to( "Users", admin_index_path )
      end
    end

    str << "</li></ul>"

    
    case controller.controller_name
      when /^start_player/
        str.gsub!( /id="nav_start_player"/, "id=\"nav_start_player\" class=\"active\"")
      when /^dominion/
        str.gsub!( /id="nav_dominion"/, "id=\"nav_dominion\" class=\"active\"" )
      when /^card/
        str.gsub!( /id="nav_edit"/, "id=\"nav_edit\" class=\"active\"" )
      when /^admin/
        str.gsub!( /id="nav_users"/, "id=\"nav_users\" class=\"active\"" )
      else
        str.gsub!( /id="nav_home"/, "id=\"nav_home\" class=\"active\"" )
    end

    return str
  end
end
