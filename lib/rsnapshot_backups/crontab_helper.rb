class CronTabHelper
	class << self
		def check_status
			list = get_cron_list
			list.include? "rsnapshot"
		end

		def add_cron(interval=nil)
			remove_cron if check_status
			if interval == "hourly"
				add_to_crontab("0 * * * * rsnapshot alpha")
			elsif interval == "weekly" # 6 - saturday
				add_to_crontab("0 0 * * 6 rsnapshot gamma")
			else # daily (as default)
				add_to_crontab("0 0 * * * rsnapshot beta")
			end
		end

		def remove_cron
			list = get_cron_list
			enteries = list.split("\n")
			enteries.delete_if {|entry| entry.include? "rsnapshot"}
			`sudo /var/hda/apps/03qjfjl1sh/elevated/crontab-util 'reset'`
			enteries.each do |entry|
				add_to_crontab(entry)
			end
		end

		def get_cron_list
			`sudo /var/hda/apps/03qjfjl1sh/elevated/crontab-util 'list'`
		end

		def add_to_crontab(cron_string)
			`sudo /var/hda/apps/03qjfjl1sh/elevated/crontab-util 'add' '#{cron_string}'`
		end

		def convert_to_readable_format(cron_string)
			if cron_string.include? "0 * * * *"
				return "hourly"
			elsif cron_string.include? "0 0 * * 6"
				return "weekly"
			elsif cron_string.include? "0 0 * * *"
				return "daily"
			else
				return nil
			end
		end

	end
end
