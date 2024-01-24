RSpec.configure do |config|
  config.before do |example|
    if example.metadata[:skip_permission]
      allow(Permission).to receive(:all).and_return([])
    end
  end
end
