class MobileEvent < ActiveRecord::Base
  attr_accessible :event_type, :latitude, :longitude, :timestamp

  belongs_to :mobile_session
  
  
  validates_presence_of :event_type, :latitude, :longitude, :timestamp
  validates :event_type, 
            inclusion: { in: ["start"], message: 'Invalid Sequence' }, 
            if: :first_check?
  validates :event_type, 
            inclusion: { in: ["check1"], message: 'Invalid Sequence'  }, 
            if: :second_check?
  validates :event_type, 
            inclusion: { in: ["check2"], message: 'Invalid Sequence'  }, 
            if: :finished?
  validates :event_type, 
            inclusion: { in: ["check1", "check2", "start"], message: 'Invalid Sequence'  }, 
            if: :cancelled?
  
 


  after_save :session_completeness_check
  private
  def session_completeness_check
    ["finish", "cancel"].include? self.event_type
    self.mobile_session.update_attributes!(is_validly_completed: true)
  end
  def cancelled? 
    event_type == 'cancel'
  end
  def finished?
    event_type == 'finish'
  end
  def first_check?
    event_type == 'check1'
  end
  def second_check? 
    event_type == 'check2'
  end
end
