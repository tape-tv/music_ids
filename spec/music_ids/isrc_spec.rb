require 'music_ids/isrc'

RSpec.describe MusicIds::ISRC do
  context "an instance" do
    let(:isrc) { MusicIds::ISRC.new("FRZ039800212") }

    it "reports the country code" do
      expect(isrc.country).to eq("FR")
    end

    it "reports the registrant code" do
      expect(isrc.registrant).to eq("Z03")
    end

    it "reports the year of reference" do
      expect(isrc.year).to eq("98")
    end

    it "reports the designation code" do
      expect(isrc.designation).to eq("00212")
    end

    context "returning a string" do
      it "reports the full isrc string" do
        expect(isrc.to_s).to eq("FRZ039800212")
      end

      it "returns a copy of the string so it remains immutable" do
        mutated = isrc.to_s << "mutated"
        expect(mutated).to_not eq(isrc.to_s)
      end
    end
  end
end
