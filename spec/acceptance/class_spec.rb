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
end
