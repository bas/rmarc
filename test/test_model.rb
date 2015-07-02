#--
# $Id: test_model.rb,v 1.3 2005/12/10 16:27:52 bpeters Exp $
#
# Copyright (c) 2005 Bas Peters
#
# This file is part of RMARC
# 
# RMARC is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public 
# License as published by the Free Software Foundation; either 
# version 2.1 of the License, or (at your option) any later version.
# 
# RMARC is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public 
# License along with RMARC; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#++
$: << File.dirname(__FILE__) + "/.." << File.dirname(__FILE__) + "/../lib"

require 'test/unit'
require 'rmarc'

class TestModel < Test::Unit::TestCase
  
  def test_control_field
    field = RMARC::ControlField.new("001", "12883376")
    assert_equal("001", field.tag)
    assert_equal("12883376", field.data)
  end
  
  def test_subfield
    subfield = RMARC::Subfield.new("a", "Summerland")
    assert_equal("a", subfield.code)
    assert_equal("Summerland", subfield.data)    
  end
  
  def test_data_field
    field = RMARC::DataField.new("245", "1", "0")    
    assert_equal("245", field.tag)
    assert_equal("1", field.ind1)
    assert_equal("0", field.ind2)
    assert_equal(0, field.subfields.length)
    
    subfield = RMARC::Subfield.new("a", "Summerland")
    field.add(subfield)
    assert_equal(1, field.subfields.length)
    
    subfield = RMARC::Subfield.new("c", "Michael Chabon")
    field.add(subfield)
    assert_equal(2, field.subfields.length)
    
    author = field.find {|s| s.code == 'c'}
    assert_equal("Michael Chabon", author.data)
    
    all = field.find_all {|s| ('a'..'e' === s.code)}
    assert_equal(2, all.length)
    
    field.remove(subfield)
    assert_equal(1, field.subfields.length)
    assert_equal("a", field.subfields.last.code)
  end
  
  def test_leader
    leader = RMARC::Leader.new("00714cam a2200205 a 4500")
    assert_equal(714, leader.record_length)
    assert_equal("a", leader.char_coding)
    assert_equal(205, leader.base_address)
    assert_equal("00714cam a2200205 a 4500", leader.to_s)
  end
  
  def test_record
    record = RMARC::Record.new()
    assert_equal(0, record.fields.length)
    field = RMARC::ControlField.new("001", "12883376")
    record.add(field)
    assert_equal(1, record.fields.length)
    
    field = RMARC::DataField.new("245", "1", "0")
    record.add(field)
    df = record.find {|f| f.tag == '245'}
    assert_equal('245', df.tag)
    
    record.remove(field)    
    assert_equal('001', record.fields.last.tag)
  end
  
end