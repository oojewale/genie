class MeetingSchedulerService
  def calendar_invite(params)
    meeting = RiCal.Calendar do |cal|
      cal.event do |event|
        event.description = params[:description]
        event.dtstart =  DateTime.parse(params[:start_time]) #("2/20/1962 14:47:39")
        event.dtend = DateTime.parse(params[:end_time])
        event.location = "Your office"
        # event.add_attendee [Staff.first.email, params[:user].email]
        event.add_attendees ["ojewaleolaide@gmail.com", "olaide.ojewale@andela.com"]
        event.alarm do
          description "Meeting with Olaide"
          # description "Meeting with #{params[:user].firstname}"
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
