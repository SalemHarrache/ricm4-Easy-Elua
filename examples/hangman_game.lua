-- Hangman in eLua using the 'term' module
-- by Bogdan Marinescu, www.eluaproject.net
-- Inspired by the original 'hangman' from the bsdgames package

-- we need a random function
-- using math.random for now, which implies target=lua, not lualong
require("arduino_wrapper")

Hangman = Class:new(App)

function Hangman:hang()
    if self.tries == 0 then
        -- Build the basic structure
        term.print( 5, 1, string.rep( '_', 6 ) )
        term.print( 5, 2, '|    |')
        for i = 3, 6 do
            term.print( 5, i, '|' )
        end
        term.print( 3, 7, '__|_____')
        term.print( 3, 8, '|      |___')
        term.print( 3, 9, '|__________|')

    elseif self.tries == 1 then
        -- Draw the head
        term.print( 10, 3, "O" )

    elseif self.tries == 2 or self.tries == 3 then
        -- First or second part of body
        term.print( 10, self.tries + 2, "|" )

    elseif self.tries == 4 or self.tries == 5 then
        -- First leg / first hand
        term.print( 9, self.tries == 4 and 6 or 4, "/" )

    elseif self.tries == 6 or self.tries == 7 then
        -- Second hand / second leg
        term.print( 11, self.tries == 7 and 6 or 4, "\\" )
    end
end

function Hangman:stats()
  term.print( self.w - 20, 5, "Total words: ", tostring( self.total ) )
  term.print( self.w - 20, 6, "Guessed words: ", tostring( self.guessed ) )
end


function Hangman:setup()
    self.h, self.w = term.getlines(), term.getcols()
    self.tries = 0
    self.words = { "simple", "hangman", "easy", "elua", "software" }
    self.total = 0
    self.guessed = 0
    pinMode(GREEN_LED, OUTPUT)
    pinMode(RED_LED, OUTPUT)
    pinMode(ORANGE_LED, OUTPUT)
end

function Hangman:condition()
    return true
end

function Hangman:blink(led)
    digitalWrite(led, HIGH)
    delay(100)
    digitalWrite(led, LOW)
end

function Hangman:exit()
    term.clrscr()
    term.moveto( 1 , 1 )
    self.terminated = true
end

function Hangman:loop()
    term.clrscr()
    term.print( 3, 12, "easy-eLua hangman" )
    term.print( 3, 13, "ESC to exit" )
    self:stats()

    -- Draw the hanging site
    self.tries = 0
    self:hang()

    -- Then write the "Guess" line
    term.print( 2, self.h - 3, "Word: " )
    local lword = self.words[ math.random( #self.words ) ]:lower()
    term.print( string.rep( "-", #lword ) )
    term.print( 2, self.h - 2, "Guess: " )

    local nguess = 0
    local tried = {}
    local key
    while self.tries < 7 and nguess < #lword do
        key = term.getchar()
        if key == term.KC_ESC then
            return self:exit()
        end
        if key > 0 and key < 255 then
            key = string.char( key ):lower()
            term.moveto( 2, self.h - 1 )
            term.clreol()
            if not key:find( '%l' ) then
                self:blink( RED_LED )
                term.print( "Invalid character" )
            else
                key = key:byte()
                if tried[ key ] ~= nil then
                    self:blink( ORANGE_LED )
                    term.print( "Already tried this key" )
                else
                    tried[ key ] = true
                    local i
                    local ok = false
                    for i = 1, #lword do
                        if key == lword:byte( i ) then
                          ok = true
                          self:blink( GREEN_LED )
                          term.print( 7 + i, self.h - 3, string.char( key ) )
                          nguess = nguess + 1
                        end
                    end
                    if not ok then
                        self:blink( RED_LED )
                        self.tries = self.tries + 1
                        self:hang()
                    end
                end
            end
            term.moveto( 9, self.h - 2 )
        end
    end

    term.moveto( 2, self.h - 1 )
    self.total = self.total + 1
    if nguess == #lword then
        term.print( "Congratulations! Another game? (y/n)" )
        self.guessed = self.guessed + 1
    else
        term.print( 8, self.h - 3, lword )
        term.print( 2, self.h - 1, "Game over. Another game? (y/n)" )
    end

    -- Show statistics again
    self:stats()

    repeat
        key = string.char( term.getchar() ):lower()
    until key == 'y' or key == 'n'

    if key == 'n' then
        return self:exit()
    end
end


app = Hangman:new("easy-eLua hangman")
app:run()

