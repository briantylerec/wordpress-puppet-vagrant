class apache {

  # Install apache pcakage
  package { 'apache2': 
    ensure => installed,
  }

  # Enable and ensure Apache is running
  service { 'apache2':
    ensure => 'running',
    enable => true,
    hasstatus => true,
    restart => "/usr/sbin/apachectl configtest && /usr/sbin/service apache2 reload",
    require => Package['php-mysqli'],
  }

  # Setting up the Apache Configuration File for WordPress
  file { '/etc/apache2/sites-available/wordpress.conf':
    ensure  => file,
    content => "
      <VirtualHost *:80>
        ServerName localhost
        DocumentRoot /var/www/html/wordpress
        <Directory /var/www/html/wordpress>
          AllowOverride All
          Require all granted
        </Directory>
      </VirtualHost>",
    notify  => Service['apache2'],  # Apache restarts if configuration is changed
  }

  # Enabling WordPress Site
  exec { 'enable-wordpress-site':
    command => '/usr/sbin/a2ensite wordpress',
    unless  => '/usr/bin/test -L /etc/apache2/sites-enabled/wordpress.conf',
    require => File['/etc/apache2/sites-available/wordpress.conf'],
  }

  # Enabling mod_rewrite module for WordPress
  exec { 'enable-mod-rewrite':
    command => '/usr/sbin/a2enmod rewrite',
    unless  => '/usr/sbin/a2query -m rewrite | grep -q "enabled"',
    require => Package['apache2'],
    notify  => Exec['restart-apache'],
  }

  # Reinicia Apache después de cambios en configuración
  exec { 'restart-apache':
    command     => 'systemctl restart apache2',
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    refreshonly => true,
  }
}
