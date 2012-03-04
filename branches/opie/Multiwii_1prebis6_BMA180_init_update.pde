/*
MultiWiiCopter by Alexandre Dubus
radio-commande.com
December 2010     V1.prebis6
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 any later version. see <http://www.gnu.org/licenses/>
*/

/*******************************/
/****CONFIGURABLE PARAMETERS****/
/*******************************/

/* Set the minimum throttle command sent to the ESC (Electronic Speed Controller) */
/* This is the minimum value that allow motors to run at a idle speed  */
//#define MINTHROTTLE 1300 // for Turnigy Plush ESCs 10A
#define MINTHROTTLE 1120 // for Super Simple ESCs 10A

/* The type of multicopter */
//#define GIMBAL
//#define BI //experimental
//#define TRI
#define QUADP
//#define QUADX
//#define Y6
//#define HEX6
//#define FLYING_WING //experimental

#define YAW_DIRECTION 1 // if you want to reverse the yaw correction direction
//#define YAW_DIRECTION -1

#define I2C_SPEED 100000L     //100kHz normal mode, this value must be used for a genuine WMP
//#define I2C_SPEED 400000L   //400kHz fast mode, it works only with some WMP clones

#define PROMINI  //Arduino type
//#define MEGA

//****** advanced users settings   *************

//enable internal I2C pull ups
#define INTERNAL_I2C_PULLUPS

/* The following lines apply only for a pitch/roll tilt stabilization system */
/* It is not compatible with Y6 or HEX6 */
/* Uncomment the first line to activate it */
//#define SERVO_TILT
#define TILT_PITCH_MIN    1020    //servo travel min, don't set it below 1020
#define TILT_PITCH_MAX    2000    //servo travel max, max value=2000
#define TILT_PITCH_MIDDLE 1500    //servo neutral value
#define TILT_PITCH_PROP   10      //servo proportional (tied to angle) ; can be negative to invert movement
#define TILT_ROLL_MIN     1020
#define TILT_ROLL_MAX     2000
#define TILT_ROLL_MIDDLE  1500
#define TILT_ROLL_PROP    10

/* I2C accelerometer */
//#define ADXL345
//#define BMA020
//#define BMA180
/* I2C barometer */
//#define BMP085

/* ADC accelerometer */ // for 5DOF from sparkfun, uses analog PIN A1/A2/A3
//#define ADCACC

/* The following lines apply only for specific receiver with only one PPM sum signal, on digital PIN 2 */
/* IF YOUR RECEIVER IS NOT CONCERNED, DON'T UNCOMMENT ANYTHING. Note this is mandatory for a Y6 setup */
/* Select the right line depending on your radio brand. Feel free to modify the order in your PPM order is different */
//#define SERIAL_SUM_PPM         PITCH,YAW,THROTTLE,ROLL,AUX1 //For Graupner/Spektrum
//#define SERIAL_SUM_PPM         ROLL,PITCH,THROTTLE,YAW,AUX1 //For Robe/Hitec/Futaba

/* interleaving delay in micro seconds between 2 readings WMP/NK in a WMP+NK config */
/* if the ACC calibration time is very long (20 or 30s), try to increase this delay up to 4000 */
#define INTERLEAVING_DELAY 3000

//for V BAT monitoring
//after the resistor divisor we should get [0V;5V]->[0;[1023] on analog V_BATPIN
//the code is implemented but not yet adjusted to empirical V levels
#define VBATLEVEL1_3S 1000
#define VBATLEVEL2_3S 800
#define VBATLEVEL3_3S 700

/* when there is an error on I2C bus, we neutralize the values during a short time. expressed in microseconds */
#define NEUTRALIZE_DELAY 100000

/* this is the value for the ESCs when thay are not armed */
/* in some case, this value must be lowered down to 900 for some specific ESCs */
#define MINCOMMAND 1000

/* this is the maximum value for the ESCs at full power */
/* this value can be increased up to 2000 */
#define MAXTHROTTLE 1850

/* This is the speed of the serial interface. 115200 kbit/s is the best option for a USB connection.*/
#define SERIAL_COM_SPEED 115200

/* In order to save space, it's possibile to desactivate the LCD configuration functions */
/* comment this line only if you don't plan to used a LCD */
#define LCD_CONF

/* motors will not spin when the throttle command is in low position */
/* this is an alternative method to stop immediately the motors */
//#define MOTOR_STOP

/* force the autolevel activation */
/* usefull for a 4 channels only setup */
//#define FORCE_LEVEL

//****** end of advanced users settings *************

/**************************************/
/****END OF CONFIGURABLE PARAMETERS****/
/**************************************/

#include <EEPROM.h>

#define LEDPIN 13
#define POWERPIN 12
#define V_BATPIN 3    //Analog PIN 3


#if defined(PROMINI)
  #define LEDPIN_PINMODE             pinMode (13, OUTPUT);
  #define LEDPIN_SWITCH              PINB |= 1<<5;     //switch LEDPIN state (digital PIN 13)
  #define LEDPIN_OFF                 PORTB &= ~(1<<5);
  #define LEDPIN_ON                  PORTB |= (1<<5);
  #define BUZZERPIN_PINMODE          pinMode (8, OUTPUT);
  #define BUZZERPIN_ON               PORTB |= 1;
  #define BUZZERPIN_OFF              PORTB &= ~1;
  #define POWERPIN_PINMODE           pinMode (12, OUTPUT);
  #define POWERPIN_ON                PORTB |= 1<<4;
  #define POWERPIN_OFF               PORTB &= ~(1<<4);
  #define I2C_PULLUPS_ENABLE         PORTC |= 1<<4; PORTC |= 1<<5;   // PIN A4&A5 (SDA&SCL)
  #define I2C_PULLUPS_DISABLE        PORTC &= ~(1<<4); PORTC &= ~(1<<5);
  #define PINMODE_LCD                pinMode(0, OUTPUT);
  #define LCDPIN_OFF                 PORTD &= ~1;
  #define LCDPIN_ON                  PORTD |= 1;
  #define DIGITAL_SERVO_TRI_PINMODE  pinMode(3,OUTPUT);
  #define DIGITAL_SERVO_TRI_HIGH     PORTD |= 1<<3;
  #define DIGITAL_SERVO_TRI_LOW      PORTD &= ~(1<<3);
  #define DIGITAL_TILT_PITCH_PINMODE pinMode(A0,OUTPUT);
  #define DIGITAL_TILT_PITCH_HIGH    PORTC |= 1<<0;
  #define DIGITAL_TILT_PITCH_LOW     PORTC &= ~(1<<0);
  #define DIGITAL_TILT_ROLL_PINMODE  pinMode(A1,OUTPUT);
  #define DIGITAL_TILT_ROLL_HIGH     PORTC |= 1<<1;
  #define DIGITAL_TILT_ROLL_LOW      PORTC &= ~(1<<1);
  #define DIGITAL_BI_REAR_HIGH       PORTB |= 1<<3; //digital PIN 11
  #define DIGITAL_BI_REAR_LOW        PORTB &= ~(1<<3);
  #define PPM_PIN_INTERRUPT          attachInterrupt(0, rxInt, RISING); //PIN 0
  #define MOTOR_ORDER                9,10,11,3,6,5  //for a quad+: rear,right,left,front
#endif
#if defined(MEGA)
  #define LEDPIN_PINMODE             pinMode (13, OUTPUT);
  #define LEDPIN_SWITCH              PINB |= (1<<7);
  #define LEDPIN_OFF                 PORTB &= ~(1<<7);
  #define LEDPIN_ON                  PORTB |= (1<<7);
  #define BUZZERPIN_PINMODE          pinMode (31, OUTPUT);
  #define BUZZERPIN_ON               PORTC |= 1<<6;
  #define BUZZERPIN_OFF              PORTC &= ~1<<6;
  #define POWERPIN_PINMODE           pinMode (12, OUTPUT);
  #define POWERPIN_ON                PORTB |= 1<<6;
  #define POWERPIN_OFF               PORTB &= ~(1<<6);
  #define I2C_PULLUPS_ENABLE         PORTD |= 1<<0; PORTD |= 1<<1;       // PIN 20&21 (SDA&SCL)
  #define I2C_PULLUPS_DISABLE        PORTD &= ~(1<<0); PORTD &= ~(1<<1);
  #define PINMODE_LCD                pinMode(0, OUTPUT);
  #define LCDPIN_OFF                 PORTE &= ~1;      //switch OFF digital PIN 0
  #define LCDPIN_ON                  PORTE |= 1;       //switch OFF digital PIN 0
  #define DIGITAL_SERVO_TRI_PINMODE  pinMode(2,OUTPUT); //PIN 2
  #define DIGITAL_SERVO_TRI_HIGH     PORTE |= 1<<4;
  #define DIGITAL_SERVO_TRI_LOW      PORTE &= ~(1<<4);
  #define DIGITAL_TILT_PITCH_PINMODE pinMode(A0,OUTPUT);
  #define DIGITAL_TILT_PITCH_HIGH    PORTF |= 1<<0;
  #define DIGITAL_TILT_PITCH_LOW     PORTF &= ~(1<<0);
  #define DIGITAL_TILT_ROLL_PINMODE  pinMode(A1,OUTPUT);
  #define DIGITAL_TILT_ROLL_HIGH     PORTF |= 1<<1;
  #define DIGITAL_TILT_ROLL_LOW      PORTF &= ~(1<<1);
  #define DIGITAL_BI_REAR_HIGH       PORTB |= 1<<3;    //digital PIN 11 wrong
  #define DIGITAL_BI_REAR_LOW        PORTB &= ~(1<<3); //wrong
  #define PPM_PIN_INTERRUPT          attachInterrupt(4, rxInt, RISING);  //PIN 19
  #define MOTOR_ORDER                3,5,6,2,7,8   //for a quad+: rear,right,left,front   //+ for y6: 7:under right  8:under left
#endif


#if defined(GIMBAL) || defined(FLYING_WING)
  #define NUMBER_MOTOR 0
#elif defined(BI)
  #define NUMBER_MOTOR 2
#elif defined(TRI)
  #define NUMBER_MOTOR 3
#elif defined(QUADP) || defined(QUADX)
  #define NUMBER_MOTOR 4
#elif defined(Y6) || defined(HEX6)
  #define NUMBER_MOTOR 6
#endif

/*********** RC alias *****************/
#define ROLL 0
#define PITCH 1
#define YAW 2
#define THROTTLE 3
#define AUX1 4

