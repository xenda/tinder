require 'spec_helper'

describe Tinder::Campfire do
  before do
    @campfire = Tinder::Campfire.new('test', :token => 'mytoken')
  end
  
  describe "rooms" do
    before do
      stub_connection(@campfire.connection) do |stub|
        stub.get('/rooms.json') {[ 200, {}, fixture('rooms.json') ]}
      end
    end
    
    it "should return rooms" do
      @campfire.rooms.size.should == 2
      @campfire.rooms.first.should be_kind_of(Tinder::Room)
    end
    
    it "should set the room name and id" do
      room = @campfire.rooms.first
      room.name.should == 'Room 1'
      room.id.should == 80749
    end
  end
  
  describe "users" do
    before do
      stub_connection(@campfire.connection) do |stub|
        stub.get('/rooms.json') {[ 200, {}, fixture('rooms.json') ]}

        [80749, 80751].each do |id|
          stub.get("/room/#{id}.json") {[ 200, {}, fixture("rooms/room#{id}.json") ]}
        end
      end
    end
    
    it "should return a sorted list of users in all rooms" do
      @campfire.users.length.should == 2
      @campfire.users.first[:name].should == "Jane Doe"
      @campfire.users.last[:name].should == "John Doe"
    end
  end
  
  describe "me" do
    before do
      stub_connection(@campfire.connection) do |stub|
        stub.get("/users/me.json") {[ 200, {}, fixture('users/me.json') ]}
      end
    end
    
    it "should return the current user's information" do
      @campfire.me["name"].should == "John Doe"
    end
  end
end
