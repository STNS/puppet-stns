# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
include stns::client
include stns::server

stns::server::groups { 'samplegroups':
  id    => 1001,
  users => 'sample',
}

stns::server::users { 'sample':
  id         => 1001,
  group_id   => 1001,
  directory  => '/home/sample',
  shell      => '/bin/bash',
}
