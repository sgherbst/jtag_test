# import modules
print('Importing modules...')
import os
import serial
import serial.tools.list_ports

# determine the USB port
print('Determining the USB port...')
ser_port = os.environ.get('UART_DEV_NAME', None)
if ser_port is None:
    matches = serial.tools.list_ports.grep('CP2103')
    match = list(matches)[0]
    ser_port = str(match.device)
print(f'Will use {ser_port}')

# connect to the CPU
print('Connecting to the CPU...')
ser = serial.Serial(
    port=ser_port,
    baudrate=115200,
    timeout=30.0  # prevent test from hanging forever
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
