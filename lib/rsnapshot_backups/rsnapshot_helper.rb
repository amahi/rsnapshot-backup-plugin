class RsnapshotHelper
	class << self
	    # funct to add new key-value in conf file if not present already
		def add_conf(key, value)
			file_path = get_config_file_path
			data = get_parsed_config_file
			return false if data.blank?

			already_present = false

			data.each do |obj|
				obj_key = obj.keys[0]
				obj_value = obj.values[0]

				if obj_key.to_s == key.to_s
					obj_value.each do |v|
						if v.to_s == value.to_s
							already_present = true
							break
						end
					end
				end

				break if already_present
			end

			unless already_present
				append_string = ""
				if value.class == Array
					append_string = "#{key}"
					value.each do |val|
						append_string = append_string+"\t#{val}"
					end
				else
					append_string = "#{key}\t#{value}"
				end

				reflect_to_file(-1, append_string)
			end
		end

		# funct to update a value of particular key in conf file. if that key is not present then the key-value pair will be added at bottom of the conf file
		def update_conf(key, value)
			file_path = get_config_file_path
			data = get_parsed_config_file
			return false if data.blank?

			already_present = false
			line_to_update = nil

			data.each do |obj|
				obj_key = obj.keys[0]
				obj_value = obj.values[0]

				if obj_key.to_s == key.to_s
					line_to_update = obj

					obj_value.each do |v|
						if v.to_s == value.to_s
							already_present = true
							break
						end
					end
				end

				return if already_present
			end

			if line_to_update.blank?
				reflect_to_file(-1, "#{key}\t#{value}")
			else
				reflect_to_file(line_to_update[:line_num], "#{key}\t#{value}")
			end
		end

		# funct to delete existing key-value in conf file if present
		def delete_conf(key, value)
			file_path = get_config_file_path
			data = get_parsed_config_file
			return false if data.blank?

			already_present = false
			line_to_update = nil

			data.each do |obj|
				obj_key = obj.keys[0]
				obj_value = obj.values[0]

				if obj_key.to_s == key.to_s
					obj_value.each do |v|
						if v.to_s == value.to_s
							already_present = true
							line_to_update = obj
							break
						end
					end
				end

				break if already_present
			end

			if already_present
				reflect_to_file(line_to_update[:line_num], "")
			end
		end

		# funct to delete existing key-value in conf file if that key is present
		def delete_conf(key)
			file_path = get_config_file_path
			data = get_parsed_config_file
			return false if data.blank?

			lines_to_update = []

			data.each do |obj|
				obj_key = obj.keys[0]
				obj_value = obj.values[0]

				if obj_key.to_s == key.to_s
					lines_to_update.unshift(obj)
				end
			end

			unless lines_to_update.blank?
				lines_to_update.each do |line|
					reflect_to_file(line[:line_num], "")
				end
			end
		end

		def get_parsed_config_file
			parse_config_file(get_config_file_path)
		end

		def get_config_file_path
			"/etc/rsnapshot.conf"
		end

		def get_parsed_sample_file
			parse_config_file(get_sample_config_file_path)
		end

		def get_sample_config_file_path
			Rails.root+Dir["plugins/*rsnapshot_backups/db/sample-data/sample_rsnapshot.conf"][0]
		end

		def parse_config_file(file_path)
			return nil unless File.exists?(file_path)
			data = []

			File.foreach(file_path).with_index do |line, num|
				next if line.length == 0
				next if line[0] == '#'
				temp = line.split("\t")
				next if temp.size <=1
				key = temp[0]
				temp.shift
				temp[temp.length-1] = temp[temp.length-1].chomp
				temp.delete("")

				data << {"#{key}": temp, line_num: num+1}
			end

			data
		end

		def get_fields(key)
			data = get_parsed_config_file
			response = []
			data.each do |obj|
				if obj.keys[0].to_s == key.to_s
					response << obj.values[0]
				end
			end
			response
		end

		def formatted_path(paths)
			return paths if paths.blank?
			if paths.class == Array
				new_paths = []
				paths.each do |path|
					next if path.size == 0
					path = "/"+path if path[0]!="/"
					path = path+"/" if path[-1]!="/"
					new_paths << path
				end
				return new_paths
			else
				paths = "/"+paths if paths[0]!="/"
				paths = paths+"/" if paths[-1]!="/"
				return paths
			end
		end

		def check_if_path_exists(paths)
			if paths.class == Array
				paths.each do |path|
					return false if path.size == 0
					return false unless File.exists?(path)
				end
				return true
			else
				return File.exists?(paths)
			end
		end

		def reflect_to_file(line_num, line)
			line = line.gsub("/","\\/")
			`sudo /var/hda/apps/03qjfjl1sh/elevated/update-conf-file #{line_num} '#{line}'`
		end

		def first_time_setup
			File.open(get_config_file_path).grep(/03qjfjl1sh/).size == 0
		end

		def run_init_script
			reflect_to_file(-1, "# file edited by app-id: 03qjfjl1sh")
			`sudo /var/hda/apps/03qjfjl1sh/elevated/init-script`
		end

	end
end

