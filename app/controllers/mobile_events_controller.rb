class MobileEventsController < ApplicationController
  ### to post via jquery from root path 
  ### $.post('/mobile_sessions/[someid]/mobile_events', 
           ##  {event: {latitude: 10.2, longitude: 10.2, event_type: 'start', timestamp: 0.0}}, 
           ## function(d) { console.log(d); })
  def index 
    @mobile_events = MobileEvent.order(:created_at)
    render json: @mobile_events.map(&:json_version).to_json
  end
  def create
     ## use find to avoid exception, expect nil if not found
    mobile_session = MobileSession.incomplete.find_by_id(params[:mobile_session_id])
    if mobile_session
      new_event = mobile_session.mobile_events.create(params[:event])
      new_event.valid? ? (render json: {status: "success"}) : (render json: {status: "error", messages: new_event.errors.values.join })
      new_event.errors.clear() # seems that i have to manually clear my errors here
    else 
      # respond to failure to find mobile session by id
      render json: {status: "failure to find mobile session by id"}
    end
  end
end
