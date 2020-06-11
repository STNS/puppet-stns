require 'spec_helper_acceptance'

describe 'stns class' do
  let(:manifest) do
    <<-EOS
      include ::stns::repo
    EOS
  end

  it 'works without errors' do
    result = apply_manifest(manifest, acceptable_exit_codes: [0, 2], catch_failures: true)

    expect(result.exit_code).not_to eq 4
    expect(result.exit_code).not_to eq 6
  end

  it 'runs a second time without changes' do
    result = apply_manifest(manifest)
    expect(result.exit_code).to eq 0
  end

  context 'RedHat', if: os[:family] == 'redhat' do
    describe yumrepo('stns') do
      it { is_expected.to be_enabled }
    end

    describe file('/etc/yum.repos.d/stns.repo') do
      it { is_expected.to be_file }
    end
  end

  context 'Debian', if: os[:family] =~ %r{^debian$} do
    describe file('/etc/apt/sources.list.d/stns.list') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match %r{^deb\s+http://repo.stns.jp/debian/\s+stns\s+main$} }
    end
  end

  context 'Ubuntu', if: os[:family] =~ %r{^Ubuntu$} do
    codename = os[:distro][:codename]
    describe file('/etc/apt/sources.list.d/stns.list') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match %r{^deb\s+http://repo.stns.jp/#{codename}/\s+stns\s+#{codename}$} }
    end
  end
end
