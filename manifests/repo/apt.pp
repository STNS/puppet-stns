class stns::repo::apt {
  if $::os['name'] == 'Ubuntu' {
    $codename = $::os['distro']['codename']
    $location = "https://repo.stns.jp/${codename}/"
    $repos    = $codename
  } else {
    $location = 'https://repo.stns.jp/debian/'
    $repos    = 'main'
  }

  apt::source { 'stns':
    location => $location,
    release  => 'stns',
    repos    => $repos,
    key      => {
      id     => 'ED9008B740C6735CB3EF098C37DE344F75E258B6',
      source => $::stns::repo::gpgkey_url,
    }
  }
}