static uint32_t previousTime;
static uint32_t neutralizeTime;
static uint32_t rcTime;
static uint32_t currentTime;
static uint8_t nunchukPresent = 0;
static uint8_t levelModeParam = 0;  //if level mode is a activated on the radio : channel 5 value superior to 1700
static uint16_t cycleTime;          // this is the number in micro second to achieve a full loop, it can differ a little and is taken into account in the PID loop
static uint16_t meanTime = 2000;    // this is the average time of the loop: around 2ms for a WMP config and 6ms for a NK+WMP config
// to be more precise, the calibration is now done is the main loop. Calibrating decreases at each cycle up to 0, then we enter in a normal mode.
// we separate the calibration of ACC and gyro, because number of measure is not always equal.
static uint16_t calibratingA;
static uint16_t calibratingG;
static uint8_t armed = 0;
static int16_t acc_1G = 200;       //this is the 1G measured acceleration (nunchuk)
static int16_t acc_25deg = 85;     //this is the the ACC value measured on x or y axis for a 25deg inclination (nunchuk) = acc_1G * sin(25)
static uint8_t accPresent = 0;
static uint8_t barometerPresent = 0;
static int16_t accADC[3];
static int16_t altitudeSmooth = 0;

// *********************
// I2C general functions
// *********************

// Mask prescaler bits : only 5 bits of TWSR defines the status of each I2C request
#define TW_STATUS_MASK	(1<<TWS7) | (1<<TWS6) | (1<<TWS5) | (1<<TWS4) | (1<<TWS3)
#define TW_STATUS       (TWSR & TW_STATUS_MASK)

void i2c_init(void) {
  #if defined(INTERNAL_I2C_PULLUPS)
    I2C_PULLUPS_ENABLE
  #else
    I2C_PULLUPS_DISABLE
  #endif
  TWSR = 0;        // no prescaler => prescaler = 1
  TWBR = ((16000000L / I2C_SPEED) - 16) / 2; // change the I2C clock rate
  TWCR = 1<<TWEN;  // enable twi module, no interrupt
}

void i2c_rep_start(uint8_t address) {
  TWCR = (1<<TWINT) | (1<<TWSTA) | (1<<TWEN) | (1<<TWSTO); // send REAPEAT START condition
  waitTransmissionI2C(); // wait until transmission completed
  checkStatusI2C(); // check value of TWI Status Register
  TWDR = address; // send device address
  TWCR = (1<<TWINT) | (1<<TWEN);
  waitTransmissionI2C(); // wail until transmission completed
  checkStatusI2C(); // check value of TWI Status Register
}

void i2c_write(uint8_t data ) {	
  TWDR = data; // send data to the previously addressed device
  TWCR = (1<<TWINT) | (1<<TWEN);
  waitTransmissionI2C(); // wait until transmission completed
  checkStatusI2C(); // check value of TWI Status Register
}

uint8_t i2c_readAck() {
  TWCR = (1<<TWINT) | (1<<TWEN) | (1<<TWEA);
  waitTransmissionI2C();
  return TWDR;
}

uint8_t i2c_readNak(void) {
  TWCR = (1<<TWINT) | (1<<TWEN);
  waitTransmissionI2C();
  return TWDR;
}

void waitTransmissionI2C() {
  uint8_t count = 255;
  while (count-->0 && !(TWCR & (1<<TWINT)) );
  if (count<2) { //we are in a blocking state => we don't insist
    TWCR = 0;  //and we force a reset on TWINT register
    neutralizeTime = micros(); //we take a timestamp here to neutralize the value during a short delay after the hard reset
  }
}

void checkStatusI2C() {
  if ( (TW_STATUS & 0xF8) == 0xF8) { //TW_NO_INFO : this I2C error status indicates a wrong I2C communication.
    // WMP does not respond anymore => we do a hard reset. I did not find another way to solve it. It takes only 13ms to reset and init to WMP or WMP+NK
    TWCR = 0;
    POWERPIN_OFF //switch OFF WMP
    delay(1);  
    POWERPIN_ON  //switch ON WMP
    delay(10);
    i2c_WMP_init(0);
    neutralizeTime = micros(); //we take a timestamp here to neutralize the WMP or WMP+NK values during a short delay (20ms) after the hard reset
  }
}

// **************************
// I2C Barometer BOSCH BMP085
// **************************
// I2C adress: 0xEE (8bit)   0x77 (7bit)
// principle:
//  1) read the calibration register (only once at the initialization)
//  2) read uncompensated temperature (not mandatory at every cycle)
//  3) read uncompensated pressure
//  4) raw temp + raw pressure => calculation of the adjusted pressure
//  the following code uses the maximum precision setting (oversampling setting 3)

// sensor registers from the BOSCH BMP085 datasheet
#if defined(BMP085)
static int16_t ac1,ac2,ac3,b1,b2,mb,mc,md;
static uint16_t  ac4,ac5,ac6;

static uint16_t ut; //uncompensated T
static uint32_t up; //uncompensated P
int32_t temperature = 0;
int32_t pressure = 0;
int16_t altitude = 0;
static int16_t altitudeZero;
static int16_t altitudeHold;

void  i2c_BMP085_init() {
  delay(10);
  ac1 = i2c_BMP085_readIntRegister(0xAA);
  ac2 = i2c_BMP085_readIntRegister(0xAC);
  ac3 = i2c_BMP085_readIntRegister(0xAE);
  ac4 = i2c_BMP085_readIntRegister(0xB0);
  ac5 = i2c_BMP085_readIntRegister(0xB2);
  ac6 = i2c_BMP085_readIntRegister(0xB4);
  b1 = i2c_BMP085_readIntRegister(0xB6);
  b2 = i2c_BMP085_readIntRegister(0xB8);
  mb = i2c_BMP085_readIntRegister(0xBA);
  mc = i2c_BMP085_readIntRegister(0xBC);
  md = i2c_BMP085_readIntRegister(0xBE);
  
  barometerPresent = 1;
  i2c_BMP085_calibrate();
}

// read a 16 bit register
int16_t i2c_BMP085_readIntRegister(unsigned char r) {
  uint8_t msb, lsb;
  
  i2c_rep_start(0xEE + 0);
  i2c_write(r);
  i2c_rep_start(0xEE + 1);//I2C read direction => 1
  msb=i2c_readAck();
  lsb=i2c_readNak();
  return (((int16_t)msb<<8) | ((int16_t)lsb));
}

// read uncompensated temperature value: send command first
void i2c_BMP085_readUT_Command() {
  i2c_rep_start(0xEE + 0);
  i2c_write(0xf4);
  i2c_write(0x2e);
  i2c_rep_start(0xEE + 0);
  i2c_write(0xF6);
}

// read uncompensated temperature value: read result bytes
// the datasheet suggests a delay of 4.5 ms after the send command
uint16_t i2c_BMP085_readUT_Result() {
  uint8_t msb, lsb;
  //delay(5); // the datasheet suggests 4.5 ms
  i2c_rep_start(0xEE + 1);//I2C read direction => 1
  msb=i2c_readAck();
  lsb=i2c_readNak();
  return (((uint16_t)msb<<8) | ((uint16_t)lsb));
}

// read uncompensated pressure value: send command first
void i2c_BMP085_readUP_Command () {
  i2c_rep_start(0xEE + 0);
  i2c_write(0xf4);
  i2c_write(0xf4); //control register value for oversampling setting 3
  i2c_rep_start(0xEE + 0); //I2C write direction => 0
  i2c_write(0xf6);
}

// read uncompensated pressure value: read result bytes
// the datasheet suggests a delay of 25.5 ms (oversampling settings 3) after the send command
uint32_t i2c_BMP085_readUP_Result () {
  uint8_t msb, lsb, xlsb;
  //delay(26);// the datasheet suggests 25.5 ms for oversampling settings 3
  i2c_rep_start(0xEE + 1);//I2C read direction => 1
  msb = i2c_readAck();
  lsb = i2c_readAck();
  xlsb = i2c_readNak();
  return (((uint32_t)msb<<16) | ((uint32_t)lsb<<8) | ((uint32_t)xlsb)) >>5;
}

// deduction of true temperature and pressure from sensor, code is described in the BMP085 specs
void i2c_BMP085_CompensatedSensor() {
  int32_t x1, x2, x3, b3, b5, b6, p;
  uint32_t b4, b7;
  uint16_t a,b;

  //calculate true temperature
  x1 = (int32_t)(ut - ac6) * ac5 >> 15;
  x2 = ((int32_t) mc << 11) / (x1 + md);
  b5 = x1 + x2;
  temperature = (b5 + 8) >> 4;
  //calculate true pressure
  b6 = b5 - 4000;
  x1 = (b2 * (b6 * b6 >> 12)) >> 11; 
  x2 = ac2 * b6 >> 11;
  x3 = x1 + x2;
  b3 = ( ( ((int32_t) ac1 * 4 + x3)<<3 ) + 2) >> 2;
  x1 = ac3 * b6 >> 13;
  x2 = (b1 * (b6 * b6 >> 12)) >> 16;
  x3 = ((x1 + x2) + 2) >> 2;
  b4 = (ac4 * (uint32_t) (x3 + 32768)) >> 15;
  b7 = (up - b3) * (50000 >> 3);
  p = b7 < 0x80000000 ? (b7 * 2) / b4 : (b7 / b4) * 2;
  x1 = (p >> 8) * (p >> 8);
  x1 = (x1 * 3038) >> 16;
  x2 = (-7357 * p) >> 16;
  pressure = p + ((x1 + x2 + 3791) >> 4);
}

//in a whole cycle: we read temperature one time and pressure 5 times
void i2c_BMP085_update() {
  static uint32_t t;
  static uint8_t state1 =0,state2 = 0;

  if ( (micros()-t )  < 30000 ) return; //each read is spaced by 30ms
  t = micros();
  
  TWBR = ((16000000L / 400000L) - 16) / 2; // change the I2C clock rate to 400kHz, BMP085 is ok with this speed
  if (state1 == 0) { 
    if (state2 == 0) {
      i2c_BMP085_readUT_Command();
      state2=1;
    } else {
      ut = i2c_BMP085_readUT_Result();
      state2=0;
      state1=5;
    }
  } else {
    if (state2 == 0) {
      i2c_BMP085_readUP_Command();
      state2=1;
    } else {
      up = i2c_BMP085_readUP_Result();
      state2=0;
      state1--;
      i2c_BMP085_CompensatedSensor();
      altitude = (1.0 - pow(float(pressure)/101325.0, 0.190295)) * 443300 - altitudeZero; // altitude in decimeter from starting point
      if ( abs(altitude-altitudeSmooth) < 100 ) //avoid altitude spike
        altitudeSmooth = (altitudeSmooth*7+altitude+4)/8;
    }
  }
}

void i2c_BMP085_calibrate() {
  altitudeZero = 0;
  for (uint8_t i=0;i<7;i++) {
    i2c_BMP085_update();
    delay(35);
  }
  altitudeZero = altitude;
}
#endif

