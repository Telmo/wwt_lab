#! /usr/bin/env ruby

require 'pp'
require 'yaml'
require 'json'
require 'fileutils'
require 'pathname'

@ip_tic = 14
@host_tic = 11

def parse_ilo_output_file(f, data_dir)
	puts "Processing #{f}"
	text = data_dir.join(f).read()
	data = {}
	data['ipmi_hostname'] = f.to_s
	data['mac_address'] = /Port1NIC_MACAddress=([0-9:a-f]*)/.match(text)[1]
	data['ip_address'] = "10.253.59.#{@ip_tic}"
	data['subnet'] =  '255.255.255.128'
	data['hostname'] = "disstack-wwt-c#{@host_tic}.ece.comcast.net"
	data['copa_os_sequence_id'] = 3
	data['serial_number'] = /number=(.+)$/.match(text)[1].strip rescue nil
	data['rack'] = 'KAFKA-NX5548-B'
	data['model'] = /name=(.+)$/.match(text)[1].strip rescue nil
	@ip_tic += 1
	@host_tic += 1
	data
end

data_dir = Pathname.new(ARGV[0])
unless data_dir.exist?
	echo "the passed dir does not exist"
	exit 1
end

out_put_dir = Pathname.new('out_put_dir')
out_put_dir.mkdir unless out_put_dir.exist?

data_dir.each_child(false) do |f|
	data = parse_ilo_output_file(f, data_dir)
	File.open(out_put_dir.join("#{data['hostname']}.yml"), 'w') { |file| file.write(data.to_yaml) }
end

