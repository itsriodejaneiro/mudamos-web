class PushMessageService
  # @see `OneSignal::Notification.create`
  # @param contents [Hash<Symbol, String>]
  #   @option contents [String] `lang` The message body in the given key lang
  # @param headings [Hash<Symbol, String>]
  #   @option contents [String] `lang` The message title in the given key lang
  # @param included_segments [Array<String>] (["All"]) the segments to include
  #
  # @example
  #   #deliver(contents: { en: "Mess body", "pt-BR": "mensagem"}, headings: { "en": "le tit", "pt-BR": "titulo"}, included_segments: ["All"])
  def deliver(**args)
    params = args.reverse_merge app_id: app_id, included_segments: %w(All)
    OneSignal::Notification.create(params: params)
  end

  def app_id
    ENV["ONESIGNAL_APP_ID"]
  end
end