// **************************
// I2C Accelerometer ADXL345 
// **************************
// I2C adress: 0x3A (8bit)    0x1D (7bit)
// principle:
//  1) CS PIN must be linked to VCC to select the I2C mode
//  2) SD0 PIN must be linked to VCC to select the right I2C adress
//  3) bit  b00000100 must be set on register 0x2D to read data (only once at the initialization)
//  4) bits b00001011 must be set on register 0x31 to select the data format (only once at the initialization)
#if defined(ADXL345)
static uint8_t rawADC_ADXL345[6];

void i2c_ADXL345_init () {
  delay(10);
  i2c_rep_start(0x3A+0);      // I2C write direction 
  i2c_write(0x31);            // DATA_FORMAT register
  i2c_write(0x0B);            // Set bits 3(full range) and 1 0 on (+/- 16g-range)
  i2c_rep_start(0x3A+0);      // I2C write direction 
  i2c_write(0x2C);            // BW_RATE
  i2c_write(8+2+1);           // 200Hz sampling (see table 5 of the spec)
  i2c_rep_start(0x3A+0);      // I2C write direction
  i2c_write(0x2D);            // register 2D
  i2c_write(1<<3);            // Set measure bit 3 on
  
  acc_1G = 250;
  acc_25deg = 106; // = acc_1G * sin(25 deg)
  accPresent = 1;
}

void i2c_ACC_getADC () {
  TWBR = ((16000000L / 400000L) - 16) / 2; // change the I2C clock rate to 400kHz, ADXL435 is ok with this speed
  i2c_rep_start(0x3A);     // I2C write direction
  i2c_write(0x32);         // Start multiple read at reg 0x32 ADX
  i2c_rep_start(0x3A +1);  // I2C read direction => 1
  for(uint8_t i = 0; i < 5; i++) {
    rawADC_ADXL345[i]=i2c_readAck();}
  rawADC_ADXL345[5]= i2c_readNak();

  accADC[PITCH] =   ((rawADC_ADXL345[1]<<8) | rawADC_ADXL345[0]);
  accADC[ROLL]  = - ((rawADC_ADXL345[3]<<8) | rawADC_ADXL345[2]);
  accADC[YAW]   = - ((rawADC_ADXL345[5]<<8) | rawADC_ADXL345[4]);
}
#endif


// **************************
// contribution from opie11 (rc-grooups)
// I2C Accelerometer BMA180
// **************************
// I2C adress: 0x80 (8bit) w/SDO to GND or 0x82 w/SDO to 3.3v
#if defined(BMA180)
static uint8_t rawADC_BMA180[6];

void i2c_BMA180_init () {
  delay(10);
  i2c_rep_start(0x80+0);      // I2C write direction 
  i2c_write(0x0D);            // ctrl_reg0
  i2c_write(1<<4);            // Set bit 4 to 1 to enable writing
  i2c_rep_start(0x80+0);       
  i2c_write(0x35);            // 
  i2c_write(3<<1);            // range set to 3.  
  i2c_rep_start(0x80+0);
  i2c_write(0x20);            // bw_tcs reg: bits 4-7 to set bw
  i2c_write(0<<4);            // bw to 10Hz (low pass filter)
  
  acc_1G = 273;
  acc_25deg = 113; // = acc_1G * sin(25 deg)
  accPresent = 1;
}

void i2c_ACC_getADC () {
  //TWBR = ((16000000L / 400000L) - 16) / 2;
  i2c_rep_start(0x80);     // I2C write direction
  i2c_write(0x02);         // Start multiple read at reg 0x02 acc_x_lsb
  i2c_rep_start(0x80 +1);  // I2C read direction => 1
  for(uint8_t i = 0; i < 5; i++) {
    rawADC_BMA180[i]=i2c_readAck();}
  rawADC_BMA180[5]= i2c_readNak();

  accADC[ROLL]  =  (((rawADC_BMA180[1]<<8) | (rawADC_BMA180[0]))>>2)/10; 
  accADC[PITCH] =  (((rawADC_BMA180[3]<<8) | (rawADC_BMA180[2]))>>2)/10;
  accADC[YAW]   = -(((rawADC_BMA180[5]<<8) | (rawADC_BMA180[4]))>>2)/10;
}
#endif

// **************
// contribution from Point65 and mgros (rc-grooups)
// BMA020 I2C
// **************
// I2C adress: 0x70 (8bit)
#if defined(BMA020)
static uint8_t rawADC_BMA020[6];

void i2c_BMA020_init(){
  byte control;
  
  i2c_rep_start(0x70);     // I2C write direction
  i2c_write(0x15);         // 
  i2c_write(0x80);         // Write B10000000 at 0x15 init BMA020

  i2c_rep_start(0x70);     // 
  i2c_write(0x14);         //  
  i2c_write(0x71);         // 
  i2c_rep_start(0x71);     //
  control = i2c_readNak();
 
  control = control >> 5;  //ensure the value of three fist bits of reg 0x14 see BMA020 documentation page 9
  control = control << 2;
  control = control | 0x00; //Range 2G 00
  control = control << 3;
  control = control | 0x00; //Bandwidth 25 Hz 000
 
  i2c_rep_start(0x70);     // I2C write direction
  i2c_write(0x14);         // Start multiple read at reg 0x32 ADX
  i2c_write(control);

  acc_1G = 240;
  acc_25deg = 101; // = acc_1G * sin(25 deg)
  accPresent = 1;
}

void i2c_ACC_getADC(){
   
  i2c_rep_start(0x70);     // I2C write direction
  i2c_write(0x02);         // Start multiple read at reg 0x32 ADX
  i2c_write(0x71);  
  i2c_rep_start(0x71);  //I2C read direction => 1
  for(uint8_t i = 0; i < 5; i++) {
    rawADC_BMA020[i]=i2c_readAck();}
  rawADC_BMA020[5]= i2c_readNak();

  accADC[ROLL]  =  (((rawADC_BMA020[1])<<8) | ((rawADC_BMA020[0]>>1)<<1))/64;
  accADC[PITCH] =  (((rawADC_BMA020[3])<<8) | ((rawADC_BMA020[2]>>1)<<1))/64;
  accADC[YAW]   = -(((rawADC_BMA020[5])<<8) | ((rawADC_BMA020[4]>>1)<<1))/64;
}
#endif

// **************************
// I2C Wii Motion Plus 
// **************************
// I2C adress 1: 0xA6 (8bit)    0x53 (7bit)
// I2C adress 2: 0xA4 (8bit)    0x52 (7bit)

static uint8_t rawADC_WMP[6];

void i2c_WMP_init(uint8_t d) {
  delay(d);
  i2c_rep_start(0xA6 + 0);//I2C write direction => 0
  i2c_write(0xF0); 
  i2c_write(0x55); 
  delay(d);
  i2c_rep_start(0xA6 + 0);//I2C write direction => 0
  i2c_write(0xFE); 
  i2c_write(0x05); 
  delay(d);
}

void i2c_WMP_getRawADC() {
  TWBR = ((16000000L / I2C_SPEED) - 16) / 2; // change the I2C clock rate
  i2c_rep_start(0xA4 + 0);//I2C write direction => 0
  i2c_write(0x00);
  i2c_rep_start(0xA4 + 1);//I2C read direction => 1
  for(uint8_t i = 0; i < 5; i++)
    rawADC_WMP[i]=i2c_readAck();
  rawADC_WMP[5]= i2c_readNak();
}

// **************************
// ADC ACC
// **************************
#if defined(ADCACC)
void adc_ACC_init(){
  pinMode(A1,INPUT);
  pinMode(A2,INPUT);
  pinMode(A3,INPUT);
}

void adc_ACC_getRawADC() {
  accADC[ROLL]  =  -analogRead(A1);
  accADC[PITCH] =  -analogRead(A2);
  accADC[YAW]   =  -analogRead(A3);

  acc_1G = 75;
  acc_25deg = 32; // = acc_1G * sin(25 deg)
  accPresent = 1;  
}
#endif

// **************
// gyro+acc IMU
// **************
static int16_t gyroData[3] = {0,0,0};
static int16_t gyroZero[3] = {0,0,0};
static int16_t accZero[3]  = {0,0,0};
static int16_t gyroADC[3];
static int16_t angle[2]; //absolute angle inclination in Deg
static int16_t accSmooth[3]; //projection of smoothed and normalized gravitation force vector on x/y/z axis, as measured by accelerometer       

uint8_t rawIMU(uint8_t withACC) { //if the WMP or NK are oriented differently, it can be changed here
  if (withACC) {
    #if defined(ADXL345) || defined(BMA020) || defined(BMA180)
      i2c_ACC_getADC();
    #endif
    #if defined(ADCACC)
      adc_ACC_getRawADC();
    #endif  
  }
  i2c_WMP_getRawADC();
  if ( (rawADC_WMP[5]&0x02) == 0x02 && (rawADC_WMP[5]&0x01) == 0 ) {// motion plus data
    gyroADC[PITCH]  = - ( ((rawADC_WMP[4]>>2)<<8) + rawADC_WMP[1] );
    gyroADC[ROLL]   = - ( ((rawADC_WMP[5]>>2)<<8) + rawADC_WMP[2] );
    gyroADC[YAW]    = - ( ((rawADC_WMP[3]>>2)<<8) + rawADC_WMP[0] );
    return 1;
  } else if ( (rawADC_WMP[5]&0x02) == 0 && (rawADC_WMP[5]&0x01) == 0) { //nunchuk data
    accADC[PITCH] = - ( (rawADC_WMP[2]<<2)        + ((rawADC_WMP[5]>>3)&0x2) );
    accADC[ROLL]  =   ( (rawADC_WMP[3]<<2)        + ((rawADC_WMP[5]>>4)&0x2) );
    accADC[YAW]   = - ( ((rawADC_WMP[4]&0xFE)<<2) + ((rawADC_WMP[5]>>5)&0x6) );
    return 0;
  } else
    return 2;
}

void initIMU(void) {
  uint8_t numberAccRead = 0;
  for(uint8_t i=0;i<100;i++) {
    delay(3);
    if (rawIMU(0) == 0) numberAccRead++; // we detect here is nunchuk extension is available
  }
  if (numberAccRead>25)
    nunchukPresent = 1;
  delay(10);
}

