require "rsnapshot_backups/rsnapshot_helper.rb"

class RsnapshotBackupsController < ApplicationController
	before_action :admin_required

	def index
		@page_title = t('rsnapshot_backups')
		# do your main thing here
	end

	def settings
		@page_title = t('rsnapshot_backups')
		@dest_path = RsnapshotHelper.get_fields("snapshot_root")
		@backup_paths = RsnapshotHelper.get_fields("backup")
	end

	def advanced
		@page_title = t('rsnapshot_backups')
		# do the advanced settings page here
	end

	def update_backup_directory
		dest_path = params[:destination_path]
		if RsnapshotHelper.path_format_checker(dest_path)
			RsnapshotHelper.update_conf("snapshot_root", dest_path)
			render :json => {success: true, set_path: dest_path}
		else
			render :json => {success: false, message: "path not exist or inappropriate format."}
		end
	end

	def update_backup_sources
		sources = params[:source_path_input]
		if RsnapshotHelper.path_format_checker(sources)
			RsnapshotHelper.delete_conf("backup")

			sources.each do |source|
				RsnapshotHelper.add_conf("backup", [source, "localhost/"])
			end

			render :json => {success: true, message: "backup paths set successfully."}
		else
			render :json => {success: false, message: "one or more paths does not exist or have inappropriate format."}
		end
	end

	def update_interval
		
	end
end
