namespace :push do
  # @example
  #   rake push:message["A title", "A body"]
  desc "Sends a push message with the given HEADING and CONTENT"
  task :message, %i(heading content) => :environment do |_, args|
    heading = args[:heading]
    content = args[:content]
    service = PushMessageService.new

    service.deliver headings: { en: heading }, contents: { en: content }
  end
end