uint8_t updateIMU(uint8_t withACC) {
  static int32_t g[3];
  static int32_t a[3];
  uint8_t axis;
  static int16_t previousGyroADC[3] = {0,0,0};
  uint8_t r;
  r=rawIMU(withACC);
  
  if (currentTime < (neutralizeTime + NEUTRALIZE_DELAY)) {//we neutralize data in case of blocking+hard reset state
    for (axis = 0; axis < 3; axis++) {gyroADC[axis]=0;accADC[axis]=0;}
    accADC[YAW] = acc_1G;
  } else {
    if (r == 1) { //gyro
      if (calibratingG>0) {
        for (axis = 0; axis < 3; axis++) {
          if (calibratingG>1) {
            if (calibratingG == 400) g[axis]=0;
            g[axis] +=gyroADC[axis];
            gyroADC[axis]=0;
          } else {
            gyroZero[axis]=(g[axis]+200)/399;
            blinkLED(10,15,1+3*nunchukPresent);
          }
        }
        calibratingG--;
      } else {
        gyroADC[PITCH] = gyroADC[PITCH] - gyroZero[PITCH];
        gyroADC[ROLL]  = gyroADC[ROLL]  - gyroZero[ROLL];
        gyroADC[YAW]   = gyroADC[YAW]   - gyroZero[YAW]; 
      }
      gyroADC[PITCH] = (rawADC_WMP[4]&0x02)>>1  ? gyroADC[PITCH]/5 : gyroADC[PITCH] ;  //we detect here the slow of fast mode WMP gyros values (see wiibrew for more details)
      gyroADC[ROLL]  = (rawADC_WMP[3]&0x01)     ? gyroADC[ROLL]/5  : gyroADC[ROLL] ;   //the ratio 1/5 is not exactly the IDG600 or ISZ650 specification 
      gyroADC[YAW]   = (rawADC_WMP[3]&0x02)>>1  ? gyroADC[YAW]/5   : gyroADC[YAW] ;
      //anti gyro glitch, limit the variation between two consecutive readings
      for (axis = 0; axis < 3; axis++) {
        gyroADC[axis] = constrain(gyroADC[axis],previousGyroADC[axis]-100,previousGyroADC[axis]+100);
        previousGyroADC[axis] = gyroADC[axis];
      }
    }
    if (r == 0 || ( (accPresent == 1) && (withACC == 1) ) ) { //nunchuk or i2c ACC
      if (calibratingA>0) {
        if (calibratingA>1) {
          for (uint8_t axis = 0; axis < 3; axis++) {
            if (calibratingA == 400) a[axis]=0;
            a[axis] +=accADC[axis];
            accADC[axis]=0;
          }
        } else {
          accZero[ROLL]  = (a[ROLL]+200)/399;
          accZero[PITCH] = (a[PITCH]+200)/399;
          accZero[YAW]   = (a[YAW]+200)/399+acc_1G; // for nunchuk 200=1G
          writeParams(); // write accZero in EEPROM
          blinkLED(10,15,1);
        }
        calibratingA--;
      } else {
        accADC[PITCH] =    accADC[PITCH] - accZero[PITCH];
        accADC[ROLL]  =    accADC[ROLL]  - accZero[ROLL] ;
        accADC[YAW]   = - (accADC[YAW]   - accZero[YAW]) ;
      }
    }
  }  
  return r;
}

// ************************************
// simplified IMU based on Kalman Filter
// inspired from http://starlino.com/imu_guide.html
// and http://www.starlino.com/imu_kalman_arduino.html
// for angles under 25deg, we use an approximation to speed up the angle calculation
// ************************************
void getEstimatedInclination(){
  int8_t i;  
  float R;
  static float RxEst = 0;      // init acc in stable mode
  static float RyEst = 0;
  static float RzEst = 1;
  static float Axz,Ayz;        //angles between projection of R on XZ/YZ plane and Z axis (in Radian)
  float RxGyro,RyGyro,RzGyro;  //R obtained from last estimated value and gyro movement
  uint8_t wGyro = 100;         // gyro weight/smooting factor
  static float invW = 1.0/(1 + 100);
  float gyroFactor;
  float a,b;
  static uint8_t small_angle=1;
  static uint16_t tCurrent=0,tPrevious=0;
  uint16_t deltaTime;
  
  tCurrent = micros();
  deltaTime = tCurrent-tPrevious;
  tPrevious = tCurrent;

  gyroFactor = deltaTime/200e6; //empirical, depends on WMP on IDG datasheet, tied of deg/ms sensibility

  for (i=0;i<3;i++) accSmooth[i] =(accSmooth[i]*7+accADC[i]+4)/8;

  if(accSmooth[YAW] > 0 ){ //we want to be sure we are not flying inverted  
    a = gyroADC[ROLL]  * gyroFactor;
    b = gyroADC[PITCH] * gyroFactor;
    
    // a very nice trigonometric approximation:
    // under 25deg, the error of this approximation is less than 1 deg: angle_axis = arcsin(ACC_axis/ACC_1G) =~= ACC_axis/ACC_1G
    // the angle calculation is much more faster in this case
    if (accSmooth[ROLL]<acc_25deg && accSmooth[ROLL]>-acc_25deg && accSmooth[PITCH]<acc_25deg && accSmooth[PITCH]>-acc_25deg) {
      Axz +=a;
      Ayz +=b;
      Axz = ((float)accSmooth[ROLL]/acc_1G + Axz*wGyro)*invW;
      Ayz = ((float)accSmooth[PITCH]/acc_1G + Ayz*wGyro)*invW;
      small_angle=1;
    } else {
      //normalize vector (convert to a vector with same direction and with length 1)
      R = sqrt(square(accSmooth[ROLL]) + square(accSmooth[PITCH]) + square(accSmooth[YAW]));
  
      if (R > acc_1G*7/5 || R < acc_1G*3/5) { //if accel magnitude >1.4G or <0.6G => we neutralize the effect of accelerometers in the angle estimation
        Axz +=  a;     //and we use only gyro integration
        Ayz +=  b;
      } else if (small_angle == 0) {
        Axz = atan2(RxEst,RzEst) + a;  // convert ADC value for to physical units
        Ayz = atan2(RyEst,RzEst) + b;  // and get updated angle according to gyro movement
      }
      
      //reverse calculation of RwGyro from Awz angles, for formulas deductions see  http://starlino.com/imu_guide.html
      RxGyro = sin(Axz) / sqrt( 1.0 + square(cos(Axz)) * square(tan(Ayz)) );
      RyGyro = sin(Ayz) / sqrt( 1.0 + square(cos(Ayz)) * square(tan(Axz)) );        
      RzGyro = sqrt(abs(1 - square(RxGyro) - square(RyGyro)));
    
      //combine Accelerometer and gyro readings
      RxEst = (accSmooth[ROLL]/R + wGyro* RxGyro)  * invW;
      RyEst = (accSmooth[PITCH]/R + wGyro* RyGyro) * invW;
      RzEst = (accSmooth[YAW]/R + wGyro* RzGyro)   * invW;
      
      small_angle=0;
    }
  }
  angle[ROLL]  =  degrees(Axz);
  angle[PITCH] =  degrees(Ayz);
}

void computeIMU () {
  uint8_t axis;
  static int16_t gyroADCprevious[3] = {0,0,0};
  static int16_t gyroADCp[3] = {0,0,0};
  int16_t gyroADCinter[3];
  static int16_t lastAccADC[3] = {0,0,0};
  static int16_t similarNumberAccData[3];
  static int16_t gyroDeviation[3];
  static uint32_t timeInterleave;
  static int16_t gyroYawSmooth = 0;

  //we separate the 2 situations because reading gyro values with a gyro only setup can be acchieved at a higher rate
  //gyro+nunchuk: we must wait for a quite high delay betwwen 2 reads to get both WM+ and Nunchuk data. It works with 3ms
  //gyro only: the delay to read 2 consecutive values can be reduced to only 0.65ms
  if (nunchukPresent) {
    annexCode();
    while((micros()-timeInterleave)<INTERLEAVING_DELAY) ; //interleaving delay between 2 consecutive reads
    timeInterleave=micros();
    updateIMU(0);
    getEstimatedInclination(); //getEstimatedInclination computation must last less than one interleaving delay
    while((micros()-timeInterleave)<INTERLEAVING_DELAY) ; //interleaving delay between 2 consecutive reads
    timeInterleave=micros();
    while(updateIMU(0) != 1) ; // For this interleaving reading, we must have a gyro update at this point (less delay)

    for (axis = 0; axis < 3; axis++) {
      // empirical, we take a weighted value of the current and the previous values
      gyroData[axis] = (gyroADC[axis]*3+gyroADCprevious[axis]+16)/4/8; // /4 is to average 4 values ; /8 is to reduce the sensibility of gyro
      gyroADCprevious[axis] = gyroADC[axis];
    }
  } else {
    #if defined(ADXL345) || defined(BMA020) || defined(BMA180) || defined(ADCACC)
      getEstimatedInclination();
      updateIMU(1); //with I2C or ADC ACC
    #else
      updateIMU(0); //without ACC
    #endif
    for (axis = 0; axis < 3; axis++)
      gyroADCp[axis] =  gyroADC[axis];
    timeInterleave=micros();
    annexCode();
    while((micros()-timeInterleave)<650) ; //empirical, interleaving delay between 2 consecutive reads
    updateIMU(0); //without ADXL ACC
    for (axis = 0; axis < 3; axis++) {
      gyroADCinter[axis] =  gyroADC[axis]+gyroADCp[axis];
      // empirical, we take a weighted value of the current and the previous values
      gyroData[axis] = (gyroADCinter[axis]+gyroADCprevious[axis]+12)/3/8; // /3 is to average 3 values ; /8 is to reduce the sensibility of gyro
      gyroADCprevious[axis] = gyroADCinter[axis]/2;
      #if not defined (ADXL345) && not defined (BMA020) && not defined (BMA180) && not defined (ADCACC)
        accADC[axis]=0;
      #endif
    }
  }
  gyroData[YAW] = (gyroYawSmooth*2+gyroData[YAW]+1)/3;
  gyroYawSmooth = gyroData[YAW];
}

// *************************
// motor and servo functions
// *************************
uint8_t PWM_PIN[6] = {MOTOR_ORDER};
  
static int16_t axisPID[3];
static int16_t motor[6];
static int16_t servo[4] = {1500,1500,1500,1500};
volatile int8_t atomicServo[4] = {250,250,250,250};

//for HEX Y6 and HEX6 flat
volatile uint8_t atomicPWM_PIN5_lowState;
volatile uint8_t atomicPWM_PIN5_highState;
volatile uint8_t atomicPWM_PIN6_lowState;
volatile uint8_t atomicPWM_PIN6_highState;

void writeMotors() { // [1000;2000] => [125;250]
  for(uint8_t i=0;i<min(NUMBER_MOTOR,4);i++)
    analogWrite(PWM_PIN[i], motor[i]>>3);
  #if (NUMBER_MOTOR == 6) && defined(MEGA)
    analogWrite(PWM_PIN[4], motor[4]>>3);
    analogWrite(PWM_PIN[5], motor[5]>>3);
  #endif
  #if (NUMBER_MOTOR == 6) && defined(PROMINI)
    atomicPWM_PIN5_highState = motor[5]/8;
    atomicPWM_PIN5_lowState = 255-atomicPWM_PIN5_highState;
    atomicPWM_PIN6_highState = motor[4]/8;
    atomicPWM_PIN6_lowState = 255-atomicPWM_PIN6_highState;
  #endif
}

