#!/usr/bin/ruby

# testing the cssParser
# @Autor: Daniel Zamorano

require '../cssSearch'
require 'test/unit'

class TestCssSearch < Test::Unit::TestCase

  # create and prepare the CssParser object
  def setup
    @params = Hash.new()
    @params["cssFile"]    = "./resources/example.css"
#    @params["cssPropertyMask"] = 'border-radius'
    @params["debug"] = true
    
    @cssSearchObj = CssSearch.new(@params)
    @results = Array.new() 
  end

  def test_getSelectors
    # results for the first test
    @results[0] = "#id-with-property"
    @results[1] = ".class-with-property"
    @results[2] = "p.element-with-property"
    @results[3] = "span"

    assert_equal @results, @cssSearchObj.getSelectors(@params), "getSelectors for border-radius test!"
  end

end