namespace :test do
  desc "Run tests with coverage enabled"
  task coverage: :environment do
    ENV["COVERAGE"] = "true"
    Rake::Task["test"].invoke
  end
end
