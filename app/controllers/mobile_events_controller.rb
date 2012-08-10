class MobileEventsController < ApplicationController
  def create
     ## use find to avoid exception, expect nil if not found
    mobile_session = MobileSession.find_by_id(params[:mobile_session_id])
    if mobile_session
      new_event = mobile_session.mobile_events.create(params[:event])
      new_event.valid? ? (render json: {status: "success"}) : (render json: {status: "error", messages: new_event.errors.values.join })
    else 
      # respond to failure to find mobile session by id
      render json: {status: "failure to find mobile session by id"}
    end
  end
end
