class CronTabHelper
	class << self
		def check_status
			list = `sudo crontab -l`
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
			list = `sudo crontab -l`
			enteries = list.split("\n")
			enteries.delete_if {|entry| entry.include? "rsnapshot"}
			`sudo crontab -r`
			enteries.each do |entry|
				add_to_crontab(entry)
			end
		end

		def add_to_crontab(cron_string)
			`crontab -l | { cat; echo '#{cron_string}'; } | crontab -`
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
