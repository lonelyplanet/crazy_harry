require 'spec_helper'

describe CrazyHarry do
  TAGS_TO_REMOVE = {
      paragraph:  '<p></p>',
      ul:         '<ul></ul>',
      div:        '<div></div>'
    }

  let(:harry) { CrazyHarry }

  context "default actions" do

    context "removing blank tags" do

      TAGS_TO_REMOVE.each do |name,example|
        it "should automatically remove blank #{name} tags" do
          harry.fragment("#{example}<p>Hello!</p>").to_s.should == '<p>Hello!</p>'
        end
      end

    end

    context "de-duping" do

      it "should automatically de-dupe lists" do
        harry.fragment('<ul><li>Duplicate.</li></ul><ul><li>Duplicate.</li></ul>').to_s.should == '<ul><li>Duplicate.</li></ul>'
      end

      it "should automatically de-dupe paragraphs" do
        harry.fragment('<p>Lorem Ipsum</p><p>Lorem Ipsum</p>').to_s.should == '<p>Lorem Ipsum</p>'
      end

      it "should not remove duplicate content that exsists at a different markup level" do
        harry.fragment('<p><strong>Location:</strong></p><strong>Location:</strong>').to_s.should == '<p><strong>Location:</strong></p><strong>Location:</strong>'
      end

      it "should not alter other content when it de-dupes" do
        harry.fragment('<h3>Here</h3><p>Yep, here.</p><h3>Here</h3><p>Here again.</p>').to_s.should == '<h3>Here</h3><p>Yep, here.</p><p>Here again.</p>'
      end

    end

  end

end
