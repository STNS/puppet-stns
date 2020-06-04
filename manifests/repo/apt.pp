class stns::repo::apt {
  if $::os['name'] == 'Ubuntu' {
    $codename = $::os['distro']['codename']
    $location = "https://repo.stns.jp/${codename}/"
    $repos    = $codename
  } else {
    $location = "https://repo.stns.jp/debian/"
    $repos    = 'main'
  }

  apt::source { 'stns':
    location => $location,
    release  => 'stns',
    repos    => $repos,
    key      => {
      id     => '6BACCE33697C7E568D5C162F018A7A21B2EC51BA',
      source => $::stns::repo::gpgkey_url,
    }
  }
}
