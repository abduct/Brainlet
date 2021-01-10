module Brainlet
  module Menu
    module_function

    def recovery(config)
      prompt = config[:prompt]
      
      task = prompt.select("Which recovery task would you like to do?", %w(Backup Backup-All Restore Restore-All Quit))

      case task
      when "Backup"
        Brainlet::Recovery::backup(config)
      when "Backup-All"
        Brainlet::Recovery::backup_all(config)
      when "Restore"
        Brainlet::Recovery::restore(config)
      when "Restore-All"
        Brainlet::Recovery::restore_all(config)
      when "Quit"
        return
      end
    end
  end
end
