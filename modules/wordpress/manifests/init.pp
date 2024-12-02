class wordpress {
  # Download WordPress from its official site
  exec { 'download-wordpress':
    command => "/usr/bin/wget https://wordpress.org/latest.tar.gz -P /tmp",
    creates => "/tmp/latest.tar.gz",  # Check if the file has already been downloaded
  }

  # Extract WordPress into the Apache directory
  exec { 'extract-wordpress':
    command => "/bin/tar -xzf /tmp/latest.tar.gz -C /var/www/html",
    creates => "/var/www/html/wordpress/index.php",  # Verifica si el archivo principal ya está extraído
    require => Exec['download-wordpress'],
  }

  # Set the appropriate permissions
  exec { 'set-permissions':
    command => "/bin/chown -R www-data:www-data /var/www/html/wordpress",
    require => Exec['extract-wordpress'],
  }

  # Create WordPress database and user in MySQL
  exec { 'create-wordpress-db':
    command => "/usr/bin/mysql -u root -e \"CREATE DATABASE IF NOT EXISTS wordpress; CREATE USER IF NOT EXISTS 'wp_user'@'localhost' IDENTIFIED BY 'wp_password'; GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'localhost'; FLUSH PRIVILEGES;\"",
    unless  => "/usr/bin/mysql -u root -p password -e 'SHOW DATABASES LIKE \"wordpress\";' | /bin/grep wordpress",
  }

  # Configure the wp-config.php file with dynamic values
  file { '/var/www/html/wordpress/wp-config.php':
    ensure  => file,
    content => template('wordpress/wp-config.php.erb'),
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    require => File['/var/www/html/wordpress'], # We make sure WordPress is installed
  }
}
