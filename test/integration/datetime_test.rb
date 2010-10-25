require 'test_helper'

class DatetimeTest < ActionController::IntegrationTest
  def self.shared_examples_for_user
    context "when edit task" do
        setup do
          @project = project_with_some_tasks(@user)
          @task =@project.tasks.first
          visit ('/tasks/edit/'+@task.task_num.to_s)
        end
        should "see local current time in field Start" do     
          assert_equal @user.tz.utc_to_local(Time.now.utc).strftime(@user.date_format + ' ' + @user.time_format), find_by_id('work_log_started_at').value
        end
      end
  end
  context "A logged in user" do 
    setup do 
      @user= login
      @user.option_tracktime=true
      @user.save!
    end  
    context "from Russia(utc+4)" do
      setup do
        @user.time_zone= "Europe/Moscow"
        @user.save!
      end
      shared_examples_for_user
    end
    context "from Uruguay(utc-3, summer utc-2)" do
       setup do
        @user.time_zone= "America/Montevideo"
        @user.save!
      end
      shared_examples_for_user
    end
  end
end
