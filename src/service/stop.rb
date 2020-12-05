module Brainlet
  module Service
    module_function

    def stop(config)
      cmd = config[:cmd]
      prompt = config[:prompt]

      name = ""

      printer_profiles = []
      Dir.chdir("/home/#{ENV['SUDO_USER']}/configs") do
        printer_profiles = Dir.glob("*").select { |f| File.directory? f }
      end

      loop do
        name = prompt.select("Which printer would you like to stop?", printer_profiles)
        break if prompt.yes?("Are you sure you would like to stop #{name}?")
      end

      cmd.run  "systemctl stop #{name}-klipper.service"
      cmd.run  "systemctl stop #{name}-moonraker.service"
      cmd.run! "systemctl stop #{name}-webcam.service"
    end
  end
end
