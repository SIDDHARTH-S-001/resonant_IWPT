#define pwm_pin 5
#define pos_pin 6
#define neg_pin 7

void setup() {
  // put your setup code here, to run once:
  pinMode(pwm_pin, OUTPUT);
  pinMode(pos_pin, OUTPUT);
  pinMode(neg_pin, OUTPUT);

  analogWrite(pwm_pin, 255);
}


void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(pos_pin, HIGH);
  digitalWrite(neg_pin, LOW);
  delayMicroseconds(106);
  digitalWrite(neg_pin, HIGH);
  digitalWrite(pos_pin, LOW);
  delayMicroseconds(106);
}
