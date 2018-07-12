RsnapshotBackups::Engine.routes.draw do
	# root of the plugin
        root :to => 'rsnapshot_backups#index'
	# examples of controllers built in this generator. delete at will
	match 'settings' => 'rsnapshot_backups#settings',:via=> :all
	match 'advanced' => 'rsnapshot_backups#advanced',:via => :all
end
