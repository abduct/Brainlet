module Brainlet
  module Profile
    module_function

    def list(config)
      cmd = config[:cmd]
      prompt = config[:prompt]

      printer_profiles = []
      Dir.chdir("/home/#{ENV['SUDO_USER']}/configs") do
        printer_profiles = Dir.glob("*").select { |f| File.directory? f }
      end

      printer_profiles.each do |name|
        moonraker_port, _ = cmd.run "grep -Po 'port: \\K(\\d*)' /home/#{ENV['SUDO_USER']}/configs/#{name}/moonraker.cfg"
        webcam_port, _    = cmd.run "grep -Po 'p \\K(\\d*)' /etc/systemd/system/#{name}-webcam.service"
        prompt.say("Printer (#{name}): Moonraker: #{moonraker_port.chomp} Webcam: #{webcam_port.chomp}")
      end
    end
  end
end
