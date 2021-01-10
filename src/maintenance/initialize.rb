module Brainlet
  module Maintenance
    module_function

    def initialize(config)
      cmd     = config[:cmd]
      spinner = config[:spinner]
      prompt  = config[:prompt]

      prompt.say("Initializing Brainlet")

      spinner.run do
        Dir.chdir("/home/#{ENV['SUDO_USER']}") do
          cmd.run "mkdir -p sdcard logs configs software recovery/configs recovery/services"
        end

        prompt.say("Checking/installing required dependencies...")
        cmd.run "apt install --yes git libv4l-dev cmake libffi-dev build-essential libncurses-dev libusb-dev avrdude gcc-avr binutils-avr avr-libc python3-virtualenv python3-dev libjpeg-dev"
      end

      prompt.say("Installing klipper...")
      Brainlet::Install::klipper(config)

      prompt.say("Installing klipper-env...")
      Brainlet::Install::klipper_env(config)

      prompt.say("Installing moonraker...")
      Brainlet::Install::moonraker(config)

      prompt.say("Installing moonraker-env...")
      Brainlet::Install::moonraker_env(config)

      prompt.say("Installing caddy...")
      Brainlet::Install::caddy(config)

      prompt.say("Installing the web ui...")
      Brainlet::Install::ui(config)

      prompt.say("Installing webcam support...")
      Brainlet::Install::webcam(config)

      prompt.say("Compiling klipper c_helper.so...")
      cmd.run "/home/#{ENV['SUDO_USER']}/software/klipper-env/bin/python2 /home/#{ENV['SUDO_USER']}/software/klipper/klippy/chelper/__init__.py"

      prompt.say("Fixing permissions...")
      cmd.run "chown -R #{ENV['SUDO_USER']}:#{ENV['SUDO_USER']} /home/#{ENV['SUDO_USER']}"
    end
  end
end
