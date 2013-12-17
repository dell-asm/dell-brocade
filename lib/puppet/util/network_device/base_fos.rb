require 'uri'
require 'openssl'
require 'cgi'
require 'puppet/util/network_device/transport_fos'
require 'puppet/util/network_device/transport_fos/base_fos'

class Puppet::Util::NetworkDevice::Base_fos
  attr_accessor :url, :transport, :crypt

  def initialize(url)
    @url = URI.parse(url)
    @query = CGI.parse(@url.query) if @url.query
    require "puppet/util/network_device/transport_fos/#{@url.scheme}"

    unless @transport
      @transport = Puppet::Util::NetworkDevice::Transport_fos.const_get(@url.scheme.capitalize).new
      @transport.host = @url.host
      @transport.port = @url.port || case @url.scheme ; when "ssh" ; 22 ; when "telnet" ; 23 ; end
      
        if checkquery?
        Puppet.debug("crypt=true")
        self.crypt = true
        # FIXME: https://github.com/puppetlabs/puppet/blob/master/lib/puppet/application/device.rb#L181
        master = File.read(File.join('/etc/puppet', 'networkdevice-secret'))
        master = master.strip
        @transport.user = decrypt(master, [@url.user].pack('h*'))
        @transport.password = decrypt(master, [@url.password].pack('h*'))
      else
	Puppet.debug("crypt=false")
        @transport.user = @url.user
        @transport.password = @url.password
      end
    end
  end

  def checkquery?
    if @query && @query['crypt'] && @query['crypt'] == ['true']
      return true
    end
  end
  
  def decrypt(master, str)
    cipher = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    cipher.decrypt
    cipher.key = key = OpenSSL::Digest::SHA512.new(master).digest
    out = cipher.update(str)
    out << cipher.final
    return out
  end
end
