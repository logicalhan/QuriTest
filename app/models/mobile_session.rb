class MobileSession < ActiveRecord::Base
  attr_accessible :is_validly_completed

  has_many :mobile_events
  accepts_nested_attributes_for :mobile_events


  scope :is_completed?,   lambda { |bool| where(is_validly_completed: bool)}
  scope :incomplete,      lambda { is_completed?(false) }
  scope :complete,        lambda { is_completed?(true) }
  scope :canceled,        lambda { includes(:mobile_events).where("mobile_events.event_type=?", 'cancel')}
  scope :finished,        lambda { includes(:mobile_events).where("mobile_events.event_type=?", 'finish')}
  

  def self.session_lengths
    self.all.map(&:session_length)
  end
  def self.canceled_count_of(type)
    self.canceled.map(&:prior_to_canceled_type).count(type)
  end
  def self.create_initial_session_with_event(event_params)
    ActiveRecord::Base.transaction do
      new_session = self.create!
      new_session.mobile_events.create!(event_params)
      new_session #return the new mobile session implicitly in block
    end
  end
  def self.canceled_by(point)
    self.canceled.map do |canceled_session|
      canceled_session if canceled_session.prior_to_canceled_type == point
    end.compact
  end


  def last_event_type
    self.mobile_events.order(:created_at).last.try(:event_type)
  end
  def prior_to_canceled_type
    self.mobile_events.order(:created_at)[-2].try(:event_type)
  end
  def was_canceled
    mobile_events.pluck(:event_type).include?("cancel")
  end
  def session_length
    timestamps.max - timestamps.min
  end
  def timestamps
    self.mobile_events.order(:created_at).pluck(:timestamp)
  end
  def status
    was_canceled ? "Canceled" : "Finished" 
  end
  def session_json
    session_hash = {}
    session_hash[:id] = id
    session_hash[:status] = status
    session_hash[:session_length] = session_length
    session_hash[:last_event_type] = was_canceled ? prior_to_canceled_type : "Finished" 
    return session_hash
  end
end
