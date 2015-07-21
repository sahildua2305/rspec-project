require 'spec_helper'

describe Burger do
  describe "#apply_ketchup" do
    context "with ketchup" do
      before do
        @burger = Burger.new(:ketchup => true)
        @burger.apply_ketchup
      end
  
      it "sets the ketchup flag to true" do
        expect(@burger.has_ketchup_on_it?).to be true
      end
    end
  
    context "without ketchup" do
      before do
        @burger = Burger.new(:ketchup => false)
        @burger.apply_ketchup
      end
  
      it "sets the ketchup flag to false" do
        expect(@burger.has_ketchup_on_it?).to be false
      end
    end
  end
end