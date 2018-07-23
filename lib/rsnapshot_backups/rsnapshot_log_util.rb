require "date"
require "rsnapshot_backups/rsnapshot_helper.rb"

class RsnapshotLogUtil
	class << self
		def parse_datetime_string(string)
			DateTime.parse(string).ctime
		end

		def get_log_file_path
			"/var/log/rsnapshot"
		end

		def get_sample_log_file_path
			Rails.root+Dir["plugins/*rsnapshot_backups/db/sample-data/sample-rsnapshot-log"][0]
		end

		def get_created_backup_names
			folder_names = []
			type_counts = {"alpha":0, "beta":0, "gamma":0}
			dest_path = RsnapshotHelper.get_fields("snapshot_root")

			Dir.open(dest_path).each do |filename|
				folder_names << filename if File.directory? filename
				if filename.to_s.index("alpha")!=-1
					type_counts[:alpha]=type_counts[:alpha]+1
				elsif filename.to_s.index("beta")!=-1
					type_counts[:beta]=type_counts[:beta]+1
				elsif filename.to_s.index("gamma")!=-1
					type_counts[:gamma]=type_counts[:gamma]+1
				end
			end

			return { folder_names: folder_names, counts: type_counts }
		end

		def parse_log_file
			log_enteries = []
			File.open(get_sample_log_file_path, "r").each do |line|
				if line =~ /\[.*\] \/usr\/bin\/rsnapshot (alpha|beta|gamma): .*/

					unless line.index("started").blank?
						type = nil
						if line.index("alpha")!=-1
							type = "alpha"
						elsif line.index("beta")!=-1
							type = "beta"
						elsif line.index("gamma")!=-1
							type = "gamma"
						end

						log_enteries << {start_time: parse_datetime_string(line[1..19]), type: type, start_message: line[48..-1].strip}
					else
						last_entry = log_enteries.last
						last_entry[:end_time]=parse_datetime_string(line[1..19])
						last_entry[:end_message]=line[48..-1].strip
						log_enteries.pop()
						log_enteries << last_entry
					end
				end

				unless line.index("touch").blank?
					last_entry = log_enteries.last
					initial_index=28
					last_index=line[0..-3].rindex("/")
					last_entry[:location]=line[initial_index..last_index]
					log_enteries.pop()
					log_enteries << last_entry
				end

			end
			log_enteries
		end

		def get_log_output
			log_enteries = self.parse_log_file
			dest_path = RsnapshotHelper.get_fields("snapshot_root")

			backup_folder_counts = self.get_created_backup_names[:counts]

			alpha_limit = [6, backup_folder_counts[:alpha]].min
			beta_limit = [7, backup_folder_counts[:beta].min
			gamma_limit = [4, backup_folder_counts[:gamma]].min

			alpha_count = beta_count = gamma_count = 0

			output = []
			log_enteries.reverse.each do |entry|
				if entry[:type] == "alpha"
					if alpha_count < alpha_limit && entry[:location] == dest_path
						alpha_count = alpha_count+1
						output << entry
					end
				elsif entry[:type] == "beta"
					if beta_count < beta_limit && entry[:location] == dest_path
						beta_count = beta_count+1
						output << entry
					end
				elsif entry[:type] == "gamma"
					if gamma_count < gamma_limit && entry[:location] == dest_path
						gamma_count = gamma_count+1
						output << entry
					end
				end
			end

			output
		end

	end
end
