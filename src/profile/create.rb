module Brainlet
  module Profile
    module_function

    def create(config)
      cmd     = config[:cmd]
      spinner = config[:spinner]
      prompt  = config[:prompt]

      sudo_user = ENV['SUDO_USER']
      profile  = "imouto"

      prompt.say("Your current profiles are:")
      Brainlet::Profile::list(config)

      loop do
        profile = prompt.ask("What would you like to profile your new profile?", default: profile)
        break if prompt.yes?("Are you sure you would to call your new profile (#{profile})?")
      end

      moonraker_port = prompt.ask("What port would you like moonraker to run on?", default: "7125")

      devices = Dir.glob("/dev/serial/by-id/*")
      device  = prompt.select("What device belongs to this profile", devices)

      if webcam = prompt.yes?("Would you like to install a webcam for this profile?")
        webcam_type    = prompt.select("What is your profiles webcam type?", %w(uvc raspicam))

        webcam_devices = Dir.glob("/dev/v4l/by-path/*").map do |file|
          {"#{file} -> #{File.readlink(file)}" => file}
        end.compact

        webcam_device  = prompt.select("What is your profiles webcam device?", webcam_devices)

        webcam_x_resolution = prompt.ask("What is your profiles webcam X resolution?", default: "1280")
        webcam_y_resolution = prompt.ask("What is your profiles webcam Y resolution?", default: "720")
        webcam_framerate    = prompt.ask("What is your profiles webcam framerate?", default: "15")
        webcam_port         = prompt.ask("What is your profiles webcam port?", default: "8080")
      end

      spinner.run do
        cmd.run "mkdir -p /home/#{sudo_user}/configs/#{profile}"
        cmd.run "mkdir -p /home/#{sudo_user}/logs/#{profile}"
        cmd.run "mkdir -p /home/#{sudo_user}/sdcard/#{profile}"

        cmd.run "cp ./resources/klipper/printer.cfg /home/#{sudo_user}/configs/#{profile}/printer.cfg"
        cmd.run "sed -i -e 's|$DEVICE|#{device}|g' /home/#{sudo_user}/configs/#{profile}/printer.cfg"
        cmd.run "sed -i -e 's|$NAME|#{sudo_user}|g' /home/#{sudo_user}/configs/#{profile}/printer.cfg"
        cmd.run "sed -i -e 's|$PROFILE|#{profile}|g' /home/#{sudo_user}/configs/#{profile}/printer.cfg"

        cmd.run "cp ./resources/klipper/macros.cfg /home/#{sudo_user}/configs/#{profile}/macros.cfg"

        cmd.run "cp ./resources/klipper/klipper.service /etc/systemd/system/#{profile}-klipper.service"
        cmd.run "sed -i -e 's|$NAME|#{sudo_user}|g' /etc/systemd/system/#{profile}-klipper.service"
        cmd.run "sed -i -e 's|$PROFILE|#{profile}|g' /etc/systemd/system/#{profile}-klipper.service"
        cmd.run "chmod 664 /etc/systemd/system/#{profile}-klipper.service"
        cmd.run "systemctl enable #{profile}-klipper.service"

        cmd.run "cp ./resources/moonraker/moonraker.service /etc/systemd/system/#{profile}-moonraker.service"
        cmd.run "sed -i -e 's|$NAME|#{sudo_user}|g' /etc/systemd/system/#{profile}-moonraker.service"
        cmd.run "sed -i -e 's|$PROFILE|#{profile}|g' /etc/systemd/system/#{profile}-moonraker.service"
        cmd.run "chmod 664 /etc/systemd/system/#{profile}-moonraker.service"
        cmd.run "systemctl enable #{profile}-moonraker.service"

        cmd.run "cp ./resources/moonraker/moonraker.cfg /home/#{sudo_user}/configs/#{profile}/moonraker.cfg"
        cmd.run "sed -i -e 's|$PORT|#{moonraker_port}|g' /home/#{sudo_user}/configs/#{profile}/moonraker.cfg"
        cmd.run "sed -i -e 's|$PROFILE|#{profile}|g' /home/#{sudo_user}/configs/#{profile}/moonraker.cfg"
        cmd.run "sed -i -e 's|$NAME|#{sudo_user}|g' /home/#{sudo_user}/configs/#{profile}/moonraker.cfg"


        if webcam
          cmd.run "cp ./resources/webcam/webcam.service /etc/systemd/system/#{profile}-webcam.service"
          cmd.run "sed -i -e 's|$NAME|#{sudo_user}|g' /etc/systemd/system/#{profile}-webcam.service"
          cmd.run "sed -i -e 's|$TYPE|#{webcam_type}|g' /etc/systemd/system/#{profile}-webcam.service"
          cmd.run "sed -i -e 's|$DEVICE|#{webcam_device}|g' /etc/systemd/system/#{profile}-webcam.service"
          cmd.run "sed -i -e 's|$FRAMERATE|#{webcam_framerate}|g' /etc/systemd/system/#{profile}-webcam.service"
          if webcam_type == "uvc"
            cmd.run "sed -i -e 's|$RESOLUTION|-r #{webcam_x_resolution}x#{webcam_y_resolution}|g' /etc/systemd/system/#{profile}-webcam.service"
          else
            cmd.run "sed -i -e 's|$RESOLUTION|-x #{webcam_x_resolution} -y #{webcam_y_resolution}|g' /etc/systemd/system/#{profile}-webcam.service"
          end
          cmd.run "sed -i -e 's|$PORT|#{webcam_port}|g' /etc/systemd/system/#{profile}-webcam.service"
          cmd.run "chmod 664 /etc/systemd/system/#{profile}-webcam.service"
          cmd.run "systemctl enable #{profile}-webcam.service"
        end

        cmd.run "chown -R #{sudo_user}:#{sudo_user} /home/#{sudo_user}"
        cmd.run "systemctl daemon-reload"

        cmd.run  "systemctl start #{profile}-klipper.service"
        cmd.run  "systemctl start #{profile}-moonraker.service"
        cmd.run! "systemctl start #{profile}-webcam.service"
      end
    end
  end
end
