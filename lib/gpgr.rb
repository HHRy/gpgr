require "gpgr/version"

#  Gpgr by Ryan Stenhouse <ryan@ryanstenhouse.eu>, March 2010
#  on behalf of Purchasing Card Consultancy Limited.
#
#  gpgr is a very light interface to the command-line GPG (GNU
#  Privacy Guard) tool which is soley concerned with making it
#  as easy as possible to encrypt files with one (or more) public
#  keys.
#
#  It does not provide any major key management tools and does not
#  support decryption.
#
#  Usage:
#
#    require 'rubygems'
#    require 'gpgr'
#
#    # Synopsis
#    #
#    list_of_keys = [ 'foo@example.com', 'bar@example.com' ]
#    Gpgr::Encrypt.file('/some_file.txt', :to => '/encrypted.gpg').encrypt_using(list_of_keys)
#
#    # To import all the public keys in a given directory
#    #
#    Gpgr::Keys.import_keys_at('/path/to/public/keys')
#
#    #  Will encrypt for every single person you have a public key for
#    #
#    Gpgr::Encrypt.file('/some_file.txt', :to => '/encrypted.gpg').encrypt_using(Gpgr::Keys.installed_public_keys)
#
module Gpgr

  # Returns the command to execute to run GPG. It is defualted to /use/bin/env gpg
  # which should correctly track down gpg on any UNIX-like operating system. If you
  # need to use this on Windows, simply change the method to return the path to where
  # gpg is installed.
  #
  # Of course, since grep is used in this script too, you'll need a windows version of
  # grep installed as well!
  #
  def self.command
    '/usr/bin/env gpg'
  end

  # Encapsulates all the functionality related to encrypting a file. All of the real work
  # is done by the class GpgGileForEncryption.
  #
  module Encrypt

    # Takes the path to the file you want to encrypt; and returns a GpgFileForEncryption
    # object for you to modify with the people (e-mail addresses) you want to encrypt this
    # file for. Optionally you can specify where you want the encrypted file to be written,
    # by setting :to => some_path. Will default to wherever the current file is, with the
    # extension 'pgp' appended.
    #
    def self.file(path, options = {})
      default_options = { :to => "#{path}.pgp" }.merge(options)
      GpgFileForEncryption.new(path, default_options[:to])
    end

    # Raised if there is an invalid e-mail address provided to encrypt with
    #
    class InvalidEmailException < Exception; end

    # Raised if the input or output files for the GPG Encryption are invalid somehow
    #
    class InvalidFileException < Exception; end


    # Contians the details used to encrypt specified +file+, is what actually does
    # any encryption.
    #
    class GpgFileForEncryption

      attr_accessor :email_addresses, :file, :file_output

      # The path to the file which GPG Will be encrypting and the path where
      # you want the encrypted file to be output.
      #
      def initialize(path, output_path)
        @file = File.expand_path(path)
        if output_path == path + '.pgp'
          @file_output = @file + '.pgp'
        else
          @file_output = File.expand_path(output_path)
        end
        @email_addresses = []
      end

      # Takes a list of e-mail addresses and then encrypts the file straight away.
      #
      def encrypt_using(email_addresses)
        using(email_addresses)
        encrypt
      end

      # Expects an array of e-mail addresses for people who this file file should be
      # decryptable by.
      #
      def using(email_addresses)
        @email_addresses = email_addresses
      end

      # Encrypts the current file for the list of recipients specific (if they are valid)
      #
      def encrypt
        bad_key = @email_addresses.empty?

        if File.exist?(@file)
          unless File.readable?(@file)
            raise InvalidFileException.new("File at #{@file} is not readable.") and return
          end
        else
          raise InvalidFileException.new("File at #{@file} does not exist.") and return
        end

        @email_addresses.each do |add|
          unless Gpgr::Keys.public_key_installed?(add)
            bad_key = true
          end
        end
        if bad_key
          raise InvalidEmailException.new("One or more of the e-mail addresses you supplied don't have valid keys assigned!")
        else
          command = Gpgr.command + " -q --no-verbose --yes -a -o #{@file_output} -r " + @email_addresses.join(' -r ') + " -e #{@file}"
          system(command)
        end
      end

    end

  end

  # Encapsulates all the functionality for dealing with GPG Keys. There isn't much here since
  # key managment isn't really one of the goals of this project. It will, however, allow you
  # to import new keys and provides a means to list existing installed keys.
  #
  module Keys

    # Imports the key at the specified path into the keyring. Since this is
    # really running gpg --import ./path/to/key.asc, the key will be imported
    # and added to the keyring for the user executing this command.
    #
    def self.import(path_to_key)
      system "#{Gpgr.command} -q --no-verbose --yes --import #{File.expand_path(path_to_key)}"
    end

    # Iterates through all of the files at a specified path and attempts to import
    # those which are likely to be GPG / PGP Public Keys.
    #
    def self.import_keys_at(path)
      Dir.new(path).each do |file|
        next if ['..','.'].include?(file)
        Gpgr::Keys.import(path + '/' + file)
      end
    end

    # Returns an array with the e-mail addresses of every installed public key
    # for looping through and detecting if a particular key is installed.
    #
    def self.installed_public_keys
      keys = []
      email_regexp = /\<(.*@.*)\>/

      # Select the output to grep for, which is different depending on the version
      # of GPG installed. This is tested on 1.4 and 2.1.
      #
      if `#{Gpgr.command} --version | grep GnuPG`.include?('1.')
        grep_for = 'pub'
      else
        grep_for = 'uid'
      end

      `#{Gpgr.command} --list-public-keys --with-colons | grep #{grep_for}`.split("\n").each do |key|
        keys << email_regexp.match(key)[1].upcase
      end

      keys.uniq
    end

    # Simply checks to see if the e-mail address passed through as an argument has a
    # public key attached to it by checking in installed_public_keys.
    #
    def self.public_key_installed?(email)
      installed_public_keys.include?(email.upcase)
    end

  end

end
