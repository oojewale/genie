class MeetingSchedulerService

  def create(user)
    event = calendar_invite(user)
    if ScheduleMailer.schedule(event).deliver_now
      render plain: "Meeting booked. We'll get back to you if no one is available."
    else
      render plain: "Sorry, we're unable to schedule your meeting @ this time."
    end
  end

  def calendar_invite(user)
    staff_email = Staff.find_by_id(rand(5)).email
    meeting = RiCal.Calendar do |cal|
      cal.event do |event|
        event.description = Faker::Lorem.sentence
        event.dtstart =  Faker::Time.between(DateTime.now + 1, DateTime.now + 3)
        event.dtend = Faker::Time.between(DateTime.now + 4, DateTime.now + 6)
        event.location = "Your office"
        event.add_attendees [staff_email, user.email]
        event.alarm do
          description "Meeting powered by Genie"
        end
      end
    end
    save_temp(meeting)
  end

  def save_temp(meeting)
    file = File.new("#{Rails.root.join('tmp', 'ics_files', 'invite.ics')}", "w+")
    file.write(meeting)
    file.close
    meeting
  end
end
