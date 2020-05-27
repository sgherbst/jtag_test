import serial

ser = serial.Serial(
    port='/dev/ttyUSB1',
    baudrate=115200
)

ser.write('ID\n'.encode('utf-8'))
out = ser.readline()

val = int(out.strip())
print(f'Got ID: {val}')

if val != 497598771:
    raise Exception('ID mismatch')
else:
    print('OK!')
