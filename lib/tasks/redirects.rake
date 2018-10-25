namespace 'redirects' do
  desc "Parse redirects.csv to _redirects"
  task :write do |t, args|
    NetlifyRedirector::Parser.new().write!
  end
end