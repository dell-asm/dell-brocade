module PuppetX
  module Brocade
    class Transport
      attr_accessor :url, :session, :crypt
      # TODO:  This is similar to force10's transport.  They could probably be somewhat merged in the future, or at least extended.
      def initialize(certname, options={})
        if options[:device_config]
          device_conf = options[:device_config]
        else
          require 'asm/device_management'
          device_conf = ASM::DeviceManagement.parse_device_config(certname)
        end


        unless @session
          #Puppet already has ssh code that we can reuse, even though this isn't being used as a network device.
          require "puppet/util/network_device/transport/ssh"
          @session = Puppet::Util::NetworkDevice::Transport::Ssh.new(true)
          @session.host = device_conf[:host]
          @session.port = device_conf[:port] || 22

          if device_conf[:arguments]['credential_id']
            require 'asm/cipher'
            cred = ASM::Cipher.decrypt_credential(device_conf[:arguments]['credential_id'])
            @session.user = cred.username
            @session.password = cred.password
          else
            #TODO:  Should there be any decryption code here?
            @session.user = device_conf[:user]
            @session.password = device_conf[:password]
          end
          @session.default_prompt = /[#>]\s?\z/n
          connect_session
        end
      end

      def connect_session
        session.connect
        login
      end

      def login
        return if session.handles_login?
        if @session.user != ''
          session.command(@session.user, {:prompt => /^Password:/, :noop => false})
        else
          session.expect(/^Password:/)
        end
        session.command(@session.password, :noop => false)
      end

      def facts
        require 'puppet_x/brocade/facts'
        @facts ||= PuppetX::Brocade::Facts.new(session)
        @facts.retrieve
        @facts.facts_to_hash
      end

      # These methods aren't used currently, but still being left in for posterity's sake in case it can be reused
      private

      def update_transport_usr_password
        if query_present_and_crypted?
          self.crypt = true
          # FIXME: https://github.com/puppetlabs/puppet/blob/master/lib/puppet/application/device.rb#L181
          master = File.read(File.join('/etc/puppet', 'networkdevice-secret'))
          master = master.strip
          @session.user = self.decrypt(master, [@url.user].pack('h*'))
          @session.password = self.decrypt(master, [@url.password].pack('h*'))
        else
          @session.user = URI.decode(@url.user)
          @session.password = URI.decode(asm_decrypt(@url.password))
        end
      end

      def query_present_and_crypted?
        if @query
          @query['crypt'] == ['true']
        else
          false
        end
      end

      def self.decrypt(master, str)
        cipher = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
        cipher.decrypt
        cipher.key = key = OpenSSL::Digest::SHA512.new(master).digest
        out = cipher.update(str)
        out << cipher.final
        return out
      end
    end
  end
end