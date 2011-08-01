require "spec_helper"

describe "layouts/inside.html.erb" do
  before(:each) do
  end
  
  context 'when an admin is logged in' do
    before(:each) do
      view.stub(:admin?) { true }
      stub_template "partials/_admin_bar.html.haml" => 'admin_bar partial'
    end
    
    it 'should render admin_bar' do
      pending "TODO"
      render
      rendered.should contain 'admin_bar partial'
    end
    
    
    
  end
  
  context 'when no admin is logged in' do
    before(:each) do
      view.stub(:admin?) { true }
      stub_template "partials/_admin_bar.html.haml" => 'admin_bar partial'
    end
    
    it 'should not render admin_bar' do
      pending "TODO"
      render
      rendered.should_not contain 'admin_bar partial'
    end
    
    context '<body>' do
      let(:default_id) { 'secPage' }
      let(:default_class) { 'twoColumn' }
      it 'replaces #id with content_for(:body_id)' do
      pending "TODO"
        view.content_for(:body_id) { 'some-id' }
        render
        rendered.should have_selector :body, :id => "some-id"
      end
      it 'defaults #id' do
      pending "TODO"
        render
        rendered.should have_selector :body, :id => default_id
      end      
      it 'replaces #class with content_for(:body_class)' do
      pending "TODO"
        view.content_for(:body_class) { 'some-class' }
        render
        rendered.should have_selector :body, :class => "some-class"
      end
      it 'defaults #class' do
      pending "TODO"
        render
        rendered.should have_selector :body, :class => default_class
      end
    end
  end
end

