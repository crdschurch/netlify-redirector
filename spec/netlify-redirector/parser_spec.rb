require 'spec_helper'

describe NetlifyRedirector::Parser do

  before do
    @dest_dir = File.join(Dir.pwd, 'tmp')
    @redir = NetlifyRedirector::Parser.new(@dest_dir)
  end

  it 'should populate some instance variables' do
    expect(@redir.dest).to eq(File.join(Dir.pwd, 'tmp', '_redirects'))
    expect(@redir.src).to eq(File.join(Dir.pwd, 'redirects.csv'))
  end

  it 'should instantiate Redirect objects for each line in src' do
    @redir.setup()
    expect(@redir.redirs.all?{|obj| obj.is_a?(NetlifyRedirector::Redirect) }).to be_truthy
  end

  it 'should write _redirects' do
    dest = File.join(Dir.pwd, 'tmp', '_redirects')
    FileUtils.rm(dest) if File.exist?(dest)
    @redir = NetlifyRedirector::Parser.new(@dest_dir)
    @redir.debug = false
    @redir.write!
    expect(@redir.output).to be_a(File)
    expect(@redir.output.to_path).to eq(File.join(Dir.pwd, 'tmp', '_redirects'))
    expect(File.exist?(@redir.output.to_path)).to be(true)
  end

  it 'should contain evaluated ENV variables in output' do
    ENV['CRDS_MAESTRO_CLIENT_ENDPOINT'] = '//something.com'
    @redir.debug = false
    @redir.write!
    expect(File.read(@redir.output)).to include(ENV['CRDS_MAESTRO_CLIENT_ENDPOINT'])
  end

end