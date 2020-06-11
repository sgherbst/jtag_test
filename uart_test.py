# determine the USB port
import os
ser_port = os.environ.get('UART_DEV_NAME', '/dev/ttyUSB2')

# import PySerial
print('Importing PySerial...')
import serial

# connect to the CPU
print('Connecting to the CPU...')
ser = serial.Serial(
    port=ser_port,
    baudrate=115200
)

# read the ID
print('Sending the ID command...')
ser.write('ID\n'.encode('utf-8'))
print('Reading the response...')
out = ser.readline()

# quit the program
print('Quitting the program...')
ser.write('EXIT\n'.encode('utf-8'))

# check results
print('Checking the results...')
val = int(out.strip())
print(f'Got ID: {val}')

if val != 497598771:
    raise Exception('ID mismatch')
else:
    print('OK!')
