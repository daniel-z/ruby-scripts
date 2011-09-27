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
    @params = Hash.new
    @params["debug"] = false
    @cssSearchObj = CssSearch.new(@params)
  end

  def test_getSelectors

    @params["cssFile"]    = "./resources/example1.css"
    @params["cssPropertyMask"] = 'border-radius'

    # results for the first test
    results = Array.new
    results[0] = "#id-with-property"
    results[1] = ".class-with-property"
    results[2] = "p.element-with-property"
    results[3] = "span"

    assert_equal results, @cssSearchObj.getSelectors(@params), "getSelectors for border-radius!"
  end

  def test_isValidFile
    @params["file"] = './resources/example1.css'
    assert_equal true, @cssSearchObj.isValidFile(@params)
  end

  def test_getAllSelectorsInDirectory
    @params["cssPropertyMask"] = 'border-radius'
    @params["directory"] = './resources/'

    results = Array.new
    results[0] = "#id-with-property"
    results[1] = ".class-with-property"
    results[2] = "p.element-with-property"
    results[3] = "span"
    results[4] = "#id-with-property.example2"
    results[5] = ".class-with-property.example2"
    results[6] = "p.element-with-property.example2"
    results[7] = "span.example2"

    assert_equal results, @cssSearchObj.getAllSelectorsInDirectory(@params), "getSelectors all selectors with border-radius in all files in given directory!"
  end

end