void writeAllMotors(int16_t mc) {   // Sends commands to all motors
  for (uint8_t i =0;i<NUMBER_MOTOR;i++)
    motor[i]=mc;
  writeMotors();
}

void initializeMotors() {
  for(uint8_t i=0;i<NUMBER_MOTOR;i++)
    pinMode(PWM_PIN[i],OUTPUT);
  writeAllMotors(1000);
  delay(300);
}

#if defined(BI) || defined(TRI) || defined(SERVO_TILT) || defined(GIMBAL) || defined(FLYING_WING)
void initializeServo() {
  #if defined(TRI)
    DIGITAL_SERVO_TRI_PINMODE
  #endif
  #if defined(SERVO_TILT) || defined(GIMBAL) || defined(FLYING_WING)
    DIGITAL_TILT_ROLL_PINMODE
    DIGITAL_TILT_PITCH_PINMODE
  #endif
  #if defined(BI)
    pinMode(PWM_PIN[2],OUTPUT); //RIGHT //thses 2 PIN are used to control 2 servos
    pinMode(PWM_PIN[3],OUTPUT); //LEFT
  #endif
  TCCR0A = 0; // normal counting mode
  TIMSK0 |= (1<<OCIE0A); // Enable CTC interrupt
}

// ****servo yaw with a 50Hz refresh rate****
// prescaler is set by default to 64 on Timer0
// Duemilanove : 16MHz / 64 => 4 us
// 256 steps = 1 counter cycle = 1024 us
// algorithm strategy:
// pulse high servo 0 -> do nothing for 1000 us -> do nothing for [0 to 1000] us -> pulse down servo 0
// pulse high servo 1 -> do nothing for 1000 us -> do nothing for [0 to 1000] us -> pulse down servo 1
// pulse high servo 2 -> do nothing for 1000 us -> do nothing for [0 to 1000] us -> pulse down servo 2
// pulse high servo 3 -> do nothing for 1000 us -> do nothing for [0 to 1000] us -> pulse down servo 3
// do nothing for 14 x 1000 us
ISR(TIMER0_COMPA_vect) {
  static uint8_t state = 0;
  static uint8_t count;
  if (state == 0) {
    //http://billgrundmann.wordpress.com/2009/03/03/to-use-or-not-use-writedigital/
    #if defined(TRI) || defined (BI)
      DIGITAL_SERVO_TRI_HIGH
    #endif
    OCR0A+= 250; // 1000 us
    state++ ;
  } else if (state == 1) {
    OCR0A+= atomicServo[0]; // 1000 + [0-1020] us
    state++;
  } else if (state == 2) {
    #if defined(TRI) || defined (BI)
      DIGITAL_SERVO_TRI_LOW
    #endif
    #if defined(BI)
      DIGITAL_BI_REAR_HIGH
    #endif
    #if defined(SERVO_TILT) || defined(GIMBAL) || defined(FLYING_WING)
      DIGITAL_TILT_PITCH_HIGH
    #endif
    OCR0A+= 250; // 1000 us
    state++;
  } else if (state == 3) {
    OCR0A+= atomicServo[1]; // 1000 + [0-1020] us
    state++;
  } else if (state == 4) {
    #if defined(SERVO_TILT) || defined(GIMBAL) || defined(FLYING_WING)
      DIGITAL_TILT_PITCH_LOW
      DIGITAL_TILT_ROLL_HIGH
    #endif
    #if defined(BI)
      DIGITAL_BI_REAR_LOW
    #endif
    state++;
    OCR0A+= 250; // 1000 us
  } else if (state == 5) {
    OCR0A+= atomicServo[2]; // 1000 + [0-1020] us
    state++;
  } else if (state == 6) {
    #if defined(SERVO_TILT) || defined(GIMBAL) || defined(FLYING_WING)
      DIGITAL_TILT_ROLL_LOW
    #endif
//servo number 4 not used for the moment
    state++;
    OCR0A+= 250; // 1000 us
  } else if (state == 7) {
    OCR0A+= atomicServo[3]; // 1000 + [0-1020] us
    state++;
  } else if (state == 8) {
//servo number 4 not used for the moment
    count = 10; // 12 x 1000 us
    state++;
    OCR0A+= 250; // 1000 us
  } else if (state == 9) {
    if (count > 0) count--;
    else state = 0;
    OCR0A+= 250;
  }
}
#endif

#if (NUMBER_MOTOR == 6) && defined(PROMINI)
void initializeSoftPWM() {
  TCCR0A = 0; // normal counting mode
  TIMSK0 |= (1<<OCIE0A); // Enable CTC interrupt
  TIMSK0 |= (1<<OCIE0B);
}

ISR(TIMER0_COMPA_vect) {
  static uint8_t state = 0;
  if (state == 0) {
    PORTD |= 1<<5; //digital PIN 5 high
    OCR0A+= atomicPWM_PIN5_highState; //250 x 4 microsecons = 1ms
    state = 1;
  } else if (state == 1) {
    OCR0A+= atomicPWM_PIN5_highState;
    state = 2;
  } else if (state == 2) {
    PORTD &= ~(1<<5); //digital PIN 5 low
    OCR0A+= atomicPWM_PIN5_lowState;
    state = 0;
  }
}

ISR(TIMER0_COMPB_vect) { //the same with digital PIN 6 and OCR0B counter
  static uint8_t state = 0;
  if (state == 0) {
    PORTD |= 1<<6;OCR0B+= atomicPWM_PIN6_highState;state = 1;
  } else if (state == 1) {
    OCR0B+= atomicPWM_PIN6_highState;state = 2;
  } else if (state == 2) {
    PORTD &= ~(1<<6);OCR0B+= atomicPWM_PIN6_lowState;state = 0;
  }
}
#endif

// ******************
// rc functions
// ******************
#define MINCHECK 1100
#define MAXCHECK 1900

//RX PIN assignment inside the port
#if defined(PROMINI) //for PORTD
  #define THROTTLEPIN  2
  #define ROLLPIN      4
  #define PITCHPIN     5
  #define YAWPIN       6
  #define AUX1PIN      7
#endif
#if defined(MEGA) //for PORTK
  #define THROTTLEPIN  0  //PIN 62 =  PIN A8
  #define ROLLPIN      1  //PIN 63 =  PIN A9
  #define PITCHPIN     2  //PIN 64 =  PIN A10
  #define YAWPIN       3  //PIN 65 =  PIN A11
  #define AUX1PIN      4  //PIN 66 =  PIN A12
#endif

static uint8_t pinRcChannel[5] = {ROLLPIN, PITCHPIN, YAWPIN, THROTTLEPIN, AUX1PIN};
volatile uint16_t rcPinValue[8] = {0,0,1000,0,1500,1500,1500,1000}; // interval [1000;2000]
static int16_t rcData[5] ; // interval [1000;2000]
static int16_t rcCommand[4] ; // interval [1000;2000] for THROTTLE and [-500;+500] for ROLL/PITCH/YAW 
static int16_t rcHysteresis[5] ;
static int16_t rcData4Values[5][4];

static uint8_t rcRate8;
static uint8_t rcExpo8;
static float rcFactor1; 
static float rcFactor2;

// ***PPM SUM SIGNAL***
#ifdef SERIAL_SUM_PPM
static uint8_t rcChannel[5] = {SERIAL_SUM_PPM};
#endif
volatile uint16_t rcValue[8] = {1500,1500,1500,1500,1500,1500,1500,1500}; // interval [1000;2000]

// Configure each rc pin for PCINT
void configureReceiver() {
  #ifndef SERIAL_SUM_PPM
    for (uint8_t chan = 0; chan < 5; chan++)
      for (uint8_t a = 0; a < 4; a++)
        rcData4Values[chan][a] = 1500; //we initiate the default value of each channel. If there is no RC receiver connected, we will see those values
    #if defined(PROMINI)
      // PCINT activated only for specific pin inside [D0-D7]  , [D2 D4 D5 D6 D7] for this multicopter
      PCMSK2 |= (1<<2) | (1<<4) | (1<<5) | (1<<6) | (1<<7); 
      PCICR   = 1<<2; // PCINT activated only for the port dealing with [D0-D7] PINs
    #endif
    #if defined(MEGA)
      // PCINT activated only for specific pin inside [A8-A15]
      DDRK = 0;  // defined PORTK as a digital port ([A8-A15] are consired as digital PINs and not analogical)
      PORTK = 0; //enable internal pull ups on the PINs of PORTK
      PCMSK2 |= (1<<0) | (1<<1) | (1<<2) | (1<<3) | (1<<4) | (1<<5) | (1<<6) | (1<<7);
      PCICR |= 1 << 2; // PCINT activated only for PORTK dealing with [A8-A15] PINs
    #endif
  #else
    PPM_PIN_INTERRUPT
  #endif
}

#ifndef SERIAL_SUM_PPM
ISR(PCINT2_vect) { //this ISR is common to every receiver channel, it is call everytime a change state occurs on a digital pin [D2-D7]
  uint8_t mask;
  uint8_t pin;
  uint16_t cTime,dTime;
  static uint16_t edgeTime[8];
  static uint8_t PCintLast;

  #if defined(PROMINI)
    pin = PIND;              // PIND indicates the state of each PIN for the arduino port dealing with [D0-D7] digital pins (8 bits variable)
  #endif
  #if defined(MEGA)
    pin = PINK;              // PINK indicates the state of each PIN for the arduino port dealing with [A8-A15] digital pins (8 bits variable)
  #endif
  mask = pin ^ PCintLast;  // doing a ^ between the current interruption and the last one indicates wich pin changed
  sei();                    // re enable other interrupts at this point, the rest of this interrupt is not so time critical and can be interrupted safely
  PCintLast = pin;         // we memorize the current state of all PINs [D0-D7]

  cTime = micros();         // micros() return a uint32_t, but it is not usefull to keep the whole bits => we keep only 16 bits
  
  // mask is pins [D0-D7] that have changed // the principle is the same on the MEGA for PORTK and [A8-A15] PINs
  // chan = pin sequence of the port. chan begins at D2 and ends at D7
  if (mask & 1<<2)           //indicates the bit 2 of the arduino port [D0-D7], that is to say digital pin 2, if 1 => this pin has just changed
    if (!(pin & 1<<2)) {     //indicates if the bit 2 of the arduino port [D0-D7] is not at a high state (so that we match here only descending PPM pulse)
      dTime = cTime-edgeTime[2]; if (900<dTime && dTime<2200) rcPinValue[2] = dTime; // just a verification: the value must be in the range [1000;2000] + some margin
    } else edgeTime[2] = cTime;    // if the bit 2 of the arduino port [D0-D7] is at a high state (ascending PPM pulse), we memorize the time
  if (mask & 1<<4)   //same principle for other channels   // avoiding a for() is more than twice faster, and it's important to minimize execution time in ISR
    if (!(pin & 1<<4)) {
      dTime = cTime-edgeTime[4]; if (900<dTime && dTime<2200) rcPinValue[4] = dTime;
    } else edgeTime[4] = cTime;
  if (mask & 1<<5)
    if (!(pin & 1<<5)) {
      dTime = cTime-edgeTime[5]; if (900<dTime && dTime<2200) rcPinValue[5] = dTime;
    } else edgeTime[5] = cTime;
  if (mask & 1<<6)
    if (!(pin & 1<<6)) {
      dTime = cTime-edgeTime[6]; if (900<dTime && dTime<2200) rcPinValue[6] = dTime;
    } else edgeTime[6] = cTime;
  if (mask & 1<<7)
    if (!(pin & 1<<7)) {
      dTime = cTime-edgeTime[7]; if (900<dTime && dTime<2200) rcPinValue[7] = dTime;
    } else edgeTime[7] = cTime;
  #if defined(MEGA)
    if (mask & 1<<0)    
      if (!(pin & 1<<0)) {
        dTime = cTime-edgeTime[0]; if (900<dTime && dTime<2200) rcPinValue[0] = dTime; 
      } else edgeTime[0] = cTime; 
    if (mask & 1<<1)      
      if (!(pin & 1<<1)) {
        dTime = cTime-edgeTime[1]; if (900<dTime && dTime<2200) rcPinValue[1] = dTime; 
      } else edgeTime[1] = cTime;
    if (mask & 1<<3)
      if (!(pin & 1<<3)) {
        dTime = cTime-edgeTime[2]; if (900<dTime && dTime<2200) rcPinValue[3] = dTime;
      } else edgeTime[2] = cTime;
  #endif
}

