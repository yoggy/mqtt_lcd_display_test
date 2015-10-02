-- load configuration
require("config")
require("lcd_aqm0802a")

lcd_setup()
lcd_print("MQTT LCDDisplay")

tmr.delay(2000 * 1000)

-- wifi
print("connect to ssid=" .. wifi_ssid);

wifi.setmode(wifi.STATION)
wifi.sta.config(wifi_ssid, wifi_pass)

for i = 1, 10 do
  lcd_print("connecting.      ");
  tmr.delay(1000 * 1000)
  if wifi.sta.status() == 5 then
    break
  end
  print(i);
  if i == 20 then
    print("wifi connecting failed...rebooting");
    node.restart();
    tmr.delay(5000 * 1000)
  end
  
  print("wifi connection waiting...");
  lcd_print("connecting      ");
  tmr.delay(1000 * 1000)
end

print("wifi connected!");
print(wifi.sta.getip());

-- MQTT subscribe
-- see also... http://www.nodemcu.com/docs/mqtt-module/
m = mqtt.Client(mqtt_client_id, 60, mqtt_username, mqtt_password)

m:on("message", function(conn, topic, data) 
  lcd_print(data)
  if data ~= nil then
    print(topic .. ":" .. data)
  end
end)

m:on("offline", function(con)
    print ("offline...")
end)

print("mqtt:connect() start")
lcd_print("                ");

-- m:connect(host, port, is_secure, auto_reconnect, function(conn))
m:connect(mqtt_host, mqtt_port, 0, 1, function(conn)
  print("connected!") 
  m:subscribe(mqtt_subscribe_topic, 0, function(conn)
  end)
end)
