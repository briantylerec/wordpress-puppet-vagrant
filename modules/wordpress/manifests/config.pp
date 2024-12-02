class wordpress::config {
    # Download the wp-cli module for wordpress
    exec { 'download-wp-cli':
        command => '/usr/bin/sudo /usr/bin/curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar',
        creates => '/usr/local/bin/wp',
    }

    exec { 'make-wp-cli-executable':
        command => '/usr/bin/sudo /bin/chmod +x /usr/local/bin/wp',
        require => Exec['download-wp-cli'],
    }

    # Make sure the WordPress directory exists
    file { '/var/www/html/wordpress':
        ensure => directory,
        owner  => 'www-data',
        group  => 'www-data',
        mode   => '0755',
    }

  # Install WordPress
    exec { 'install-wordpress':
        command => 'wp core install --url="http://192.168.33.10/" --title="My Blog" --admin_user="bmora" --admin_password="password" --admin_email="bmora@example.com" --path="/var/www/html/wordpress" --allow-root',
        cwd     => '/var/www/html/wordpress',
        path    => '/bin:/usr/bin:/usr/local/bin',
    }
}
