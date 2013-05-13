require 'html_truncator'
module CrazyHarry
  module Truncate
    def truncate!(count, opts = {})
      truncated = HTML_Truncator.truncate(self.fragment.to_s, count, opts)
      self.fragment = Loofah.fragment(truncated)
      self
    end
  end
end
