require 'spec_helper'
describe MetaReports::Table do
  it 'can be created' do
    MetaReports::Table.new.should be
  end

  it 'returns the table' do
    table = MetaReports::Table.new
    table.to_a.class.name.should == 'Array'
  end

  it 'stores unknown methods in options' do
    table = MetaReports::Table.new
    table.foo = "moo"
    table.options[:foo].should == "moo"
    table._bar = "boo"
    table.options[:bar].should == "boo"
  end

  it 'returns option values' do
    table = MetaReports::Table.new
    table.foo = "bar"
    table.foo.should == "bar"
  end

  it 'returns nil or val for _ methods' do
    table = MetaReports::Table.new
    table._foo.should == nil
    table._foo = "bar"
    table._foo.should == "bar"
  end

  it 'adds to data array' do
    table = MetaReports::Table.new
    table << [:foo, "bar"]
    table.to_a.should match_array([[:foo, 'bar']])
    # alias
    table.data.should match_array([[:foo, 'bar']])
  end

  it 'returns length' do
    table = MetaReports::Table.new
    table << [:foo, "bar"]
    table.length.should == 1
  end

  it 'adds to data array' do
    table = MetaReports::Table.new
    table << [:foo, "bar"]
    table.to_a.should match_array([[:foo, 'bar']])
  end

  it 'adds row_classes directly' do
    table = MetaReports::Table.new
    table.row_classes[5] = 'zoop'
    table.options[:row_classes].should == {5 => 'zoop'}
  end

  it 'works with a block' do
    table = MetaReports::Table.new do |d|
      d.foo = "bar"
    end
    table.options[:foo].should == 'bar'
  end
end
