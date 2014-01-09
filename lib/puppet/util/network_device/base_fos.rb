require 'uri'
require 'openssl'
require 'cgi'
require 'puppet/util/network_device/transport_fos'
require 'puppet/util/network_device/transport_fos/base_fos'

# "Base class for Network Device"
class Puppet::Util::NetworkDevice::Base_fos
  attr_accessor :url, :transport, :crypt
  def initialize(url)
    @url = URI.parse(url)
    query_str = @url.query
    url_scheme = @url.scheme
    @query = CGI.parse(query_str) if query_str
    require "puppet/util/network_device/transport_fos/#{url_scheme}"

    unless @transport
      @transport = Puppet::Util::NetworkDevice::Transport_fos.const_get(url_scheme.capitalize).new
      @transport.host = @url.host
      @transport.port = get_transport_port()
      update_transport_usr_password()
    end
  end

  private

  def update_transport_usr_password

    if query_present_and_crypted?
      update_transport_for_crypted_url
    else
      update_transport_for_uncrypted_url
    end

  end

  private

  def update_transport_for_crypted_url

    self.crypt = true
    # FIXME: https://github.com/puppetlabs/puppet/blob/master/lib/puppet/application/device.rb#L181
    master = File.read(File.join('/etc/puppet', 'networkdevice-secret'))
    master = master.strip
    @transport.user = self.decrypt(master, [@url.user].pack('h*'))
    @transport.password = self.decrypt(master, [@url.password].pack('h*'))

  end

  private

  def update_transport_for_uncrypted_url
    @transport.user = URI.decode(@url.user)
    @transport.password = URI.decode(@url.password)
  end

  private

  def get_transport_port

    new_port = 22
    case @url.scheme
    when "ssh"
      then new_port = 22
    when "telnet"
      then new_port = 23
    end

    @url.port || new_port

  end

  private

  def query_present_and_crypted?

    if @query
      if @query['crypt'] == ['true']
      return true
      end
    end
    return false
  end

  private

  def self.decrypt(master, str)
    cipher = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    cipher.decrypt
    cipher.key = key = OpenSSL::Digest::SHA512.new(master).digest
    out = cipher.update(str)
    out << cipher.final
    return out
  end
end
