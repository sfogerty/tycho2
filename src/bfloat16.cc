/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
 * Randall Woodall                                                                         *
 * June 15, 2018                                                                           *
 * bfloat16.cc                                                                             *
 * Provides storage methods for a half-precision floating point number.                    *
 * Emphasis on storage optimization and conversion speed.                                  *
 * Follows the intel bfloat16 https://en.wikipedia.org/wiki/Bfloat16_floating-point_format *
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
 */
#include <cstdlib>
#include <cstdio>
#include "bfloat16.hh"

//Initialize the value to a memory address for short.
bfloat16::bfloat16() {
    //value = (short*)malloc(sizeof(short));
    value = 0;
}

//Value added constructor taking a value.
bfloat16::bfloat16(float to_convert) {
    value = (*(int *)&to_convert >> 16) | 0x0000;
}

void bfloat16::set_value(float to_convert) {
    value = (*(int *)&to_convert >> 16) | 0x0000;
}

//Convert a bfloat16 to a float
float bfloat16::get_value() {
    int * toRet = (int*)malloc(sizeof(int));
    (*toRet) = value << 16;
    return *(float*)toRet;
}
