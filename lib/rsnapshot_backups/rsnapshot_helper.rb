class SmartTestUtil
	class << self
		def get_parsed_config_file
			parse_config_file("/etc/rsnapshot.conf")
		end

		def get_parsed_sample_file
			path = Rails.root+Dir["plugins/*rsnapshot_backups/db/sample-data/sample_rsnapshot.conf"][0]
			parse_config_file(path)
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

				data << {"#{key}": temp}
			end

			data
		end
	end
end
