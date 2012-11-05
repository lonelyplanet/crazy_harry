module CrazyHarry
  module Foster

    def foster!
      self.steps << foster_orphaned_li

      run!

      self
    end

    private

    def foster_orphaned_li
      Loofah::Scrubber.new do |node|
        node.replace("<ul>#{node}</ul>") if orphaned_li?(node)
      end
    end

    def orphaned_li?(node)
      node.name == 'li' && node.parent.name !~ /ol|ul/
    end

  end
end
