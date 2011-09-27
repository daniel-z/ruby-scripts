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
      logger ({"type"     => 'error', 
              "function" => 'getProperFile', 
              "message"  => "file doesn't exists: #{params["file"]}"})      
      return false
    end

    if ! /\.css\Z/ =~ "#{params["file"]}"
      logger ({"type"     => 'info', 
              "function" => 'isValidFile', 
              "message"  => "this is not a valid css file"})
      return false
    end
    
    return true
  end # isValidFile

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