require 'music_ids/isrc'

module MusicIds
  RSpec.describe ISRC do
    context "an instance" do
      let(:isrc) { ISRC.new("FRZ039800212") }

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

      it "returns itself when to_isrc called" do
        expect(isrc.to_isrc).to be(isrc)
      end

      it "compares equal with itself" do
        expect(isrc).to eq(isrc)
      end

      it "compares equal with another ISRC instance of the same ISRC string" do
        expect(isrc).to eq(ISRC.new(isrc.to_s))
      end
    end

    context "parsing" do
      it "can parse a hyphen-separated ISRC" do
        expect(ISRC.parse("FR-Z03-98-00212")).to eq(ISRC.new("FRZ039800212"))
      end

      it "can parse a non-separated ISRC" do
        expect(ISRC.parse("FRZ039800212")).to eq(ISRC.new("FRZ039800212"))
      end

      it "will not parse a string that's not long enough" do
        expect { ISRC.parse("FRZ03") }.to raise_error(ArgumentError)
      end
    end
  end
end
