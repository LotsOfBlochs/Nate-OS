#pragma once

#include <stdint.h>

#define low_16(address) (uint16_t)((address) & 0xffff)
#define mid_16(address) (uint16_t)(((address) >> 16) & 0xffff)
#define high_32(address) (uint32_t)(((address) >> 32) & 0xffffffff)