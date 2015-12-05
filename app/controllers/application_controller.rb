class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # Execute SQL statement
  # http://stackoverflow.com/questions/22752777/how-do-you-manually-execute-sql-commands-in-ruby-on-rails-using-nuodb
  def execute_statement(sql)
       results = ActiveRecord::Base.connection.execute(sql)
       if results.present?
           return results
       else
           return nil
       end
   end
end
