-- eLua examples
-- Control LED intensity with PWM

local pwmid, tmrid, ledpin
if pd.board() == 'STM32F4DSCY' then
  pwmid = 1 
  tmrid = 2  
  pwm.setclock( pwmid, 25000000 )
else
  print( pd.board() .. " not supported by this example" )
  return
end

print "Control LED with PWM (fade up/down)"
print "Press any key to exit"

local crtduty, incr = 10, 5
tmr.start( tmrid )
pwm.setup( pwmid, 50000, crtduty )
pwm.start( pwmid )

while uart.getchar( 0, 0 ) == "" do
  if crtduty == 95 or crtduty == 5 then
    incr = -incr
  end
  crtduty = crtduty + incr
  pwm.setup( pwmid, 50000, crtduty )  
  tmr.delay( tmrid, 50000 )  
end

pwm.stop( pwmid )
