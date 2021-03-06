class EmailWorker < Workling::Base
  def do_smart_group_contact(options)
    #unless options[:p].blank?
      logger.info("::: do_smart_group_contact was called in the EmailWorker :::")
      person = Person.find(options[:p])
      VolunteerMailer.deliver_smart_group_contact(options[:subject], options[:message], person, options[:current_user_email])
    #end
  end
  
  def do_group_text(options)
    person = Person.find(options[:p])
    group = Group.find(options[:group_id])
    VolunteerMailer.deliver_group_text(options[:subject], options[:message], person, options[:current_user_email],group)
  end
  
  def do_group_email(options)
    logger.info("::: do_group_email was called in the EmailWorker :::")
    person = Person.find(options[:p])
    group = Group.find(options[:group_id])
    VolunteerMailer.deliver_group_contact(options[:subject], options[:message], person, options[:current_user_email],group)
  end
  
  def do_meeting_notify(options)
    VolunteerMailer.deliver_meeting_created_message(options[:created_by],
                                                    options[:group_name],
                                                    options[:meeting_date],
                                                    options[:sender_email],
                                                    options[:meeting_notes],
                                                    options[:number_present])
  end
  
  def do_note_notify(options)
    relationship = Relationship.find(options[:relationship_id])
    VolunteerMailer.deliver_note_created_message(options[:created_by],
                                                 options[:sender_email],
                                                 options[:note_text],
                                                 relationship)
  end
  
  def do_setup_person_contr_fields(options)
    @people = Person.find(:all)
    @people.each do |p|
      p.set_recent_contr
      p.set_contr_count
    end
  end
  
  def setup_attendance_trackers(options)
    @people = Person.find(:all)
    @people.each do |p|
      @groups = p.attendances.collect {|a| a.meeting.group.id rescue nil}.compact.uniq
      @groups.each do |group|
        AttendanceTracker.do_new_attendance(Attendance.find_all_by_person_and_group(p.id,group).first)
      end
    end
  end
  

end