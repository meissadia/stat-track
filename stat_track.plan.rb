Write hoopscrape in parallel to conform to new app

Team
  has_one :roster,   dependent: :destroy
  has_one :coach,    through:   :roster,   source: :coach
  has_many :players, through:   :roster,   source: :players
  has_one :schedule, dependent: :destroy
  has_many :games,   through:   :schedule, source: :games
  has_one :record,   dependent: :destroy

Player
  belongs_to :roster

Schedule
  belongs :team
  has_many :games

Roster
  belongs_to :team
  has_one :coach
  has_many :players

Game
  belongs_to :schedule
  belongs_to :team, foreign_key: 'home'
  belongs_to :team, foreign_key: 'away'
  has_many :game_stats

Coach
  belongs_to :roster
  t.string :name

Record
  belongs_to :team
  t.integer :wins
  t.integer :losses
