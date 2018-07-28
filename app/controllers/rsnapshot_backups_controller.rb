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
		@logs = RsnapshotLogUtil.get_log_output
	end

	def settings
		@page_title = t('amahi_backups')
		@dest_path = RsnapshotHelper.get_fields("snapshot_root")
		@backup_paths = RsnapshotHelper.get_fields("backup")
		@cron_job_status = CronTabHelper.check_status
		@current_interval = @cron_job_status? CronTabHelper.get_cron_interval : nil
	end

	def update_backup_directory
		dest_path = params[:destination_path]
		if RsnapshotHelper.path_format_checker(dest_path)
			RsnapshotHelper.update_conf("snapshot_root", dest_path)
			render :json => {success: true, set_path: dest_path}
		else
			render :json => {success: false, message: "Path not exist or Inappropriate format."}
		end
	end

	def update_backup_sources
		sources = params[:source_path_input]
		if sources.blank? or sources.length==0
			render :json => {success: false, message: "Number of Paths cannot be 0."}
			return
		end

		if RsnapshotHelper.path_format_checker(sources)
			RsnapshotHelper.delete_conf("backup")

			sources.each do |source|
				RsnapshotHelper.add_conf("backup", [source, "localhost/"])
			end

			render :json => {success: true, message: "Backup Paths Set Successfully.", sources: sources}
		else
			render :json => {success: false, message: "One or more Paths have Inappropriate format."}
		end
	end

	def update_interval
		CronTabHelper.add_cron(params[:interval])
	end

	def stop_automatic_backup
		CronTabHelper.remove_cron
	end

end
