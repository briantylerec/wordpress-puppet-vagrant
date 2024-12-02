class php {
  # Make sure Apache is configured before PHP
  package { 'php':
    ensure => installed,
    require => Class['apache'], 
  }

  # MySQL extension for PHP
  package { 'php-mysql':
    ensure => installed,
    require => Package['php'],
  }

  # PHP module for Apache
  package { 'libapache2-mod-php':
    ensure => installed,
    require => Package['php'],
  }

  package { 'php-mysqli':
    ensure => installed,
  }
}
