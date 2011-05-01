require 'rest_client'
require 'json'
class RabbitManager

  def initialize(uri)
    @uri = uri
  end

  def add_vhost(vh)
    RestClient.put "#{@uri}/api/vhosts/#{CGI.escape(vh)}", nil, :content_type => :json, :accept => :json
  end

  def delete_vhost(vh)
    RestClient.delete "#{@uri}/api/vhosts/#{CGI.escape(vh)}"
  end

  def add_queue(queue_name, options = {})
    options = default_options.merge(options)
    RestClient.put "#{@uri}/api/queues/#{CGI.escape(options[:vhost])}/#{queue_name}", {"type"=> options[:type],"auto_delete" => options[:auto_delete], "durable" =>options[:durable], "arguments" => options[:arguments]}.to_json, :content_type => :json, :accept => :json
  end

  def get_queue(queue_name, options = {})
    options[:vhost] ||= '/'
    begin
      JSON.parse(RestClient.get "#{@uri}/api/queues/#{CGI.escape(options[:vhost])}/#{queue_name}")
    rescue
      nil
    end
  end

  def delete_queue(queue_name, options = {})
    options[:vhost] ||= '/'
    begin
      RestClient.delete "#{@uri}/api/queues/#{CGI.escape(options[:vhost])}/#{queue_name}"
    rescue
      nil
    end
  end

  def add_exchange(name, options = {})
    options = default_options.merge(options)
    RestClient.put "#{@uri}/api/exchanges/#{CGI.escape(options[:vhost])}/#{name}", {"type" => options[:type], "auto_delete" => options[:auto_delete], "durable" => options[:durable], "internal" => options[:internal], "arguments" => options[:arguments]}.to_json, :content_type => :json, :accept => :json
  end

  def delete_exchange(name, options = {})
    options[:vhost] ||= '/'
    RestClient.delete "#{@uri}/api/exchanges/#{CGI.escape(options[:vhost])}/#{name}"
  end

  def add_binding(exchange, queue, options = {})
    options = default_options.merge(options)
    url = "#{@uri}/api/bindings/#{CGI.escape(options[:vhost])}/e/#{exchange}/q/#{queue}"
    RestClient.post url, {'routing_key' => options[:key], "arguments" => options[:arguments] }.to_json, :content_type => :json
  end


  def add_user(username, password, options = {})
    options[:administrator] ||= false
    RestClient.put "#{@uri}/api/users/#{username}", {"password" => password, "administrator" =>options[:administrator]}.to_json, :content_type => :json, :accept => :json
  end


  def get_user(username)
    begin
      JSON.parse(RestClient.get "#{@uri}/api/users/#{username}")
    rescue
      nil
    end
  end

  def delete_user(username)
    begin
      RestClient.delete "#{@uri}/api/users/#{username}"
    rescue
      nil
    end
  end

  def add_permission(username, permissions, options = {})
    options[:vhost] ||= '/'
    RestClient.put "#{@uri}/api/permissions/#{CGI.escape(options[:vhost])}/#{username}", permissions.to_json, :content_type => :json, :accept => :json
  end

  def get_permissions(username, options = {})
    options[:vhost] ||= '/'
    begin
      JSON.parse(RestClient.get "#{@uri}/api/permissions/#{CGI.escape(options[:vhost])}/#{username}")
    rescue
      nil
    end
  end

  def default_options
    options = {}
    options[:vhost] = '/'
    options[:auto_delete] = false
    options[:durable] = true
    options[:arguments] = []
    options[:internal] = false
    options
  end

end
