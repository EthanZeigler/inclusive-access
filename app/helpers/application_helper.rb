# Helper functions made here are accessable in all views
# for example, app_name is now accessable to all views
module ApplicationHelper
    def app_name
        conf = app_config
        unless conf.nil?
            conf.name
        else
            "?"
        end
    end
    
private
    def app_config
        AppConfig.first
    end
end
