require 'spec_helper'
describe MetaReports::Data do
  it 'can be created' do
    MetaReports::Data.new.should be
  end

  it 'returns the hash' do
    data = MetaReports::Data.new
    data.to_h.class.name.should == 'Hash'
  end

  it 'stores unknown methods in hash' do
    data = MetaReports::Data.new
    data.foo = "moo"
    data.to_h[:foo].should == "moo"
    data._bar = "boo"
    data.to_h[:bar].should == "boo"
  end

  it 'returns hash values' do
    data = MetaReports::Data.new
    data.foo = "bar"
    data.foo.should == "bar"
  end

  it 'returns nil or val for _ methods' do
    data = MetaReports::Data.new
    data._foo.should == nil
    data._foo = "bar"
    data._foo.should == "bar"
  end

  it 'passes methods to hash if not a key' do
    data = MetaReports::Data.new
    data.foo = "bar"
    data.to_a.should match_array([[:foo, 'bar']])
  end

  it 'works with a block' do
    data = MetaReports::Data.new do |d|
      d.foo = "bar"
    end
    data.foo.should == 'bar'
  end
end
