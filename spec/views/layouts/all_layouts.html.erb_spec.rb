require "spec_helper"

# Loops through each template file and checks for correct formating
TEMPLATES.keys.each do |template|

  describe "layouts/#{template}.html.erb" do
    before(:each) do
      view.stub(:admin?) {false}
      layout_partials.each  { |partial_name| stub_template "layouts/partials/#{partial_name}.html.erb" => "#{partial_name} partial" }
    end
    
    it "renders #{REQUIRED_TEMPLATE_PARTIALS.join(', ')} partials" do
      render
      REQUIRED_TEMPLATE_PARTIALS.each { |partial|
        rendered.should =~ /#{partial} partial/
      }
    end
    
    it 'accepts content_for :head' do
      view.content_for(:head) { 'head insert' }
      render
      rendered.should =~ /head insert/
    end
    
    context 'when compared to TEMPLATES' do
      before(:each) do
        @element_areas = TEMPLATES[template]["total_element_areas"]
        @element_areas.times { |area| view.content_for("element_area_#{area}".intern) { "area #{area}" } }
      end
      
      it 'has an total_element_areas' do
        @element_areas.should be_an_instance_of(Fixnum)
      end
      
      it 'should have the correct number of element_areas' do
        render
        @element_areas.times { |area| rendered.should =~ /area #{area}/ }
      end
    end
  
    context '<head>' do
      it 'should render a <head>' do
        render
        rendered.should have_selector("head")
      end    
    end
      
    context '<body>' do
      let(:default_id) { 'secPage' }
      let(:default_class) { 'twoColumn' }
      it 'should render a <body>' do
        render
        rendered.should have_selector("body")
      end 
      it 'replaces #id with content_for(:body_id)' do
        view.content_for(:body_id) { 'some-id' }
        render
        rendered.should have_selector :body, :id => "some-id"
      end
      it 'defaults #id' do
        render
        rendered.should have_selector :body, :id => default_id
      end      
      it 'replaces #class with content_for(:body_class)' do
        view.content_for(:body_class) { 'some-class' }
        render
        rendered.should have_selector :body, :class => "some-class"
      end
      it 'defaults #class' do
        render
        rendered.should have_selector :body, :class => default_class
      end
    end
    
    context 'when an admin is logged in' do
      before(:each) do
        view.stub(:admin?) { true }
        stub_template "partials/_admin_bar.html.haml" => 'admin_bar partial'
      end
      
      it 'should render admin_bar' do
        render
        rendered.should =~ /admin_bar partial/
      end     
    end
    
    context 'when no admin is logged in' do
      before(:each) do
        #view.stub(:admin?) { false }
        stub_template "partials/_admin_bar.html.haml" => 'admin_bar partial'
      end
      
      it 'should not render admin_bar' do
        render
        rendered.should_not =~ /admin_bar partial/
      end
    end
    
  end
end

