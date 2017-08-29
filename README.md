# gpgr - GNU Privacy Guard Encryption in Ruby
March 2010 - Present, Ryan Stenhouse <ryan@ryanstenhouse.eu>
Originally behalf of [Purchasing Card Consultancy Limited][1].

> The current development version of gpgr is released under the MIT
> license. Previous versions were licensed under the GNU GPL. If you
> require the use of a GNU GPL version, please  use `0.0.4`.

## About

gpgr is a lightweight and fast wrapper around the <tt>gpg</tt> command
commonly found on Linux and other Unix-like operating systems.

It is only concerned with quickly and easily encrypting files, to that
end aside from some basic key-management support, it will not wrap any
other parts of the gpg functionality.

If you need something that will elegantly and quickly encrypt files for
you and make managing the keys used within your application for this
purpose a snap, use this. If not, use something else.

## Installation

From Rubygems:

  gem install gpgr

From GitHub:

  Download or Clone the repoistory or just gpgr.rb and include it where
  you need it.


## Requirements

gpgr has only really been tested on *nix environments, and indeed the path
hard-coded by default for the gpg binary will only be meaningful if you're
using a Linux-based or other UNIX-like operating system.

The only requirement (apart, obviously, from Ruby) is that you have gpg
installed. On most modern Linux distributions, it should be there by default
to verify, open a terminal and key in:

<tt>gpg --version</tt>

If you see something like:

<pre>
  ryan@ubuntu:~$ gpg --version
  gpg (GnuPG) 1.4.6
  Copyright (C) 2006 Free Software Foundation, Inc.
  This program comes with ABSOLUTELY NO WARRANTY.
  This is free software, and you are welcome to redistribute it
  under certain conditions. See the file COPYING for details.

  Home: ~/.gnupg
  Supported algorithms:
  Pubkey: RSA, RSA-E, RSA-S, ELG-E, DSA
  Cipher: 3DES, CAST5, BLOWFISH, AES, AES192, AES256, TWOFISH
  Hash: MD5, SHA1, RIPEMD160, SHA256, SHA384, SHA512, SHA224
  Compression: Uncompressed, ZIP, ZLIB, BZIP2
</pre>

Congratulations.

For **Ubuntu / Debian** distros, you can try the following if its not installed by default:

<tt>sudo aptitude install seahorse gpg-rsa gpgkeys gpgsm gpgv</tt>

As well as installing the command-line tools gpgr expects, seahorse which,
is a fantastic graphical tool for managing your keys, will be installed


For **Mac OS X**, you will first need to install <tt>gpg</tt>, you can do
this through MacPorts or Frink, but the best way is through [MacGPG][2], just
[download the latest version][3] and install int <tt>.pkg</tt> file it downloads.

## A Note on Testing

Since gpgr really is just firing of to the GPG binary to all of the real work, there is little
to test within gpgr itself. I've added the tests I feel are prudent and useful. Feel free to
contribute your own if you think a particular area could do with higher coverage.

I do take the view, however, that GPG it's self is a very well established and proven, mature
project; and as such - any tests which attempt to test that *gpg* is functioning correctly will
not be accepted - I'm happy to assume that it is.

[1]: http://www.pccl.co.uk
[2]: http://macgpg.sourceforge.net/
[3]: http://sourceforge.net/projects/macgpg2/files/
