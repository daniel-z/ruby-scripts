#!/usr/bin/ruby

require 'css_parser'


class CssSearch
  
  def initialize( params )
    @debug = params['debug'] || false
    
    #look for needed parameters or exit
    if !params['cssFile']
      logger 'initialize', 'Needed cssFile parameter'
      exit
    end
    
    @params = params || return
    @parserObj = CssParser::Parser.new
    @parserObj.load_file!(@params['cssFile'])

      @params.each_pair do |key,value|
        logger 'initialize', "params: Key = #{key}, Value = #{value}"
      end

  end

  def getSelectors (params)
    
    functionName = 'getSelectors'
    
    #look for needed parameters or exit
    if !params['cssPropertyMask']
      logger functionName, 'Needed cssPropertyMask parameter'
      exit
    end
    
    cssPropertyMask = ( params['cssPropertyMask'] || @params["cssPropertyMask"] ) || '*'
    cssSelectors = Hash.new
    
    logger functionName , "cssPropertyMask: #{cssPropertyMask}"
    
    # iterate through selectors
    @parserObj.each_selector() do |selector, declarations, specificity|
        if  declarations =~ /#{cssPropertyMask}/ 
          #just set the selector as key and 1 to avoid duplicate elements if we use a hash
          cssSelectors["#{selector}"] = 1
          
          logger functionName , "true! #{selector} -> #{cssSelectors["#{selector}"]}"
        end
    end

    # get selector into array
    resultingSelectors = Array.new(cssSelectors.keys)

    logger functionName, "Resulting Selectors:"
    resultingSelectors.each do | selector | logger functionName,  "#{selector}" end

    return resultingSelectors

  end # getSelectors
  
  def logger (function, message)
    puts "##{function}: #{message}" if @debug
  end

end #class
