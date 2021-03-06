
#include "hl-idl-helpers.h"
#include <hl.h>

HL_PRIM hl_type hltx_ui16 = { HUI16 };
static  hl_type *strType = nullptr;
void hl_cache_string_type( vstring *str) {
   strType = str->t;
   printf("SYSTEM PREAMBLE -- NEED TO REMOVE THIS HACK\n");
}

vstring * hl_utf8_to_hlstr( const char *str) {
    int strLen = (int)strlen( str );
    uchar * ubuf = (uchar*)hl_gc_alloc_noptr((strLen + 1) << 1);
    hl_from_utf8( ubuf, strLen, str );

    vstring* vstr = (vstring *)hl_gc_alloc_raw(sizeof(vstring));

    vstr->bytes = ubuf;
    vstr->length = strLen;
    vstr->t = strType;
    return vstr;
}