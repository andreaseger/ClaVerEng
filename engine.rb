require_relative 'config/environment'

class ClaVerEng

  def run
    puts 'running...'
  end
  def self.run!
    new.run
  end
end

ClaVerEng.run!