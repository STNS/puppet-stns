require 'spec_helper_acceptance'

describe 'stns::server class' do
  let(:manifest) {
    <<-EOS
      include ::stns::server
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

  describe package('stns') do
    it { should be_installed }
  end

  describe file('/etc/stns/conf.d') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/stns/stns.conf') do
    it { should be_file }
    its(:content) { should match /^port\s+=\s+\d+$/ }
    its(:content) { should match /^user\s+=\s+".*"$/ }
    its(:content) { should match /^password\s+=\s+".*"$/ }
  end

  describe service('stns') do
    it { should be_enabled }
    it { should be_running }
  end
end
