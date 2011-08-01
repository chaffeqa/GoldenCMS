require 'spec_helper'

describe Element do
  let(:element) {Factory(:element)}
  
  context 'basic attributes' do
    it 'requires a page' do
      Factory.build(:element, :page_id => nil).should have_at_least(1).errors_on(:page_id)
    end
    it 'requires a title' do
      Factory.build(:element, :title => '').should have_at_least(1).errors_on(:title)
    end
  end
  
  context '#html_id' do
    it 'requires an html safe html_id' do
      Factory.build(:element, :html_id => 'bad /html').should have_at_least(1).errors_on(:html_id)
    end
    it 'allows an html_id to be set' do
      elem = Factory(:element, :html_id => 'special-id')
      elem.html_id.should == 'special-id'
    end
    it 'creates an to_slug of the title if no html_id is given' do
      element.html_id.should == element.title.to_slug
    end
  end
  
  context '#html_class' do
    it 'requires an html safe html_class' do
      Factory.build(:element, :html_class => 'bad /html').should have_at_least(1).errors_on(:html_class)
    end
    it 'allows an html_class to be set' do
      elem = Factory(:element, :html_class => 'special-class')
      elem.html_class.should == 'special-class'
    end
    it 'creates an to_slug of the title if no html_class is given' do
      element.html_class.should == element.title.to_slug
    end
  end
  
  context 'manipulating ordering' do
    #TODO
  end
end
