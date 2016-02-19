require 'spec_helper_acceptance'

describe 'stns::client class' do
  let(:manifest) {
    <<-EOS
      include ::stns::client
    EOS
  }

  it "should work without errors" do
    result = apply_manifest(manifest, :acceptable_exit_codes => [0, 2], :catch_failures => true)
    expect(result.exit_code).not_to eq 4
    expect(result.exit_code).not_to eq 6
  end

  it "should run a second time without changes" do
    result = apply_manifest(manifest)
    expect(result.exit_code).to eq 0
  end

  describe package('libnss-stns') do
    it { should be_installed }
  end

  describe file('/etc/nsswitch.conf') do
    its(:content) { should match /passwd:\s+files\s+stns$/ }
    its(:content) { should match /shadow:\s+files\s+stns$/ }
    its(:content) { should match /group:\s+files\s+stns$/ }
  end

  describe file('/etc/stns/libnss_stns.conf') do
    it { should be_file }
    its(:content) { should match /^api_end_point\s+=\s+\[.+\]$/ }
    its(:content) { should match /^user\s+=\s+".*"$/ }
    its(:content) { should match /^password\s+=\s+".*"$/ }
    its(:content) { should match /^wrapper_path\s+=\s+".*"$/ }
    its(:content) { should match /^chain_ssh_wrapper\s+=\s+".*"$/ }
    its(:content) { should match /^ssl_verify\s+=\s+(true|false)$/ }
  end
end
