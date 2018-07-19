class CronTabHelper
	class << self
		def check_status
			response = `sudo crontab -l`
			response.include? "rsnapshot"
		end

		def add_cron(interval)
			remove_cron if check_status
			
			#if interval == "daily"
			#if interval == "hourly"
			#if interval == "weekly"
		end

		def remove_cron
		end

		def convert_to_readable_format(cron_string)
		end
	end
end
