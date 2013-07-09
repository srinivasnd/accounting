name             "accounting"
maintainer       "PagodaBox"
maintainer_email "hal@pagodabox.com"
license          IO.read(File.join(File.dirname(__FILE__), 'LICENSE.txt'))
description      "Installs/Configures accounting"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.1.5"

depends 'yum'
depends 'apt'