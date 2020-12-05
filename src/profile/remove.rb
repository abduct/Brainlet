module Brainlet
  module Profile
    module_function

    def remove(config)
      cmd     = config[:cmd]
      spinner = config[:spinner]
      prompt  = config[:prompt]

      printer_profiles = []
      Dir.chdir("/home/#{ENV['SUDO_USER']}/configs") do
        printer_profiles = Dir.glob("*").select { |f| File.directory? f }
      end

      profile = ""

      loop do
        profile = prompt.select("Which printer would you like to remove?", printer_profiles)
        break if prompt.yes?("Are you sure you would like to remove #{profile}?")
      end

      spinner.run do
        cmd.run "rm -rf /home/#{ENV['SUDO_USER']}/configs/#{profile}"
        cmd.run "rm -rf /home/#{ENV['SUDO_USER']}/logs/#{profile}"

        cmd.run "systemctl stop #{profile}-klipper.service"
        cmd.run "systemctl disable #{profile}-klipper.service"
        cmd.run "rm -rf /etc/systemd/system/#{profile}-klipper.service"

        cmd.run "systemctl stop #{profile}-moonraker.service"
        cmd.run "systemctl disable #{profile}-moonraker.service"
        cmd.run "rm -rf /etc/systemd/system/#{profile}-moonraker.service"

        cmd.run! "systemctl stop #{profile}-webcam.service"
        cmd.run! "systemctl disable #{profile}-webcam.service"
        cmd.run! "rm -rf /etc/systemd/system/#{profile}-webcam.service"

        cmd.run "systemctl daemon-reload"
      end
    end
  end
end
