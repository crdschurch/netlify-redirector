require 'spec_helper'

describe NetlifyRedirector::Redirect do

  before do
    src = "/undivided-training,https://undivided.netlify.com,301"
    @redirect = NetlifyRedirector::Redirect.new(src.split(','))
  end

  it 'should do string replacements' do
    ENV['JEKYLL_REDIR_TEST'] = 'lebowski'
    expect(NetlifyRedirector::Redirect.send(:replace, 'jeff/${env:JEKYLL_REDIR_TEST}/dude')).to eq('jeff/lebowski/dude')
  end

  it 'should return redirect rule via to_s method' do
    expect(@redirect.to_s).to eq("/undivided-training\thttps://undivided.netlify.com\t301")
  end

  context 'evaluating current context' do

    it 'should return env value for CONTEXT' do
      ENV['CONTEXT'] = 'release'
      expect(@redirect.deployment_context).to eq('release')
    end

    context 'when CONTEXT is nil' do
      it 'should return BRANCH' do
        ENV['CONTEXT'] = nil
        ENV['BRANCH'] = 'some-branch'
        expect(@redirect.deployment_context).to eq('some-branch')
      end
    end

    context 'when CONTEXT and BRANCH are both nil' do
      it 'should return current git branch from system' do
        ENV['CONTEXT'] = nil
        ENV['BRANCH'] = nil
        branch = @redirect.class.git_branch
        expect(@redirect.deployment_context).to eq(branch)
      end
    end

    context 'when CONTEXT is production' do
      it 'should default to current git branch' do
        branch = @redirect.class.git_branch
        ENV['CONTEXT'] = 'production'
        expect(@redirect.deployment_context).to eq(branch)
      end
    end

    context 'when CONTEXT is deploy-preview' do
      it 'should default to development' do
        ENV['CONTEXT'] = 'deploy-preview'
        expect(@redirect.deployment_context).to eq('development')
      end
    end
  end

  it 'should include rules with context specified' do
    src = "/undivided-training,https://undivided.netlify.com,301,release"
    @redirect = NetlifyRedirector::Redirect.new(src.split(','))
    ENV['CONTEXT'] = 'release'
    expect(@redirect.context_included?).to be_truthy
  end

  it 'should exclude rules that do not match current context' do
    src = %w(/zzz https://undivided.netlify.com 301 zzz,release)
    @redirect = NetlifyRedirector::Redirect.new(src)
    ENV['CONTEXT'] = 'zzz'
    expect(@redirect.context_included?).to be_truthy
    ENV['CONTEXT'] = 'release'
    expect(@redirect.context_included?).to be_truthy
    ENV['CONTEXT'] = 'production'
    expect(@redirect.context_included?).to be_falsey
  end

end