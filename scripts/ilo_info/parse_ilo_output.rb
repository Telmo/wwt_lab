#! /usr/bin/env ruby

# Takes a string of ilo data from standard in (piped from something) and parses out data 
# and formats it in yaml.
#
#  Usage:
#          cat ilo_data.txt | ./parse_ilo_output.rb
#

require 'yaml'

def safe_string(s)
  if ! s.valid_encoding?
    s = s.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
  end
  s
end

def safe_regex(regex, text)
  m = regex.match(safe_string(text))
  return nil if m.nil?
  m[1].chomp
end

def ilo_section(section, text)
  return nil if section.nil? or text.nil?

  m = /^#{section.gsub('/', '\/')}((.|\n)*)/.match(safe_string(text))
  return nil if m.nil?
  s = m[1]
  s[0..(s.index('Verbs') -1)]
end

text = ARGF.read
data = {}

data['serial_number'] = safe_regex(/number=(.+)$/,                     ilo_section('/system1',                           text))
data['model']         = safe_regex(/name=(.+)$/,                       ilo_section('/system1',                           text))
data['ipmi_hostname'] = safe_regex(/IPv4Address=(.+)$/,                ilo_section('/map1/enetport1/lanendpt1/ipendpt1', text))
data['mac_address']   = safe_regex(/Port1NIC_MACAddress=([0-9:a-f]*)/, ilo_section('/system1/network1/Integrated_NICs',  text)) 
data['mac_address_2'] = safe_regex(/Port2NIC_MACAddress=([0-9:a-f]*)/, ilo_section('/system1/network1/Integrated_NICs',  text)) 

s = ilo_section('/map1/firmware1',  text)
data['ilo_version']               = "#{safe_regex(/version=(.+)$/, s)} (#{safe_regex(/date=(.+)$/, s)})"
data['ilo_host_name']             = safe_regex(/Hostname=(.*)/,                    ilo_section('/map1/dnsendpt1',  text))
data['boot_mode']                 = safe_regex(/oemhp_bootmode=(.*)/,         ilo_section('/system1/bootconfig1',  text))
data['boot_mode_pending']         = safe_regex(/oemhp_pendingbootmode=(.*)/,  ilo_section('/system1/bootconfig1',  text))
data['system_rom_version']        = safe_regex(/VersionString=(.+)$/,         ilo_section('/system1/swid2',  text))
data['system_rom_version_backup'] = safe_regex(/VersionString=(.+)$/,         ilo_section('/system1/swid3',  text))

puts data.to_yaml
