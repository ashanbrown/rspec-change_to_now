
    describe "detecting even numbers" do
      it "fails for odd numbers" do
        expect([1]).to detect(&:even?)
      end
    end