class MaintainDbController < ApplicationController
  def index
    @status = [""]
    @settings = DbSetting.first
    @last_update = Gamestat.where("boxscore_id > 0").order("created_at desc").limit(1)
    @last_update = (@last_update.first.created_at.in_time_zone('Arizona')).strftime('%D %r')
    Thread.new do
      @status = Game.updateFromSchedule()
      ActiveRecord::Base.connection.close
    end
    render 'maintain_db/index'
  end

  def updateDb
    @status = ["updateTeams"]
    @status = Game.updateFromSchedule()
    @last_update = Gamestat.where("boxscore_id > 0").order("created_at desc").limit(1)
    @last_update = (@last_update.first.created_at.in_time_zone('Arizona')).strftime('%D %r')
    render '/maintain_db/index'
  end

  def loadTeams
    @status = "loadTeams"
    teamList = NbaTeamList.new.teamList
    teamList.each do |team|
      render 'maintain_db/index'
    end
  end

  def loadRosters
    @status = "loadRosters"
    render 'maintain_db/index'
  end

  def loadSchedules
    @status = "loadSchedules"
    render 'maintain_db/index'
  end

  def loadGamestats
    @status = "loadGamestats"
    render 'maintain_db/index'
  end
end
