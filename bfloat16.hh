/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
 * Randall Woodall                                                                         *
 * June 15, 2018                                                                           *
 * bfloat16.hh                                                                             *
 * Provides storage headers for a half-precision floating point number.                    *
 * Emphasis on storage optimization and conversion speed.                                  *
 * Follows the intel bfloat16 https://en.wikipedia.org/wiki/Bfloat16_floating-point_format *
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
 */
#ifndef BFLOAT16
#define BFLOAT16
//A new type that declares the space required for half a float (16-bits)
//(Utilizes a short.)
class bfloat16 {
    private:
        short value;
    public:
        bfloat16();
        bfloat16(float to_convert);
        void set_value(float to_convert);
        float get_value();
};
#endif
