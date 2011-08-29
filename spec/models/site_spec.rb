require "spec_helper"

describe Site do
  let(:site) { build(:site) }
  
  it 'requires a site name' do
    site.site_name = ''
    site.save
    site.should have(2).errors_on(:site_name)
  end
  
  it 'requires a subdomain' do
    site.subdomain = ''
    site.save
    site.should have(2).errors_on(:subdomain)
  end
  
  it 'saves with a site_name and subdomain' do
    site.save!
  end
  
  
  context '#find_by_subdomains' do
    before(:each) do
      @www_site = create(:site)
      @cool_site = create(:site, :subdomain => 'cool')
    end
    it 'respondes to #find_by_subdomains' do
      Site.should respond_to :find_by_subdomains
    end
    it 'returns the any matched site' do
      Site.find_by_subdomains(["www","bad"]).should == @www_site
    end
    it 'returns the "www" site if the passed in subdomain is ""' do
      Site.find_by_subdomains([""]).should == @www_site      
    end
    it 'returns the "www" site if no subdomains are passed in' do
      Site.find_by_subdomains([]).should == @www_site      
    end
    it 'returns the site if a string is passed in' do
      Site.find_by_subdomains("www").should == @www_site      
    end
  end
  
end
