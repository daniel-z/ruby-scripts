#!/usr/bin/ruby

# This software by Daniel Zamorano is licensed under a 
# Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
# Read the license here: http://creativecommons.org/licenses/by-nc-sa/3.0/

# cssSearch - This searchs for a css property in a css file

require 'css_parser'


class CssSearch

  def initialize( params )
    @debug = params['debug'] || false    
    #look for needed parameters or exit
    if !params['cssFile']
      logger ({"type" => 'error', "function" => 'initialize', "message" => 'Needed cssFile parameter'})
      exit
    end
    
    @params = params || return
    @parserObj = CssParser::Parser.new
    @parserObj.load_file!(@params['cssFile'])

      @params.each_pair do |key,value|
        logger ({"type"     => 'info', 
                "function" => 'initialize', 
                "message"  => "params: Key = #{key}, Value = #{value}"})
      end

  end

  def getSelectors (params)
    
    functionName = 'getSelectors'
    
    #look for needed parameters or exit
    if !params['cssPropertyMask']
      logger ({"type"     => 'error',
              "function" => "#{functionName}",
              "message"  => "Needed cssPropertyMask parameter"})
      exit
    end
    
    cssPropertyMask = ( params['cssPropertyMask'] || @params["cssPropertyMask"] ) || '*'
    cssSelectors = Hash.new
    
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

  end 
  
  
  # ---
  # private functions
  # ---
  
  private 
  
  def logger (params)
    # print message just if debug is enabled
    exit if !@debug
    
    prefix = Hash.new
    prefix['error']   = 'ERROR!!'
    prefix['warning'] = 'WARNING'
    prefix['info']    = 'INFO'    

    #look for needed parameters or exit    
    for parameter in ['message','type','function'].each
      if !params["#{parameter}"]
          puts "#{prefix['error']} - logger: needed #{parameter} parameter!"
          exit
      end
    end
    
    if !prefix["#{params['type']}"] and @debug
      puts "#{prefix['error']} - logger: invalid log type for message: #{params['message']}"
      exit
    end

    puts "#{prefix["#{params['type']}"]} - #{params['function']}: #{params['message']}"

  end

end #class
