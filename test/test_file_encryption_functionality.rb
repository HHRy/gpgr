require File.dirname(__FILE__) + '/test_helper.rb'

class TestFileEncryptionFunctionality < Test::Unit::TestCase

  def test_file_method_returns_expected_object
    o = Gpgr::Encrypt.file(__FILE__)
    assert_equal Gpgr::Encrypt::GpgFileForEncryption, o.class
  end  

  def test_default_values_are_corrently_set
    o = Gpgr::Encrypt.file(__FILE__)
    assert_equal File.expand_path(__FILE__), o.file
    assert_equal File.expand_path(__FILE__) + '.pgp', o.file_output
    assert o.email_addresses.empty?
  end

  def test_can_set_output_file_path
    o = Gpgr::Encrypt.file(__FILE__ , :to => '/tmp/boogaboog.gpg')
    assert_equal File.expand_path(__FILE__), o.file
    assert_equal '/tmp/boogaboog.gpg', o.file_output
  end

  def test_using_updates_email_addresses
    o = Gpgr::Encrypt.file(__FILE__)
    assert o.email_addresses.empty?
    o.using [ 'test@test.com' ]
    assert !o.email_addresses.empty?
  end

  def test_encrypt_will_not_work_with_a_bad_email
    o = Gpgr::Encrypt.file(__FILE__)
    o.using [ 'nobody@example.com' ]
    assert_raise Gpgr::Encrypt::InvalidEmailException do
      o.encrypt
    end
    assert !File.exists?(o.file_output)
  end
  
  def test_encrypt_will_not_work_if_source_file_doesnt_exist
    o = Gpgr::Encrypt.file('/tmp/i_just_made_this_up')
    o.using [ 'nobody@example.com' ]
    assert_raise Gpgr::Encrypt::InvalidFileException do
      o.encrypt
    end
    assert !File.exists?(o.file_output)
  end
 
end
