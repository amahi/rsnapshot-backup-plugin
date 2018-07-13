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
		Rails.logger.info("\n\n\nhi, there\n #{params.as_json}")
	end
end
