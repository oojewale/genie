class ScheduleMailer < ApplicationMailer
  default from: 'notifications@genie.com'

  def schedule(event)
    recievers = event.subcomponents["VEVENT"].first.attendee_property.first.value
    @url  = 'http://example.com/login'
    attachments["invite.ics"] =
      {
        content_type: "text/calendar",
        body: File.read("#{Rails.root.join('tmp', 'ics_files', 'invite.ics')}")
      }
    mail(to: recievers, subject: 'Meeting Schedule')
  end
end
