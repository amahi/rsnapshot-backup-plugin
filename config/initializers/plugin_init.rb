# plugin initialization
t = Tab.new("rsnapshot_backups", "amahi_backups", "/tab/amahi_backups")
# add any subtabs with what you need. params are controller and the label, for example
t.add("index", "details")
t.add("settings", "settings")