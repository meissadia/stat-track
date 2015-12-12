class Gamestat < ActiveRecord::Base
  belongs_to :player
  # belongs_to :game

  FIELD_NAMES = [:t_abbr,:game_num,:p_name,:pos,:min,:fgm,:fga,:tpm,:tpa,:ftm,:fta,:oreb,:dreb,:reb,:ast,:stl,:blk,:tos,:pf,:plus,:pts,:starter]

  def self.formulaGameScore
    "(pts + (fgm * 0.4) + (fga * -0.7) + ((fta-ftm) * -0.4) + "\
        "(OREB * 0.7) + (DREB * 0.3) + STL + (AST * 0.7) + (BLK * 0.7) + "\
          "(PF * -0.4) - tos) as gamescore"\
  end
end
