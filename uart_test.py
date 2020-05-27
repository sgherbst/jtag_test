import serial

# connect to the CPU

ser = serial.Serial(
    port='/dev/ttyUSB1',
    baudrate=115200
)

# read the ID

ser.write('ID\n'.encode('utf-8'))
out = ser.readline()

# quit the program

ser.write('EXIT\n'.encode('utf-8'))

# check results

val = int(out.strip())
print(f'Got ID: {val}')

if val != 497598771:
    raise Exception('ID mismatch')
else:
    print('OK!')
