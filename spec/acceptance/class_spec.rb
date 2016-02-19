require 'spec_helper_acceptance'

describe 'stns class' do
  let(:manifest) {
    <<-EOS
    'include ::stns'
    EOS
  }

  hosts.each do |host|
    it "should work without errors on #{host}" do
      result = apply_manifest_on(host, manifest, :acceptable_exit_codes => [0, 2], :catch_failures => true)

      expect(result.exit_code).not_to eq 4
      expect(result.exit_code).not_to eq 6
    end
  end
end
