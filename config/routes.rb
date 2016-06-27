Rails.application.routes.draw do
  resources :db_settings

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'homepage#index'

  get  'maintain_db'               => 'maintain_db#index'
  post 'maintain_db/loadTeams'     => 'maintain_db#loadTeams'
  post 'maintain_db/loadRosters'   => 'maintain_db#loadRosters'
  post 'maintain_db/loadSchedules' => 'maintain_db#loadSchedules'
  post 'maintain_db/loadGamestats' => 'maintain_db#loadGamestats'
  post 'maintain_db/updateDb'      => 'maintain_db#updateDb'

  get 'teams'             => 'team#index'
  get 'team'              => 'team#index'
  get 'team/:id'          => 'team#show'
  get 'team/abbr/:abbr'   => 'team#by_team'
  get 'team/schedule/:id' => 'team#schedule'

  get 'game/:boxscore_id' => 'game#show'

  get 'players'    => 'player#index'
  get 'player/:id' => 'player#show'

end
