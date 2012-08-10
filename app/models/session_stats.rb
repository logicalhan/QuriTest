class SessionStats
  def initialize(sessions)
    @sessions = sessions
  end
  def percentage_which_are(options)
    if options[:optional_filter] 
      @sessions.canceled_by(options[:optional_filter]).count / @sessions.send(options[:filter]).count.to_f
    else
      @sessions.send(options[:filter]).count / @sessions.count.to_f
    end
  end
  def mean_session_length_for(complete_or_canceled, *optional_canceled_filter)
    optional_canceled_filter = optional_canceled_filter.first if optional_canceled_filter.any?
  end
end