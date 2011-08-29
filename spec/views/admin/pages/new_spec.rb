require "spec_helper"

describe "admin/pages/new.html.erb" do
  before {create_test_site}
  it "should render the form" do    
    stub_template "admin/pages/_form.html.erb" => 'form'
    render
    rendered.should =~ /form/
  end
end