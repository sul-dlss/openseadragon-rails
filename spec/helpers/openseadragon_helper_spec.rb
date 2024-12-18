require 'spec_helper'

RSpec.describe Openseadragon::OpenseadragonHelper do
  describe "#picture_tag" do
    context "without any sources" do
      it "should render an empty <picture>" do
        expect(helper.picture_tag).to have_selector 'picture'
      end

      it "should use provided options" do
        expect(helper.picture_tag a: 1).to have_selector 'picture[a="1"]'
      end
    end

    context "with two sources" do
      it "should include both sources" do
        response = helper.picture_tag 'image1.jpg', 'image2.jpg'
        expect(response).to have_selector 'picture source[src="image1.jpg"]'
        expect(response).to have_selector 'picture source[src="image2.jpg"]'
      end

      it "should use provided global options" do
        response = helper.picture_tag 'image1.jpg', 'image2.jpg', { a: 1 }, {b: 2}
        expect(response).to have_selector 'picture[b="2"]'
        expect(response).to have_selector 'picture source[src="image1.jpg"][a="1"]'
        expect(response).to have_selector 'picture source[src="image2.jpg"][a="1"]'
      end

    end

    context "with a source given as a hash" do
      it "should use the key of the hash for the src" do
        expect(helper.picture_tag ['image1.jpg' => { }]).to have_selector 'picture source[src="image1.jpg"]'
      end

      it "should use the attributes as options for the source tag" do
        expect(helper.picture_tag ['image1.jpg' => { a: 1}]).to have_selector 'picture source[src="image1.jpg"][a="1"]'
      end

      it "should merge the source-specific attributes with the global attributes" do
        expect(helper.picture_tag ['image1.jpg' => { a: 1}], {a: 2, b: 2}, { }).to have_selector 'picture source[src="image1.jpg"][a="1"][b="2"]'
      end
    end
  end

  describe "#openseadragon_picture_tag" do
    before { allow(helper).to receive(:osd_asset_defaults).and_return({b: 6}) }

    context "with no args" do
      subject { helper.openseadragon_picture_tag }
      it "should mark the <picture> as an openseadragon tag" do
          expect(subject).to match /picture data-openseadragon="#{helper.escape_once({b: 6}.to_json)}"/
      end
    end

    context "with simple strings" do
      subject { helper.openseadragon_picture_tag('image1.jpg', 'image2.jpg') }

      it "should pass simple strings through" do
        expect(subject).to have_selector 'picture source[src="image1.jpg"][media="openseadragon"]'
        expect(subject).to have_selector 'picture source[src="image2.jpg"][media="openseadragon"]'
        expect(subject).to match /picture data-openseadragon="#{helper.escape_once({b: 6}.to_json)}"/
      end
    end

    context "with tilesource objects" do
      subject { helper.openseadragon_picture_tag(double(to_tilesource: { a: 1})) }
      it "should convert sources to tilesources" do
        expect(subject).to have_selector 'picture source[src="openseadragon-tilesource"]'
        expect(subject).to match /data-openseadragon="#{helper.escape_once({a: 1}.to_json)}"/
        expect(subject).to match /picture data-openseadragon="#{helper.escape_once({b: 6}.to_json)}"/
      end
    end

    context "with a source given as a hash" do
      subject { helper.openseadragon_picture_tag(['image1.jpg' => { html: { id: 'xyz' }}]) }
      it "should extract html options" do
        expect(subject).to have_selector 'picture source[src="image1.jpg"][id="xyz"]'
        expect(subject).to match /picture data-openseadragon="#{helper.escape_once({b: 6}.to_json)}"/
      end

      context "and extra options" do
        subject { helper.openseadragon_picture_tag(['image1.jpg' => { a: 1}]) }
        it "should pass the remaining options as encoded openseadragon options" do
          expect(subject).to have_selector 'picture source[src="image1.jpg"]'
          expect(subject).to have_selector 'picture source[src="image1.jpg"][data-openseadragon]'
          expect(subject).to match /data-openseadragon="#{helper.escape_once({a: 1}.to_json)}"/
        end
      end

      context "tilesource key and options" do
        let(:source) { double(to_tilesource: { a: 1, b: 1}) }
        subject { helper.openseadragon_picture_tag([source => { html: { id: 'xyz' }, b: 2, c: 3}]) }
        it "should merge a tilesource key with the options provided" do
          expect(subject).to have_selector 'picture source[src="openseadragon-tilesource"]'
          expect(subject).to have_selector 'picture source[src="openseadragon-tilesource"][id="xyz"]'
          expect(subject).to match /data-openseadragon="#{helper.escape_once({a: 1, b: 2, c: 3}.to_json)}"/
        end
      end
    end
  end

  describe "#osd_asset_defaults" do
    let(:defaults) { helper.send(:osd_asset_defaults) }

    describe "['prefixUrl']" do
      subject { defaults['prefixUrl'] }
      it { is_expected.to eq ''}
    end

    describe "['navImages']" do
      subject { defaults['navImages'] }
      it { is_expected.to include('zoomIn', 'zoomOut', 'home', 'fullpage', 'rotateleft', 'rotateright', 'previous', 'next') }

      it 'has all the values' do
        expect(subject).to all(include(have_key('REST')))
        expect(subject).to all(include(have_key('GROUP')))
        expect(subject).to all(include(have_key('HOVER')))
        expect(subject).to all(include(have_key('DOWN')))
      end
    end
  end
end
