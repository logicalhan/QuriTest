class MobileSession < ActiveRecord::Base
  attr_accessible :is_validly_completed

  has_many :mobile_events
  accepts_nested_attributes_for :mobile_events


  scope :is_completed?,   lambda { |bool| where(is_validly_completed: bool)}
  scope :incomplete,      lambda { is_completed?(false) }
  scope :complete,        lambda { is_completed?(true) }
  
  def last_event_type
    self.mobile_events.order(:created_at).last.try(:event_type)
  end
  
  def self.create_initial_session_with_event(event_params)
    ActiveRecord::Base.transaction do
      new_session = self.create!
      new_session.mobile_events.create!(event_params)
      new_session #return the new mobile session implicitly in block
    end
  end
end
