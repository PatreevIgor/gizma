class Worker
  STATUS_FREE = 'free'.freeze
  STATUS_BUSY = 'busy'.freeze

  def initialize(bot, message)
    $status = STATUS_FREE
    @bot = bot
    @message = message
  end

  def run
    $status = STATUS_BUSY

    Thread.new do
      loop do
        sleep 60

        dota_manager.execute

        break if status_free?
      end

      $status = STATUS_FREE
    end
  end

  def stop
    $status = STATUS_FREE
  end

  def status
    $status
  end

  def status_free?
    $status == STATUS_FREE
  end

  def busy?
    $status == STATUS_BUSY
  end

  private

  attr_reader :bot, :message

  def send_message(text)
    bot.api.send_message(chat_id: message.chat.id, text: text)
  end

  def dota_manager
    @dota_manager ||= Dota2::Manager.new
  end
end