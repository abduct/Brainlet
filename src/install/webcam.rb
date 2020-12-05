module Brainlet
  module Install
    module_function

    def webcam(config)
      cmd     = config[:cmd]
      spinner = config[:spinner]

      spinner.run do
        Dir.chdir("/home/#{ENV['SUDO_USER']}/software") do
          cmd.run "rm -rf webcam"
          cmd.run "git clone --depth 1 #{config[:webcam]} webcam"

          Dir.chdir("/home/#{ENV['SUDO_USER']}/software/webcam/mjpg-streamer-experimental") do
            cmd.run "make"
            cmd.run "make install"
          end
        end
      end
    end
  end
end
