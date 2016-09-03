class Api::V1::ScheduleController < ApplicationController
  def create
    user_with_time = { created_at: Time.now, customer: curent_user }
    # user_with_time = { created_at: Time.now }
    event = MeetingSchedulerService.new.calendar_invite(permitted_params.merge!(user_with_time))

    if ScheduleMailer.schedule(event).deliver_now
      render plain: "Meeting booked. We'll get back to you if no one is available."
    else
      render plain: "Sorry, we're unable to schedule your meeting @ this time."
    end
  end

  private

  def permitted_params
    params.permit(:start_time, :end_time, :title, :description)
  end
end
