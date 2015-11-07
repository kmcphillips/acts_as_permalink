require 'spec_helper'

describe Acts::Permalink::Config do
  it "has defaults" do
    config = Acts::Permalink::Config.new

    expect(config.to).to eq(:permalink)
    expect(config.from).to eq(:title)
    expect(config.separator).to eq("-")
    expect(config.max_length).to eq(60)
    expect(config.scope).to be_nil
  end

  it "allows the underscore property" do
    expect(Acts::Permalink::Config.new(underscore: true).separator).to eq("_")
  end

  it "allows indifferent access" do
    config = Acts::Permalink::Config.new("underscore" => true, "max_length" => "10")

    expect(config.separator).to eq("_")
    expect(config.max_length).to eq(10)
  end

  it "overrides the columns" do
    config = Acts::Permalink::Config.new(to: :to_column, from: "from_column")

    expect(config.to).to eq(:to_column)
    expect(config.from).to eq(:from_column)
  end

  it "max_length checks for numbers and allows defaults with bad data" do
    expect(Acts::Permalink::Config.new(max_length: -1).max_length).to eq(60)
    expect(Acts::Permalink::Config.new(max_length: "asdf").max_length).to eq(60)
    expect(Acts::Permalink::Config.new(max_length: 666).max_length).to eq(666)
    expect(Acts::Permalink::Config.new(max_length: "666").max_length).to eq(666)
  end

  it "does presence on the scope" do
    expect(Acts::Permalink::Config.new(scope: 1).scope).to eq(1)
    expect(Acts::Permalink::Config.new(scope: "").scope).to be_nil
  end
end
