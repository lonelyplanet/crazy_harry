require 'loofah'

%w(default foster change redact translate base version).each do |load_lib|
  require_relative "crazy_harry/#{load_lib}"
end

module CrazyHarry

  attr_accessor :base

  class << self

    def fragment(fragment, opts = {})
      preserve_brs = opts.delete(:preserve_brs)
      base = Base.new(fragment: fragment)
      base.no_blanks!
      base.convert_br_to_p! unless preserve_brs
      base.dedupe!
      base
    end

    def to_s
      @base.to_s
    end

  end

end
