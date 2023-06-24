class stns::repo::apt {
  apt::source { 'stns':
    location => 'http://repo.stns.jp/debian/',
    release  => 'stns',
    key      => {
      id     => 'ED9008B740C6735CB3EF098C37DE344F75E258B6',
      source => $::stns::repo::gpgkey_url,
    }
  }
}