#else 
void rxInt() {
  uint16_t now,diff;
  static uint16_t last = 0;
  static uint8_t chan = 0;

  now = micros();
  diff = now - last;
  last = now;
  if(diff>5000) chan = 0;
  else {
    if(900<diff && diff<2200 && chan<8 ) rcValue[chan] = diff;
    chan++;
  }
}
#endif

uint16_t readRawRC(uint8_t chan) {
  uint16_t data;
  uint8_t oldSREG;
  oldSREG = SREG;
  cli(); // Let's disable interrupts
  #ifndef SERIAL_SUM_PPM
    data = rcPinValue[pinRcChannel[chan]]; // Let's copy the data Atomically
  #else
    data = rcValue[rcChannel[chan]]; 
  #endif
  SREG = oldSREG;
  sei();// Let's enable the interrupts
  return data; // We return the value correctly copied when the IRQ's where disabled
}
  
void computeRC() {
  static uint8_t rc4ValuesIndex = 0;
  uint8_t chan,a;

  rc4ValuesIndex++;
  for (chan = 0; chan < 5; chan++) {
    rcData4Values[chan][rc4ValuesIndex%4] = readRawRC(chan);
    rcData[chan] = 0;
    for (a = 0; a < 4; a++)
      rcData[chan] += rcData4Values[chan][a];
    rcData[chan]= (rcData[chan]+2)/4;
    if ( rcData[chan] < rcHysteresis[chan] -4)  rcHysteresis[chan] = rcData[chan]+2;
    if ( rcData[chan] > rcHysteresis[chan] +4)  rcHysteresis[chan] = rcData[chan]-2;
  }
  #if defined(FORCE_LEVEL)
    rcData[AUX1] = 2000;
  #endif
}


// ****************
// EEPROM functions
// ****************
static uint8_t P8[3], I8[3], D8[3]; //8 bits is much faster and the code is much shorter
static uint8_t dynP8[3], dynI8[3], dynD8[3]; 
static uint8_t accStrength8;
static uint8_t rollPitchRate;
static uint8_t yawRate;
static uint8_t dynThrPID;
static uint8_t checkNewConf = 130;

void readEEPROM() {
  uint8_t i,p=1;
  for(i=0;i<3;i++) {P8[i] = EEPROM.read(p++);I8[i] = EEPROM.read(p++);D8[i] = EEPROM.read(p++);}
  rcRate8 = EEPROM.read(p++);rcExpo8 = EEPROM.read(p++);
  accStrength8 = EEPROM.read(p++);
  rollPitchRate = EEPROM.read(p++);
  yawRate = EEPROM.read(p++);
  dynThrPID = EEPROM.read(p++);
  for(i=0;i<3;i++) accZero[i] = (EEPROM.read(p++)&0xff) + (EEPROM.read(p++)<<8);

  //note on the following lines: we do this calcul here because it's a static and redundant result and we don't want to load the critical loop whith it
  rcFactor1 = rcRate8/50.0*rcExpo8/100.0/250000.0;
  rcFactor2 = (100-rcExpo8)*rcRate8/5000.0;
}

void writeParams() {
  uint8_t i,p=1;
  EEPROM.write(0, checkNewConf);
  for(i=0;i<3;i++) {EEPROM.write(p++,P8[i]);  EEPROM.write(p++,I8[i]);  EEPROM.write(p++,D8[i]);}
  EEPROM.write(p++,rcRate8);EEPROM.write(p++,rcExpo8);
  EEPROM.write(p++,accStrength8);
  EEPROM.write(p++,rollPitchRate);
  EEPROM.write(p++,yawRate);
  EEPROM.write(p++,dynThrPID);
  for(i=0;i<3;i++) {EEPROM.write(p++,accZero[i]);EEPROM.write(p++,accZero[i]>>8&0xff);}
  readEEPROM();
}

void checkFirstTime() {
  if ( EEPROM.read(0) != checkNewConf ) {
    P8[ROLL] = 40; I8[ROLL] = 30; D8[ROLL] = 13;
    P8[PITCH] = 40; I8[PITCH] = 30; D8[PITCH] = 13;
    P8[YAW]  = 80; I8[YAW]  = 0;  D8[YAW]  = 0;
    rcRate8 = 45;
    rcExpo8 = 65;
    accStrength8 = 100;
    rollPitchRate = 0;
    yawRate = 0;
    dynThrPID = 0;
    writeParams();
  }
}

// *****************************
// LCD & display & monitoring
// *****************************

// 1000000 / 9600  = 104 microseconds at 9600 baud.
// we set it below to take some margin with the running interrupts
#define BITDELAY 102
void LCDprint(uint8_t i) {
  LCDPIN_OFF
  delayMicroseconds(BITDELAY);
  for (uint8_t mask = 0x01; mask; mask <<= 1) {
    if (i & mask) LCDPIN_ON // choose bit
    else LCDPIN_OFF  
    delayMicroseconds(BITDELAY);
  }
  LCDPIN_ON //switch ON digital PIN 0
  delayMicroseconds(BITDELAY);
}

void LCDprintChar(const char *s) {
  while (*s) LCDprint(*s++);
}

void initLCD() {
  Serial.end();
  blinkLED(20,30,1);
  //init LCD
  PINMODE_LCD //TX PIN for LCD = Arduino RX PIN (more convenient to connect a servo plug on arduino pro mini)
  LCDprint(0xFE);LCDprint(0x0D); //cursor blink mode
}

void annexCode() { //this code is excetuted at each loop and won't interfere with control loop if it lasts less than 650 microseconds
  uint16_t vbat10bits,a,b;
  static uint32_t serialTime;
  static uint32_t buzzerTime;
  static uint32_t calibrateTime;
  static uint8_t  buzzerState = 0;
  uint8_t axis;
  uint8_t prop1,prop2;

  for(axis=0;axis<2;axis++) {
    //PITCH & ROLL dynamic PID adjustemnt, depending on stick deviation
    prop1 = 100-min(abs(rcData[axis]-1500)/5,100)*rollPitchRate/100;
    //PITCH & ROLL only dynamic PID adjustemnt,  depending on throttle value
    if (rcData[THROTTLE]<1500)                               prop2 = 100;
    else if (rcData[THROTTLE]>1499 && rcData[THROTTLE]<2000) prop2 = 100 - (rcData[THROTTLE]-1500) * dynThrPID/500;
    else                                                     prop2 = 100 - dynThrPID;
    dynP8[axis] = P8[axis]*prop1/100*prop2/100;
    dynD8[axis] = D8[axis]*prop1/100*prop2/100;
  }
  
  //YAW dynamic PID adjustemnt
  prop1 = 100-min(abs(rcData[YAW]-1500)/5,100)*yawRate/100;
  dynP8[YAW] = P8[YAW]*prop1/100;
  dynD8[YAW] = D8[YAW]*prop1/100;

  vbat10bits = analogRead(V_BATPIN);

  if (vbat10bits>VBATLEVEL1_3S) {                                          //VBAT ok, buzzer off
    BUZZERPIN_OFF
  } else if ((vbat10bits>VBATLEVEL2_3S) && (vbat10bits<VBATLEVEL1_3S)) {   //First level 0.25s beep spacing 1s
    if (buzzerState && (currentTime > buzzerTime + 250000) ) {
      buzzerState = 0;BUZZERPIN_OFF;buzzerTime = currentTime;
    } else if ( !buzzerState && (currentTime > buzzerTime + 1000000) ) {
      buzzerState = 1;BUZZERPIN_ON;buzzerTime = currentTime;
    }
  } else if ((vbat10bits>VBATLEVEL3_3S) && (vbat10bits<VBATLEVEL2_3S)) {   //First level 0.25s beep spacing 0.5s
    if (buzzerState && (currentTime > buzzerTime + 250000) ) {
      buzzerState = 0;BUZZERPIN_OFF;buzzerTime = currentTime;
    } else if ( !buzzerState && (currentTime > buzzerTime + 500000) ) {
      buzzerState = 1;BUZZERPIN_ON;buzzerTime = currentTime;
    }
  } else {                                                                 //Last level 0.25s beep spacing 0.25s
    if (buzzerState && (currentTime > buzzerTime + 250000) ) {
      buzzerState = 0;BUZZERPIN_OFF;buzzerTime = currentTime;
    } else if (!buzzerState  && (currentTime > buzzerTime + 250000) ) {
      buzzerState = 1;BUZZERPIN_ON;buzzerTime = currentTime;
    }
  }

  if ( (currentTime > calibrateTime + 100000)  && ( (calibratingA>0 && (nunchukPresent == 1 || accPresent == 1)) || (calibratingG>0) ) ) {         // Calibration phasis
    LEDPIN_SWITCH
    calibrateTime = currentTime;
  } else if ( (calibratingA==0) || (calibratingG==0 && !(nunchukPresent == 1 || accPresent == 1)) ) {
    if (armed) LEDPIN_ON
    else LEDPIN_OFF
  }

  if (currentTime > serialTime + 20000) { // 50Hz
    serialCom();
    serialTime = currentTime;
  }
  for( axis=0;axis<2;axis++)
    rcCommand[axis]   = (rcHysteresis[axis]-1500) * (rcFactor2 + rcFactor1*square((rcHysteresis[axis]-1500)));
  rcCommand[THROTTLE] = (MAXTHROTTLE-MINTHROTTLE)/(2000.0-MINCHECK) * (rcHysteresis[THROTTLE]-MINCHECK) + MINTHROTTLE;
  rcCommand[YAW]      = rcHysteresis[YAW]-1500;
}

