require 'spec_helper'

describe Group do
  describe "validations" do
    describe "name" do
      it "requires name to be set" do
        Factory.build(:group, :name => nil).should_not be_valid
        Factory.build(:group, :name => "").should_not be_valid
        Factory.build(:group, :name => "foo").should be_valid
      end
    end
  end
  describe "life cycle" do
    describe "canonicalized_name" do
      [
        ["Joe's Schmoes", "joe-s-schmoes"],
        ["Sanchez", "sanchez"],
        ["PETA", "peta"],
      ].each do |name|
        it "turns the name #{name[0]} into something url friendly" do
          group = Factory.build(:group, :name => name[0])
          group.canonicalized_name.should be_blank
          group.save!
          group.canonicalized_name.should == name[1]
        end
      end
    end
  end
end