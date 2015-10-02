--
-- lcd_aqm0802a.lua
--
-- how to use
--
--    lcd_setup()
--    lcd_print("ABCDEFGH01234567")
--

-- https://github.com/nodemcu/nodemcu-firmware/wiki/nodemcu_api_en#new_gpio_map
i2c_scl = 2  -- IO4
i2c_sda = 1  -- IO5

-- AQM0802A  - http://akizukidenshi.com/catalog/g/gP-06669/
i2c_dev_addr = 0x3e

i2c_id = 0
i2c.setup(i2c_id, i2c_sda, i2c_scl, i2c.SLOW)

function lcd_data(c, d)
    i2c.start(i2c_id)
    i2c.address(i2c_id, i2c_dev_addr , i2c.TRANSMITTER)
    i2c.write(i2c_id, c)
    i2c.write(i2c_id, d)
    i2c.stop(i2c_id)
end

function lcd_cmd(d)
    lcd_data(0x00, d);
end

function lcd_char(d)
    lcd_data(0x40, d);
end

function lcd_setup()
    -- http://maicommon.ciao.jp/ss/Arduino_g/LCD_I2C/index.htm
    lcd_cmd(0x38) 
    lcd_cmd(0x39) 
    lcd_cmd(0x14) 
    lcd_cmd(0x70) 
    lcd_cmd(0x56) 
    lcd_cmd(0x6c) 

    lcd_cmd(0x38) 
    lcd_cmd(0x0c) 
    
    lcd_clear()
end

function lcd_clear() 
    lcd_cmd(0x01)
end

function lcd_move_cursor(x, y)
    if y == 0 then
        lcd_cmd(0x80 + x)
    elseif y == 1 then
        lcd_cmd(0xc0 + x)
    end
end

function lcd_print(str)
    lcd_move_cursor(0, 0)

    if str == nil then
        lcd_clear();
        return
    end

    if string.len(str) == 0 then
        lcd_clear();
        return
    end
    
    for i = 1, string.len(str) do
        lcd_char(str:byte(i))
        if i == 8 then
            lcd_move_cursor(0, 1)
        end
    end
end
