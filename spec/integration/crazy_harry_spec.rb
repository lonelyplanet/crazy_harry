require 'spec_helper'

describe CrazyHarry do

  let(:harry) { CrazyHarry }

  it "should allow method chaining" do
    harry.fragment('<script>STEAL COOKIE!</script><em>Place</em><p>Lodging</p><b>Location:</b> Warsaw')
      .redact!( unsafe: true, tags: 'em' )
      .change!( from: 'b', to: 'h3' )
      .truncate!(3, ellipsis: '...')
      .translate!( from_text: 'Lodging', to_text: 'Hotel', add_attributes: { class: 'partner' } )
      .to_s.should == 'Place <p class="partner">Hotel</p><h3 class="partner">Location:</h3>...'
  end

  it "should not care about the chain order" do
    harry.fragment('<script>STEAL COOKIE!</script><em>Place</em><p>Lodging</p><b>Location:</b>')
      .translate!( from_text: 'Lodging', to_text: 'Hotel', add_attributes: { class: 'partner' } )
      .redact!( unsafe: true, tags: 'em' )
      .change!( from: 'b', to: 'h3' )
      .truncate!(3)
      .to_s.should == 'Place <p class="partner">Hotel</p><h3 class="partner">Location:</h3>'
  end

  it "should not care about repetition when dupes are preserved" do
    harry.fragment('<script>STEAL COOKIE!</script><em>Place</em><p>Lodging</p><b>Location:</b><p>Lodging</p>', preserve_dupes: true)
      .translate!( from_text: 'Lodging', to_text: 'Hotel', add_attributes: { class: 'partner' } )
      .redact!( unsafe: true, tags: 'em' )
      .change!( from: 'b', to: 'h3' )
      .to_s.should == 'Place <p class="partner">Hotel</p><h3 class="partner">Location:</h3><p class="partner">Hotel</p>'
  end


end
