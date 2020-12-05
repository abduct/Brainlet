module Brainlet
  module Maintenance
    module_function

    def python2(config)
      prompt  = config[:prompt]
      cmd     = config[:cmd]

      prompt.say("Checking python2 dependency...")
      cmd.run! "which python2"
      if not $?.success?
        prompt.say("Installing python2 (This may take up to 20 minutes)...")
        Brainlet::Install::python2(config)
      else
        prompt.say("Python2 is already installed...")
      end
    end
  end
end
