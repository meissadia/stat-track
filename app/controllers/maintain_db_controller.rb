class MaintainDbController < ApplicationController
  def index
    @status = [""]
    @settings = DbSetting.first
    render 'maintain_db/index'
  end

  def updateDb
    @status = ["updateTeams"]
    @status = Game.UpdateFromSchedule()
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
