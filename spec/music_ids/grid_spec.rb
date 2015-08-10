require 'music_ids/grid'

module MusicIds
  RSpec.describe GRid do
    context "parsing" do
      context "well-formed inputs" do
        let(:expected) { GRid.new('A12425GABC1234002M') }

        specify { expect(GRid.parse('A1-2425G-ABC1234002-M')).to eq(expected) }
        specify { expect(GRid.parse('A12425GABC1234002M')).to eq(expected) }
        specify { expect(GRid.parse('a12425gabc1234002m')).to eq(expected) }
        specify { expect(GRid.parse('A12425GABC1234002M').ok?).to be(true) }
      end

      context "strict parsing" do
        it "will not parse a string that's not long enough" do
          expect { GRid.parse('A12425G') }.to raise_error(ArgumentError)
        end

        it "will not parse a non-A1 identifer scheme element" do
          expect { GRid.parse('B1-2425G-ABC1234002-M') }.to raise_error(ArgumentError)
        end


        it "will not parse non A-Z 0-9 anywwhere" do
          expect { GRid.parse('A1~425GABC1234002M') }.to raise_error(ArgumentError)
          expect { GRid.parse('A12425GA_C1234002M') }.to raise_error(ArgumentError)
          expect { GRid.parse('A12425GABC1234002*') }.to raise_error(ArgumentError)
        end
      end

      context "relaxed parsing" do
        it "marks a bad input string instead of raising" do
          expect(GRid.parse('A12425G', relaxed: true).ok?).to be(false)
        end

        it "handles good inputs exactly as strict does" do
          expect(GRid.parse('A12425GABC1234002M', relaxed: true).ok?).to be(true)
        end
      end
    end

    context "an instance" do
      let(:grid) { GRid.new('A12425GABC1234002M') }

      it "reports the identifier scheme" do
        expect(grid.scheme).to eq('A1')
      end

      it "reports the issuer code element" do
        expect(grid.issuer).to eq('2425G')
      end

      it "reports the release number element" do
        expect(grid.release).to eq('ABC1234002')
      end

      it "reports the check character element" do
        expect(grid.check).to eq('M')
      end

      context "returning a string" do
        it "reports the full grid string" do
          expect(grid.to_s).to eq('A12425GABC1234002M')
        end

        it "returns a copy of the string so it remains immutable" do
          mutated = grid.to_s << 'mutated'
          expect(mutated).to_not eq(grid.to_s)
        end
      end

      context "a bad GRid instance" do
        let(:grid) { GRid.new('A12425G', ok: false) }

        it "will not report the identifier scheme" do
          expect(grid.scheme).to be_nil
        end

        it "will not report the issuer code element" do
          expect(grid.issuer).to be_nil
        end

        it "will not report the release number element" do
          expect(grid.release).to be_nil
        end

        it "will not report the check character" do
          expect(grid.check).to be_nil
        end

        it "returns the bad GRid string as usual" do
          expect(grid.to_s).to eq('A12425G')
        end
      end

      it "returns itself when to_grid called" do
        expect(grid.to_grid).to be(grid)
      end

      it "compares equal with itself" do
        expect(grid).to eq(grid)
      end

      it "compares equal with another GRid instance of the same GRid string" do
        expect(grid).to eq(GRid.new(grid.to_s))
      end
    end

    context "string representation" do
      let(:grid) { GRid.new('A12425GABC1234002M') }

      it "can generate a full (hyphenated) string representation for presentation uses" do
        expect(grid.as(:full)).to eq('A1-2425G-ABC1234002-M')
      end

      it "can generate a (non-hyphenated) string representation for data uses" do
        expect(grid.as(:data)).to eq('A12425GABC1234002M')
      end

      it "requesting another format raises an ArgumentError" do
        expect { grid.as(:other) }.to raise_error(ArgumentError)
      end

      it "the data format is identical to the to_s format" do
        expect(grid.as(:data)).to eq(grid.to_s)
      end

      context "a bad GRid" do
        let(:grid) { GRid.new('A1-2425G', ok: false) }

        it "the :full format just returns the to_s format" do
          expect(grid.as(:full)).to eq('A1-2425G')
        end
      end
    end
  end
end
