class stns::repo::apt {
  $dist = $::facts['lsbdistcodename']
  apt::source { 'stns':
    location => "http://repo.stns.jp/${dist}/",
    release  => 'stns',
    repos    => $dist,
    key      => {
      id     => 'ED9008B740C6735CB3EF098C37DE344F75E258B6',
      source => $::stns::repo::gpgkey_url,
    }
  }
}
