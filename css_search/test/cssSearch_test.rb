#!/usr/bin/ruby

# This software by Daniel Zamorano is licensed under a 
# Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
# Read the license here: http://creativecommons.org/licenses/by-nc-sa/3.0/

# cssSearch_test - Testing the cssSearch module

require '../cssSearch'
require 'test/unit'

class TestCssSearch < Test::Unit::TestCase

  # create and prepare the CssParser object
  def setup
    @params = Hash.new()
    @params["cssFile"]    = "./resources/example.css"
    @params["cssPropertyMask"] = 'border-radius'
    @params["debug"] = true
    @cssSearchObj = CssSearch.new(@params)
  end

  def test_getSelectors
    # results for the first test
    results = Array.new() 
    results[0] = "#id-with-property"
    results[1] = ".class-with-property"
    results[2] = "p.element-with-property"
    results[3] = "span"

    assert_equal results, @cssSearchObj.getSelectors(@params), "getSelectors for border-radius test!"
  end

end