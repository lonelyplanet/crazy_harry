require 'spec_helper'

describe CrazyHarry::Redactor do

  #   Strip all tags  -- should convert </p> and <br> to linebreaks by default
  #   Strip tags from text: "HostelWorld"
  #   Strip tags from text: "HostelWorld" inside h3
  #
  #   ADS suggested ability to remove tag and content, so 'kill'  Probably
  #   more appropriate for script and image tags
  #
  #   Kill a where a has attribute: "nofollow", text: "visit Disneyland"
  #   Kill img

  let(:redactor){ CrazyHarry::Redactor }

  context "strip all tags" do 

    it "should be able to strip all tags" do
      redactor.new( fragment: "<b>a</b>\nb<br /><h3>c</h3><img src='blah.jpg' />" ).strip!.should == "a\nb\nc\n"
    end

  end

  context "strip specific tags" do

    it "should be able to strip unsafe tags" do
      redactor.new( fragment: 'Me steal <script>Cookie!</script>').strip( unsafe: true ).run!.should == 'Me steal'
      redactor.new( fragment: 'What is that <bloog>thing</bloog>?').strip( unsafe: true ).run!.should == 'What is that ?'
    end

    it "should allow the unsafe strip method to be overridden (it prunes by default)" do
      fragment = 'Me steal <script>Cookie!</script>'
      redactor.new( fragment: fragment).strip( unsafe: :escape ).run!.should == 'Me steal &lt;script&gt;Cookie!&lt;/script&gt;'
      redactor.new( fragment: fragment).strip( unsafe: :strip ).run!.should == 'Me steal Cookie!'
    end

    it "should prune unsafe tags if called without any arguments" do
      redactor.new( fragment: 'Me steal <script>Cookie!</script>').strip.run!.should == 'Me steal'
    end

    it "should raise an error if asked for an unknown strip method" do
      -> { redactor.new( fragment: 'Any old thing').strip( unsafe: 'magical_magic' ).run! }.should raise_error(CrazyHarry::Redactor::InvalidStripMethod)
    end

    it "should be able to strip a specific tag" do
      redactor.new( fragment: '<b>Location:</b><p>Saigon</p>' ).strip( tags: 'b' ).run!.should == "Location: <p>Saigon</p>"
    end

    it "should strip every occurrence of a tag" do
      redactor.new( fragment: '<b>Location:</b><p>Saigon</p><b>Rates:</b>' ).strip( tags: 'b' ).run!.should == "Location: <p>Saigon</p>Rates:"
    end

    it "should be able to strip multiple tags" do
      redactor.new( fragment: '<b>One</b><p>Saigon <em>Plaza</em></p>').strip( tags: %w(b em)).run!.should == "One <p>Saigon Plaza </p>"
    end

    it "should close a paragraph tag early if the fragment has an illegally nested header tag" do
      redactor.new( fragment: '<b>One</b><p>Saigon <h3>Plaza</h3></p>').strip( tags: %w(b h3)).run!.should == "One <p>Saigon </p>Plaza"
    end

    context "whitespace and breaks" do

      it "shouldn't add excessive extra whitespace" do
        redactor.new( fragment: '<b>Location: </b> <b>Prices:</b>' ).strip( tags: 'b' ).run!.should == 'Location: Prices:'
      end

      it "should add a newline after a stripped block element" do
        redactor.new( fragment: '<h3>Location:</h3><p>Lorem ipsum</p>' ).strip( tags: 'h3' ).run!.should == "Location:\n<p>Lorem ipsum</p>"
      end

    end

    context "targeting and scope" do

      it "should allow strip to be targeted by the tag content" do
        redactor.new( fragment: '<h3>Location:</h3><h3>Ho Chi Minh City</h3>' ).strip( tags: 'h3', text: 'Location:' ).run!.should ==
          "Location:\n<h3>Ho Chi Minh City</h3>"
      end

      it "should allow strip to be targeted by an attribute" do
        redactor.new( fragment: '<h3 class="big">Big</h3><h3 class="red">Red</h3>').strip( tags: 'h3', attributes: { class: 'red' } ).run!.should ==
          '<h3 class="big">Big</h3>Red'
      end

      it "should be able to scope changes to specific blocks" do
        redactor.new( fragment: '<div><b>Hotels</b></div><p><b>Hotels</b></p><b>Tents</b>' ).strip( tags: 'b', scope: 'p' ).run!.should ==
          '<div><b>Hotels</b></div><p>Hotels </p><b>Tents</b>'
      end

      it "should allow strip to be targeted and scoped" do
        redactor.new( fragment: '<b>Location:</b><p><b>Big</b> <b>Bad</b> Hotel</p>' ).strip( tags: 'b', scope: 'p', text: 'Big' ).run!.should ==
          '<b>Location:</b><p>Big <b>Bad</b> Hotel</p>'
      end

    end

  end

  context 'pruning' do

    it 'should be able to prune a tag, removing the tag and its contents' do
      redactor.new( fragment: 'I do not want <h3>Big</h3> images.').strip( tags: 'h3', prune: true ).run!.should == 'I do not want images.'
    end

  end

end
