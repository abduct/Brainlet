module Brainlet
  module Install
    module_function

    def python2(config)
      cmd     = config[:cmd]
      spinner = config[:spinner]

      spinner.run do
        Dir.chdir("/usr/src") do
          cmd.run "wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz"
          cmd.run "tar xzf Python-2.7.18.tgz"

          Dir.chdir("/usr/src/Python-2.7.18") do
            cmd.run "./configure --enable-optimizations"
            cmd.run "make altinstall"
            cmd.run "ln -s /usr/local/bin/python2.7 /usr/bin/python2"
          end

          cmd.run "wget https://bootstrap.pypa.io/get-pip.py"
          cmd.run "python2 get-pip.py"
          cmd.run "pip2 install --upgrade setuptools virtualenv"

          cmd.run "rm -rf Python*"
          cmd.run "rm -rf get-pip.py"
        end
      end
    end
  end
end
