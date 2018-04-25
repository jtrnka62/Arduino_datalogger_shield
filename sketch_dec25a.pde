#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
#include <Time.h>   
#include <DS1307RTC.h>  // a basic DS1307 library that returns time as a time_t
#include <SD.h>

LiquidCrystal_I2C lcd(0x20,16,2);  // set the LCD address to 0x20 for a 16 chars and 2 line display
const int ledPin = 5;        // Backlight connected to digital pin 5
const int contrastPin = 9;  // LCD contrast to digital pin 9
const int buttonpin = 0;  // input pin for the keyboard
const int sd_cs = 8;  // cs pin for microSD card
File myFile;
int val;

void setup()
{
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);   // sets the pin as output
  pinMode(contrastPin, OUTPUT);   // sets the pin as output
  
  analogWrite(ledPin, 255); // (0=0%, 255=100%)
  analogWrite(contrastPin, 30); // (255=0%, 0=100%)
  

  // TESTE do LCD 
  lcd.init();   // initialize the lcd 
  lcd.print("LCD Display TEST");    // Print a message to the LCD.
  Serial.println("LCD Display TEST");    // Print a message to the serial.
  lcd.setCursor(0, 1); // second line, position 0 
  lcd.print("0123456789012345");
  delay(4000);

  
  // TEST do backlight
  lcd.clear();
  lcd.home();
  lcd.print("Backlight fade");
  Serial.println("Backlight fade TEST");    // Print a message to the serial.
  lcd.setCursor(6, 1);
  lcd.print("TEST");
  
  for(int fadeValue = 255; fadeValue >= 0; fadeValue--) {   // fade out from max to min in increments of 1 point:  
    analogWrite(ledPin, fadeValue); // sets the value (range from 0 to 255):
    delay(20); // wait for 20 milliseconds to see the dimming effect
  }
  delay(500);
  analogWrite(ledPin, 255); // sets the value (range from 0 to 255):


  // TESTE do contraste
  lcd.clear();
  lcd.home();
  lcd.print("Contrast fade");
  Serial.println("Contrast fade TEST");    // Print a message to the serial.
  lcd.setCursor(6, 1);
  lcd.print("TEST");
  
  for(int fadeValue = 0; fadeValue <= 100; fadeValue++) {   // fade out from max to min in increments of 1 point:  
    analogWrite(contrastPin, fadeValue); // sets the value (range from 0 to 255):
    delay(50); // wait for 50 milliseconds to see the contrast effect
  }
  delay(500);
  analogWrite(contrastPin, 30); // sets the value (range from 0 to 255):


  // TESTE do cartao SD
  lcd.clear();
  lcd.home();
  lcd.print("Init SD card...");
  Serial.print("Init SD card... ");
  // On the Shield, CS is pin 3. It's set as an output by default.
  // Note that even if it's not used as the CS pin, the hardware SS pin 
  // (10 on most Arduino boards, 53 on the Mega) must be left as an output 
  // or the SD library functions will not work. 
   pinMode(10, OUTPUT);
   lcd.setCursor(0, 1); // second line, position 0

  if (!SD.begin(sd_cs)) {
    lcd.print("init SD failed!");
    Serial.println(" FAILED!");
    delay(2000);
    return;
  }
  lcd.print("init SD OK");
  Serial.println(" OK");
  delay(2000);

  // open the file. note that only one file can be open at a time,
  // so you have to close this one before opening another.
  myFile = SD.open("test.txt", FILE_WRITE);
  
  // if the file opened okay, write to it:
  lcd.clear();
  lcd.home();
  if (myFile) {
    lcd.print("Writing test.txt");
    Serial.print("Writing test.txt ");
    myFile.println("SD Testes OK");
	// close the file:
    myFile.close();
    lcd.setCursor(0, 1); // second line, position 0
    lcd.print("Written OK");
    Serial.println(" OK");
    delay(2000);
  } else {
    // if the file didn't open, print an error:
    lcd.print("ERR I/O test.txt");
    Serial.println("ERR I/O writing test.txt");
    return;
  }


  // Keyboard TEST
  // SEL button TEST
  lcd.clear();
  lcd.home();
  lcd.print("Keyboard TEST");
  Serial.println("Keyboard TEST");
  lcd.setCursor(0, 1);
  lcd.print("Press SEL");
  Serial.print("Press SEL... "); 
  do {
   val = analogRead(buttonpin);   // read the input pin
   if( val < 1000 ) {  // 0
      delay(20); // debounce
      val = analogRead(buttonpin);   // read the input pin, pull-up 2K2
      lcd.setCursor(10, 1);
      if( val < 10) {
        lcd.println("OK SEL");
        Serial.println(" OK SEL");
      }
      else
      {
        lcd.print("FAILED");
        Serial.println(" FAILED!");
        return;
      }
      delay(1000);
   }   
  }  while (val > 1000);


  //LEFT button TEST
  lcd.clear();
  lcd.home();
  lcd.print("Keyboard TEST");
  lcd.setCursor(0, 1);
  lcd.print("Press LFT");
  Serial.print("Press LEFT... ");
  do {
   val = analogRead(buttonpin);   // read the input pin
   if( val < 1000 ) {  // 0
      delay(20); // debounce
      val = analogRead(buttonpin);   // read the input pin
      lcd.setCursor(10, 1);
      if( val >= (133-7) and val <= (133+7)) {  // 133 +-5% resistor 330 Ohms
        lcd.print("OK LEFT");
        Serial.println("OK LEFT");
      }
      else
      {
        lcd.print("FAILED");
        Serial.println(" FAILED!");
        return;
      }
      delay(1000);
   }  
  } while (val > 1000);

  //DOWN button TEST 
  lcd.clear();
  lcd.home();
  lcd.print("Keyboard TEST");
  lcd.setCursor(0, 1);
  lcd.print("Press DWN");
  Serial.print("Press DOWN... ");
  do {
   val = analogRead(buttonpin);   // read the input pin
   if( val < 1000 ) {  // 0
      delay(20); // debounce
      val = analogRead(buttonpin);   // read the input pin
      lcd.setCursor(10, 1);
      if( val >= (295-15) and val <= (295+15)) {  // 295 +-5% resistor 560 Ohms
        lcd.print("OK DWN");
        Serial.println("OK DOWN");
      }
      else
      {
        lcd.print("FAILED");
        Serial.println(" FAILED!");
        return;
      }
      delay(1000);
   }  
  } while (val > 1000);

  //UP button TEST 
  lcd.clear();
  lcd.home();
  lcd.print("Keyboard TEST");
  lcd.setCursor(0, 1);
  lcd.print("Press UP");
  Serial.print("Press UP... ");
  do {
   val = analogRead(buttonpin);   // read the input pin
   if( val < 1000 ) {  // 0
      delay(20); // debounce
      val = analogRead(buttonpin);   // read the input pin
      lcd.setCursor(10, 1);
      if( val >= (473-24) and val <= (473+24)) {  // 473 +-5% resistor 1K Ohms
        lcd.print("OK UP");
        Serial.println("OK UP");
      }
      else
      {
        lcd.print("FAILED");
        Serial.println(" FAILED!");
        return;
      }
      delay(1000);
   }  
  } while (val > 1000);


  //RIGHT button TEST
  lcd.clear();
  lcd.home();
  lcd.print("Keyboard TEST");
  lcd.setCursor(0, 1);
  lcd.print("Press RGT");
  Serial.print("Press RIGHT... ");
  do {
   val = analogRead(buttonpin);   // read the input pin
   if( val < 1000 ) {  // 0
      delay(20); // debounce
      val = analogRead(buttonpin);   // read the input pin
      lcd.setCursor(10, 1);
      if( val >= (718-36) and val <= (718+36)) {  // 718 +-5% resistor 3.3K Ohms
        lcd.print("OK RGT");
        Serial.println("OK RIGHT");
      }
      else
      {
        lcd.print("FAILED");
        Serial.println(" FAILED!");
        return;
      }
      delay(1000);
   }  
  } while (val > 1000);

  
  // RTC TEST
  lcd.clear();
  lcd.home();
  lcd.print("RT Clock TEST");
  Serial.print("RT Clock TEST... ");
  lcd.setCursor(0, 1);
  delay(500);
  setSyncProvider(RTC.get);   // the function to get the time from the RTC
  if(timeStatus()!= timeSet) {
     lcd.print("RTC FAILED");
     Serial.println(" FAILED!");
     return;
  }
  else
  {
    int i = 0;
    lcd.clear();
    do {
      i++;
      digitalClockDisplay();
      delay(1000);
    } while (i < 6);
    lcd.clear();
    lcd.home();
    lcd.setCursor(0, 1);
    lcd.print("RTC OK");
    Serial.println(" OK");
  }
  delay(2000);

  // END of TESTS
  lcd.clear();
  lcd.home();
  lcd.print("  TESTS PASSED  ");
  Serial.println("TESTS PASSED");
  
}

