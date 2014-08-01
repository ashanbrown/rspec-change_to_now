
  describe "adding one" do
    it "adds one" do
      x = 1
      expect { x += 1 }.to change { x }.to_now eq 3
    end
  end