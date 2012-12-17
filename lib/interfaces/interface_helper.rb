#
# Helper for simple interface classes
# @abstract Subclass and set ATTRIBUTES
class InterfaceHelper
  attr_accessor *ATTRIBUTES

  def initialize args
    ATTRIBUTES.each do |sym|
      self.send("@#{sym.to_s}=?",args[sym])
    end
  end
end