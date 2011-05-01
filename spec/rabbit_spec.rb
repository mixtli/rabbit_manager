require 'spec_helper'

describe RabbitManager do

  before do
    @rabbit = RabbitManager.new("http://guest:guest@localhost:55672")
    @vhost = '/'
    @rabbit.add_vhost(@vhost)
    @rabbit.delete_queue("test_queue", :vhost => @vhost)
    @rabbit.delete_user("testuser")
  end

  after do
    @rabbit.delete_queue("test_queue", :vhost => @vhost)
  end

  it "should create a queue" do
    queue = @rabbit.get_queue("test_queue", :vhost => @vhost)
    queue.should be_nil    
    @rabbit.add_queue("test_queue", :vhost => @vhost)
    queue = @rabbit.get_queue("test_queue", :vhost => @vhost)
    queue['name'].should eql("test_queue")
    @rabbit.delete_queue('test_queue', :vhost => @vhost)
  end

  it "should create a user" do
    user = @rabbit.get_user("testuser")
    user.should be_nil
    @rabbit.add_user("testuser", "testpass")
    user = @rabbit.get_user("testuser")
    user.should_not be_nil
  end


  it "should create a permission" do
    permissions = {
        'scope' => 'client',
        'configure' => '.*',
        'write' => '.*',
        'read' =>'.*'
    }
    @rabbit.add_user("testuser", "testpass")
    @rabbit.add_queue("test_queue", :vhost => @vhost)
    @rabbit.add_permission("testuser", permissions, :vhost => @vhost)

    perms = @rabbit.get_permissions("testuser", :vhost => @vhost)
    perms['user'].should == "testuser"
  end
end