#--
# $Id: test_writer.rb,v 1.3 2005/12/09 15:30:46 bpeters Exp $
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

class TestWriter < Test::Unit::TestCase

  def test_write_marc
    assert_nothing_raised() {
      File.open("test/chabon.mrc", "r") do |file|
        reader = RMARC::MarcStreamReader.new(file)
        writer = RMARC::MarcStreamWriter.new(STDOUT)
        while reader.has_next
          record = reader.next()
          writer.write_record(record)
        end
      end
    }
  end
  
  def test_write_marc_xml
    assert_nothing_raised() {
      writer = RMARC::MarcXmlWriter.new(STDOUT)
      File.open("test/chabon.mrc", "r") do |file|
        reader = RMARC::MarcStreamReader.new(file)
        writer.start_document
        while reader.has_next
          record = reader.next()
          writer.write_record(record)
        end
        writer.end_document
      end
    }
  end
  
end
