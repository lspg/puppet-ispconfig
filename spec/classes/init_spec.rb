require 'spec_helper'
describe 'ispconfig' do

  context 'with defaults for all parameters' do
    it { should contain_class('dotdeb') }
  end
end
