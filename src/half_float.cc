/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
 * Randall Woodall                                                      *
 * June 15, 2018                                                        *
 * half_float_store.cc                                                  *
 * Provides storage methods for a half-precision floating point number. *
 * Emphasis on storage optimization.                                    *
 * Follows IEEE-754-2008                                                *
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
 */
#include <cstdlib>
#include <cstdio>
#include "half_float.hh"

//Initialize the value to a memory address for short.
half_float::half_float() {
    value = 0;
}

//Value added constructor taking a value.
half_float::half_float(float to_convert) {
    value = 0;
    set_value(to_convert);
}

//Convert a given floating point number to half-float.
void half_float::set_value(float to_convert_f) {
    //Convert to an integer point for bitwise, declare exponent
    int to_convert = *(int *)&to_convert_f, exponent;
    //Clear value
    value = 0x0000;
    //Pull the sign bit (from 32), and shift it to the MSB of new float
    value = 0x8000 & (to_convert >> 16);
    //Pull the most significant 10 mantissa bits (12 through 22)
    value = value | (0x03FF & (to_convert >> 13));
    //Pull the exponent field, normalize and set up for half precision
    exponent = (0x00FF & (to_convert >> 23)) - 127 + 15;
    //Put in the exponent
    value = value | ((exponent << 10) & 0x7C00);
}

//Convert a half_float to a float
float half_float::get_value() {
    int * toRet = (int*)malloc(sizeof(int));
    int exponent = (value & 0x7C00) >> 10;
    //Check for special cases of the exponent
    //If the exponent is 11111, we will assume real values were the origin
    if((exponent ^ 0x001F) == 0)
        exponent = 0x00FF; //We lost too much value and hit infinity.
    //Else assume normalized
    else
        exponent = exponent - 15 + 127;
    (*toRet) =((0x8000 & value) << 16) | (exponent << 23) | ((0x03FF & value) << 13);
    return *(float*)toRet;
}