class Admin::PagesController < ApplicationController
  def home
    @stats = SessionStats.new(MobileSession)
    @mobile_sessions = MobileSession.order(:created_at)
  end
end
