#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "fmmacar.h"
#include "tomacar.h"

#define PkgName "Lingua::AR::MacArabic"

/* Perl 5.6.1 ? */
#ifndef uvuni_to_utf8
#define uvuni_to_utf8   uv_to_utf8
#endif /* uvuni_to_utf8 */

/* Perl 5.6.1 ? */
#ifndef utf8n_to_uvuni
#define utf8n_to_uvuni  utf8_to_uv
#endif /* utf8n_to_uvuni */

#define SBCS_LEN	1

#define MAC_AR_DIR_NT	0
#define MAC_AR_DIR_LR	1
#define MAC_AR_DIR_RL	2

#define MAC_AR_UV_PDF	0x202C
#define MAC_AR_UV_LRO	0x202D
#define MAC_AR_UV_RLO	0x202E

static U8 ** mac_ar_table [] = {
    to_mac_ar_N,
    to_mac_ar_L,
    to_mac_ar_R
};

MODULE = Lingua::AR::MacArabic	PACKAGE = Lingua::AR::MacArabic

void
decode(src)
    SV* src
  PROTOTYPE: $
  ALIAS:
    decodeMacArabic = 1
  PREINIT:
    SV *dst;
    STRLEN srclen;
    U8 *s, *e, *p, uni[UTF8_MAXLEN + 1];
    UV uv;
    STDCHAR curdir, predir;
  PPCODE:
    if (SvUTF8(src)) {
	src = sv_mortalcopy(src);
	sv_utf8_downgrade(src, 0);
    }
    s = (U8*)SvPV(src,srclen);
    e = s + srclen;
    dst = sv_2mortal(newSV(1));
    (void)SvPOK_only(dst);
    SvUTF8_on(dst);

    predir = MAC_AR_DIR_NT;
    for (p = s; p < e; p++, predir = curdir) {
	curdir = fm_mac_ar_dir[*p];

	if (predir != curdir) {
	    if (predir != MAC_AR_DIR_NT) {
		uv = MAC_AR_UV_PDF;
		(void)uvuni_to_utf8(uni, uv);
		sv_catpvn(dst, (char*)uni, (STRLEN)UNISKIP(uv));
	    }
	    if (curdir != MAC_AR_DIR_NT) {
		uv = (curdir == MAC_AR_DIR_LR) ? MAC_AR_UV_LRO :
		     (curdir == MAC_AR_DIR_RL) ? MAC_AR_UV_RLO :
		     0; /* Panic: undefined direction in decode" */;
		(void)uvuni_to_utf8(uni, uv);
		sv_catpvn(dst, (char*)uni, (STRLEN)UNISKIP(uv));
	    }
	}

	uv = fm_mac_ar_tbl[*p];
	(void)uvuni_to_utf8(uni, uv);
	sv_catpvn(dst, (char*)uni, (STRLEN)UNISKIP(uv));
    }

    if (predir != MAC_AR_DIR_NT) {
	uv = MAC_AR_UV_PDF;
	(void)uvuni_to_utf8(uni, uv);
	sv_catpvn(dst, (char*)uni, (STRLEN)UNISKIP(uv));
    }
    XPUSHs(dst);



void
encode(arg1, arg2 = 0)
    SV* arg1
    SV* arg2
  PROTOTYPE: $;$
  ALIAS:
    encodeMacArabic = 1
  PREINIT:
    SV *src, *dst, *ref;
    STRLEN srclen, retlen;
    U8 *s, *e, *p;
    U8 b, *t, **table;
    UV uv;
    STDCHAR dir;
    bool cv = 0;
    bool pv = 0;
  PPCODE:
    src = arg1;
    if (items == 2) {
	if (SvROK(arg1)) {
	    ref = SvRV(arg1);
	    if (SvTYPE(ref) == SVt_PVCV)
		cv = TRUE;
	    else if (SvPOK(ref))
		pv = TRUE;
	    else
		croak(PkgName " 1st argument is not STRING nor CODEREF");
	}
	src = arg2;
    }

    if (!SvUTF8(src)) {
	src = sv_mortalcopy(src);
	sv_utf8_upgrade(src);
    }
    s = (U8*)SvPV(src,srclen);
    e = s + srclen;
    dst = sv_2mortal(newSV(1));
    (void)SvPOK_only(dst);
    SvUTF8_off(dst);

    dir = MAC_AR_DIR_NT;

    for (p = s; p < e;) {
	uv = utf8n_to_uvuni(p, e - p, &retlen, 0);
	p += retlen;

	switch (uv) {
	case MAC_AR_UV_PDF:
	    dir = MAC_AR_DIR_NT;
	    break;
	case MAC_AR_UV_LRO:
	    dir = MAC_AR_DIR_LR;
	    break;
	case MAC_AR_UV_RLO:
	    dir = MAC_AR_DIR_RL;
	    break;
	default:
	    table = mac_ar_table[dir];
	    t = uv < 0x10000 ? table[uv >> 8] : NULL;
	    b = t ? t[uv & 0xff] : 0;

	    if (b || uv == 0) {
		sv_catpvn(dst, (char*)&b, SBCS_LEN);
	    }
	    else if (pv) {
		sv_catsv(dst, ref);
	    }
	    else if (cv) {
		dSP;
		int count;
		ENTER;
		SAVETMPS;
		PUSHMARK(SP);
		XPUSHs(sv_2mortal(newSVuv(uv)));
		PUTBACK;
		count = call_sv(ref, G_SCALAR);
		SPAGAIN;
		if (count != 1)
		    croak("Panic in XS, " PkgName "\n");
		sv_catsv(dst,POPs);
		PUTBACK;
		FREETMPS;
		LEAVE;
	    }
	}
    }
    XPUSHs(dst);

