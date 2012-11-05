require 'spec_helper'

describe CrazyHarry::Foster do

    let(:harry){ CrazyHarry }

    it "should wrap orphaned list items" do
      harry.fragment('<p><li>orphan</li><ul><li>item</li></p>').foster!.to_s.should ==
        '<ul><li>orphan</li></ul><ul><li>item</li></ul>'
    end

end
