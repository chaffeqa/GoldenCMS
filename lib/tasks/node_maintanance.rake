namespace :db do
  desc 'Check the categories table and resaves each; triggering any invalid categories'
  task :clean_categories => :environment do
    errors=[]
    # Check for bad categories
    Category.all.each do |cat|
      cat.save
      errors << [cat.id, cat.errors] unless cat.errors.blank?
    end
    puts 'All Categories updated!'
    puts errors.empty? ? 'No errors found' : 'Errors:'
    errors.each{|e| puts "#{e.first}: #{e.last.full_messages.inspect}" }
  end
  
  desc 'Check the items table and resaves each; triggering any invalid items'
  task :clean_items => :environment do
    errors=[]
    # Check for bad categories
    Item.all.each do |item|
      item.save
      errors << [item.id, item.errors] unless cat.errors.blank?
    end
    puts 'All Items updated!'
    puts errors.empty? ? 'No errors found' : 'Errors:'
    errors.each{|e| puts "ID: #{e.first} - Errors: #{e.last.full_messages.inspect}" }
  end
  
  desc 'Check the nodes table and resaves each; triggering any invalid nodes'
  task :clean_nodes => :environment do
    errors=[]
    # Check for bad categories
    Node.all.each do |node|
      node.save
      errors << [node.id, node.errors] unless node.errors.blank?
    end
    puts 'All Nodes updated!'
    puts errors.empty? ? 'No errors found' : 'Errors:'
    errors.each{|e| puts "ID: #{e.first} - Errors: #{e.last.full_messages.inspect}" }
  end
end

