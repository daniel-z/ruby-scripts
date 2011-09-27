#!/usr/bin/ruby

# This software by Daniel Zamorano is licensed under a 
# Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
# Read the license here: http://creativecommons.org/licenses/by-nc-sa/3.0/

# cssSearch - This searchs for a css property in a css file

require 'css_parser'


class CssSearch

  def initialize( params )
    @debug = params['debug'] || false
    @parserObj = CssParser::Parser.new
  end

  def getSelectors (params)

    functionName = 'getSelectors'

    #look for needed parameters or return
    for parameter in ['cssPropertyMask', 'cssFile']
      if !params["#{parameter}"]
        logger ({"type"     => 'error',
                "function" => "#{functionName}",
                "message"  => "Needed #{parameter} parameter"})
        return false
      end
    end

    cssPropertyMask = ( params['cssPropertyMask'] ) || '*'
    cssSelectors = Hash.new

    if isValidFile({"file" => params['cssFile']})
      @parserObj.load_file!(params['cssFile'])   
    end

    logger ({"type"     => 'info',
            "function" => "#{functionName}", 
            "message"  => "cssPropertyMask: #{cssPropertyMask}"})

    # iterate through selectors
    @parserObj.each_selector() do |selector, declarations, specificity|
        if  declarations =~ /#{cssPropertyMask}/ 
          #just set the selector as key and 1 to avoid duplicate elements if we use a hash
          cssSelectors["#{selector}"] = 1

          logger ({"type"     => 'info',
                  "function" => "#{functionName}", 
                  "message"  => "true! #{selector} -> #{cssSelectors["#{selector}"]}"})
        end
    end

    # get selector into array
    resultingSelectors = Array.new(cssSelectors.keys)

    logger ({"type"     => 'info',
            "function" => "#{functionName}", 
            "message"  => "Resulting Selectors:"})

    resultingSelectors.each do | selector |
      logger ({"type" => 'info', "function" => "#{functionName}", "message"  => "#{selector}"})     
    end

    return resultingSelectors

  end #getSelectors



  def getAllSelectorsInDirectory (params)
    #look for needed parameters or return
    for parameter in ['directory', 'cssPropertyMask']
      if !params["#{parameter}"]
        logger ({"type"     => 'error', 
                "function" => 'getAllSelectorsInDirectory', 
                "message"  => "needed #{parameter} parameter!"})
        return false
      end
    end
    
    # get all files in directory
    fileList = Hash.new
    logger ({"type"     => 'info',
             "function" => 'getAllSelectorsInDirectory', 
             "message"  => "File List of dir: #{params['directory']}"})

    dirEntries = Array.new(Dir.entries("#{params['directory']}"))
    dirEntries.each do | file |
      if isValidFile("file" => "#{params["directory"]}\/#{file}") 
         fileList["#{file}"] = 1;
      end
    end

    allSelectors = Hash.new

    # make the search for every file
    for file in fileList.keys

      fileResults = Hash.new

      fileResults = getSelectors({
          "cssPropertyMask" => "#{params['cssPropertyMask']}",
          "cssFile"         => "#{params["directory"]}\/#{file}" })
      
      fileResults.each do |selector|
        allSelectors["#{selector}"] = 1 
      end

    end

    return allSelectors.keys
  end # getAllSelectorsInDirectory

  # ---
  # private functions
  # ---
  
  # private



  def isValidFile (params)

    #look for needed parameters or return
    for parameter in ['file']
      if !params["#{parameter}"]
        logger ({"type"     => 'error', 
                "function" => 'isValidFile', 
                "message"  => "needed #{parameter} parameter!"})
        return false
      end
    end

    if !File.exists?("#{params["file"]}")
      logger ({"type"    => 'error', 
              "function" => 'isValidFile', 
              "message"  => "file doesn't exists: #{params["file"]}"})      
      return false
    end

    if File.directory?("#{params["file"]}")
      logger ({"type"    => 'info', 
              "function" => 'isValidFile', 
              "message"  => "#{params["file"]} is a directory"})      
      return false
    end


    if !(/\.css\Z/ =~ "#{params["file"]}")
      logger ({"type"    => 'info', 
              "function" => 'isValidFile', 
              "message"  => "#{params["file"]} is not a valid css file"})
      return false
    end

    logger ({"type"     => 'info', 
            "function" => 'isValidFile', 
            "message"  => "Valid!!: #{params["file"]}"})

    return true
  end # isValidFile



  # ToDo: Use Logger from Ruby
  def logger (params)
    # print message just if debug is enabled
    return if !@debug
    
    prefix = Hash.new
    prefix['error']   = 'ERROR!!'
    prefix['warning'] = 'WARNING'
    prefix['info']    = 'INFO'    

    #look for needed parameters or return
    for parameter in ['message','type','function']
      if !params["#{parameter}"]
          puts "#{prefix['error']} - logger: needed #{parameter} parameter!"
          return
      end
    end
    
    if !prefix["#{params['type']}"] and @debug
      puts "#{prefix['error']} - logger: invalid log type for message: #{params['message']}"
      return
    end

    puts "#{prefix["#{params['type']}"]} - #{params['function']}: #{params['message']}"

  end # loggers



end #class