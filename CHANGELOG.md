Release 1.7.0 (2016/11/20)
---

- Feature: Add parameter uid_shift and gid_shift [#26](https://github.com/STNS/puppet-stns/pull/26)

Release 1.6.0 (2016/08/08)
---

- Change: Change file path to stns-\*-wrapper [#24](https://github.com/STNS/puppet-stns/pull/24)
- Feature: Support request_eader [#25](https://github.com/STNS/puppet-stns/pull/25)

Release 1.5.0 (2016/07/29)
---

- Change: $package_ensure is deprecated and use $libnss_stns_ensure and $libpam_stns_ensure instead. [#22](https://github.com/STNS/puppet-stns/pull/22)

Release 1.4.0 (2016/06/27)
---

- Feature: Add params `$request_timeout` and `$http_proxy` to stns::client class [#21](https://github.com/STNS/puppet-stns/pull/21)

Release 1.3.0 (2016/06/09)
---

- Feature: Add `$package_latest` option to catch up latest packages in stns::server [#19](https://github.com/STNS/puppet-stns/pull/19)

Release 1.2.0 (2016/06/09)
---

- Feature: Add `$package_latest` option to catch up latest packages in stns::client [#18](https://github.com/STNS/puppet-stns/pull/18)

Release 1.1.0 (2016/05/03)
---

- Feature: Install libpam-stns package [#12](https://github.com/STNS/puppet-stns/pull/12)

Release 1.0.0 (2016/03/18)
---

- Feature: Configure users and groups of STNS server [#7](https://github.com/STNS/puppet-stns/pull/7)

Release 0.3.0 (2016/03/17)
---

- Handle sshd\_config with augeas [#6](https://github.com/STNS/puppet-stns/pull/6)

Release 0.2.0 (2016/03/17)
---

- Handle nsswitch.conf with augeas [#5](https://github.com/STNS/puppet-stns/pull/5)

Release 0.1.0
---

### Summary

Initial release.
