#!/usr/bin/ruby
#
# mqtt_lcd_clock_pub.rb - publish the local time using the MQTT.
#
#   $ sudo gem install mqtt
#   $ sudo gem install pit
#
require 'rubygems'
require 'mqtt'
require 'pit'

$config = Pit.get("mqtt_lcd_clock_pub", :require => {
  "remote_host" => "mqtt.example.com",
  "remote_port" => 1883,
  "use_auth"    => false,
  "username"    => "username",
  "password"    => "password",
  "topic"       => "topic",
})

$conn_opts = {
  remote_host: $config["remote_host"],
  remote_port: $config["remote_port"].to_i,
}
if $config["use_auth"] == true
  $conn_opts["username"] = $config["username"]
  $conn_opts["password"] = $config["password"]
end


$old_t = Time.now
$now_t = Time.now

def publish(c, t)
  str = t.strftime("%m/%d%a%H:%M:%S").downcase
  puts "topic=" + $config["topic"] + ", message=" + str
  c.publish($config["topic"], str)
end

MQTT::Client.connect($conn_opts) do |c|
   puts "connected!"

   loop do
     $now_t = Time.now
     diff = $now_t.to_f - $old_t.to_f
     if diff > 1.0
       publish(c, $now_t)
       $old_t = $now_t
     end
     sleep 0.1
   end
end


