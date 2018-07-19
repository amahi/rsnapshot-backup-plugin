# plugin initialization
t = Tab.new("rsnapshot_backups", "rsnapshot_backups", "/tab/rsnapshot_backups")
# add any subtabs with what you need. params are controller and the label, for example
t.add("index", "details")
t.add("settings", "settings")