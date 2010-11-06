view_files = Dir['app/views/**/*.html.erb']
spec_files = Dir['spec/views/**/*.html.erb_spec.rb']
spec_files_we_should_have = view_files.map { |file| file.sub(/^app/, "spec") + "_spec.rb" }
missing_spec_files = spec_files_we_should_have - spec_files
raise "You forgot some view specs: #{missing_spec_files.join("\n")}" unless missing_spec_files.empty?
