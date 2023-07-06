namespace :api do
  task :generate_docs do
    raml2html = 'node_modules/raml2html/bin/raml2html'

    raml_files = [
      {
        src: '_api/v1/doc.raml',
        dest: 'api/v1/index.html'
      }
    ]

    raml_files.each do |file|
      raml_file = "#{ROOT_PATH}/#{file[:src]}"
      html_file = "#{ROOT_PATH}/#{file[:dest]}"

      html_dir = File.dirname(html_file)
      FileUtils.mkdir_p(html_dir)

      cmd = %Q[#{raml2html} #{raml_file} > #{html_file}]
      puts `#{cmd}`
      #Kernel.system(cmd)
      exitstatus = $?.exitstatus
      if exitstatus.zero?
        puts "Compilation done for #{file[:src]}. Generated the #{file[:dest]} file."
      else
        puts "Something failed during RAML to HTML compilation for #{raml_file}."

        if File.exist?(html_file)
          puts "You can check the HTML output in the #{html_file} file. It should contain an error message. Here is the preview:"
          puts '=== START ==='
          puts File.read(html_file)
          puts '=== END ==='
        end

        Kernel.exit(exitstatus)
      end
    end

    puts 'Finished!'
  end
end
