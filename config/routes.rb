RsnapshotBackups::Engine.routes.draw do
	root :to => 'rsnapshot_backups#index'
	match 'settings' => 'rsnapshot_backups#settings',:via=> :all

	post 'set_backup_directory' => 'rsnapshot_backups#update_backup_directory'
	post 'set_backup_sources' => 'rsnapshot_backups#update_backup_sources'
	post 'set_interval' => 'rsnapshot_backups#update_interval'
end
