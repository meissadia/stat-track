class Gamestat < ActiveRecord::Base
  belongs_to :player
  # belongs_to :game

  FIELD_NAMES = [:t_abbr,:game_num,:p_name,:pos,:min,:fgm,:fga,:tpm,:tpa,:ftm,:fta,:oreb,:dreb,:reb,:ast,:stl,:blk,:tos,:pf,:plus,:pts,:starter]
end
