require 'spec_helper'

describe Element do
  
  it "should save a valid element" do
    build(:element).save!
  end
  
  context 'basic attributes' do
    it 'requires a page' do
      build(:element, :page_id => nil).should_not be_valid
    end
    it 'requires a title' do
      build(:element, :title => '').should_not be_valid
    end
  end
  
  context '#html_id' do
    it 'requires an html safe html_id' do
      build(:element, :html_id => 'bad /html').should_not be_valid
    end
    it 'allows an html_id to be set' do
      create(:element, :html_id => 'special-id').html_id.should eq('special-id')
    end
    it 'creates an to_slug of the title if no html_id is given' do
      elem = create(:element)
      elem.html_id.should eq(elem.title.to_slug)
    end
  end
  
  context '#html_class' do
    it 'requires an html safe html_class' do
      build(:element, :html_class => 'bad /html').should_not be_valid
    end
    it 'allows an html_class to be set' do
      create(:element, :html_class => 'special-class').html_class.should eq('special-class')
    end
    it 'creates an to_slug of the title if no html_class is given' do
      elem = create(:element)
      elem.html_class.should eq(elem.title.to_slug)
    end
  end
  
  context 'manipulating ordering' do
    #TODO
  end
end