void configurationLoop() {
  uint8_t chan;
  uint8_t param;
  uint8_t paramActive;
  uint8_t val;
  uint8_t valActive;
  static char line1[17];
  static char line2[17];
  uint8_t LCD=1;
  uint8_t posLCD = 130;
  uint8_t refreshLCD = 1;

  initLCD();
  param = 1;
  while (LCD == 1) {
    if (refreshLCD == 1) {
      if (param < 4) {
        if (param == 1) {strcpy(line1," *P*    I     D "); posLCD = 130;}  //no more sprintf(), better for code size
        if (param == 2) {strcpy(line1,"  P    *I*    D "); posLCD = 136;}
        if (param == 3) {strcpy(line1,"  P     I    *D*"); posLCD = 142;}
        line2[0] = '0'+P8[ROLL]/100;line2[1] = '0'+P8[ROLL]/10-(P8[ROLL]/100)*10;line2[2] = '.';line2[3] = '0'+P8[ROLL]-(P8[ROLL]/10)*10;
        line2[4] = ' ';line2[5] = ' ';
        line2[6] = '0';line2[7] = '.';line2[8] = '0'+I8[ROLL]/100;line2[9] = '0'+I8[ROLL]/10-(I8[ROLL]/100)*10;line2[10] = '0'+I8[ROLL]-(I8[ROLL]/10)*10;
        line2[11] = ' ';line2[12] = ' ';
        line2[13] = '-';line2[14] = '0'+D8[PITCH]/10;line2[15] = '0'+D8[PITCH]-(D8[PITCH]/10)*10;  
      }
      if (param == 4) {
        line2[0] = '0'+P8[YAW]/100;line2[1] = '0'+P8[YAW]/10-(P8[YAW]/100)*10;line2[2] = '.';line2[3] = '0'+P8[YAW]-(P8[YAW]/10)*10;
        strcpy(line2+4,"            ");
        strcpy(line1,"*P YAW*        "); posLCD = 130;
      }
      LCDprint(0xFE);LCDprint(128);LCDprintChar(line1); //refresh line 1 of LCD
      LCDprint(0xFE);LCDprint(192);LCDprintChar(line2); //refresh line 2 of LCD
      LCDprint(0xFE);LCDprint(posLCD); //cursor position
      refreshLCD=0;
    }
    for (chan = ROLL; chan < 4; chan++) rcData[chan] = readRawRC(chan);

    //switch config param with pitch
    if (rcData[PITCH] < MINCHECK && paramActive == 0) {
      paramActive = 1;
      refreshLCD=1;
      param++; if (param>4) param=4;
      if (param < 5) {blinkLED(10,20,param);}
    }
    if (rcData[PITCH] > MAXCHECK && paramActive == 0) {
      paramActive = 1;
      refreshLCD=1;
      param--; if (param<1) param=1;
      if (param < 5) {blinkLED(10,20,param);}
    }
    if (rcData[PITCH] < MAXCHECK && rcData[PITCH] > MINCHECK)  paramActive = 0;

    //+ or - param with low and high roll
    if (rcData[ROLL] < MINCHECK && valActive == 0) {
      valActive = 1;
      refreshLCD=1;
      //set val -
      if (param == 1 && (P8[ROLL]>0)) {P8[ROLL] -= 1 ;P8[PITCH]=P8[ROLL];}
      if (param == 2 && (I8[ROLL]>4)) {I8[ROLL] -= 5 ;I8[PITCH]=I8[ROLL];}
      if (param == 3) {D8[ROLL] += 1; D8[PITCH]=D8[ROLL];}
      if (param == 4 && (P8[YAW]>9)) {P8[YAW] -= 10;}
      blinkLED(10,30,1);
    }
    if (rcData[ROLL] > MAXCHECK && valActive == 0) {
      valActive = 1;
      refreshLCD=1;
      //set val +
      if (param == 1) {P8[ROLL] += 1;P8[PITCH]=P8[ROLL];}
      if (param == 2) {I8[ROLL] += 5;I8[PITCH]=I8[ROLL];}
      if (param == 3 && (D8[ROLL]>0)) {D8[ROLL] -= 1;D8[PITCH]=D8[ROLL];}
      if (param == 4) {P8[YAW] += 10;}
      blinkLED(10,30,1);
    }
    if (rcData[ROLL] < MAXCHECK && rcData[ROLL]  > MINCHECK) valActive = 0;
    if (rcData[YAW]  < MINCHECK && rcData[PITCH] > MAXCHECK) LCD = 0;
  }
  writeParams();
  blinkLED(20,30,1);
  Serial.begin(SERIAL_COM_SPEED);
}

void blinkLED(uint8_t num, uint8_t wait,uint8_t repeat) {
  uint8_t i,r;
  for (r=0;r<repeat;r++) {
    for(i=0;i<num;i++) {
      LEDPIN_SWITCH //switch LEDPIN state
      BUZZERPIN_ON
      delay(wait);
      BUZZERPIN_OFF
    }
    delay(60);
  }
  BUZZERPIN_OFF
}
  
void setup() {
  Serial.begin(SERIAL_COM_SPEED);
  LEDPIN_PINMODE
  POWERPIN_PINMODE
  BUZZERPIN_PINMODE
  POWERPIN_OFF
  initializeMotors();
  readEEPROM();
  checkFirstTime();
  configureReceiver();
  delay(200);
  POWERPIN_ON
  delay(100);
  i2c_init();
  i2c_WMP_init(250);
  initIMU();
  #if defined(BMP085)
    i2c_BMP085_init();
  #endif
  #if defined(BMA180) 
    i2c_BMA180_init();
  #endif 
  #if defined(BMA020) 
    i2c_BMA020_init();
  #endif
  #if defined(ADXL345)
    i2c_ADXL345_init();
  #endif
  #if defined(ADCACC)
    adc_ACC_init();
  #endif
  #if defined(BI) || defined(TRI) || defined(SERVO_TILT) || defined(GIMBAL) || defined(FLYING_WING)
    initializeServo();
  #elif (NUMBER_MOTOR == 6) && defined(PROMINI)
    initializeSoftPWM();
  #endif
  previousTime = micros();
  #if defined(GIMBAL) || defined(FLYING_WING)
   calibratingA = 400;
  #else
    calibratingA = 0;
  #endif
  calibratingG = 400;
}

