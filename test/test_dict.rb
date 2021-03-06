#encoding: utf-8
$: << "."
require "test_helper"

class TestDict < Test::Unit::TestCase
  def setup
    path_prj = File.expand_path( File.join( File.dirname(__FILE__), ".." ) )
    file_chinese_character_list = File.join( path_prj, "data", "Modern Chinese Character Frequency List" )
    file_ps = File.join( path_prj, "data", "dict.dat" )
    # file_json = File.join( path_prj, "data", "dict.json" )
    @dict = Dict.new(file_chinese_character_list, file_ps)
  end

  def test_dict_size
    assert_equal(9933, @dict.chars.size)
  end

  def test_dict_first
    assert_equal("的", @dict.chars.first.ch)
  end

  def test_dict_last
    assert_equal("鴒", @dict.chars.last.ch)
  end
  
  def test_parse
    
  end
  
  def test_store
    
  end
  
  def test_retrieve
    
  end
  
  def test_count
    
  end
  
  def test_generate_names
    
  end
end
