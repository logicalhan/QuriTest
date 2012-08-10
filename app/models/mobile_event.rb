class MobileEvent < ActiveRecord::Base
  attr_accessible :event_type, :latitude, :longitude, :timestamp

  belongs_to :mobile_session
  
  delegate :last_event_type, to: :mobile_session
  validates_presence_of :event_type, :latitude, :longitude, :timestamp
  validates :event_type, 
            inclusion: { in: ["check1", 'cancel'], message: 'Invalid Sequence - last type was start' }, 
            if: :last_type_was_start?
  validates :event_type, 
            inclusion: { in: ["check2", 'cancel'], message: 'Invalid Sequence - last type was check1'  }, 
            if: :last_type_was_check1?
  validates :event_type, 
            inclusion: { in: ["finish", 'cancel'], message: 'Invalid Sequence - last type was check2'  }, 
            if: :last_type_was_check2?

 


  after_save :session_completeness_check

  def json_version
    event_hash = {}
    event_hash[:session] = mobile_session_id
    event_hash[:session_status] = mobile_session.status
    event_hash[:event_type] = event_type
    event_hash[:timestamp] = timestamp
    event_hash[:latitude] = latitude
    event_hash[:longitude] = longitude
    event_hash[:session_length]=mobile_session.session_length
    return event_hash
  end


  private
  def session_completeness_check
    if ["finish", "cancel"].include? self.event_type
      self.mobile_session.update_attributes!(is_validly_completed: true)
    end
  end

  def last_type_was_check2?
    last_event_type == 'check2'
  end
  def last_type_was_start?
    last_event_type == 'start'
  end
  def last_type_was_check1? 
    last_event_type == 'check1'
  end

end
