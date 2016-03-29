# -*- coding: ISO-8859-1 -*-

$:.unshift File.dirname(__FILE__)
$:.unshift File.dirname(__FILE__) + "/.."
$:.unshift File.dirname(__FILE__) + "/../../.."

require 'rubygems'
require 'mypdf/writer'
require 'pdf/writer/graphics'

require 'imageinfo.rb'


print "Image Formats: #{PDF::Writer::Graphics::ImageInfo.formats.inspect}\n"

    open('igor_portrait.jpg', "rb") do |fh|
      image = PDF::Writer::Graphics::ImageInfo.new(fh.read)
			print <<-EOF
Format  : #{image.format}
Width   : #{image.width.inspect}
Height  : #{image.height.inspect}
Bits    : #{image.bits.inspect}
Channels: #{image.channels.inspect}
			EOF
		end
