RSpec.configure do |config|
  config.around do |example|
    if example.metadata[:time_freeze].present?
      Timecop.freeze(example.metadata[:time_freeze]) { example.run }
    else
      example.run
    end
  end
end
