# makes 100 mobile sessions #
100.times do |i|
  latitude = Random.rand(1000)/10
  longitude = Random.rand(1000)/10
  MobileSession.create_initial_session_with_event(longitude: longitude, latitude: latitude, event_type: 'start', timestamp: Time.now.to_f)
end
def cancel(xtimes, time_adjustment)
  incomplete_sessions = MobileSession.incomplete
  xtimes.times do |i|
    latitude = Random.rand(1000)/10
    longitude = Random.rand(1000)/10
    incomplete_sessions[i].mobile_events.create!(longitude: longitude, latitude: latitude, event_type: 'cancel', timestamp: (Time.now + time_adjustment).to_f)
  end
end
def next_event(event_type, time_adjustment)
  incomplete_sessions = MobileSession.incomplete
  incomplete_sessions.count.times do |i|
    latitude = Random.rand(1000)/10
    longitude = Random.rand(1000)/10
    incomplete_sessions[i].mobile_events.create!(longitude: longitude, latitude: latitude, event_type: event_type, timestamp: (Time.now + time_adjustment).to_f)
  end
end
def sequence(type, time_adjustment)
  count = MobileSession.incomplete.count
  random = Random.rand(count)
  cancel_count = [count,random].min
  cancel(cancel_count, time_adjustment)
  next_event(type, time_adjustment)
end
sequence('check1', 1.minute)
sequence('check2', 10.minutes)
sequence('finish', 1.hour)