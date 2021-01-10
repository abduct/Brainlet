module Brainlet
  module Menu
    module_function

    def service(config)
      prompt = config[:prompt]
      
      task = prompt.select("Which service task would you like to do?", %w(Restart Restart-All Start Stop Quit))

      case task
      when "Restart"
        Brainlet::Service::restart(config)
      when "Restart-All"
        Brainlet::Service::restart_all(config)
      when "Start"
        Brainlet::Service::start(config)
      when "Stop"
        Brainlet::Service::stop(config)
      when "Quit"
        return
      end
    end
  end
end
