module Brainlet
  module Menu
    module_function

    def profile(config)
      prompt = config[:prompt]
      
      task = prompt.select("Which profile task would you like to do?", %w(List Create Remove Quit))

      case task
      when "List"
        Brainlet::Profile::list(config)
      when "Create"
        Brainlet::Profile::create(config)
      when "Remove"
        Brainlet::Profile::remove(config)
      when "Quit"
        return
      end
    end
  end
end
