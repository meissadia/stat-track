class DbSettingsController < ApplicationController
  def new
  end

  def create
    #render plain: params[:db_settings].inspect
    @db_setting = DbSetting.new(db_setting_params)
    if !@db_setting.save
      redirect_to 'db_setting/new'
    end

    redirect_to @db_setting
  end

  def show
    @db_setting = DbSetting.find(params[:id])
  end

  def index
    @db_settings = DbSetting.all
  end

  private
  def db_setting_params
    params.require(:db_setting).permit(:user, :db_name, :db_user, :db_password,
      :start_fresh, :show_statements, :auto_populate_tables,
      :auto_populate_teams, :auto_populate_rosters, :auto_populate_schedules,
      :auto_populate_gamestats, :auto_populate_lotto, :auto_populate_draft)
  end
end
