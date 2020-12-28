module Brainlet
  module Maintenance
    module_function

    def update(config)
      prompt = config[:prompt]

      tasks = prompt.multi_select("Which projects do you want to update?", %w(klipper moonraker ui webcam caddy))

      tasks.each do |task|
        case task
        when "klipper"
          prompt.say("Updating the klipper source")
          Brainlet::Install::klipper(config)
          prompt.say("Creating the klipper environment")
          Brainlet::Install::klipper_env(config)
        when "moonraker"
          prompt.say("Updating the moonraker source")
          Brainlet::Install::moonraker(config)
          prompt.say("Updating the moonraker environment")
          Brainlet::Install::moonraker_env(config)
        when "ui"
          prompt.say("Updating the UI source")
          Brainlet::Install::ui(config)
        when "webcam"
          prompt.say("Updating the webcam source")
          Brainlet::Install::webcam(config)
        when "caddy"
          prompt.say("Updating the caddy binary")
          Brainlet::Install::caddy(config)
        end
      end
    end
  end
end
