require 'zlib'
require 'taglib'

if(ARGV.count == 0)
  puts "Available tags:"
  TagLib::Tag.public_instance_methods(false).each do |tag|
    if tag.to_s.end_with? "="
      puts "* "+ tag.to_s.delete("=")
    end
  end
end

if(ARGV.count != 3)
   abort "Invalid parameter number: add folder name, tag name, tag value"
end

fileName = ARGV[0]
tagName = ARGV[1]
tagValue = ARGV[2]

files = Dir.glob(fileName + '//*.mp3')

methodName = tagName + "="

begin
 TagLib::Tag.public_instance_method(methodName)
rescue
 abort "Tag with name '#{tagName}' not found"
end

files.each { |file|

  puts "Writing tag to #{file}..."
  data = TagLib::MPEG::File.new(file)

  method = data.tag.method(methodName)

  begin
    method.call(tagValue)
  rescue
    begin
      method.call(tagValue.to_i)
    rescue Exception => e
      puts e.message
    end
  end
    
  data.save
  data.close
}
