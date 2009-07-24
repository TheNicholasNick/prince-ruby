class Prince
  
  attr_accessor :exe_path, :style_sheets, :log_file, :options

  # Initialize method
  #
  def initialize()
    # Finds where the application lives, so we can call it.
    @exe_path = `which prince`.chomp
  	@style_sheets = ""
  	@log_file = nil
  	@options = " --silent --no-network --disallow-modify --disallow-annotate"
  end
  
  # Sets stylesheets...
  # Can pass in multiple paths for css files.
  #
  def add_style_sheets(*sheets)
    for sheet in sheets do
      @style_sheets << " -s #{sheet} "
    end
  end
  
  # Returns fully formed executable path with any command line switches
  # we've set based on our variables.
  #
  def exe_path
    @exe_path << " --log=#{@log_file}" unless @log_file.nil?
    @exe_path << @options
    @exe_path << @style_sheets
    return @exe_path
  end
  
  # Makes a pdf from a passed in string (html).
  #
  def html2pdf_to_string(string)
    path = self.exe_path()
    # set up to take IO as input and output
    path << " --input=html - -o -"
    # Actually call the prince command, and pass the entire data stream back.
    pdf = IO.popen(path, "w+")
    pdf.puts(string)
    pdf.close_write
    output = pdf.gets(nil)
    pdf.close_read
    return output
  end
  
  # Makes a pdf from a passed in string (html) and saves to file specified
  # returns true / false if it everything completed ok
  # 
  def html2pdf_to_file(string, file)
    path = self.exe_path()
    # set up to take IO as input and output
    path << " --input=html - -o #{file}"
    # Actually call the prince command.
    pdf = IO.popen(path, "w+")
    pdf.puts(string)
    pdf.close
    # see if everything finished ok
    $?.exitstatus == 0
  end
end