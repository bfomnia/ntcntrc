# Nginx webserver
# Used documentation: https://forge.puppet.com/modules/puppet/nginx/readme
# Used default nginx logging

package {'nginx':
    ensure => 'installed',
    }

nginx::resource::server { 'puppet_netcentric_test':
  members => {
    'https://domain.com' => {
      server => '10.10.10.10',
      www_root => '/var/www/puppet_netcentric_test',
      listen_port   => 443,
      use_ssl => true,
      ssl_cert => '/var/lib/puppet/ssl/certs/domain.com.pem',
      ssl_key  => '/var/lib/puppet/ssl/private_keys/domain.com.pem',
      access_log => '/var/log/nginx/domain.com_access.log',
      error_log  => '/var/log/nginx/domain.com_error.log',
      weight => 1,
    },
    'https://domain.com/resoure2' => {
      server => '20.20.20.20',
      www_root => '/var/www/resoure2',
      listen_port   => 443,
      use_ssl => true,
      ssl_cert => '/var/lib/puppet/ssl/certs/domain.com.pem',
      ssl_key  => '/var/lib/puppet/ssl/private_keys/domain.com.pem',
      access_log => '/var/log/nginx/domain.com_resoure2_access.log',
      error_log  => '/var/log/nginx/domain.com_resoure2_error.log',
      weight => 1,
    },
}


# Health Check
# Used documentation: https://forge.puppet.com/modules/puppet/healthcheck/readme

netcentric_test_cluster_nodes = ['https://domain.com', 'https://domain.com/resoure2']

tcp_conn_validator { '$netcentric_test_cluster_nodes' :
  listen_port   => 443,
  use_ssl => true,
  try_sleep => 10,
  timeout => 50,
}

