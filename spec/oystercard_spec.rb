require "oystercard"

describe Oystercard do

  context "#balance" do
  it "carries a balance" do
    expect(subject.balance).to eq 0
  end

  it "has an effect on the balance" do
    expect{ subject.topup(10)}.to change{ subject.balance }.by 10
  end

end

  context "#topup" do

    it "responds to topup with 1 argument" do
      expect(subject).to respond_to(:topup).with(1).argument
    end


    it "allows topup with a value" do
      expect(subject.topup(20)).to eq 20
    end


    it "will not topup when the balance would be over £#{Oystercard::MAX_MONEY}" do
      expect{subject.topup(91)}.to raise_error "Your balance cannot go over £#{Oystercard::MAX_MONEY}."
    end

  end

  # context "#deduct" do
  #   it "responds to deduct with 1 argument" do
  #     expect(subject).to respond_to(:deduct).with(1).argument
  #   end
  #
  #   it "deducts fare from balance" do
  #     expect{subject.deduct(10)}.to change{ subject.balance }.by -10
  #   end
  #
  # end

  context "#touch_in" do
    before(:each) do
      subject.topup(50)
    end

    it "is initially not in a journey" do
      expect(subject).not_to be_on_journey
    end

    it "responds to touch_in method" do
      expect(subject).to respond_to(:touch_in)
    end

    it "registers as being in a journey after touchin" do
      subject.touch_in
      expect(subject).to be_on_journey
    end
  end

context "#touch_in_errors" do
    it "raises an error when minimum amount not reached" do
      expect{ subject.touch_in }.to raise_error "min. balance of £#{Oystercard::MIN_MONEY} not reached"
    end
  end

context "#touch_out" do
  before(:each) do
    subject.topup(50)
  end

  it "responds to touch_out method" do
    expect(subject).to respond_to(:touch_out)
  end

  it "registers as journey complete after touch_out" do
    subject.touch_in
    subject.touch_out
    expect(subject).not_to be_on_journey
  end

  it " deducts minimum fare when touch_out" do
  subject.touch_in
  expect{ subject.touch_out}.to change{ subject.balance}.by -(Oystercard::MINIMUM_FARE)
  end
end
end
