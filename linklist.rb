require "open-uri"
require "nokogiri"

class Linklist < SourceAdapter
  def initialize(source,credential)
    super(source,credential)
  end
 
  def login
  end
 
  def query
    puts "===================================== query"
    begin
    xml = nil
    result = {}
    open("http://gentle-mountain-31.heroku.com/images.xml") do |f|
      xml = Nokogiri::XML(f.read)
    end
    xml.xpath('./images/image').each do |image_node|
      id = image_node.xpath("./id/text()").to_s
      link = image_node.xpath("./link/text()").to_s
      img_url = image_node.xpath("./img_url/text()").to_s
      title = image_node.xpath("./title/text()").to_s
      result[id] = {'link' => link, 'title' => title, 'img_url' => img_url} 
    end
    rescue
        puts "*** ERROR ***"
        $stderr.puts $!
        raise "query failed"    
    end  
    puts "result=#{result.inspect}"
    @result = result
  end
 
  def sync

    super # this creates object value triples from an @result variable that contains an array of hashes
  end
 
  def create(name_value_list)
    #TODO: write some code here
    # the backend application will provide the object hash key and corresponding value
    raise "Please provide some code to create a single object in the backend application using the hash values in name_value_list"
  end
 
  def update(name_value_list)
    #TODO: write some code here
    # be sure to have a hash key and value for "object"
    raise "Please provide some code to update a single object in the backend application using the hash values in name_value_list"
  end
 
  def delete(name_value_list)
    #TODO: write some code here if applicable
    # be sure to have a hash key and value for "object"
    # for now, we'll say that its OK to not have a delete operation
    # raise "Please provide some code to delete a single object in the backend application using the hash values in name_value_list"
  end
 
  def logoff
    #TODO: write some code here if applicable
    # no need to do a raise here
  end
end