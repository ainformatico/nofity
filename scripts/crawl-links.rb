require File.join(Rails.root, 'app/services/notes/parser_service.rb')

Link.all.each_with_index do |link, index|
  puts "#{index + 1}/#{Link.all.count}"
  ::Notes::LinkFetcher.queue(link.id, link.user.id)
end
