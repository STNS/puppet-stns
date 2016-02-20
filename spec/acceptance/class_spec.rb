require 'spec_helper_acceptance'

describe 'stns class' do
  let(:manifest) {
    <<-EOS
      include ::stns
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

  context 'RedHat', :if => os[:family] == 'redhat' do
    describe yumrepo('stns') do
      it { should be_enabled }
    end

    describe file('/etc/yum.repos.d/stns.repo') do
      it { should be_file }
    end
  end

  context 'Debian', :if => os[:family] =~ /^(ubuntu|debian)$/ do
    describe file('/etc/apt/sources.list.d/stns.list') do
      it { should be_file }
      its(:content) { should match %r|^deb\s+http://repo.stns.jp/debian/\s+stns\s+main$| }
    end
  end
end
