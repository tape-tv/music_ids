require 'music_ids/isrc'

module MusicIds
  RSpec.describe ISRC do
    context "parsing" do
      context "well-formed inputs" do
        let(:expected) { ISRC.new("FRZ039800212") }

        specify { expect(ISRC.parse("FR-Z03-98-00212")).to eq(expected) }
        specify { expect(ISRC.parse("FRZ039800212")).to eq(expected) }
        specify { expect(ISRC.parse("frz039800212")).to eq(expected) }
      end

      context "strict parsing" do
        it "will not parse a string that's not long enough" do
          expect { ISRC.parse("FRZ03") }.to raise_error(ArgumentError)
        end

        it "will not parse a non-alpha country code" do
          expect { ISRC.parse("11Z039800212") }.to raise_error(ArgumentError)
        end

        it "will not parse a non-digit year" do
          expect { ISRC.parse("FRZ03AA00212") }.to raise_error(ArgumentError)
        end

        it "will not parse a non-digit designation code" do
          expect { ISRC.parse("FRZ0398A0212") }.to raise_error(ArgumentError)
        end

        it "will not parse non A-Z 0-9 anywwhere" do
          expect { ISRC.parse("~RZ039800212") }.to raise_error(ArgumentError)
          expect { ISRC.parse("FRZ-39800212") }.to raise_error(ArgumentError)
          expect { ISRC.parse("FRZ039_00212") }.to raise_error(ArgumentError)
          expect { ISRC.parse("FRZ039800*12") }.to raise_error(ArgumentError)
        end
      end

      context "relaxed parsing" do
        it "marks a bad input string instead of raising" do
          expect(ISRC.parse("FRZ03", relaxed: true).ok?).to be(false)
        end
      end
    end

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

      context "a bad ISRC instance" do
        let(:isrc) { ISRC.new('FRZ03', ok: false) }

        it "will not report the country code" do
          expect(isrc.country).to be_nil
        end

        it "will not report the registrant code" do
          expect(isrc.registrant).to be_nil
        end

        it "will not report the year of reference" do
          expect(isrc.year).to be_nil
        end

        it "will not report the designation code" do
          expect(isrc.designation).to be_nil
        end

        it "returns the bad ISRC string as usual" do
          expect(isrc.to_s).to eq('FRZ03')
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

    context "string representation" do
      let(:isrc) { ISRC.new('FRZ039800212') }

      it "can generate a full (hyphenated) string representation for presentation uses" do
        expect(isrc.as(:full)).to eq('FR-Z03-98-00212')
      end

      it "can generate a (non-hyphenated) string representation for data uses" do
        expect(isrc.as(:data)).to eq('FRZ039800212')
      end

      it "requesting another format raises an ArgumentError" do
        expect { isrc.as(:other) }.to raise_error(ArgumentError)
      end

      it "the data format is identical to the to_s format" do
        expect(isrc.as(:data)).to eq(isrc.to_s)
      end
    end
  end
end
