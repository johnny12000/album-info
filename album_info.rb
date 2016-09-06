require 'zlib'
require 'taglib'

if(ARGV.count != 1)
   abort "Invalid parameter number: add folder name"
end

fileName = ARGV[0]

files = Dir.glob(fileName + '//*.mp3')

tags =[]

files.each { |file|
  data = TagLib::MPEG::File.new(file)
  tags = tags + [[data.tag.title, data.tag.album]]
  data.close
}

titleLength = 0
albumLength = 0

tags.each { |tag|
  
  title = tag[0] 
  album = tag[1]
  
  if title.length > titleLength
    titleLength = title.length
  end
  if album.length > albumLength
    albumLength = album.length
  end
}

format = "| %-#{titleLength}s | %-#{albumLength}s |"
header = sprintf format, "Title", "Album"
separator = "+"
(1..titleLength+2).each { separator += "-"}
separator += "+"
(1..albumLength+2).each { separator += "-"}
separator += "+"

puts separator
puts header
puts separator

tags.each { |tag|
  title = tag[0]
  album = tag[1]
 
   puts sprintf format, title, album
}

puts separator


