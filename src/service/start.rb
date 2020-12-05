module Brainlet
  module Service
    module_function

    def start(config)
      cmd = config[:cmd]
      prompt = config[:prompt]

      name = ""

      printer_profiles = []
      Dir.chdir("/home/#{ENV['SUDO_USER']}/configs") do
        printer_profiles = Dir.glob("*").select { |f| File.directory? f }
      end

      loop do
        name = prompt.select("Which printer would you like to start?", printer_profiles)
        break if prompt.yes?("Are you sure you would like to start #{name}?")
      end

      cmd.run  "systemctl start #{name}-klipper.service"
      cmd.run  "systemctl start #{name}-moonraker.service"
      cmd.run! "systemctl start #{name}-webcam.service"
    end
  end
end
