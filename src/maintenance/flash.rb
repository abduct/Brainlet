module Brainlet
  module Maintenance
    module_function

    def flash(config)
      cmd     = config[:cmd]
      spinner = config[:spinner]
      prompt  = config[:prompt]

      prompt.warn("Warning: Some printers are not able to be flashed over USB!")

      devices = Dir.glob("/dev/serial/by-id/*")
      device  = prompt.select('Please select the device you wish flash', devices)

      spinner.run do
        Dir.chdir("/home/#{ENV['SUDO_USER']}/software/klipper") do
          cmd.run "make flash FLASH_DEVICE=#{device}"
        end
      end
    end
  end
end
