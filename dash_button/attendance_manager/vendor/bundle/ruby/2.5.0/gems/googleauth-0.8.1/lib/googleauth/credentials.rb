# Copyright 2017, Google Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
#     * Neither the name of Google Inc. nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require "forwardable"
require "json"
require "signet/oauth_2/client"

require "googleauth/credentials_loader"

module Google
  module Auth
    # This class is intended to be inherited by API-specific classes
    # which overrides the SCOPE constant.
    class Credentials
      TOKEN_CREDENTIAL_URI = "https://oauth2.googleapis.com/token".freeze
      AUDIENCE = "https://oauth2.googleapis.com/token".freeze
      SCOPE = [].freeze
      PATH_ENV_VARS = [].freeze
      JSON_ENV_VARS = [].freeze
      DEFAULT_PATHS = [].freeze

      attr_accessor :client
      attr_reader   :project_id

      # Delegate client methods to the client object.
      extend Forwardable
      def_delegators :@client,
                     :token_credential_uri, :audience,
                     :scope, :issuer, :signing_key, :updater_proc

      # rubocop:disable Metrics/AbcSize
      def initialize keyfile, options = {}
        scope = options[:scope]
        verify_keyfile_provided! keyfile
        @project_id = options["project_id"] || options["project"]
        if keyfile.is_a? Signet::OAuth2::Client
          @client = keyfile
          @project_id ||= keyfile.project_id if keyfile.respond_to? :project_id
        elsif keyfile.is_a? Hash
          hash = stringify_hash_keys keyfile
          hash["scope"] ||= scope
          @client = init_client hash, options
          @project_id ||= (hash["project_id"] || hash["project"])
        else
          verify_keyfile_exists! keyfile
          json = JSON.parse ::File.read(keyfile)
          json["scope"] ||= scope
          @project_id ||= (json["project_id"] || json["project"])
          @client = init_client json, options
        end
        CredentialsLoader.warn_if_cloud_sdk_credentials @client.client_id
        @project_id ||= CredentialsLoader.load_gcloud_project_id
        @client.fetch_access_token!
      end
      # rubocop:enable Metrics/AbcSize

      # Returns the default credentials checking, in this order, the path env
      # evironment variables, json environment variables, default paths. If the
      # previously stated locations do not contain keyfile information,
      # this method defaults to use the application default.
      def self.default options = {}
        # First try to find keyfile file from environment variables.
        client = from_path_vars options

        # Second try to find keyfile json from environment variables.
        client ||= from_json_vars options

        # Third try to find keyfile file from known file paths.
        client ||= from_default_paths options

        # Finally get instantiated client from Google::Auth
        client ||= from_application_default options
        client
      end

      def self.from_path_vars options
        self::PATH_ENV_VARS
          .map { |v| ENV[v] }
          .compact
          .select { |p| ::File.file? p }
          .each do |file|
            return new file, options
          end
        nil
      end

      def self.from_json_vars options
        json = lambda do |v|
          unless ENV[v].nil?
            begin
              JSON.parse ENV[v]
            rescue StandardError
              nil
            end
          end
        end
        self::JSON_ENV_VARS.map(&json).compact.each { |hash| return new hash, options }
        nil
      end

      def self.from_default_paths options
        self::DEFAULT_PATHS
          .select { |p| ::File.file? p }
          .each do |file|
            return new file, options
          end
        nil
      end

      def self.from_application_default options
        scope = options[:scope] || self::SCOPE
        client = Google::Auth.get_application_default scope
        new client, options
      end
      private_class_method :from_path_vars,
                           :from_json_vars,
                           :from_default_paths,
                           :from_application_default

      protected

      # Verify that the keyfile argument is provided.
      def verify_keyfile_provided! keyfile
        return unless keyfile.nil?
        raise "The keyfile passed to Google::Auth::Credentials.new was nil."
      end

      # Verify that the keyfile argument is a file.
      def verify_keyfile_exists! keyfile
        exists = ::File.file? keyfile
        raise "The keyfile '#{keyfile}' is not a valid file." unless exists
      end

      # Initializes the Signet client.
      def init_client keyfile, connection_options = {}
        client_opts = client_options keyfile
        Signet::OAuth2::Client.new(client_opts)
                              .configure_connection(connection_options)
      end

      # returns a new Hash with string keys instead of symbol keys.
      def stringify_hash_keys hash
        Hash[hash.map { |k, v| [k.to_s, v] }]
      end

      def client_options options
        # Keyfile options have higher priority over constructor defaults
        options["token_credential_uri"] ||= self.class::TOKEN_CREDENTIAL_URI
        options["audience"] ||= self.class::AUDIENCE
        options["scope"] ||= self.class::SCOPE

        # client options for initializing signet client
        { token_credential_uri: options["token_credential_uri"],
          audience:             options["audience"],
          scope:                Array(options["scope"]),
          issuer:               options["client_email"],
          signing_key:          OpenSSL::PKey::RSA.new(options["private_key"]) }
      end
    end
  end
end
