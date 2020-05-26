#include "xgpio.h"

int init_GPIO();

void poke_tdi(u32 val);

void poke_tck(u32 val);

void poke_tms(u32 val);

void poke_trst_n(u32 val);

u32 get_tdo();

u32 get_tap_state();

u32 get_magic_bits();
