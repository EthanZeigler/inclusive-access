class ApplicationController < ActionController::Base
  def catch_all
    render template: "catch-all"
  end
end
