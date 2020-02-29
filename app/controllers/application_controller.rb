class ApplicationController < ActionController::Base
  def catch_all
    render template: "vue"
  end
end
