# encoding: UTF-8
require 'spec_helper'

describe CrazyHarry::Truncate do
  let(:harry){ CrazyHarry }

  it "truncate by number of words" do
    harry.fragment('<p>text goes here</p>').truncate!(2).to_s.should == '<p>text goes…</p>'
  end

  it "closes html tags properly" do
    harry.fragment('<p>text <b>goes here</b></p>').truncate!(2).to_s.should == '<p>text <b>goes</b>…</p>'
  end

  it "passes extra options to HTML_Truncator" do
    harry.fragment('<p>text goes here</p>').truncate!(10, length_in_chars: true, ellipsis: ' (...)').to_s
      .should == '<p>text goes (...)</p>'
  end
end
