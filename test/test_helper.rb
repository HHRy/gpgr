require 'test/unit'

# Figure out the root relative to where this file is
#
GPGR_ROOT = File.expand_path(File.dirname(__FILE__) + '/../lib')

# Include the gpgr library
#
require GPGR_ROOT + '/gpgr.rb'

def remove_installed_key(email)
  system "gpg -q --no-verbose --delete-key --yes --batch #{email}"
end

def cleanup_batch_keys
    remove_installed_key 'testymctest1@example.com'
    remove_installed_key 'testymctest2@example.com'
    remove_installed_key 'testymctest3@example.com'
end