void loop()
{
  if(Serial.available())
  {
     time_t t = processSyncMessage();
     if(t >0)
     {
        RTC.set(t);   // set the RTC and the system time to the received value
        setTime(t);          
     }
  }

  for(int fadeValue = 255; fadeValue >= 20; fadeValue--) {   // fade out from max to min in increments of 1 point:  
    analogWrite(ledPin, fadeValue); // sets the value (range from 0 to 255):
    delay(5); // wait for 20 milliseconds to see the dimming effect
  }
  for(int fadeValue = 20; fadeValue <= 255; fadeValue++) {   // fade out from max to min in increments of 1 point:  
    analogWrite(ledPin, fadeValue); // sets the value (range from 0 to 255):
    delay(5); // wait for 20 milliseconds to see the dimming effect
  }
}

// ************* Display date / time on LCD display *************
void digitalClockDisplay()
{
  // digital clock display of the date and time
  lcd.setCursor(1, 0);  //line=1 (0 is the first line), x=1
  printDayOfWeek(weekday());
  lcd.print(" ");
  printDigits(day());
  lcd.print("/");
  printDigits(month());
  lcd.print("/");
  printDigits(year());
  lcd.setCursor(4, 1);  //line=2 (1 is the second line), x=3
  printDigits(hour());
  lcd.print(":");
  printDigits(minute());
  lcd.print(":");
  printDigits(second());
}

