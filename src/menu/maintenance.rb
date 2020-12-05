module Brainlet
  module Menu
    module_function

    def maintenance(config)
      prompt = config[:prompt]
      
      task = prompt.select("Which maintenance task would you like to do?", %w(Initialize Python2 Update Build Flash Quit))

      case task
      when "Initialize"
        Brainlet::Maintenance::initialize(config)
      when "Python2"
        Brainlet::Maintenance::python2(config)
      when "Update"
        Brainlet::Maintenance::update(config)
      when "Build"
        Brainlet::Maintenance::build(config)
      when "Flash"
        Brainlet::Maintenance::flash(config)
      when "Quit"
        return
      end
    end
  end
end
