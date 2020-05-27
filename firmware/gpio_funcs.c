#include "xparameters.h"
#include "xgpio.h"
#include "xil_printf.h"
#include "sleep.h"

XGpio Gpio;
u32 gpio_out = 0x00000004;

int init_GPIO(){
    int status;
    status = XGpio_Initialize(&Gpio, XPAR_GPIO_0_DEVICE_ID);
    if (status != XST_SUCCESS) {
        return 1;
    } else {
        return 0;
    }
}

void poke_bit(u32 idx, u32 val){
    // change bit
    gpio_out = (gpio_out & (~(1UL << idx))) | ((val & 1) << idx);
    
    // write value
    XGpio_DiscreteWrite(&Gpio, 2, gpio_out);
    
    // slight delay
    usleep(10);
}

u32 get_word(u32 idx, u32 len){
    usleep(10);
    return ((XGpio_DiscreteRead(&Gpio, 1) >> idx) & ((1UL << len) - 1UL));
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
    return get_word(0, 1);
}

u32 get_tap_state(){
    return get_word(4, 16);
}

u32 get_magic_bits(){
    return get_word(20, 12);
}
