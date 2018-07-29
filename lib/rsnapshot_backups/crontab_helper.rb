class CronTabHelper
	class << self
		def check_status
			intervals = get_cron_intervals
			intervals.size != 0
		end

		def add_crons(intervals)
			intervals.each do |interval|
				add_cron(interval)
			end
		end

		def add_cron(interval=nil)
			if interval == "weekly"
				add_to_crontab('weekly')
			elsif interval == "monthly"
				add_to_crontab('monthly')
			else # daily (as default)
				add_to_crontab('daily')
			end
		end

		def remove_cron(interval)
			`sudo /var/hda/apps/03qjfjl1sh/elevated/crontab-util 'remove' '#{interval}'`
		end

		def get_cron_list
			`sudo /var/hda/apps/03qjfjl1sh/elevated/crontab-util 'list'`
		end

		def add_to_crontab(interval)
			`sudo /var/hda/apps/03qjfjl1sh/elevated/crontab-util 'add' '#{interval}'`
		end

		def get_cron_intervals
			list = get_cron_list
			intervals = list.split(" ")
		end

		def remove_all_crons
			`sudo /var/hda/apps/03qjfjl1sh/elevated/crontab-util 'reset'`
		end

	end
end
