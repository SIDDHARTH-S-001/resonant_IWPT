import numpy as np
import tensorflow as tf
import board
import time
import busio
import adafruit_ads1x15.ads1115 as ADS
from adafruit_ads1x15.analog_in import AnalogIn

# model_path = 'model.tflite'
model_path = '/home/pi/Project/new_model.tflite'
print("loaded model")
interpreter = tf.lite.Interpreter(model_path=model_path)
interpreter.allocate_tensors()
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()
print("Import Successful")

# Initialize the I2C interface
i2c = busio.I2C(board.SCL, board.SDA)

# Create an ADS1115 object
ads = ADS.ADS1115(i2c)

# Define the analog input channel
ch0 = AnalogIn(ads, ADS.P0)
ch1 = AnalogIn(ads, ADS.P1)

# Initialize variables for weighted averages
current_sum = 0
voltage_sum = 0
temp = 23.0

# Number of samples for the weighted average
sample_count = 100

while True:
    # Read and accumulate 100 samples
    for _ in range(sample_count):
        current = ch0.value * (30 / 65535) * (0.0768 / 8.93)
        voltage = ch1.value * (25 / 65535) * (7.68 / 4.66)
        current_sum += current
        voltage_sum += voltage

    # Calculate the weighted average
    weighted_average_current = current_sum / sample_count
    weighted_average_voltage = voltage_sum / sample_count

    # Display the results
    print("Current: {:.2f}".format(current), "voltage: {:.2f}".format(voltage),
          "temperature: {:.2f}".format(temp), "Average Current: {:.2f}".format(weighted_average_current),
          " Average Voltage: {:.2f}".format(weighted_average_voltage))

    inputs = np.array([[voltage, current, temp, weighted_average_voltage, weighted_average_current]], dtype=np.float32)
    
    inputs = inputs.reshape((1, 1, 5))
    interpreter.set_tensor(input_details[0]['index'], inputs)
    interpreter.invoke()
    soc = interpreter.get_tensor(output_details[0]['index'])
    soc = soc[0][0][0] * 100 # in %
    # soc = "{:.2f}".format(soc)
    print("soc: ", soc)
    
    # Reset the sums for the next round
    current_sum = 0
    voltage_sum = 0

    # Sleep for 0.5 seconds
    time.sleep(0.5)



