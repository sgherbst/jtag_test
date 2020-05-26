#include "xparameters.h"
#include "xgpio.h"
#include "xil_printf.h"
#include "sleep.h"

XGpio Gpio;

u32 gpio_out = 0x00000004;

void poke_bit(u32 idx, u32 val){
	// change bit
	gpio_out = (gpio_out & (~(1UL << idx))) | ((val & 1) << idx);

	// write value
	XGpio_DiscreteWrite(&Gpio, 2, gpio_out);

	// slight delay
    usleep(10);
}

void poke_tdi(u32 val){
	poke_bit(3, val);
}

void poke_tck(u32 val){
	poke_bit(0, val);
}

void poke_tms(u32 val){
	poke_bit(2, val);
}

void poke_trst_n(u32 val){
	poke_bit(1, val);
}

u32 get_tdo(){
	usleep(10);
	return (XGpio_DiscreteRead(&Gpio, 1) & 1);
}

u32 get_tap_state(){
	usleep(10);
	return ((XGpio_DiscreteRead(&Gpio, 1) >> 4) & 0xffff);
}

u32 get_magic_bits(){
	usleep(10);
	return ((XGpio_DiscreteRead(&Gpio, 1) >> 20) & 0xfff);
}

void cycle(){
	poke_tck(1);
	poke_tck(0);
}

void do_reset(){
	// initialize signals
    poke_tdi(0);
    poke_tck(0);
    poke_tms(1);
    poke_trst_n(0);
    cycle();

    // de-assert reset
    poke_trst_n(1);
    cycle();

    // go to the IDLE state
    poke_tms(1);
    cycle();
    for (u32 i=0; i<10; i++){
    	cycle();
    }

    poke_tms(0);
    cycle();
}

void shift_ir (u32 inst_in, u32 length) {
    // Move to Select-DR-Scan state
    poke_tms(1);
    cycle();

    // Move to Select-IR-Scan state
    poke_tms(1);
    cycle();

    // Move to Capture IR state
    poke_tms(0);
    cycle();

    // Move to Shift-IR state
    poke_tms(0);
    cycle();

    // Remain in Shift-IR state and shift in inst_in.
    // Observe the TDO signal to read the x_inst_out
    for (u32 i=0; i<(length-1); i++){
        poke_tdi((inst_in >> i) & 1);
        cycle();
    }

    // Shift in the last bit and switch to Exit1-IR state
    poke_tdi((inst_in >> (length - 1)) & 1);
    poke_tms(1);
    cycle();

    // Move to Update-IR state
    poke_tms(1);
    cycle();

    // Move to Run-Test/Idle state
    poke_tms(0);
    cycle();
    cycle();
}

u32 shift_dr (u32 data_in, u32 length) {
	// Move to Select-DR-Scan state
    poke_tms(1);
    cycle();

    // Move to Capture-DR state
    poke_tms(0);
    cycle();

    // Move to Shift-DR state
    poke_tms(0);
    cycle();

    // Remain in Shift-DR state and shift in data_in.
	// Observe the TDO signal to read the data_out
    u32 retval = 0;
    for (u32 i=0; i<(length-1); i++){
        poke_tdi((data_in >> i) & 1);
        retval |= (get_tdo() << i);
        cycle();
    }

    // Shift in the last bit and switch to Exit1-DR state
    poke_tdi((data_in >> (length - 1)) & 1);
    retval |= (get_tdo() << (length-1));
    poke_tms(1);
    cycle();

    // Move to Update-DR state
    poke_tms(1);
    cycle();

    // Move to Run-Test/Idle state
    poke_tms(0);
    cycle();
    cycle();

	// Return result
	return retval;
}

u32 read_id(){
    shift_ir(1, 5);
    return shift_dr(0, 32);
}

int main()
{
	int Status;

	/* Initialize the GPIO driver */
	Status = XGpio_Initialize(&Gpio, XPAR_GPIO_0_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("GPIO Initialization Failed\r\n");
		return XST_FAILURE;
	}

	do_reset();

    while(1){
    	xil_printf("magic=0x%03x\r\n", get_magic_bits());
    	xil_printf("id=0x%08x\r\n", read_id());
    	usleep(1000000);
    }

    return 0;
}