// ******** Main Loop *********
void loop () {
  static uint8_t rcDelayCommand; // this indicates the number of time (multiple of RC measurement at 50Hz) the sticks must be maintained to run or switch off motors
  uint8_t axis,i;
  int16_t error;
  int16_t delta;
  static int16_t lastGyro[3] = {0,0,0};
  static int16_t delta1[3];
  static int16_t delta2[3];
  uint16_t maxMotor;
  static int32_t errorGyroI[3] = {0,0,0};
  static int16_t altitudeHold = 0;
  static uint8_t altitudeLock;
  
  if (currentTime > (rcTime + 20000) ) { // 50Hz
    computeRC();
    if (rcData[THROTTLE] < MINCHECK) {
      errorGyroI[ROLL] = 0;
      errorGyroI[PITCH] = 0;
      errorGyroI[YAW] = 0;
      rcDelayCommand++;
      if (rcData[YAW] < MINCHECK && armed == 1) {
        if (rcDelayCommand == 20) { // rcDelayCommand = 20 => 20x20ms = 0.4s = time to wait for a specific RC command to be acknowledged
          armed = 0;
          writeAllMotors(MINCOMMAND);
        }
      } else if (rcData[YAW] < MINCHECK && rcData[PITCH] < MINCHECK && armed == 0) {
        if (rcDelayCommand == 20) {
          calibratingA=400;
          calibratingG=400;
        }
      } else if (rcData[YAW] > MAXCHECK && rcData[PITCH] < MAXCHECK && armed == 0 && calibratingG == 0) {
        if (rcDelayCommand == 20) {
          armed = 1;
          writeAllMotors(MINTHROTTLE);
        }
      } else if (rcData[YAW] > MAXCHECK && rcData[PITCH] > MAXCHECK && armed == 0) {
        if (rcDelayCommand == 20) {
          atomicServo[0] = 125; //we center the yaw gyro in conf mode
          #if defined(LCD_CONF)
            configurationLoop(); //beginning LCD configuration
          #endif
          previousTime = micros();
        }
      } else {
        rcDelayCommand = 0;
      }
    }
    if (rcData[AUX1] > 1700 && (nunchukPresent == 1 || accPresent == 1)) {
      levelModeParam = 1;
      #if defined(BMP085)
        if (altitudeLock == 0) {
          altitudeLock = 1;
          altitudeHold = altitudeSmooth;
        }
      #endif
    } else {
      levelModeParam = 0;
      altitudeLock = 0;
    }
    rcTime = currentTime; 
  }
  
  #if defined(BMP085)
    i2c_BMP085_update();
  #endif
  computeIMU();
  
  #if defined(BMP085)
    if (levelModeParam)
      rcCommand[THROTTLE] = constrain(rcCommand[THROTTLE]-5*(altitudeSmooth-altitudeHold),MINTHROTTLE,min(rcCommand[THROTTLE]+200,MAXTHROTTLE));
  #endif

  // Measure loop rate just afer reading the sensors
  currentTime = micros();
  cycleTime = currentTime - previousTime;
  previousTime = currentTime;

  #ifdef BI
    static int16_t gyroRollSmooth = 0;
    gyroData[ROLL] = ((int32_t)gyroRollSmooth*10+gyroData[ROLL]+5)/11;
    gyroRollSmooth = gyroData[ROLL];
  #endif

  //**** PITCH & ROLL & YAW PID ****    
  for(axis=0;axis<3;axis++) {
    if (levelModeParam == 1 && axis<2 ) rcCommand[axis] = rcCommand[axis]-constrain(angle[axis]*accStrength8/25,-200,+200);  //level mode, nothing more !
    error = rcCommand[axis]*10/P8[axis] - gyroData[axis];
    
    if (abs(gyroData[axis]) < 80 ) {
      errorGyroI[axis] += error; //no more time factor applied (not sure it was really usefull)
      errorGyroI[axis] = constrain(errorGyroI[axis],-2000,+2000); //WindUp
    } else
      errorGyroI[axis] = 0;

    delta = gyroData[axis] - lastGyro[axis];//no more time factor applied (not sure it was really usefull)

    axisPID[axis] =  rcCommand[axis] - gyroData[axis]*dynP8[axis]/10 - (delta1[axis] + delta2[axis] + delta +1)* dynD8[axis] /3; // P & D
    axisPID[axis] += errorGyroI[axis]*I8[axis]/1000; // I
 
    delta2[axis] = delta1[axis];
    delta1[axis] = delta;
    lastGyro[axis] = gyroData[axis];
  }

  #if NUMBER_MOTOR > 3
    //prevent "yaw jump" during yaw correction: the yaw correction should allow the same ammount of motor speed variation in both ways
    if      (rcCommand[THROTTLE]-axisPID[YAW] < MINTHROTTLE) axisPID[YAW] = rcCommand[THROTTLE]-MINTHROTTLE;
    else if (rcCommand[THROTTLE]+axisPID[YAW] < MINTHROTTLE) axisPID[YAW] = -rcCommand[THROTTLE]+MINTHROTTLE;
    else if (rcCommand[THROTTLE]+axisPID[YAW] > MAXTHROTTLE) axisPID[YAW] = MAXTHROTTLE-rcCommand[THROTTLE];
    else if (rcCommand[THROTTLE]-axisPID[YAW] > MAXTHROTTLE) axisPID[YAW] = -MAXTHROTTLE+rcCommand[THROTTLE];
    axisPID[YAW] = constrain(axisPID[YAW],-50-abs(rcCommand[YAW]),+50+abs(rcCommand[YAW]));
  #endif

  #ifdef BI
    motor[0] = rcCommand[THROTTLE] + axisPID[PITCH]; //REAR
    motor[1] = rcCommand[THROTTLE] - axisPID[PITCH]; //FRONT
    servo[0]  = constrain(1500 + YAW_DIRECTION * axisPID[YAW] - axisPID[ROLL], 1020, 2000); //REAR
    servo[1]  = constrain(1500 + YAW_DIRECTION * axisPID[YAW] + axisPID[ROLL], 1020, 2000); //FRONT
  #endif
  #ifdef TRI
    motor[0] = rcCommand[THROTTLE] + axisPID[PITCH]*4/3 ; //REAR
    motor[1] = rcCommand[THROTTLE] - axisPID[ROLL] - axisPID[PITCH]*2/3 ; //RIGHT
    motor[2] = rcCommand[THROTTLE] + axisPID[ROLL] - axisPID[PITCH]*2/3 ; //LEFT
    servo[0] = constrain(1500 + YAW_DIRECTION * axisPID[YAW], 1020, 2000); //REAR
  #endif
  #ifdef QUADP
    motor[0] = rcCommand[THROTTLE] + axisPID[PITCH] - YAW_DIRECTION * axisPID[YAW]; //REAR
    motor[1] = rcCommand[THROTTLE] - axisPID[ROLL]  + YAW_DIRECTION * axisPID[YAW]; //RIGHT
    motor[2] = rcCommand[THROTTLE] + axisPID[ROLL]  + YAW_DIRECTION * axisPID[YAW]; //LEFT
    motor[3] = rcCommand[THROTTLE] - axisPID[PITCH] - YAW_DIRECTION * axisPID[YAW]; //FRONT
  #endif
  #ifdef QUADX
    motor[0] = rcCommand[THROTTLE] - axisPID[ROLL] + axisPID[PITCH] - YAW_DIRECTION * axisPID[YAW]; //REAR_R
    motor[1] = rcCommand[THROTTLE] - axisPID[ROLL] - axisPID[PITCH] + YAW_DIRECTION * axisPID[YAW]; //FRONT_R
    motor[2] = rcCommand[THROTTLE] + axisPID[ROLL] + axisPID[PITCH] + YAW_DIRECTION * axisPID[YAW]; //REAR_L
    motor[3] = rcCommand[THROTTLE] + axisPID[ROLL] - axisPID[PITCH] - YAW_DIRECTION * axisPID[YAW]; //FRONT_L
  #endif
  #ifdef Y6
    motor[0] = rcCommand[THROTTLE]                 + axisPID[PITCH]*4/3 + YAW_DIRECTION * axisPID[YAW]; //REAR
    motor[1] = rcCommand[THROTTLE] - axisPID[ROLL] - axisPID[PITCH]*2/3 - YAW_DIRECTION * axisPID[YAW]; //RIGHT
    motor[2] = rcCommand[THROTTLE] + axisPID[ROLL] - axisPID[PITCH]*2/3 - YAW_DIRECTION * axisPID[YAW]; //LEFT
    motor[3] = rcCommand[THROTTLE]                 + axisPID[PITCH]*4/3 - YAW_DIRECTION * axisPID[YAW]; //UNDER_REAR
    motor[4] = rcCommand[THROTTLE] - axisPID[ROLL] - axisPID[PITCH]*2/3 + YAW_DIRECTION * axisPID[YAW]; //UNDER_RIGHT
    motor[5] = rcCommand[THROTTLE] + axisPID[ROLL] - axisPID[PITCH]*2/3 + YAW_DIRECTION * axisPID[YAW]; //UNDER_LEFT
  #endif
  #ifdef HEX6
    motor[0] = rcCommand[THROTTLE] - axisPID[ROLL]/2 + axisPID[PITCH]/2 + YAW_DIRECTION * axisPID[YAW]; //REAR_R
    motor[1] = rcCommand[THROTTLE] - axisPID[ROLL]/2 - axisPID[PITCH]/2 - YAW_DIRECTION * axisPID[YAW]; //FRONT_R
    motor[2] = rcCommand[THROTTLE] + axisPID[ROLL]/2 + axisPID[PITCH]/2 + YAW_DIRECTION * axisPID[YAW]; //REAR_L
    motor[3] = rcCommand[THROTTLE] + axisPID[ROLL]/2 - axisPID[PITCH]/2 - YAW_DIRECTION * axisPID[YAW]; //FRONT_L
    motor[4] = rcCommand[THROTTLE]                   - axisPID[PITCH]   + YAW_DIRECTION * axisPID[YAW]; //FRONT
    motor[5] = rcCommand[THROTTLE]                   + axisPID[PITCH]   - YAW_DIRECTION * axisPID[YAW]; //REAR
  #endif
  #ifdef SERVO_TILT
    servo[1] = constrain(TILT_PITCH_MIDDLE + TILT_PITCH_PROP * angle[PITCH] *6 /10 , TILT_PITCH_MIN, TILT_PITCH_MAX);
    servo[2] = constrain(TILT_ROLL_MIDDLE + TILT_ROLL_PROP * angle[ROLL] *6 /10  , TILT_ROLL_MIN, TILT_ROLL_MAX);
  #endif
  #ifdef GIMBAL
    servo[1] = constrain(TILT_PITCH_MIDDLE + TILT_PITCH_PROP * angle[PITCH] *6 /10 + rcCommand[PITCH], TILT_PITCH_MIN, TILT_PITCH_MAX);
    servo[2] = constrain(TILT_ROLL_MIDDLE + TILT_ROLL_PROP * angle[ROLL] *6 /10  + rcCommand[ROLL], TILT_ROLL_MIN, TILT_ROLL_MAX);
  #endif
  #ifdef FLYING_WING
    servo[1]  = constrain(1500 + axisPID[PITCH] - axisPID[ROLL], 1020, 2000); //LEFT the sens of the 2 servo can be changed here: invert the sign before axisPID
    servo[2]  = constrain(1500 + axisPID[PITCH] + axisPID[ROLL], 1020, 2000); //RIGHT
  #endif

  maxMotor=motor[0];
  for(i=1;i< NUMBER_MOTOR;i++)
    if (motor[i]>maxMotor) maxMotor=motor[i];
  for (i = 0; i < NUMBER_MOTOR; i++) {
    if (maxMotor > MAXTHROTTLE) // this is a way to still have good gyro corrections if at least one motor reaches its max.
      motor[i] -= maxMotor - MAXTHROTTLE;
    motor[i] = constrain(motor[i], MINTHROTTLE, MAXTHROTTLE);
    if ((rcData[THROTTLE]) < MINCHECK)
      #ifndef MOTOR_STOP
        motor[i] = MINTHROTTLE;
      #else
        motor[i] = MINCOMMAND;
      #endif
    if (armed == 0)
      motor[i] = MINCOMMAND;
  }

  #if defined(BI) || defined(TRI) || defined(SERVO_TILT) || defined(GIMBAL) || defined(FLYING_WING)
    atomicServo[0] = (servo[0]-1000)/4;
    atomicServo[1] = (servo[1]-1000)/4;
    atomicServo[2] = (servo[2]-1000)/4;
    atomicServo[3] = (servo[3]-1000)/4;
  #endif
  
  writeMotors();
}

static uint8_t point;
static uint8_t s[128];
void serialize16(int16_t a) {s[point++]  = a; s[point++]  = a>>8&0xff;}
void serialize8(int8_t a) {s[point++]  = a;}

void serialCom() {
  int16_t a;
  uint8_t i;
  if (Serial.available()) {
    switch (Serial.read()) {
    case 'A': //arduino to GUI all data
      point=0;
      serialize8('A');
      for(i=0;i<3;i++) serialize16(accSmooth[i]);
      for(i=0;i<3;i++) serialize16(gyroData[i]);
      serialize16(altitudeSmooth);
      serialize16(0); // compas
      for(i=0;i<4;i++) serialize16(servo[i]);
      for(i=0;i<6;i++) serialize16(motor[i]);
      for(i=0;i<5;i++) serialize16(rcHysteresis[i]);      
      serialize8(nunchukPresent);
      serialize8(accPresent);
      serialize8(barometerPresent);
      serialize8(0); //i2C_MagnetoPresent
      serialize8(levelModeParam);
      serialize16(cycleTime);
      for(i=0;i<2;i++) serialize16(angle[i]);
    #if defined(TRI)
      serialize8(1);
    #elif defined(QUADP)
      serialize8(2);
    #elif defined(QUADX)
      serialize8(3);
    #elif defined(BI)
      serialize8(4);
    #elif defined(GIMBAL)
      serialize8(5);
    #elif defined(Y6)
      serialize8(6);
    #elif defined(HEX6)
      serialize8(7);
    #elif defined(FLYING_WING)
      serialize8(8);
    #endif
      for(i=0;i<3;i++) {serialize8(P8[i]);serialize8(I8[i]);serialize8(D8[i]);}
      serialize8(rcRate8); serialize8(rcExpo8);
      serialize8(accStrength8);
      serialize8(rollPitchRate); serialize8(yawRate);
      serialize8(dynThrPID);
      serialize8('A');
      Serial.write(s,point);
      break;      
    case 'C': //GUI to arduino param
      while (Serial.available()<18) {}
      for(i=0;i<3;i++) {P8[i]= Serial.read(); I8[i]= Serial.read(); D8[i]= Serial.read();}
      rcRate8 = Serial.read(); rcExpo8 = Serial.read();
      accStrength8 = Serial.read();
      rollPitchRate = Serial.read(); yawRate = Serial.read();
      dynThrPID = Serial.read();
      writeParams();
      break;
    }
  }
}