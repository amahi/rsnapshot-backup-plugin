require "rsnapshot_backups/rsnapshot_helper.rb"
require "rsnapshot_backups/crontab_helper.rb"
require "rsnapshot_backups/rsnapshot_log_util.rb"

class RsnapshotBackupsController < ApplicationController
	before_action :admin_required

	def index
		@page_title = t('amahi_backups')
		RsnapshotHelper.run_init_script if RsnapshotHelper.first_time_setup
		@cron_job_status = CronTabHelper.check_status
		@dest_path = RsnapshotHelper.get_fields("snapshot_root")
		@logs = @cron_job_status? RsnapshotLogUtil.get_log_output : nil
	end

	def settings
		@page_title = t('amahi_backups')
		@dest_path = RsnapshotHelper.get_fields("snapshot_root")
		@backup_paths = RsnapshotHelper.get_fields("backup")
		@cron_job_status = CronTabHelper.check_status
		@current_intervals = CronTabHelper.get_cron_intervals
	end

	def update_backup_directory
		dest_path = RsnapshotHelper.formatted_path(params[:destination_path])
		if RsnapshotHelper.check_if_path_exists(dest_path)
			RsnapshotHelper.update_conf("snapshot_root", dest_path)
			render :json => {success: true, set_path: dest_path, message: "Updated"}
		else
			render :json => {success: false, message: "Error: Path '#{dest_path}' do not exist."}
		end
	end

	def update_backup_sources
		sources = RsnapshotHelper.formatted_path(params[:source_path_input])
		if sources.blank? or sources.length==0
			render :json => {success: false, message: "Number of paths cannot be 0."}
			return
		end

		if RsnapshotHelper.check_if_path_exists(sources)
			RsnapshotHelper.delete_conf("backup")

			sources.each do |source|
				RsnapshotHelper.add_conf("backup", [source, "./"])
			end

			render :json => {success: true, message: "Updated", sources: sources}
		else
			render :json => {success: false, message: "Error: One or more paths do not exist."}
		end
	end

	def start_backups
		intervals = params[:interval]
		if intervals.blank? or intervals.size == 0
			render :json => {success: false, message: "Error: Select atleast one 'Repeat Duration' to start backups"}
		else
			CronTabHelper.add_crons(intervals)
			render :json => {success: true, message: "Backups Scheduled"}
		end
	end

	def stop_backups
		CronTabHelper.remove_all_crons
		render :json => {success: true, message: "Backups Stopped"}
	end

	def update_interval
		type = params[:type]
		interval = params[:interval]
		if type == "true"
			CronTabHelper.add_cron(interval)
		else
			CronTabHelper.remove_cron(interval)
		end
		render :json => {success: true, message: "Updated",
			interval: interval, type: type}
	end

end