// ************* Print on the LCD the day corresponding to the day number of the RTC *************
void printDayOfWeek(int dayOfWeek)
{
  switch(dayOfWeek){
  case 1:
    lcd.print("Sun");
    break;
  case 2:
    lcd.print("Mon");
    break;
  case 3:
    lcd.print("Tue");
    break;
  case 4:
    lcd.print("Wed");
    break;
  case 5:
    lcd.print("Thu");
    break;
  case 6:
    lcd.print("Fri");
    break;
  case 7:
    lcd.print("Sat");
    break;
  }
}

// ************* Utility function for digital clock/date display: prints leading 0 *************
void printDigits(int digits)
{
  if(digits < 10)
    lcd.print('0');
  lcd.print(digits);
}

/*  code to process time sync messages from the serial port   */
#define TIME_MSG_LEN  11   // time sync to PC is HEADER followed by unix time_t as ten ascii digits
#define TIME_HEADER  'T'   // Header tag for serial time sync message

time_t processSyncMessage() {
  // return the time if a valid sync message is received on the serial port.
  while(Serial.available() >=  TIME_MSG_LEN ){  // time message consists of a header and ten ascii digits
    char c = Serial.read() ; 
    Serial.print(c);  
    if( c == TIME_HEADER ) {       
      time_t pctime = 0;
      for(int i=0; i < TIME_MSG_LEN -1; i++){   
        c = Serial.read();          
        if( c >= '0' && c <= '9'){   
          pctime = (10 * pctime) + (c - '0') ; // convert digits to a number    
        }
      }   
      return pctime; 
    }  
  }
  return 0;
}
