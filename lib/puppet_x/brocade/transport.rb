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

        device_conf[:arguments] ||= {}
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
            @session.user = device_conf[:user]
            @session.password = device_conf[:password]
          end
          @session.default_prompt = /[#>]\s?\z/n
          connect_session
        end
      end

      def connect_session
        retry_count=0

        begin
          session.connect do |status|
            retry_count += 1
            # Brocade limits number of remote connections,if connections exceed raise exception after multiple retires
            raise("Maximum Remote connections Reached") if status.match(/Max remote sessions for login/)
          end
        rescue Exception => e
          sleep(30)
          if retry_count < 4
            Puppet.warning("Detected maximum active remote connections,retrying again to connect")
            retry
          else
            raise ("Maximum Remote connections and retry limits exceded")
          end
        end

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
    end
  end
end