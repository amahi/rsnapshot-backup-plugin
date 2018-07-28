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
		@current_interval = @cron_job_status? CronTabHelper.get_cron_interval : nil
	end

	def update_backup_directory
		dest_path = RsnapshotHelper.formatted_path(params[:destination_path])
		if RsnapshotHelper.check_if_path_exists(dest_path)
			RsnapshotHelper.update_conf("snapshot_root", dest_path)
			render :json => {success: true, set_path: dest_path}
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

			render :json => {success: true, message: "Backup Paths Set Successfully.", sources: sources}
		else
			render :json => {success: false, message: "Error: One or more paths do not exist."}
		end
	end

	def update_interval
		CronTabHelper.add_cron(params[:interval])
	end

	def stop_automatic_backup
		CronTabHelper.remove_cron
	end

end
