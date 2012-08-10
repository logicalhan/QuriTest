class MobileSessionsController < ApplicationController
  ### to post via jquery from root path 
  ### $.post('/mobile_sessions', 
           ##  {event: {latitude: 10.2, longitude: 10.2, event_type: 'start', timestamp: 0.0}}, 
           ## function(d) { console.log(d); })
  def create
    new_mobile_session = MobileSession.create_initial_session_with_event(params[:event])
    render json: new_mobile_session.id.to_json
  end
  def index
    @mobile_sessions = MobileSession.order(:id).map(&:session_json)

    respond_to do |f|
      f.json {render json: @mobile_sessions.to_json}
    end
  end
end
