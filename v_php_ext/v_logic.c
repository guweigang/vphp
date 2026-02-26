
#ifndef V_COMMIT_HASH
	#define V_COMMIT_HASH "6fa4008a2aa1f7ee94b4ef4e5471af5a0a7ed016"
#endif

#define V_USE_SIGNAL_H

// V comptime_definitions:
// V compile time defines by -d or -define flags:
//     All custom defines      : macos
//     Turned ON custom defines: macos
#define CUSTOM_DEFINE_macos

#define __VTHREADS__ (1)

// V typedefs:
typedef struct IError IError;
typedef struct vphp__ITask vphp__ITask;
typedef struct none none;

// BEGIN_multi_return_typedefs
typedef struct multi_return_u32_u32 multi_return_u32_u32;
typedef struct multi_return_string_string multi_return_string_string;
typedef struct multi_return_int_int multi_return_int_int;
typedef struct multi_return_u32_u32_u32 multi_return_u32_u32_u32;
typedef struct multi_return_strconv__ParserState_strconv__PrepNumber multi_return_strconv__ParserState_strconv__PrepNumber;
typedef struct multi_return_u64_int multi_return_u64_int;
typedef struct multi_return_i64_int multi_return_i64_int;
typedef struct multi_return_strconv__Dec32_bool multi_return_strconv__Dec32_bool;
typedef struct multi_return_strconv__Dec64_bool multi_return_strconv__Dec64_bool;
typedef struct multi_return_string_int multi_return_string_int;
typedef struct multi_return_int_bool multi_return_int_bool;
typedef struct multi_return_string_string_string multi_return_string_string_string;
typedef struct multi_return_Array_string_Array_string multi_return_Array_string_Array_string;
typedef struct multi_return_u64_u64 multi_return_u64_u64;
typedef struct multi_return_f64_int multi_return_f64_int;
// END_multi_return_typedefs

typedef struct strings__IndentParam strings__IndentParam;
typedef struct builtin__closure__Closure builtin__closure__Closure;
typedef struct builtin__closure__ClosureMutex builtin__closure__ClosureMutex;
typedef struct strconv__AtoF64Param strconv__AtoF64Param;
typedef struct strconv__BF_param strconv__BF_param;
typedef struct strconv__PrepNumber strconv__PrepNumber;
typedef struct strconv__Dec32 strconv__Dec32;
typedef struct strconv__Dec64 strconv__Dec64;
typedef struct strconv__Uint128 strconv__Uint128;
typedef union strconv__Uf32 strconv__Uf32;
typedef union strconv__Uf64 strconv__Uf64;
typedef union strconv__Float64u strconv__Float64u;
typedef union strconv__Float32u strconv__Float32u;
typedef struct GCHeapUsage GCHeapUsage;
typedef struct array array;
typedef struct _result _result;
typedef struct Error Error;
typedef struct MessageError MessageError;
typedef struct _option _option;
typedef struct None__ None__;
typedef struct InputRuneIterator InputRuneIterator;
typedef struct DenseArray DenseArray;
typedef struct map map;
typedef struct VAssertMetaInfo VAssertMetaInfo;
typedef struct FieldData FieldData;
typedef struct SortedMap SortedMap;
typedef struct mapnode mapnode;
typedef struct string string;
typedef struct RepIndex RepIndex;
typedef struct WrapConfig WrapConfig;
typedef struct RunesIterator RunesIterator;
typedef union StrIntpMem StrIntpMem;
typedef struct StrIntpData StrIntpData;
typedef struct ToWideConfig ToWideConfig;
typedef struct strings__textscanner__TextScanner strings__textscanner__TextScanner;
typedef struct term__termios__Termios term__termios__Termios;
typedef struct vphp__Val vphp__Val;
typedef struct vphp__Context vphp__Context;
typedef struct vphp__MapContext vphp__MapContext;
typedef struct vphp__AsyncResult vphp__AsyncResult;
typedef struct vphp__TaskRegistry vphp__TaskRegistry;
typedef struct os__Command os__Command;
typedef struct os__Eof os__Eof;
typedef struct os__NotExpected os__NotExpected;
typedef struct os__File os__File;
typedef struct os__FileNotOpenedError os__FileNotOpenedError;
typedef struct os__SizeOfTypeIs0Error os__SizeOfTypeIs0Error;
typedef struct os__FileMode os__FileMode;
typedef struct os__FileInfo os__FileInfo;
typedef struct os__FilePermission os__FilePermission;
typedef struct os__CopyParams os__CopyParams;
typedef struct os__PathKind os__PathKind;
typedef struct os__SystemError os__SystemError;
typedef struct os__DiskUsage os__DiskUsage;
typedef struct os__Result os__Result;
typedef struct os__MvParams os__MvParams;
typedef struct os__ExecutableNotFoundError os__ExecutableNotFoundError;
typedef struct os__WalkParams os__WalkParams;
typedef struct os__MkdirParams os__MkdirParams;
typedef struct os__Uname os__Uname;
typedef struct os__Stat os__Stat;
typedef struct os__Pipe os__Pipe;
typedef struct os__IOCapture os__IOCapture;
typedef struct os__Process os__Process;
typedef struct main__Coach main__Coach;
typedef struct main__Database main__Database;
typedef struct main__MotionReport main__MotionReport;
typedef struct main__HeartPoint main__HeartPoint;
typedef struct main__AnalyzeTask main__AnalyzeTask;
typedef struct _result_int _result_int;
typedef struct _result_f64 _result_f64;
typedef struct _result_u64 _result_u64;
typedef struct _result_i64 _result_i64;
typedef struct _result_multi_return_i64_int _result_multi_return_i64_int;
typedef struct _result_i8 _result_i8;
typedef struct _result_i16 _result_i16;
typedef struct _result_i32 _result_i32;
typedef struct _result_u8 _result_u8;
typedef struct _result_u16 _result_u16;
typedef struct _result_u32 _result_u32;
typedef struct _result_void _result_void;
typedef struct _result_rune _result_rune;
typedef struct _result_string _result_string;
typedef struct _result_vphp__Val _result_vphp__Val;
typedef struct _result_os__Command _result_os__Command;
typedef struct _result_os__File _result_os__File;
typedef struct _result_FILE_ptr _result_FILE_ptr;
typedef struct _result_os__Stat _result_os__Stat;
typedef struct _result_Array_u8 _result_Array_u8;
typedef struct _result_strings__Builder _result_strings__Builder;
typedef struct _result_Array_string _result_Array_string;
typedef struct _result_os__Result _result_os__Result;
typedef struct _result_os__DiskUsage _result_os__DiskUsage;
typedef struct _result_os__Pipe _result_os__Pipe;
typedef struct _result_os__IOCapture _result_os__IOCapture;
typedef struct _result_anon_fn_os__signal _result_anon_fn_os__signal;
typedef struct _option_rune _option_rune;
typedef struct _option_multi_return_string_string _option_multi_return_string_string;
typedef struct _option_int _option_int;
typedef struct _option_anon_fn___vphp__ITask _option_anon_fn___vphp__ITask;
typedef struct _option_string _option_string;

 // V preincludes:

#if defined(__TINYC__) && defined(__has_include) // tcc does not support has_include properly yet, turn it off completely
#undef __has_include
#endif

// V cheaders:
// Generated by the V compiler

#if defined __GNUC__ && __GNUC__ >= 14
#pragma GCC diagnostic warning "-Wimplicit-function-declaration"
#pragma GCC diagnostic warning "-Wincompatible-pointer-types"
#pragma GCC diagnostic warning "-Wint-conversion"
#pragma GCC diagnostic warning "-Wreturn-mismatch"
#endif


#if defined(__TINYC__) && defined(__has_include) // tcc does not support has_include properly yet, turn it off completely
#undef __has_include
#endif

#if defined(__has_include)
#if __has_include(<inttypes.h>)
#include <inttypes.h>
#else
#error VERROR_MESSAGE The C compiler can not find <inttypes.h>. Please install the package `build-essential`.
#endif
#else
#include <inttypes.h>
#endif


#if defined(__has_include)
#if __has_include(<stddef.h>)
#include <stddef.h>
#else
#error VERROR_MESSAGE The C compiler can not find <stddef.h>. Please install the package `build-essential`.
#endif
#else
#include <stddef.h>
#endif


//================================== builtin types ================================*/
#if defined(__x86_64__) || defined(_M_AMD64) || defined(__aarch64__) || defined(__arm64__) || defined(_M_ARM64) || (defined(__riscv_xlen) && __riscv_xlen == 64) || defined(__s390x__) || (defined(__powerpc64__) && defined(__LITTLE_ENDIAN__)) || defined(__loongarch64)
typedef int64_t vint_t;
#else
typedef int32_t vint_t;
#endif
typedef int64_t i64;
typedef int16_t i16;
typedef int8_t i8;
typedef uint64_t u64;
typedef uint32_t u32;
typedef uint8_t u8;
typedef uint16_t u16;
typedef u8 byte;
typedef int32_t i32;
typedef uint32_t rune;
typedef size_t usize;
typedef ptrdiff_t isize;
#ifndef VNOFLOAT
typedef float f32;
typedef double f64;
#else
typedef int32_t f32;
typedef int64_t f64;
#endif
typedef int64_t int_literal;
#ifndef VNOFLOAT
typedef double float_literal;
#else
typedef int64_t float_literal;
#endif
typedef unsigned char* byteptr;
typedef void* voidptr;
typedef char* charptr;
typedef u8 array_fixed_byte_300 [300];
typedef struct sync__Channel* chan;
#ifndef CUSTOM_DEFINE_no_bool
	#ifndef __cplusplus
		#ifndef bool
			#ifdef CUSTOM_DEFINE_4bytebool
				typedef int bool;
			#else
				typedef u8 bool;
			#endif
			#define true 1
			#define false 0
		#endif
	#endif
#endif


typedef u64 (*MapHashFn)(voidptr);
typedef bool (*MapEqFn)(voidptr, voidptr);
typedef void (*MapCloneFn)(voidptr, voidptr);
typedef void (*MapFreeFn)(voidptr);

//============================== HELPER C MACROS =============================*/
// _SLIT0 is used as NULL string for literal arguments
// `"" s` is used to enforce a string literal argument
#define _SLIT0 (string){.str=(byteptr)(""), .len=0, .is_lit=1}
#define _S(s) ((string){.str=(byteptr)("" s), .len=(sizeof(s)-1), .is_lit=1})
#define _SLEN(s, n) ((string){.str=(byteptr)("" s), .len=n, .is_lit=1})
// optimized way to compare literal strings
#define _SLIT_EQ(sptr, slen, lit) (slen == sizeof("" lit)-1 && !builtin__vmemcmp(sptr, "" lit, slen))
#define _SLIT_NE(sptr, slen, lit) (slen != sizeof("" lit)-1 || builtin__vmemcmp(sptr, "" lit, slen))
// take the address of an rvalue
#define ADDR(type, expr) (&((type[]){expr}[0]))
// copy something to the heap
#define HEAP(type, expr) ((type*)builtin__memdup((void*)&((type[]){expr}[0]), sizeof(type)))
#define HEAP_noscan(type, expr) ((type*)builtin__memdup_noscan((void*)&((type[]){expr}[0]), sizeof(type)))
#define HEAP_align(type, expr, align) ((type*)builtin__memdup_align((void*)&((type[]){expr}[0]), sizeof(type), align))
#define _PUSH_MANY(arr, val, tmp, tmp_typ) {tmp_typ tmp = (val); builtin__array_push_many(arr, tmp.data, tmp.len);}
#define _PUSH_MANY_noscan(arr, val, tmp, tmp_typ) {tmp_typ tmp = (val); builtin__array_push_many_noscan(arr, tmp.data, tmp.len);}

#define E_STRUCT_DECL
#define E_STRUCT
#define __NOINLINE __attribute__((noinline))
#define __IRQHANDLER __attribute__((interrupt))
#define __V_architecture 0
#if defined(__x86_64__) || defined(_M_AMD64)
	#define __V_amd64  1
	#undef __V_architecture
	#define __V_architecture 1
#endif
#if defined(__aarch64__) || defined(__arm64__) || defined(_M_ARM64)
	#define __V_arm64  1
	#undef __V_architecture
	#define __V_architecture 2
#endif
#if defined(__arm__) || defined(_M_ARM)
	#define __V_arm32  1
	#undef __V_architecture
	#define __V_architecture 3
#endif
#if defined(__riscv) && __riscv_xlen == 64
	#define __V_rv64  1
	#undef __V_architecture
	#define __V_architecture 4
#endif
#if defined(__riscv) && __riscv_xlen == 32
	#define __V_rv32  1
	#undef __V_architecture
	#define __V_architecture 5
#endif
#if defined(__i386__) || defined(_M_IX86)
	#define __V_x86    1
	#undef __V_architecture
	#define __V_architecture 6
#endif
#if defined(__s390x__)
	#define __V_s390x  1
	#undef __V_architecture
	#define __V_architecture 7
#endif
#if defined(__powerpc64__) && defined(__LITTLE_ENDIAN__)
	#define __V_ppc64le  1
	#undef __V_architecture
	#define __V_architecture 8
#endif
#if defined(__loongarch64)
	#define __V_loongarch64  1
	#undef __V_architecture
	#define __V_architecture 9
#endif
// Using just __GNUC__ for detecting gcc, is not reliable because other compilers define it too:
#ifdef __GNUC__
	#define __V_GCC__
#endif
#ifdef __TINYC__
	#undef __V_GCC__
#endif
#ifdef __cplusplus
	#undef __V_GCC__
#endif
#ifdef __clang__
	#undef __V_GCC__
#endif
#ifdef _MSC_VER
	#undef __V_GCC__
	#undef E_STRUCT_DECL
	#undef E_STRUCT
	#define E_STRUCT_DECL unsigned char _dummy_pad
	#define E_STRUCT 0
#endif
#ifndef _WIN32
	#if defined __has_include
		#if __has_include (<execinfo.h>)
			#include <execinfo.h>
		#else
			// On linux: int backtrace(void **__array, int __size);
			// On BSD: size_t backtrace(void **, size_t);
		#endif
	#endif
#endif
#ifdef __TINYC__
	#define _Atomic volatile
	#undef E_STRUCT_DECL
	#undef E_STRUCT
	#define E_STRUCT_DECL unsigned char _dummy_pad
	#define E_STRUCT 0
	#undef __NOINLINE
	#undef __IRQHANDLER
	// tcc does not support inlining at all
	#define __NOINLINE
	#define __IRQHANDLER
	// #include <byteswap.h>
	int tcc_backtrace(const char *fmt, ...);
#endif
// Use __offsetof_ptr instead of __offset_of, when you *do* have a valid pointer, to avoid UB:
#ifndef __offsetof_ptr
	#define __offsetof_ptr(ptr,PTYPE,FIELDNAME) ((size_t)((byte *)&((PTYPE *)ptr)->FIELDNAME - (byte *)ptr))
#endif
// for __offset_of
#ifndef __offsetof
#if defined(__TINYC__) || defined(_MSC_VER)
	#define __offsetof(PTYPE,FIELDNAME) ((size_t)(&((PTYPE *)0)->FIELDNAME))
#else
	#define __offsetof(st, m) __builtin_offsetof(st, m)
#endif
#endif
#if defined(_WIN32) || defined(__CYGWIN__)
	#define VV_EXP extern __declspec(dllexport)
	#define VV_LOC static
#else
	// 4 < gcc < 5 is used by some older Ubuntu LTS and Centos versions,
	// and does not support __has_attribute(visibility) ...
	#ifndef __has_attribute
		#define __has_attribute(x) 0  // Compatibility with non-clang compilers.
	#endif
	#if (defined(__GNUC__) && (__GNUC__ >= 4)) || (defined(__clang__) && __has_attribute(visibility))
		#ifdef ARM
			#define VV_EXP  extern __attribute__((externally_visible,visibility("default")))
		#else
			#define VV_EXP  extern __attribute__((visibility("default")))
		#endif
		#if defined(__clang__) && (defined(_VUSECACHE) || defined(_VBUILDMODULE))
			#define VV_LOC static
		#else
			#define VV_LOC  __attribute__ ((visibility ("hidden")))
		#endif
	#else
		#define VV_EXP extern
		#define VV_LOC static
	#endif
#endif
#ifdef __cplusplus
	#include <utility>
	#define _MOV std::move
#else
	#define _MOV
#endif
#if defined(__TINYC__) && defined(__has_include) // tcc does not support has_include properly yet, turn it off completely
#undef __has_include
#endif
//likely and unlikely macros
#if defined(__GNUC__) || defined(__INTEL_COMPILER) || defined(__clang__)
	#define _likely_(x)  __builtin_expect(x,1)
	#define _unlikely_(x)  __builtin_expect(x,0)
#else
	#define _likely_(x) (x)
	#define _unlikely_(x) (x)
#endif

// c_headers
typedef int (*qsort_callback_func)(const void*, const void*);
#include <stdio.h>  // TODO: remove all these includes, define all function signatures and types manually
#include <stdlib.h>
#include <string.h>
#include <stdarg.h> // for va_list
#if defined(__TINYC__)
// https://lists.nongnu.org/archive/html/tinycc-devel/2025-10/msg00007.html
// gnu headers use to #define __attribute__ to empty for non-gcc compilers
#undef __attribute__
#endif
//================================== GLOBALS =================================*/
void _vinit(int ___argc, voidptr ___argv);
void _vcleanup(void);
#ifdef _WIN32
	// workaround for windows, export _vinit_caller/_vcleanup_caller, let dl.open()/dl.close() call it
	// NOTE: This is hardcoded in vlib/dl/dl_windows.c.v!
	VV_EXP void _vinit_caller();
	VV_EXP void _vcleanup_caller();
#endif
#define sigaction_size sizeof(sigaction);
#define _ARR_LEN(a) ( (sizeof(a)) / (sizeof(a[0])) )
#if INTPTR_MAX == INT32_MAX
	#define TARGET_IS_32BIT 1
#elif INTPTR_MAX == INT64_MAX
	#define TARGET_IS_64BIT 1
#else
	#error "The environment is not 32 or 64-bit."
#endif
#if defined(__BYTE_ORDER__) && __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__ || defined(__BYTE_ORDER) && __BYTE_ORDER == __BIG_ENDIAN || defined(__BIG_ENDIAN__) || defined(__ARMEB__) || defined(__THUMBEB__) || defined(__AARCH64EB__) || defined(_MIBSEB) || defined(__MIBSEB) || defined(__MIBSEB__)
	#define TARGET_ORDER_IS_BIG 1
#elif defined(__BYTE_ORDER__) && __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__ || defined(__BYTE_ORDER) && __BYTE_ORDER == __LITTLE_ENDIAN || defined(__LITTLE_ENDIAN__) || defined(__ARMEL__) || defined(__THUMBEL__) || defined(__AARCH64EL__) || defined(_MIPSEL) || defined(__MIPSEL) || defined(__MIPSEL__) || defined(_M_AMD64) || defined(_M_ARM64) || defined(_M_X64) || defined(_M_IX86)
	#define TARGET_ORDER_IS_LITTLE 1
#else
	#error "Unknown architecture endianness"
#endif
#ifndef _WIN32
	#include <ctype.h>
	#include <locale.h> // tolower
	#include <sys/time.h>
	#include <unistd.h> // sleep
	extern char **environ;
	#include <pthread.h>
	#ifndef PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP
		// musl does not have that
		#define pthread_rwlockattr_setkind_np(a, b)
	#endif
#endif
#if defined(__linux__) || defined(__APPLE__) || defined(__FreeBSD__) || defined(__DragonFly__) || defined(__vinix__) || defined(__serenity__) || defined(__sun) || defined(__plan9__) || defined(__OpenBSD__)
	#include <sys/types.h>
	#include <sys/wait.h> // for os__wait
#endif
#ifdef __OpenBSD__
	#include <sys/resource.h>
#endif
#ifdef __FreeBSD__
	#include <signal.h>
	#include <execinfo.h>
#endif
#ifdef __NetBSD__
	#include <sys/wait.h> // for os__wait
#endif
#ifdef __TERMUX__
#if !defined(__BIONIC_AVAILABILITY_GUARD)
	#define __BIONIC_AVAILABILITY_GUARD(api_level) 0
#endif
#if __BIONIC_AVAILABILITY_GUARD(28)
#else
void * aligned_alloc(size_t alignment, size_t size) { return malloc(size); }
#endif
#endif
#ifdef _WIN32
	#define WINVER 0x0600
	#ifdef _WIN32_WINNT
		#undef _WIN32_WINNT
	#endif
	#define _WIN32_WINNT 0x0600
	#ifndef WIN32_FULL
	#define WIN32_LEAN_AND_MEAN
	#endif
	#ifndef _UNICODE
	#define _UNICODE
	#endif
	#ifndef UNICODE
	#define UNICODE
	#endif
	#include <windows.h>
	#include <io.h> // _waccess
	#include <direct.h> // _wgetcwd
	#ifdef V_USE_SIGNAL_H
	#include <signal.h> // signal and SIGSEGV for segmentation fault handler
	#endif
	#ifdef _MSC_VER
		// On MSVC these are the same (as long as /volatile:ms is passed)
		#define _Atomic volatile
		// MSVC cannot parse some things properly
		#undef __NOINLINE
		#undef __IRQHANDLER
		#define __NOINLINE __declspec(noinline)
		#define __IRQHANDLER __declspec(naked)
		#include <dbghelp.h>
		#pragma comment(lib, "Dbghelp")
	#endif
#endif
#if defined(__CYGWIN__) && !defined(_WIN32)
	#error Cygwin is not supported, please use MinGW or Visual Studio.
#endif
#if defined(__MINGW32__) || defined(__MINGW64__) || (defined(_WIN32) && defined(__TINYC__))
	#undef PRId64
	#undef PRIi64
	#undef PRIo64
	#undef PRIu64
	#undef PRIx64
	#undef PRIX64
	#define PRId64 "lld"
	#define PRIi64 "lli"
	#define PRIo64 "llo"
	#define PRIu64 "llu"
	#define PRIx64 "llx"
	#define PRIX64 "llX"
#endif
#ifdef _VFREESTANDING
#undef _VFREESTANDING
#endif


// unsigned/signed comparisons
static inline bool _us32_gt(uint32_t a, int32_t b) { return a > INT32_MAX || (int32_t)a > b; }
static inline bool _us32_ge(uint32_t a, int32_t b) { return a >= INT32_MAX || (int32_t)a >= b; }
static inline bool _us32_eq(uint32_t a, int32_t b) { return a <= INT32_MAX && (int32_t)a == b; }
static inline bool _us32_ne(uint32_t a, int32_t b) { return a > INT32_MAX || (int32_t)a != b; }
static inline bool _us32_le(uint32_t a, int32_t b) { return a <= INT32_MAX && (int32_t)a <= b; }
static inline bool _us32_lt(uint32_t a, int32_t b) { return a < INT32_MAX && (int32_t)a < b; }
static inline bool _us64_gt(uint64_t a, int64_t b) { return a > INT64_MAX || (int64_t)a > b; }
static inline bool _us64_ge(uint64_t a, int64_t b) { return a >= INT64_MAX || (int64_t)a >= b; }
static inline bool _us64_eq(uint64_t a, int64_t b) { return a <= INT64_MAX && (int64_t)a == b; }
static inline bool _us64_ne(uint64_t a, int64_t b) { return a > INT64_MAX || (int64_t)a != b; }
static inline bool _us64_le(uint64_t a, int64_t b) { return a <= INT64_MAX && (int64_t)a <= b; }
static inline bool _us64_lt(uint64_t a, int64_t b) { return a < INT64_MAX && (int64_t)a < b; }


#if !defined(VNORETURN)
	#if defined(__TINYC__)
		#include <stdnoreturn.h>
		#define VNORETURN noreturn
	#endif
	# if !defined(__TINYC__) && defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L
	#  define VNORETURN _Noreturn
	# elif !defined(VNORETURN) && defined(__GNUC__) && __GNUC__ >= 2
	#  define VNORETURN __attribute__((noreturn))
	# endif
	#ifndef VNORETURN
		#define VNORETURN
	#endif
#endif


#if !defined(VUNREACHABLE)
	#if defined(__GNUC__) && !defined(__clang__)
		#define V_GCC_VERSION  (__GNUC__ * 10000L + __GNUC_MINOR__ * 100L + __GNUC_PATCHLEVEL__)
		#if (V_GCC_VERSION >= 40500L) && !defined(__TINYC__)
			#define VUNREACHABLE()  do { __builtin_unreachable(); } while (0)
		#endif
	#endif
	#if defined(__clang__) && defined(__has_builtin) && !defined(__TINYC__)
		#if __has_builtin(__builtin_unreachable)
			#define VUNREACHABLE()  do { __builtin_unreachable(); } while (0)
		#endif
	#endif
	#ifndef VUNREACHABLE
		#define VUNREACHABLE() do { } while (0)
	#endif
#endif


#ifndef wyhash_final_version_4_2
#define wyhash_final_version_4_2
#ifndef WYHASH_CONDOM
// protections that produce different results:
// 1: normal valid behavior
// 2: extra protection against entropy loss (probability=2^-63), aka. "blind multiplication"
#define WYHASH_CONDOM 1
#endif
#ifndef WYHASH_32BIT_MUM
// 0: normal version, slow on 32 bit systems
// 1: faster on 32 bit systems but produces different results, incompatible with wy2u0k function
#define WYHASH_32BIT_MUM 0
#endif
// includes
#include <stdint.h>
#if defined(_MSC_VER) && defined(_M_X64)
	#include <intrin.h>
	#pragma intrinsic(_umul128)
#endif
// 128bit multiply function
static inline uint64_t _wyrot(uint64_t x) { return (x>>32)|(x<<32); }
static inline void _wymum(uint64_t *A, uint64_t *B){
#if(WYHASH_32BIT_MUM)
	uint64_t hh=(*A>>32)*(*B>>32), hl=(*A>>32)*(uint32_t)*B, lh=(uint32_t)*A*(*B>>32), ll=(uint64_t)(uint32_t)*A*(uint32_t)*B;
	#if(WYHASH_CONDOM>1)
	*A^=_wyrot(hl)^hh; *B^=_wyrot(lh)^ll;
	#else
	*A=_wyrot(hl)^hh; *B=_wyrot(lh)^ll;
	#endif
#elif defined(__SIZEOF_INT128__) && !defined(VWASM)
	__uint128_t r=*A; r*=*B;
	#if(WYHASH_CONDOM>1)
	*A^=(uint64_t)r; *B^=(uint64_t)(r>>64);
	#else
	*A=(uint64_t)r; *B=(uint64_t)(r>>64);
	#endif
#elif defined(_MSC_VER) && defined(_M_X64)
	#if(WYHASH_CONDOM>1)
	uint64_t  a,  b;
	a=_umul128(*A,*B,&b);
	*A^=a;  *B^=b;
	#else
	*A=_umul128(*A,*B,B);
	#endif
#else
	uint64_t ha=*A>>32, hb=*B>>32, la=(uint32_t)*A, lb=(uint32_t)*B, hi, lo;
	uint64_t rh=ha*hb, rm0=ha*lb, rm1=hb*la, rl=la*lb, t=rl+(rm0<<32), c=t<rl;
	lo=t+(rm1<<32); c+=lo<t; hi=rh+(rm0>>32)+(rm1>>32)+c;
	#if(WYHASH_CONDOM>1)
	*A^=lo;  *B^=hi;
	#else
	*A=lo;  *B=hi;
	#endif
#endif
}
// multiply and xor mix function, aka MUM
static inline uint64_t _wymix(uint64_t A, uint64_t B){ _wymum(&A,&B); return A^B; }
// endian macros
#ifndef WYHASH_LITTLE_ENDIAN
	#ifdef TARGET_ORDER_IS_LITTLE
		#define WYHASH_LITTLE_ENDIAN 1
	#else
		#define WYHASH_LITTLE_ENDIAN 0
	#endif
#endif
// read functions
#if (WYHASH_LITTLE_ENDIAN)
	static inline uint64_t _wyr8(const uint8_t *p) { uint64_t v; memcpy(&v, p, 8); return v;}
	static inline uint64_t _wyr4(const uint8_t *p) { uint32_t v; memcpy(&v, p, 4); return v;}
#elif !defined(__TINYC__) && (defined(__GNUC__) || defined(__INTEL_COMPILER) || defined(__clang__))
	static inline uint64_t _wyr8(const uint8_t *p) { uint64_t v; memcpy(&v, p, 8); return __builtin_bswap64(v);}
	static inline uint64_t _wyr4(const uint8_t *p) { uint32_t v; memcpy(&v, p, 4); return __builtin_bswap32(v);}
#elif defined(_MSC_VER)
	static inline uint64_t _wyr8(const uint8_t *p) { uint64_t v; memcpy(&v, p, 8); return _byteswap_uint64(v);}
	static inline uint64_t _wyr4(const uint8_t *p) { uint32_t v; memcpy(&v, p, 4); return _byteswap_ulong(v);}
#else
	static inline uint64_t _wyr8(const uint8_t *p) {
		uint64_t v; memcpy(&v, p, 8);
		return (((v >> 56) & 0xff)| ((v >> 40) & 0xff00)| ((v >> 24) & 0xff0000)| ((v >>  8) & 0xff000000)| ((v <<  8) & 0xff00000000)| ((v << 24) & 0xff0000000000)| ((v << 40) & 0xff000000000000)| ((v << 56) & 0xff00000000000000));
	}
	static inline uint64_t _wyr4(const uint8_t *p) {
		uint32_t v; memcpy(&v, p, 4);
		return (((v >> 24) & 0xff)| ((v >>  8) & 0xff00)| ((v <<  8) & 0xff0000)| ((v << 24) & 0xff000000));
	}
#endif
static inline uint64_t _wyr3(const uint8_t *p, size_t k) { return (((uint64_t)p[0])<<16)|(((uint64_t)p[k>>1])<<8)|p[k-1];}
// wyhash main function
static inline uint64_t wyhash(const void *key, size_t len, uint64_t seed, const uint64_t *secret){
	const uint8_t *p=(const uint8_t *)key; seed^=_wymix(seed^secret[0],secret[1]);	uint64_t a, b;
	if (_likely_(len<=16)) {
		if (_likely_(len>=4)) { a=(_wyr4(p)<<32)|_wyr4(p+((len>>3)<<2)); b=(_wyr4(p+len-4)<<32)|_wyr4(p+len-4-((len>>3)<<2)); }
		else if (_likely_(len>0)) { a=_wyr3(p,len); b=0; }
		else a=b=0;
	} else {
		size_t i=len;
		if (_unlikely_(i>=48)) {
			uint64_t see1=seed, see2=seed;
			do {
				seed=_wymix(_wyr8(p)^secret[1],_wyr8(p+8)^seed);
				see1=_wymix(_wyr8(p+16)^secret[2],_wyr8(p+24)^see1);
				see2=_wymix(_wyr8(p+32)^secret[3],_wyr8(p+40)^see2);
				p+=48; i-=48;
			} while(_likely_(i>=48));
			seed^=see1^see2;
		}
		while(_unlikely_(i>16)) { seed=_wymix(_wyr8(p)^secret[1],_wyr8(p+8)^seed);  i-=16; p+=16; }
		a=_wyr8(p+i-16);  b=_wyr8(p+i-8);
	}
	a^=secret[1]; b^=seed;  _wymum(&a,&b);
	return  _wymix(a^secret[0]^len,b^secret[1]);
}
// the default secret parameters
static const uint64_t _wyp[4] = {0x2d358dccaa6c78a5ull, 0x8bb84b93962eacc9ull, 0x4b33a62ed433d4a3ull, 0x4d5a2da51de1aa47ull};
// a useful 64bit-64bit mix function to produce deterministic pseudo random numbers that can pass BigCrush and PractRand
static inline uint64_t wyhash64(uint64_t A, uint64_t B){ A^=0x2d358dccaa6c78a5ull; B^=0x8bb84b93962eacc9ull; _wymum(&A,&B); return _wymix(A^0x2d358dccaa6c78a5ull,B^0x8bb84b93962eacc9ull);}
// the wyrand PRNG that pass BigCrush and PractRand
static inline uint64_t wyrand(uint64_t *seed){ *seed+=0x2d358dccaa6c78a5ull; return _wymix(*seed,*seed^0x8bb84b93962eacc9ull);}
#ifndef __vinix__
// convert any 64 bit pseudo random numbers to uniform distribution [0,1). It can be combined with wyrand, wyhash64 or wyhash.
static inline double wy2u01(uint64_t r){ const double _wynorm=1.0/(1ull<<52); return (r>>12)*_wynorm;}
// convert any 64 bit pseudo random numbers to APPROXIMATE Gaussian distribution. It can be combined with wyrand, wyhash64 or wyhash.
static inline double wy2gau(uint64_t r){ const double _wynorm=1.0/(1ull<<20); return ((r&0x1fffff)+((r>>21)&0x1fffff)+((r>>42)&0x1fffff))*_wynorm-3.0;}
#endif
#if(!WYHASH_32BIT_MUM)
// fast range integer random number generation on [0,k) credit to Daniel Lemire. May not work when WYHASH_32BIT_MUM=1. It can be combined with wyrand, wyhash64 or wyhash.
static inline uint64_t wy2u0k(uint64_t r, uint64_t k){ _wymum(&r,&k); return k; }
#endif
#endif
#define _IN_MAP(val, m) builtin__map_exists(m, val)


// V includes:

#if defined(__TINYC__) && defined(__has_include) // tcc does not support has_include properly yet, turn it off completely
#undef __has_include
#endif

#if !defined(_VFREESTANDING) && !defined(__vinix__)

// added by module `builtin.closure`, file: closure_nix.c.v:4:

#if defined(__has_include)
#if __has_include(<sys/mman.h>)
#include <sys/mman.h>
#else
#error VERROR_MESSAGE Header file <sys/mman.h>, needed for module `builtin.closure` was not found. Please install the corresponding development headers.
#endif
#else
#include <sys/mman.h>
#endif

#endif

#if !defined(_VNATIVE)

// added by module `builtin`, file: float.c.v:10:

#if defined(__has_include)
#if __has_include(<float.h>)
#include <float.h>
#else
#error VERROR_MESSAGE Header file <float.h>, needed for module `builtin` was not found. Please install the corresponding development headers.
#endif
#else
#include <float.h>
#endif

#endif

// added by module `term.termios`, file: termios_darwin.c.v:10:

#if defined(__has_include)
#if __has_include(<termios.h>)
#include <termios.h>
#else
#error VERROR_MESSAGE Header file <termios.h>, needed for module `term.termios` was not found. Please install the corresponding development headers.
#endif
#else
#include <termios.h>
#endif


// added by module `term.termios`, file: termios_darwin.c.v:11:

#if defined(__has_include)
#if __has_include(<sys/ioctl.h>)
#include <sys/ioctl.h>
#else
#error VERROR_MESSAGE Header file <sys/ioctl.h>, needed for module `term.termios` was not found. Please install the corresponding development headers.
#endif
#else
#include <sys/ioctl.h>
#endif


// added by module `vphp`, file: vphp.v:3:

#if defined(__has_include)
#if __has_include(<php.h>)
#include <php.h>
#else
#error VERROR_MESSAGE Header file <php.h>, needed for module `vphp` was not found. Please install the corresponding development headers.
#endif
#else
#include <php.h>
#endif


// added by module `vphp`, file: vphp.v:4:

#if defined(__has_include)
#if __has_include("v_bridge.h")
#include "v_bridge.h"
#else
#error VERROR_MESSAGE Header file "v_bridge.h", needed for module `vphp` was not found. Please install the corresponding development headers.
#endif
#else
#include "v_bridge.h"
#endif


// added by module `os`, file: debugger_darwin.c.v:3:

#if defined(__has_include)
#if __has_include(<sys/types.h>)
#include <sys/types.h>
#else
#error VERROR_MESSAGE Header file <sys/types.h>, needed for module `os` was not found. Please install the corresponding development headers.
#endif
#else
#include <sys/types.h>
#endif


// added by module `os`, file: debugger_darwin.c.v:4:

#if defined(__has_include)
#if __has_include(<sys/ptrace.h>)
#include <sys/ptrace.h>
#else
#error VERROR_MESSAGE Header file <sys/ptrace.h>, needed for module `os` was not found. Please install the corresponding development headers.
#endif
#else
#include <sys/ptrace.h>
#endif


#if !defined(_WIN32)

// added by module `os`, file: fd.c.v:6:

#if defined(__has_include)
#if __has_include(<sys/select.h>)
#include <sys/select.h>
#else
#error VERROR_MESSAGE Header file <sys/select.h>, needed for module `os` was not found. Please install the corresponding development headers.
#endif
#else
#include <sys/select.h>
#endif

#endif

// added by module `os`, file: os.c.v:5:

#if defined(__has_include)
#if __has_include(<sys/stat.h>)
#include <sys/stat.h>
#else
#error VERROR_MESSAGE Header file <sys/stat.h>, needed for module `os` was not found. Please install the corresponding development headers.
#endif
#else
#include <sys/stat.h>
#endif


// added by module `os`, file: os.c.v:6:
#include <errno.h>

// added by module `os`, file: os.c.v:9:

#if defined(__has_include)
#if __has_include(<mach-o/dyld.h>)
#include <mach-o/dyld.h>
#else
#error VERROR_MESSAGE Header file <mach-o/dyld.h>, needed for module `os` was not found. Please install the corresponding development headers.
#endif
#else
#include <mach-o/dyld.h>
#endif


// added by module `os`, file: os_nix.c.v:5:

#if defined(__has_include)
#if __has_include(<dirent.h>)
#include <dirent.h>
#else
#error VERROR_MESSAGE Header file <dirent.h>, needed for module `os` was not found. Please install the corresponding development headers.
#endif
#else
#include <dirent.h>
#endif


// added by module `os`, file: os_nix.c.v:6:

#if defined(__has_include)
#if __has_include(<unistd.h>)
#include <unistd.h>
#else
#error VERROR_MESSAGE Header file <unistd.h>, needed for module `os` was not found. Please install the corresponding development headers.
#endif
#else
#include <unistd.h>
#endif


// added by module `os`, file: os_nix.c.v:7:

#if defined(__has_include)
#if __has_include(<fcntl.h>)
#include <fcntl.h>
#else
#error VERROR_MESSAGE Header file <fcntl.h>, needed for module `os` was not found. Please install the corresponding development headers.
#endif
#else
#include <fcntl.h>
#endif


// added by module `os`, file: os_nix.c.v:8:

#if defined(__has_include)
#if __has_include(<sys/utsname.h>)
#include <sys/utsname.h>
#else
#error VERROR_MESSAGE Header file <sys/utsname.h>, needed for module `os` was not found. Please install the corresponding development headers.
#endif
#else
#include <sys/utsname.h>
#endif


// added by module `os`, file: os_nix.c.v:9:

#if defined(__has_include)
#if __has_include(<sys/types.h>)
#include <sys/types.h>
#else
#error VERROR_MESSAGE Header file <sys/types.h>, needed for module `os` was not found. Please install the corresponding development headers.
#endif
#else
#include <sys/types.h>
#endif


// added by module `os`, file: os_nix.c.v:10:

#if defined(__has_include)
#if __has_include(<sys/statvfs.h>)
#include <sys/statvfs.h>
#else
#error VERROR_MESSAGE Header file <sys/statvfs.h>, needed for module `os` was not found. Please install the corresponding development headers.
#endif
#else
#include <sys/statvfs.h>
#endif


// added by module `os`, file: os_nix.c.v:11:

#if defined(__has_include)
#if __has_include(<utime.h>)
#include <utime.h>
#else
#error VERROR_MESSAGE Header file <utime.h>, needed for module `os` was not found. Please install the corresponding development headers.
#endif
#else
#include <utime.h>
#endif


// added by module `os`, file: signal.c.v:3:

#if defined(__has_include)
#if __has_include(<signal.h>)
#include <signal.h>
#else
#error VERROR_MESSAGE Header file <signal.h>, needed for module `os` was not found. Please install the corresponding development headers.
#endif
#else
#include <signal.h>
#endif


// added by module `os`, file: signal_darwin.c.v:5:

#if defined(__has_include)
#if __has_include(<signal.h>)
#include <signal.h>
#else
#error VERROR_MESSAGE Header file <signal.h>, needed for module `os` was not found. Please install the corresponding development headers.
#endif
#else
#include <signal.h>
#endif


// added by module `main`, file: v_logic.v:6:

#if defined(__has_include)
#if __has_include(<php.h>)
#include <php.h>
#else
#error VERROR_MESSAGE Header file <php.h>, needed for module `main` was not found. Please install the corresponding development headers.
#endif
#else
#include <php.h>
#endif


// added by module `main`, file: v_logic.v:7:

#if defined(__has_include)
#if __has_include("../vphp/v_bridge.h")
#include "../vphp/v_bridge.h"
#else
#error VERROR_MESSAGE Header file "../vphp/v_bridge.h", needed for module `main` was not found. Please install the corresponding development headers.
#endif
#else
#include "../vphp/v_bridge.h"
#endif


// V global/const #define ... :
#define _const_builtin__closure__assumed_page_size 16384
#define _const_strconv__digits 18
#define _const_strconv__c_dpoint '.'
#define _const_strconv__c_plus '+'
#define _const_strconv__c_minus '-'
#define _const_strconv__c_zero '0'
#define _const_strconv__c_nine '9'
#define _const_strconv__int_size 32
#define _const_strconv__max_size_f64_char 512
#define _const_min_int -2147483648
#define _const_max_int 2147483647
#define _const_hashbits 24
#define _const_max_cached_hashbits 16
#define _const_init_log_capicity 5
#define _const_init_capicity 32
#define _const_init_even_index 30
#define _const_extra_metas_inc 4
#define _const_rune_maps_columns_in_row 4
#define _const_rune_maps_ul -3
#define _const_rune_maps_utl -2
#define _const_degree 6
#define _const_mid_index 5
#define _const_replace_stack_buffer_size 10
#define _const_kmp_stack_buffer_size 20
#define _const_vphp__e_error 1
#define _const_vphp__e_warning 2
#define _const_vphp__e_notice 8
#define _const_os__max_path_buffer_size 4096
#define _const_os__o_binary 0
#define _const_os__fslash '/'
#define _const_os__dot '.'
#define _const_os__buf_size 4096
#define _const_os__error_code_not_set -1
#define _const_os__max_path_len 4096
#define _const_os__f_ok 0
#define _const_os__x_ok 1
#define _const_os__w_ok 2
#define _const_os__r_ok 4
#define _const_os__sys_write 4
#define _const_os__sys_open 5
#define _const_os__sys_close 6
#define _const_os__sys_mkdir 136
#define _const_os__sys_creat 8
#define _const_os__sys_open_nocancel 398
#define _const_os__sys_stat64 338
#define _const_os__s_ifmt 61440
#define _const_os__s_ifdir 16384
#define _const_os__s_ifreg 32768
#define _const_os__s_iflnk 40960
#define _const_os__s_isuid 2048
#define _const_os__s_isgid 1024
#define _const_os__s_isvtx 512
#define _const_os__s_irusr 256
#define _const_os__s_iwusr 128
#define _const_os__s_ixusr 64
#define _const_os__s_irgrp 32
#define _const_os__s_iwgrp 16
#define _const_os__s_ixgrp 8
#define _const_os__s_iroth 4
#define _const_os__s_iwoth 2
#define _const_os__s_ixoth 1

// Enum definitions:

typedef enum {
	strings__IndentState__normal, // 
	strings__IndentState__in_string, // +1
}  strings__IndentState;

typedef enum {
	builtin__closure__MemoryProtectAtrr__read_exec, // 
	builtin__closure__MemoryProtectAtrr__read_write, // +1
}  builtin__closure__MemoryProtectAtrr;

typedef enum {
	strconv__ParserState__ok, // 
	strconv__ParserState__pzero, // +1
	strconv__ParserState__mzero, // +2
	strconv__ParserState__pinf, // +3
	strconv__ParserState__minf, // +4
	strconv__ParserState__invalid_number, // +5
	strconv__ParserState__extra_char, // +6
}  strconv__ParserState;

typedef enum {
	strconv__Align_text__right = 0, // 0
	strconv__Align_text__left, // 0+1
	strconv__Align_text__center, // 0+2
}  strconv__Align_text;

typedef enum {
	strconv__Char_parse_state__start, // 
	strconv__Char_parse_state__norm_char, // +1
	strconv__Char_parse_state__field_char, // +2
	strconv__Char_parse_state__pad_ch, // +3
	strconv__Char_parse_state__len_set_start, // +4
	strconv__Char_parse_state__len_set_in, // +5
	strconv__Char_parse_state__check_type, // +6
	strconv__Char_parse_state__check_float, // +7
	strconv__Char_parse_state__check_float_in, // +8
	strconv__Char_parse_state__reset_params, // +9
}  strconv__Char_parse_state;

typedef enum {
	ArrayFlags__noslices = 1U, // u64(1) << 0
	ArrayFlags__noshrink = 2U, // u64(1) << 1
	ArrayFlags__nogrow = 4U, // u64(1) << 2
	ArrayFlags__nofree = 8U, // u64(1) << 3
}  ArrayFlags;

typedef enum {
	ChanState__success, // 
	ChanState__not_ready, // +1
	ChanState__closed, // +2
}  ChanState;

typedef enum {
	AttributeKind__plain, // 
	AttributeKind__string, // +1
	AttributeKind__number, // +2
	AttributeKind__bool, // +3
	AttributeKind__comptime_define, // +4
}  AttributeKind;

typedef enum {
	MapMode__to_upper, // 
	MapMode__to_lower, // +1
	MapMode__to_title, // +2
}  MapMode;

typedef enum {
	TrimMode__trim_left, // 
	TrimMode__trim_right, // +1
	TrimMode__trim_both, // +2
}  TrimMode;

typedef enum {
	StrIntpType__si_no_str = 0, // 0
	StrIntpType__si_c, // 0+1
	StrIntpType__si_u8, // 0+2
	StrIntpType__si_i8, // 0+3
	StrIntpType__si_u16, // 0+4
	StrIntpType__si_i16, // 0+5
	StrIntpType__si_u32, // 0+6
	StrIntpType__si_i32, // 0+7
	StrIntpType__si_u64, // 0+8
	StrIntpType__si_i64, // 0+9
	StrIntpType__si_e32, // 0+10
	StrIntpType__si_e64, // 0+11
	StrIntpType__si_f32, // 0+12
	StrIntpType__si_f64, // 0+13
	StrIntpType__si_g32, // 0+14
	StrIntpType__si_g64, // 0+15
	StrIntpType__si_s, // 0+16
	StrIntpType__si_p, // 0+17
	StrIntpType__si_r, // 0+18
	StrIntpType__si_vp, // 0+19
}  StrIntpType;

typedef enum {
	vphp__PHPType__undef = 0, // 0
	vphp__PHPType__null = 1, // 1
	vphp__PHPType__false_ = 2, // 2
	vphp__PHPType__true_ = 3, // 3
	vphp__PHPType__long = 4, // 4
	vphp__PHPType__double = 5, // 5
	vphp__PHPType__string = 6, // 6
	vphp__PHPType__array = 7, // 7
	vphp__PHPType__object = 8, // 8
	vphp__PHPType__resource = 9, // 9
	vphp__PHPType__reference = 10, // 10
}  vphp__PHPType;

typedef enum {
	os__SeekMode__start, // 
	os__SeekMode__current, // +1
	os__SeekMode__end, // +2
}  os__SeekMode;

typedef enum {
	os__FileBufferMode__fully_buffered = _IOFBF, // _IOFBF
	os__FileBufferMode__line_buffered = _IOLBF, // _IOLBF
	os__FileBufferMode__not_buffered = _IONBF, // _IONBF
}  os__FileBufferMode;

typedef enum {
	os__FileType__unknown, // 
	os__FileType__regular, // +1
	os__FileType__directory, // +2
	os__FileType__character_device, // +3
	os__FileType__block_device, // +4
	os__FileType__fifo, // +5
	os__FileType__symbolic_link, // +6
	os__FileType__socket, // +7
}  os__FileType;

typedef enum {
	os__GlobMatch__exact, // 
	os__GlobMatch__ends_with, // +1
	os__GlobMatch__starts_with, // +2
	os__GlobMatch__start_and_ends_with, // +3
	os__GlobMatch__contains, // +4
	os__GlobMatch__any, // +5
}  os__GlobMatch;

typedef enum {
	os__ChildProcessPipeKind__stdin, // 
	os__ChildProcessPipeKind__stdout, // +1
	os__ChildProcessPipeKind__stderr, // +2
}  os__ChildProcessPipeKind;

typedef enum {
	os__ProcessState__not_started, // 
	os__ProcessState__running, // +1
	os__ProcessState__stopped, // +2
	os__ProcessState__exited, // +3
	os__ProcessState__aborted, // +4
	os__ProcessState__closed, // +5
}  os__ProcessState;

typedef enum {
	os__Signal__hup = 1, // 1
	os__Signal__int = 2, // 2
	os__Signal__quit = 3, // 3
	os__Signal__ill = 4, // 4
	os__Signal__trap = 5, // 5
	os__Signal__abrt = 6, // 6
	os__Signal__bus = 7, // 7
	os__Signal__fpe = 8, // 8
	os__Signal__kill = 9, // 9
	os__Signal__usr1 = 10, // 10
	os__Signal__segv = 11, // 11
	os__Signal__usr2 = 12, // 12
	os__Signal__pipe = 13, // 13
	os__Signal__alrm = 14, // 14
	os__Signal__term = 15, // 15
	os__Signal__stkflt = 16, // 16
	os__Signal__chld = 17, // 17
	os__Signal__cont = 18, // 18
	os__Signal__stop = 19, // 19
	os__Signal__tstp = 20, // 20
	os__Signal__ttin = 21, // 21
	os__Signal__ttou = 22, // 22
	os__Signal__urg = 23, // 23
	os__Signal__xcpu = 24, // 24
	os__Signal__xfsz = 25, // 25
	os__Signal__vtalrm = 26, // 26
	os__Signal__prof = 27, // 27
	os__Signal__winch = 28, // 28
	os__Signal__poll = 29, // 29
	os__Signal__pwr = 30, // 30
	os__Signal__sys = 31, // 31
}  os__Signal;

// Thread definitions:
typedef pthread_t __v_thread_Array_f64;

// V type definitions:
struct IError {
	union {
		void* _object;
		None__* _None__;
		voidptr* _voidptr;
		Error* _Error;
		MessageError* _MessageError;
		os__Eof* _os__Eof;
		os__NotExpected* _os__NotExpected;
		os__FileNotOpenedError* _os__FileNotOpenedError;
		os__SizeOfTypeIs0Error* _os__SizeOfTypeIs0Error;
		os__ExecutableNotFoundError* _os__ExecutableNotFoundError;
	};
	u32 _typ;
};

struct string {
	u8* str;
	int len;
	int is_lit;
};

struct array {
	voidptr data;
	int offset;
	int len;
	int cap;
	ArrayFlags flags;
	int element_size;
};

struct DenseArray {
	int key_bytes;
	int value_bytes;
	int cap;
	int len;
	u32 deletes;
	u8* all_deleted;
	u8* keys;
	u8* values;
};

struct map {
	int key_bytes;
	int value_bytes;
	u32 even_index;
	u8 cached_hashbits;
	u8 shift;
	DenseArray key_values;
	u32* metas;
	u32 extra_metas;
	bool has_string_keys;
	MapHashFn hash_fn;
	MapEqFn key_eq_fn;
	MapCloneFn clone_fn;
	MapFreeFn free_fn;
	int len;
};

struct Error {
	E_STRUCT_DECL;
};

struct _option {
	u8 state;
	IError err;
};

struct _result {
	bool is_error;
	IError err;
};
typedef array Array_string;
typedef array Array_u8;
typedef array Array_voidptr;
typedef array Array_int;
typedef array Array_rune;
typedef string Array_fixed_string_11 [11];
typedef voidptr Array_fixed_voidptr_11 [11];
typedef array Array_RepIndex;
typedef map Map_string_string;
typedef array Array_f64;
typedef array Array_main__HeartPoint;
typedef map Map_string_int;
typedef array Array_bool;
typedef array Array_vphp__Val;
typedef map Map_string_f64;
typedef array Array_i64;
typedef map Map_string_vphp__TaskCreator;
typedef array Array_char_ptr;
typedef int Array_fixed_int_3 [3];
typedef array Array_os__Signal;
typedef char Array_fixed_char_256 [256];
typedef u8 Array_fixed_u8_5 [5];
typedef u8 Array_fixed_u8_25 [25];
typedef u8 Array_fixed_u8_12 [12];
typedef u8 Array_fixed_u8_8 [8];
typedef u8 Array_fixed_u8_32 [32];
typedef u8 Array_fixed_u8_64 [64];
typedef u8 Array_fixed_u8_256 [256];
typedef u64 Array_fixed_u64_309 [309];
typedef u64 Array_fixed_u64_324 [324];
typedef u32 Array_fixed_u32_10 [10];
typedef u64 Array_fixed_u64_20 [20];
typedef u64 Array_fixed_u64_584 [584];
typedef u64 Array_fixed_u64_652 [652];
typedef f64 Array_fixed_f64_36 [36];
typedef u8 Array_fixed_u8_26 [26];
typedef u8 Array_fixed_u8_512 [512];
typedef u64 Array_fixed_u64_47 [47];
typedef u64 Array_fixed_u64_31 [31];
typedef voidptr Array_fixed_voidptr_100 [100];
typedef u8 Array_fixed_u8_17 [17];
typedef i32 Array_fixed_i32_1264 [1264];
typedef int Array_fixed_int_10 [10];
typedef int Array_fixed_int_20 [20];
typedef array Array_StrIntpType;
typedef u8 Array_fixed_u8_4096 [4096];
typedef u8 Array_fixed_u8_1024 [1024];
typedef int Array_fixed_int_2 [2];
typedef array Array_os__ProcessState;
typedef int Array_fixed_int_6 [6];
typedef Array_u8 strings__Builder;
typedef usize term__termios__TcFlag;
typedef usize term__termios__Speed;
typedef u8 term__termios__Cc;
typedef int (*anon_fn_voidptr_voidptr__int)(voidptr,voidptr);
typedef void (*FnExitCb)();
typedef void (*FnGC_WarnCB)(char*,usize);
typedef int (*FnSortCB)(voidptr,voidptr);
typedef voidptr (*anon_fn___voidptr)();
typedef vphp__ITask (*vphp__TaskCreator)();
typedef void (*anon_fn_string)(string);
typedef void (*os__FnWalkContextCB)(voidptr,string);
typedef void (*os__SignalHandler)(os__Signal);
struct vphp__ITask {
	union {
		void* _object;
		main__AnalyzeTask* _main__AnalyzeTask;
		voidptr* _voidptr;
	};
	u32 _typ;
};
// #start sorted_symbols
struct none {
	E_STRUCT_DECL;
};

struct None__ {
	Error Error;
};

struct InputRuneIterator {
	E_STRUCT_DECL;
};

struct vphp__Val {
	zval* raw;
};

struct main__Coach {
	string name;
};

struct vphp__Context {
	zend_execute_data* ex;
	zval* ret;
};

struct os__Eof {
	Error Error;
};

struct os__FileNotOpenedError {
	Error Error;
};

struct os__SizeOfTypeIs0Error {
	Error Error;
};

struct os__ExecutableNotFoundError {
	Error Error;
};

struct os__Uname {
	string sysname;
	string nodename;
	string release;
	string version;
	string machine;
};

struct GCHeapUsage {
	usize heap_size;
	usize free_bytes;
	usize total_bytes;
	usize unmapped_bytes;
	usize bytes_since_gc;
};

struct MessageError {
	string msg;
	int code;
};

union strconv__Float64u {
	f64 f;
	u64 u;
};

union strconv__Float32u {
	f32 f;
	u32 u;
};

struct VAssertMetaInfo {
	string fpath;
	int line_nr;
	string fn_name;
	string src;
	string op;
	string llabel;
	string rlabel;
	string lvalue;
	string rvalue;
	string message;
	bool has_msg;
};

struct FieldData {
	string name;
	int typ;
	int unaliased_typ;
	Array_string attrs;
	bool is_pub;
	bool is_mut;
	bool is_embed;
	bool is_shared;
	bool is_atomic;
	bool is_option;
	bool is_array;
	bool is_map;
	bool is_chan;
	bool is_enum;
	bool is_struct;
	bool is_alias;
	u8 indirections;
};

struct SortedMap {
	int value_bytes;
	mapnode* root;
	int len;
};

struct RepIndex {
	int idx;
	int val_idx;
};

struct WrapConfig {
	int width;
	string end;
};

struct RunesIterator {
	string s;
	int i;
};

union StrIntpMem {
	u32 d_c;
	u8 d_u8;
	i8 d_i8;
	u16 d_u16;
	i16 d_i16;
	u32 d_u32;
	i32 d_i32;
	u64 d_u64;
	i64 d_i64;
	f32 d_f32;
	f64 d_f64;
	string d_s;
	string d_r;
	voidptr d_p;
	voidptr d_vp;
};

struct strconv__BF_param {
	u8 pad_ch;
	int len0;
	int len1;
	bool positive;
	bool sign_flag;
	strconv__Align_text align;
	bool rm_tail_zero;
};

struct ToWideConfig {
	bool from_ansi;
};

struct main__AnalyzeTask {
	Array_f64 data;
};

struct main__Database {
	bool connected;
};

struct main__MotionReport {
	string user_name;
	f64 max_hr;
	f64 min_hr;
	f64 avg_hr;
	string risk_level;
	string device_mode;
};

struct main__HeartPoint {
	int timestamp;
	f64 hr;
};

struct strings__IndentParam {
	rune block_start;
	rune block_end;
	rune indent_char;
	int indent_count;
	int starting_level;
};

struct builtin__closure__ClosureMutex {
	pthread_mutex_t closure_mtx;
};

struct strconv__PrepNumber {
	bool negative;
	int exponent;
	u64 mantissa;
};

struct strconv__AtoF64Param {
	bool allow_extra_chars;
};

struct strconv__Dec32 {
	u32 m;
	int e;
};

union strconv__Uf32 {
	f32 f;
	u32 u;
};

struct strconv__Dec64 {
	u64 m;
	int e;
};

struct strconv__Uint128 {
	u64 lo;
	u64 hi;
};

union strconv__Uf64 {
	f64 f;
	u64 u;
};

struct vphp__MapContext {
	Map_string_string m;
};

struct vphp__AsyncResult {
	__v_thread_Array_f64 handle;
};

struct vphp__TaskRegistry {
	Map_string_vphp__TaskCreator tasks;
};

struct os__Command {
	voidptr f;
	bool eof;
	int exit_code;
	string path;
	bool redirect_stdout;
};

struct os__NotExpected {
	string cause;
	int code;
};

struct os__File {
	voidptr cfile;
	int fd;
	bool is_opened;
};

struct os__FilePermission {
	bool read;
	bool write;
	bool execute;
};

struct os__Stat {
	u64 dev;
	u64 inode;
	u32 mode;
	u64 nlink;
	u32 uid;
	u32 gid;
	u64 rdev;
	u64 size;
	i64 atime;
	i64 mtime;
	i64 ctime;
};

struct os__CopyParams {
	bool fail_if_exists;
};

struct os__PathKind {
	bool is_file;
	bool is_dir;
	bool is_link;
};

struct os__SystemError {
	string msg;
	int code;
};

struct os__DiskUsage {
	u64 total;
	u64 available;
	u64 used;
};

struct os__Result {
	int exit_code;
	string output;
};

struct os__MvParams {
	bool overwrite;
};

struct os__WalkParams {
	bool hidden;
};

struct os__MkdirParams {
	u32 mode;
};

struct os__Pipe {
	int read_fd;
	int write_fd;
};

struct strings__textscanner__TextScanner {
	string input;
	int ilen;
	int pos;
};
typedef term__termios__Cc Array_fixed_term__termios__Cc_20 [20];

struct mapnode {
	voidptr* children;
	int len;
	Array_fixed_string_11 keys;
	Array_fixed_voidptr_11 values;
};

struct StrIntpData {
	string str;
	u32 fmt;
	StrIntpMem d;
};

struct builtin__closure__Closure {
	builtin__closure__ClosureMutex ClosureMutex;
	voidptr closure_ptr;
	anon_fn___voidptr closure_get_data;
	int closure_cap;
	int v_page_size;
};

struct os__FileMode {
	os__FileType typ;
	os__FilePermission owner;
	os__FilePermission group;
	os__FilePermission others;
};

struct term__termios__Termios {
	term__termios__TcFlag c_iflag;
	term__termios__TcFlag c_oflag;
	term__termios__TcFlag c_cflag;
	term__termios__TcFlag c_lflag;
	Array_fixed_term__termios__Cc_20 c_cc;
	term__termios__Speed c_ispeed;
	term__termios__Speed c_ospeed;
};

struct os__IOCapture {
	os__Pipe __v_stdout;
	os__Pipe __v_stderr;
	int original_stdout_fd;
	int original_stderr_fd;
};

struct os__Process {
	string filename;
	int pid;
	int code;
	os__ProcessState status;
	string err;
	Array_string args;
	string work_folder;
	bool env_is_custom;
	Array_string env;
	bool use_stdio_ctl;
	bool use_pgroup;
	Array_fixed_int_3 stdio_fd;
	voidptr wdata;
	bool create_no_window;
};

struct os__FileInfo {
	os__FileMode FileMode;
	u64 size;
	i64 mtime;
};
// #end sorted_symbols

// BEGIN_multi_return_structs
struct multi_return_u32_u32 {
	u32 arg0;
	u32 arg1;
};

struct multi_return_string_string {
	string arg0;
	string arg1;
};

struct multi_return_int_int {
	int arg0;
	int arg1;
};

struct multi_return_u32_u32_u32 {
	u32 arg0;
	u32 arg1;
	u32 arg2;
};

struct multi_return_strconv__ParserState_strconv__PrepNumber {
	strconv__ParserState arg0;
	strconv__PrepNumber arg1;
};

struct multi_return_u64_int {
	u64 arg0;
	int arg1;
};

struct multi_return_i64_int {
	i64 arg0;
	int arg1;
};

struct multi_return_strconv__Dec32_bool {
	strconv__Dec32 arg0;
	bool arg1;
};

struct multi_return_strconv__Dec64_bool {
	strconv__Dec64 arg0;
	bool arg1;
};

struct multi_return_string_int {
	string arg0;
	int arg1;
};

struct multi_return_int_bool {
	int arg0;
	bool arg1;
};

struct multi_return_string_string_string {
	string arg0;
	string arg1;
	string arg2;
};

struct multi_return_Array_string_Array_string {
	Array_string arg0;
	Array_string arg1;
};

struct multi_return_u64_u64 {
	u64 arg0;
	u64 arg1;
};

struct multi_return_f64_int {
	f64 arg0;
	int arg1;
};

// END_multi_return_structs


typedef struct thread_arg_vphp__ITask_run {
	Array_f64 (*fn) (vphp__ITask);
	vphp__ITask arg0;
} thread_arg_vphp__ITask_run;
static bool Array_u8_contains(Array_u8 a, u8 v);
static bool Array_string_contains(Array_string a, string v);

// V Option_xxx definitions:
struct _option_rune {
	byte state;
	IError err;
	byte data[sizeof(rune) > 1 ? sizeof(rune) : 1];
};

struct _option_multi_return_string_string {
	byte state;
	IError err;
	byte data[sizeof(multi_return_string_string) > 1 ? sizeof(multi_return_string_string) : 1];
};

struct _option_int {
	byte state;
	IError err;
	byte data[sizeof(int) > 1 ? sizeof(int) : 1];
};

struct _option_anon_fn___vphp__ITask {
	byte state;
	IError err;
	byte data[sizeof(void*) > 1 ? sizeof(void*) : 1];
};

struct _option_string {
	byte state;
	IError err;
	byte data[sizeof(string) > 1 ? sizeof(string) : 1];
};


// V result_xxx definitions:
struct _result_int {
	bool is_error;
	IError err;
	byte data[sizeof(int) > 1 ? sizeof(int) : 1];
};

struct _result_f64 {
	bool is_error;
	IError err;
	byte data[sizeof(f64) > 1 ? sizeof(f64) : 1];
};

struct _result_u64 {
	bool is_error;
	IError err;
	byte data[sizeof(u64) > 1 ? sizeof(u64) : 1];
};

struct _result_i64 {
	bool is_error;
	IError err;
	byte data[sizeof(i64) > 1 ? sizeof(i64) : 1];
};

struct _result_multi_return_i64_int {
	bool is_error;
	IError err;
	byte data[sizeof(multi_return_i64_int) > 1 ? sizeof(multi_return_i64_int) : 1];
};

struct _result_i8 {
	bool is_error;
	IError err;
	byte data[sizeof(i8) > 1 ? sizeof(i8) : 1];
};

struct _result_i16 {
	bool is_error;
	IError err;
	byte data[sizeof(i16) > 1 ? sizeof(i16) : 1];
};

struct _result_i32 {
	bool is_error;
	IError err;
	byte data[sizeof(i32) > 1 ? sizeof(i32) : 1];
};

struct _result_u8 {
	bool is_error;
	IError err;
	byte data[sizeof(u8) > 1 ? sizeof(u8) : 1];
};

struct _result_u16 {
	bool is_error;
	IError err;
	byte data[sizeof(u16) > 1 ? sizeof(u16) : 1];
};

struct _result_u32 {
	bool is_error;
	IError err;
	byte data[sizeof(u32) > 1 ? sizeof(u32) : 1];
};

struct _result_void {
	bool is_error;
	IError err;
	byte data[sizeof(u8) > 1 ? sizeof(u8) : 1];
};

struct _result_rune {
	bool is_error;
	IError err;
	byte data[sizeof(rune) > 1 ? sizeof(rune) : 1];
};

struct _result_string {
	bool is_error;
	IError err;
	byte data[sizeof(string) > 1 ? sizeof(string) : 1];
};

struct _result_vphp__Val {
	bool is_error;
	IError err;
	byte data[sizeof(vphp__Val) > 1 ? sizeof(vphp__Val) : 1];
};

struct _result_os__Command {
	bool is_error;
	IError err;
	byte data[sizeof(os__Command) > 1 ? sizeof(os__Command) : 1];
};

struct _result_os__File {
	bool is_error;
	IError err;
	byte data[sizeof(os__File) > 1 ? sizeof(os__File) : 1];
};

struct _result_FILE_ptr {
	bool is_error;
	IError err;
	byte data[sizeof(FILE*) > 1 ? sizeof(FILE*) : 1];
};

struct _result_os__Stat {
	bool is_error;
	IError err;
	byte data[sizeof(os__Stat) > 1 ? sizeof(os__Stat) : 1];
};

struct _result_Array_u8 {
	bool is_error;
	IError err;
	byte data[sizeof(Array_u8) > 1 ? sizeof(Array_u8) : 1];
};

struct _result_strings__Builder {
	bool is_error;
	IError err;
	byte data[sizeof(strings__Builder) > 1 ? sizeof(strings__Builder) : 1];
};

struct _result_Array_string {
	bool is_error;
	IError err;
	byte data[sizeof(Array_string) > 1 ? sizeof(Array_string) : 1];
};

struct _result_os__Result {
	bool is_error;
	IError err;
	byte data[sizeof(os__Result) > 1 ? sizeof(os__Result) : 1];
};

struct _result_os__DiskUsage {
	bool is_error;
	IError err;
	byte data[sizeof(os__DiskUsage) > 1 ? sizeof(os__DiskUsage) : 1];
};

struct _result_os__Pipe {
	bool is_error;
	IError err;
	byte data[sizeof(os__Pipe) > 1 ? sizeof(os__Pipe) : 1];
};

struct _result_os__IOCapture {
	bool is_error;
	IError err;
	byte data[sizeof(os__IOCapture) > 1 ? sizeof(os__IOCapture) : 1];
};

struct _result_anon_fn_os__signal {
	bool is_error;
	IError err;
	byte data[sizeof(void*) > 1 ? sizeof(void*) : 1];
};


// V definitions:
static char * v_typeof_interface_IError(u32 sidx);
u32 v_typeof_interface_idx_IError(u32 sidx);
static char * v_typeof_interface_vphp__ITask(u32 sidx);
u32 v_typeof_interface_idx_vphp__ITask(u32 sidx);
// end of definitions #endif
strings__Builder strings__new_builder(int initial_size);
Array_u8 strings__Builder_reuse_as_plain_u8_array(strings__Builder* b);
void strings__Builder_write_ptr(strings__Builder* b, u8* ptr, int len);
void strings__Builder_write_rune(strings__Builder* b, rune r);
void strings__Builder_write_runes(strings__Builder* b, Array_rune runes);
void strings__Builder_write_u8(strings__Builder* b, u8 data);
void strings__Builder_write_byte(strings__Builder* b, u8 data);
void strings__Builder_write_decimal(strings__Builder* b, i64 n);
_result_int strings__Builder_write(strings__Builder* b, Array_u8 data);
void strings__Builder_drain_builder(strings__Builder* b, strings__Builder* other, int other_new_cap);
u8 strings__Builder_byte_at(strings__Builder* b, int n);
void strings__Builder_write_string(strings__Builder* b, string s);
void strings__Builder_write_string2(strings__Builder* b, string s1, string s2);
void strings__Builder_go_back(strings__Builder* b, int n);
string strings__Builder_spart(strings__Builder* b, int start_pos, int n);
string strings__Builder_cut_last(strings__Builder* b, int n);
string strings__Builder_cut_to(strings__Builder* b, int pos);
void strings__Builder_go_back_to(strings__Builder* b, int pos);
void strings__Builder_writeln(strings__Builder* b, string s);
void strings__Builder_writeln2(strings__Builder* b, string s1, string s2);
string strings__Builder_last_n(strings__Builder* b, int n);
string strings__Builder_after(strings__Builder* b, int n);
string strings__Builder_str(strings__Builder* b);
void strings__Builder_ensure_cap(strings__Builder* b, int n);
void strings__Builder_grow_len(strings__Builder* b, int n);
void strings__Builder_free(strings__Builder* b);
void strings__Builder_write_repeated_rune(strings__Builder* b, rune r, int count);
void strings__Builder_indent(strings__Builder* b, string s, strings__IndentParam param);
VV_LOC int strings__min(int a, int b, int c);
VV_LOC int strings__max2(int a, int b);
VV_LOC int strings__min2(int a, int b);
VV_LOC int strings__abs2(int a, int b);
int strings__levenshtein_distance(string a, string b);
f32 strings__levenshtein_distance_percentage(string a, string b);
f32 strings__dice_coefficient(string s1, string s2);
int strings__hamming_distance(string a, string b);
f32 strings__hamming_similarity(string a, string b);
f64 strings__jaro_similarity(string a, string b);
f64 strings__jaro_winkler_similarity(string a, string b);
string strings__repeat(u8 c, int n);
string strings__repeat_string(string s, int n);
string strings__find_between_pair_u8(string input, u8 start, u8 end);
string strings__find_between_pair_rune(string input, rune start, rune end);
string strings__find_between_pair_string(string input, string start, string end);
Array_string strings__split_capital(string s);
VV_LOC void builtin__closure__closure_alloc(void);
VV_LOC void builtin__closure__closure_init(void);
VV_LOC voidptr builtin__closure__closure_create(voidptr func, voidptr data);
VV_LOC u8* builtin__closure__closure_alloc_platform(void);
VV_LOC void builtin__closure__closure_memory_protect_platform(voidptr ptr, isize size, builtin__closure__MemoryProtectAtrr attr);
VV_LOC int builtin__closure__get_page_size_platform(void);
VV_LOC void builtin__closure__closure_mtx_lock_init_platform(void);
VV_LOC void builtin__closure__closure_mtx_lock_platform(void);
VV_LOC void builtin__closure__closure_mtx_unlock_platform(void);
multi_return_u64_u64 math__bits__mul_64(u64 x, u64 y);
multi_return_u64_u64 math__bits__mul_add_64(u64 x, u64 y, u64 z);
int math__bits__leading_zeros_8(u8 x);
int math__bits__leading_zeros_16(u16 x);
int math__bits__leading_zeros_32(u32 x);
int math__bits__leading_zeros_64(u64 x);
int math__bits__trailing_zeros_8(u8 x);
int math__bits__trailing_zeros_16(u16 x);
int math__bits__trailing_zeros_32(u32 x);
int math__bits__trailing_zeros_64(u64 x);
int math__bits__ones_count_8(u8 x);
int math__bits__ones_count_16(u16 x);
int math__bits__ones_count_32(u32 x);
int math__bits__ones_count_64(u64 x);
int math__bits__pure_v_but_overridden_by_c_leading_zeros_8(u8 x);
VV_LOC int math__bits__leading_zeros_8_default(u8 x);
int math__bits__pure_v_but_overridden_by_c_leading_zeros_16(u16 x);
VV_LOC int math__bits__leading_zeros_16_default(u16 x);
int math__bits__pure_v_but_overridden_by_c_leading_zeros_32(u32 x);
VV_LOC int math__bits__leading_zeros_32_default(u32 x);
int math__bits__pure_v_but_overridden_by_c_leading_zeros_64(u64 x);
VV_LOC int math__bits__leading_zeros_64_default(u64 x);
int math__bits__pure_v_but_overridden_by_c_trailing_zeros_8(u8 x);
VV_LOC int math__bits__trailing_zeros_8_default(u8 x);
int math__bits__pure_v_but_overridden_by_c_trailing_zeros_16(u16 x);
VV_LOC int math__bits__trailing_zeros_16_default(u16 x);
int math__bits__pure_v_but_overridden_by_c_trailing_zeros_32(u32 x);
VV_LOC int math__bits__trailing_zeros_32_default(u32 x);
int math__bits__pure_v_but_overridden_by_c_trailing_zeros_64(u64 x);
VV_LOC int math__bits__trailing_zeros_64_default(u64 x);
int math__bits__pure_v_but_overridden_by_c_ones_count_8(u8 x);
VV_LOC int math__bits__ones_count_8_default(u8 x);
int math__bits__pure_v_but_overridden_by_c_ones_count_16(u16 x);
VV_LOC int math__bits__ones_count_16_default(u16 x);
int math__bits__pure_v_but_overridden_by_c_ones_count_32(u32 x);
VV_LOC int math__bits__ones_count_32_default(u32 x);
int math__bits__pure_v_but_overridden_by_c_ones_count_64(u64 x);
VV_LOC int math__bits__ones_count_64_default(u64 x);
u8 math__bits__rotate_left_8(u8 x, int k);
u16 math__bits__rotate_left_16(u16 x, int k);
u32 math__bits__rotate_left_32(u32 x, int k);
u64 math__bits__rotate_left_64(u64 x, int k);
u8 math__bits__reverse_8(u8 x);
u16 math__bits__reverse_16(u16 x);
u32 math__bits__reverse_32(u32 x);
u64 math__bits__reverse_64(u64 x);
u16 math__bits__reverse_bytes_16(u16 x);
u32 math__bits__reverse_bytes_32(u32 x);
u64 math__bits__reverse_bytes_64(u64 x);
int math__bits__len_8(u8 x);
int math__bits__len_16(u16 x);
int math__bits__len_32(u32 x);
int math__bits__len_64(u64 x);
multi_return_u32_u32 math__bits__add_32(u32 x, u32 y, u32 carry);
multi_return_u64_u64 math__bits__add_64(u64 x, u64 y, u64 carry);
multi_return_u32_u32 math__bits__sub_32(u32 x, u32 y, u32 borrow);
multi_return_u64_u64 math__bits__sub_64(u64 x, u64 y, u64 borrow);
multi_return_u32_u32 math__bits__mul_32(u32 x, u32 y);
VV_LOC multi_return_u32_u32 math__bits__mul_32_default(u32 x, u32 y);
multi_return_u64_u64 math__bits__pure_v_but_overridden_by_arm64_mul_64(u64 x, u64 y);
VV_LOC multi_return_u64_u64 math__bits__mul_64_default(u64 x, u64 y);
multi_return_u32_u32 math__bits__mul_add_32(u32 x, u32 y, u32 z);
VV_LOC multi_return_u32_u32 math__bits__mul_add_32_default(u32 x, u32 y, u32 z);
multi_return_u64_u64 math__bits__pure_v_but_overridden_by_arm64_mul_add_64(u64 x, u64 y, u64 z);
VV_LOC multi_return_u64_u64 math__bits__mul_add_64_default(u64 x, u64 y, u64 z);
multi_return_u32_u32 math__bits__div_32(u32 hi, u32 lo, u32 y);
VV_LOC multi_return_u32_u32 math__bits__div_32_default(u32 hi, u32 lo, u32 y);
multi_return_u64_u64 math__bits__div_64(u64 hi, u64 lo, u64 y1);
VV_LOC multi_return_u64_u64 math__bits__div_64_default(u64 hi, u64 lo, u64 y1);
u32 math__bits__rem_32(u32 hi, u32 lo, u32 y);
u64 math__bits__rem_64(u64 hi, u64 lo, u64 y);
multi_return_f64_int math__bits__normalize(f64 x);
u32 math__bits__f32_bits(f32 f);
f32 math__bits__f32_from_bits(u32 b);
u64 math__bits__f64_bits(f64 f);
f64 math__bits__f64_from_bits(u64 b);
VV_LOC multi_return_u32_u32_u32 strconv__lsr96(u32 s2, u32 s1, u32 s0);
VV_LOC multi_return_u32_u32_u32 strconv__lsl96(u32 s2, u32 s1, u32 s0);
VV_LOC multi_return_u32_u32_u32 strconv__add96(u32 s2, u32 s1, u32 s0, u32 d2, u32 d1, u32 d0);
VV_LOC multi_return_strconv__ParserState_strconv__PrepNumber strconv__parser(string s);
VV_LOC u64 strconv__converter(strconv__PrepNumber* pn);
_result_f64 strconv__atof64(string s, strconv__AtoF64Param param);
f64 strconv__atof_quick(string s);
u8 strconv__byte_to_lower(u8 c);
_result_u64 strconv__common_parse_uint(string s, int _base, int _bit_size, bool error_on_non_digit, bool error_on_high_digit);
multi_return_u64_int strconv__common_parse_uint2(string s, int _base, int _bit_size);
_result_u64 strconv__parse_uint(string s, int _base, int _bit_size);
_result_i64 strconv__common_parse_int(string _s, int base, int _bit_size, bool error_on_non_digit, bool error_on_high_digit);
_result_i64 strconv__parse_int(string _s, int base, int _bit_size);
VV_LOC _result_multi_return_i64_int strconv__atoi_common_check(string s);
VV_LOC _result_i64 strconv__atoi_common(string s, i64 type_min, i64 type_max);
_result_int strconv__atoi(string s);
_result_i8 strconv__atoi8(string s);
_result_i16 strconv__atoi16(string s);
_result_i32 strconv__atoi32(string s);
_result_i64 strconv__atoi64(string s);
VV_LOC _result_i64 strconv__safe_add_64bits(i64 a, i64 b);
VV_LOC _result_i64 strconv__safe_mul10_64bits(i64 a);
VV_LOC _result_int strconv__atou_common_check(string s);
VV_LOC _result_u64 strconv__atou_common(string s, u64 type_max);
_result_u8 strconv__atou8(string s);
_result_u16 strconv__atou16(string s);
_result_u32 strconv__atou(string s);
_result_u32 strconv__atou32(string s);
_result_u64 strconv__atou64(string s);
string strconv__Dec32_get_string_32(strconv__Dec32 d, bool neg, int i_n_digit, int i_pad_digit);
VV_LOC multi_return_strconv__Dec32_bool strconv__f32_to_decimal_exact_int(u32 i_mant, u32 exp);
VV_LOC strconv__Dec32 strconv__f32_to_decimal(u32 mant, u32 exp);
string strconv__f32_to_str(f32 f, int n_digit);
string strconv__f32_to_str_pad(f32 f, int n_digit);
VV_LOC string strconv__Dec64_get_string_64(strconv__Dec64 d, bool neg, int i_n_digit, int i_pad_digit);
VV_LOC multi_return_strconv__Dec64_bool strconv__f64_to_decimal_exact_int(u64 i_mant, u64 exp);
VV_LOC strconv__Dec64 strconv__f64_to_decimal(u64 mant, u64 exp);
string strconv__f64_to_str(f64 f, int n_digit);
string strconv__f64_to_str_pad(f64 f, int n_digit);
string strconv__format_str(string s, strconv__BF_param p);
void strconv__format_str_sb(string s, strconv__BF_param p, strings__Builder* sb);
void strconv__format_dec_sb(u64 d, strconv__BF_param p, strings__Builder* res);
string strconv__f64_to_str_lnd1(f64 f, int dec_digit);
string strconv__format_fl(f64 f, strconv__BF_param p);
string strconv__format_es(f64 f, strconv__BF_param p);
string strconv__remove_tail_zeros(string s);
string strconv__ftoa_64(f64 f);
string strconv__ftoa_long_64(f64 f);
string strconv__ftoa_32(f32 f);
string strconv__ftoa_long_32(f32 f);
string strconv__format_int(i64 n, int radix);
string strconv__format_uint(u64 n, int radix);
string strconv__f32_to_str_l(f32 f);
string strconv__f32_to_str_l_with_dot(f32 f);
string strconv__f64_to_str_l(f64 f);
string strconv__f64_to_str_l_with_dot(f64 f);
string strconv__fxx_to_str_l_parse(string s);
string strconv__fxx_to_str_l_parse_with_dot(string s);
VV_LOC u32 strconv__bool_to_u32(bool b);
VV_LOC u64 strconv__bool_to_u64(bool b);
VV_LOC string strconv__get_string_special(bool neg, bool expZero, bool mantZero);
VV_LOC u32 strconv__mul_shift_32(u32 m, u64 mul, int ishift);
VV_LOC u32 strconv__mul_pow5_invdiv_pow2(u32 m, u32 q, int j);
VV_LOC u32 strconv__mul_pow5_div_pow2(u32 m, u32 i, int j);
VV_LOC u32 strconv__pow5_factor_32(u32 i_v);
VV_LOC bool strconv__multiple_of_power_of_five_32(u32 v, u32 p);
VV_LOC bool strconv__multiple_of_power_of_two_32(u32 v, u32 p);
VV_LOC u32 strconv__log10_pow2(int e);
VV_LOC u32 strconv__log10_pow5(int e);
VV_LOC int strconv__pow5_bits(int e);
VV_LOC u64 strconv__shift_right_128(strconv__Uint128 v, int shift);
VV_LOC u64 strconv__mul_shift_64(u64 m, strconv__Uint128 mul, int shift);
VV_LOC u32 strconv__pow5_factor_64(u64 v_i);
VV_LOC bool strconv__multiple_of_power_of_five_64(u64 v, u32 p);
VV_LOC bool strconv__multiple_of_power_of_two_64(u64 v, u32 p);
int strconv__dec_digits(u64 n);
void strconv__v_printf(string str, Array_voidptr pt);
string strconv__v_sprintf(string str, Array_voidptr pt);
VV_LOC void strconv__v_sprintf_panic(int idx, int len);
VV_LOC f64 strconv__fabs(f64 x);
string strconv__format_fl_old(f64 f, strconv__BF_param p);
VV_LOC string strconv__format_es_old(f64 f, strconv__BF_param p);
VV_LOC string strconv__remove_tail_zeros_old(string s);
string strconv__format_dec_old(u64 d, strconv__BF_param p);
VV_LOC void builtin___memory_panic(string fname, isize size);
u8* builtin___v_malloc(isize n);
u8* builtin__malloc_noscan(isize n);
VV_LOC u64 builtin____at_least_one(u64 how_many);
u8* builtin__malloc_uncollectable(isize n);
u8* builtin__v_realloc(u8* b, isize n);
u8* builtin__realloc_data(u8* old_data, int old_size, int new_size);
u8* builtin__vcalloc(isize n);
u8* builtin__vcalloc_noscan(isize n);
void builtin___v_free(voidptr ptr);
voidptr builtin__memdup(voidptr src, isize sz);
voidptr builtin__memdup_noscan(voidptr src, isize sz);
voidptr builtin__memdup_uncollectable(voidptr src, isize sz);
voidptr builtin__memdup_align(voidptr src, isize sz, isize align);
GCHeapUsage builtin__gc_heap_usage(void);
usize builtin__gc_memory_use(void);
VV_LOC array builtin____new_array(int mylen, int cap, int elm_size);
VV_LOC array builtin____new_array_with_default(int mylen, int cap, int elm_size, voidptr val);
VV_LOC array builtin____new_array_with_multi_default(int mylen, int cap, int elm_size, voidptr val);
VV_LOC array builtin____new_array_with_array_default(int mylen, int cap, int elm_size, array val, int depth);
VV_LOC array builtin__new_array_from_c_array(int len, int cap, int elm_size, voidptr c_array);
void builtin__array_ensure_cap(array* a, int required);
array builtin__array_repeat(array a, int count);
array builtin__array_repeat_to_depth(array a, int count, int depth);
void builtin__array_insert(array* a, int i, voidptr val);
VV_LOC void builtin__array_insert_many(array* a, int i, voidptr val, int size);
void builtin__array_prepend(array* a, voidptr val);
VV_LOC void builtin__array_prepend_many(array* a, voidptr val, int size);
void builtin__array_delete(array* a, int i);
void builtin__array_delete_many(array* a, int i, int size);
void builtin__array_clear(array* a);
void builtin__array_reset(array* a);
void builtin__array_trim(array* a, int index);
void builtin__array_drop(array* a, int num);
VV_LOC voidptr builtin__array_get_unsafe(array a, int i);
VV_LOC voidptr builtin__array_get(array a, int i);
VV_LOC voidptr builtin__array_get_with_check(array a, int i);
voidptr builtin__array_first(array a);
voidptr builtin__array_last(array a);
voidptr builtin__array_pop_left(array* a);
voidptr builtin__array_pop(array* a);
void builtin__array_delete_last(array* a);
VV_LOC array builtin__array_slice(array a, int start, int _end);
VV_LOC array builtin__array_slice_ni(array a, int _start, int _end);
VV_LOC array builtin__array_clone_static_to_depth(array a, int depth);
array builtin__array_clone(array* a);
array builtin__array_clone_to_depth(array* a, int depth);
VV_LOC void builtin__array_set_unsafe(array* a, int i, voidptr val);
VV_LOC void builtin__array_set(array* a, int i, voidptr val);
VV_LOC void builtin__array_push(array* a, voidptr val);
void builtin__array_push_many(array* a, voidptr val, int size);
void builtin__array_reverse_in_place(array* a);
array builtin__array_reverse(array a);
void builtin__array_free(array* a);
array builtin__array_filter(array a, bool (*predicate)(voidptr ));
bool builtin__array_any(array a, bool (*predicate)(voidptr ));
int builtin__array_count(array a, bool (*predicate)(voidptr ));
bool builtin__array_all(array a, bool (*predicate)(voidptr ));
array builtin__array_map(array a, voidptr (*callback)(voidptr ));
void builtin__array_sort(array* a, int (*callback)(voidptr , voidptr ));
array builtin__array_sorted(array* a, int (*callback)(voidptr , voidptr ));
void builtin__array_sort_with_compare(array* a, int (*callback)(voidptr , voidptr ));
array builtin__array_sorted_with_compare(array* a, int (*callback)(voidptr , voidptr ));
bool builtin__array_contains(array a, voidptr value);
int builtin__array_index(array a, voidptr value);
int builtin__array_last_index(array a, voidptr value);
void Array_string_free(Array_string* a);
string Array_string_str(Array_string a);
string Array_u8_hex(Array_u8 b);
int builtin__copy(Array_u8* dst, Array_u8 src);
void builtin__array_grow_cap(array* a, int amount);
void builtin__array_grow_len(array* a, int amount);
Array_voidptr builtin__array_pointers(array a);
Array_u8 builtin__voidptr_vbytes(voidptr data, int len);
Array_u8 builtin__u8_vbytes(u8* data, int len);
void builtin__u8_free(u8* data);
VV_LOC void builtin__panic_on_negative_len(int len);
VV_LOC void builtin__panic_on_negative_cap(int cap);
VV_LOC array builtin____new_array_noscan(int mylen, int cap, int elm_size);
VV_LOC array builtin____new_array_with_default_noscan(int mylen, int cap, int elm_size, voidptr val);
VV_LOC array builtin____new_array_with_multi_default_noscan(int mylen, int cap, int elm_size, voidptr val);
VV_LOC array builtin____new_array_with_array_default_noscan(int mylen, int cap, int elm_size, array val, int depth);
VV_LOC void builtin__array_prepend_noscan(array* a, voidptr val);
VV_LOC void builtin__array_push_noscan(array* a, voidptr val);
VV_LOC void builtin__array_push_many_noscan(array* a, voidptr val, int size);
void builtin__print_backtrace(void);
bool builtin__print_backtrace_skipping_top_frames(int xskipframes);
VV_LOC bool builtin__print_backtrace_skipping_top_frames_bsd(int skipframes);
void builtin___v_exit(int code);
_result_void builtin__at_exit(void (*cb)());
VV_LOC void builtin__v_segmentation_fault_handler(i32 signal_number);
VV_LOC int builtin__v_fixed_index(int i, int len);
Array_string builtin__arguments(void);
string builtin__vcurrent_hash(void);
u64 builtin__v_getpid(void);
u64 builtin__v_gettid(void);
bool builtin__isnil(voidptr v);
VV_LOC void builtin__builtin_init(void);
void builtin__panic_lasterr(string base);
void builtin__gc_check_leaks(void);
bool builtin__gc_is_enabled(void);
void builtin__gc_enable(void);
void builtin__gc_disable(void);
void builtin__gc_collect(void);
void builtin__gc_get_warn_proc(void);
void builtin__gc_set_warn_proc(void (*cb)(char* msg, usize arg));
int builtin__vstrlen(u8* s);
int builtin__vstrlen_char(char* s);
voidptr builtin__vmemcpy(voidptr dest, const voidptr const_src, isize n);
voidptr builtin__vmemmove(voidptr dest, const voidptr const_src, isize n);
int builtin__vmemcmp(const voidptr const_s1, const voidptr const_s2, isize n);
voidptr builtin__vmemset(voidptr s, int c, isize n);
VV_LOC void builtin__vqsort(voidptr base, usize nmemb, usize size, int (*sort_cb)(const voidptr const_a, const voidptr const_b));
void builtin__chan_close(chan ch);
ChanState builtin__chan_try_pop(chan ch, voidptr obj);
ChanState builtin__chan_try_push(chan ch, voidptr obj);
VV_LOC void builtin___result_ok(voidptr data, _result* res, int size);
string builtin__IError_str(IError err);
string builtin__Error_msg(Error err);
int builtin__Error_code(Error err);
string builtin__MessageError_str(MessageError err);
string builtin__MessageError_msg(MessageError err);
int builtin__MessageError_code(MessageError err);
void builtin__MessageError_free(MessageError* err);
IError builtin___v_error(string message);
IError builtin__error_with_code(string message, int code);
VV_LOC void builtin___option_none(voidptr data, _option* option, int size);
VV_LOC void builtin___option_ok(voidptr data, _option* option, int size);
VV_LOC void builtin___option_clone(_option* current, _option* option, int size);
VV_LOC string builtin__None___str(None__ _d1);
string builtin__none_str(none _d1);
int builtin__input_character(void);
int builtin__print_character(u8 ch);
string builtin__f64_str(f64 x);
string builtin__f64_strg(f64 x);
string builtin__float_literal_str(float_literal d);
string builtin__f64_strsci(f64 x, int digit_num);
string builtin__f64_strlong(f64 x);
string builtin__f32_str(f32 x);
string builtin__f32_strg(f32 x);
string builtin__f32_strsci(f32 x, int digit_num);
string builtin__f32_strlong(f32 x);
f32 builtin__f32_abs(f32 a);
f64 builtin__f64_abs(f64 a);
f32 builtin__f32_min(f32 a, f32 b);
f32 builtin__f32_max(f32 a, f32 b);
f64 builtin__f64_min(f64 a, f64 b);
f64 builtin__f64_max(f64 a, f64 b);
bool builtin__f32_eq_epsilon(f32 a, f32 b);
bool builtin__f64_eq_epsilon(f64 a, f64 b);
_option_rune builtin__input_rune(void);
_option_rune builtin__InputRuneIterator_next(InputRuneIterator* self);
InputRuneIterator builtin__input_rune_iterator(void);
string builtin__ptr_str(voidptr ptr);
string builtin__isize_str(isize x);
string builtin__usize_str(usize x);
string builtin__char_str(char* cptr);
VV_LOC string builtin__int_str_l(int nn, int max);
string builtin__i8_str(i8 n);
string builtin__i16_str(i16 n);
string builtin__u16_str(u16 n);
string builtin__i32_str(i32 n);
string builtin__int_hex_full(int nn);
string builtin__int_str(int n);
string builtin__u32_str(u32 nn);
string builtin__int_literal_str(int_literal n);
string builtin__i64_str(i64 nn);
VV_LOC string builtin__impl_i64_to_string(i64 nn);
string builtin__u64_str(u64 nn);
string builtin__bool_str(bool b);
VV_LOC string builtin__u64_to_hex(u64 nn, u8 len);
VV_LOC string builtin__u64_to_hex_no_leading_zeros(u64 nn, u8 len);
string builtin__u8_hex(u8 nn);
string builtin__char_hex(char c);
string builtin__rune_hex(rune r);
string builtin__i8_hex(i8 nn);
string builtin__u16_hex(u16 nn);
string builtin__i16_hex(i16 nn);
string builtin__u32_hex(u32 nn);
string builtin__int_hex(int nn);
string builtin__int_hex2(int n);
string builtin__u64_hex(u64 nn);
string builtin__i64_hex(i64 nn);
string builtin__int_literal_hex(int_literal nn);
string builtin__voidptr_str(voidptr nn);
string builtin__byteptr_str(byteptr nn);
string builtin__charptr_str(charptr nn);
string builtin__u8_hex_full(u8 nn);
string builtin__i8_hex_full(i8 nn);
string builtin__u16_hex_full(u16 nn);
string builtin__i16_hex_full(i16 nn);
string builtin__u32_hex_full(u32 nn);
string builtin__i64_hex_full(i64 nn);
string builtin__voidptr_hex_full(voidptr nn);
string builtin__int_literal_hex_full(int_literal nn);
string builtin__u64_hex_full(u64 nn);
string builtin__u8_str(u8 b);
string builtin__u8_ascii_str(u8 b);
string builtin__u8_str_escaped(u8 b);
bool builtin__u8_is_capital(u8 c);
string Array_u8_bytestr(Array_u8 b);
_result_rune Array_u8_byterune(Array_u8 b);
string builtin__u8_repeat(u8 b, int count);
int builtin__int_min(int a, int b);
int builtin__int_max(int a, int b);
VV_LOC bool builtin__fast_string_eq(string a, string b);
VV_LOC u64 builtin__map_hash_string(voidptr pkey);
VV_LOC u64 builtin__map_hash_int_1(voidptr pkey);
VV_LOC u64 builtin__map_hash_int_2(voidptr pkey);
VV_LOC u64 builtin__map_hash_int_4(voidptr pkey);
VV_LOC u64 builtin__map_hash_int_8(voidptr pkey);
VV_LOC voidptr builtin__map_enum_fn(int kind, int esize);
VV_LOC void builtin__DenseArray_zeros_to_end(DenseArray* d);
VV_LOC DenseArray builtin__new_dense_array(int key_bytes, int value_bytes);
VV_LOC voidptr builtin__DenseArray_key(DenseArray* d, int i);
VV_LOC voidptr builtin__DenseArray_value(DenseArray* d, int i);
VV_LOC bool builtin__DenseArray_has_index(DenseArray* d, int i);
VV_LOC int builtin__DenseArray_expand(DenseArray* d);
VV_LOC bool builtin__map_eq_string(voidptr a, voidptr b);
VV_LOC bool builtin__map_eq_int_1(voidptr a, voidptr b);
VV_LOC bool builtin__map_eq_int_2(voidptr a, voidptr b);
VV_LOC bool builtin__map_eq_int_4(voidptr a, voidptr b);
VV_LOC bool builtin__map_eq_int_8(voidptr a, voidptr b);
VV_LOC void builtin__map_clone_string(voidptr dest, voidptr pkey);
VV_LOC void builtin__map_clone_int_1(voidptr dest, voidptr pkey);
VV_LOC void builtin__map_clone_int_2(voidptr dest, voidptr pkey);
VV_LOC void builtin__map_clone_int_4(voidptr dest, voidptr pkey);
VV_LOC void builtin__map_clone_int_8(voidptr dest, voidptr pkey);
VV_LOC void builtin__map_free_string(voidptr pkey);
VV_LOC void builtin__map_free_nop(voidptr _d1);
VV_LOC map builtin__new_map(int key_bytes, int value_bytes, u64 (*hash_fn)(voidptr ), bool (*key_eq_fn)(voidptr , voidptr ), void (*clone_fn)(voidptr , voidptr ), void (*free_fn)(voidptr ));
VV_LOC map builtin__new_map_init(u64 (*hash_fn)(voidptr ), bool (*key_eq_fn)(voidptr , voidptr ), void (*clone_fn)(voidptr , voidptr ), void (*free_fn)(voidptr ), int n, int key_bytes, int value_bytes, voidptr keys, voidptr values);
map builtin__map_move(map* m);
void builtin__map_clear(map* m);
VV_LOC multi_return_u32_u32 builtin__map_key_to_index(map* m, voidptr pkey);
VV_LOC multi_return_u32_u32 builtin__map_meta_less(map* m, u32 _index, u32 _metas);
VV_LOC void builtin__map_meta_greater(map* m, u32 _index, u32 _metas, u32 kvi);
VV_LOC void builtin__map_ensure_extra_metas(map* m, u32 probe_count);
VV_LOC void builtin__map_set(map* m, voidptr key, voidptr value);
VV_LOC void builtin__map_expand(map* m);
VV_LOC void builtin__map_rehash(map* m);
void builtin__map_reserve(map* m, u32 meta_bytes);
VV_LOC void builtin__map_cached_rehash(map* m, u32 old_cap);
VV_LOC voidptr builtin__map_get_and_set(map* m, voidptr key, voidptr zero);
VV_LOC voidptr builtin__map_get(map* m, voidptr key, voidptr zero);
VV_LOC voidptr builtin__map_get_check(map* m, voidptr key);
VV_LOC bool builtin__map_exists(map* m, voidptr key);
VV_LOC void builtin__DenseArray_delete(DenseArray* d, int i);
void builtin__map_delete(map* m, voidptr key);
array builtin__map_keys(map* m);
array builtin__map_values(map* m);
VV_LOC DenseArray builtin__DenseArray_clone(DenseArray* d);
map builtin__map_clone(map* m);
void builtin__map_free(map* m);
void builtin__VAssertMetaInfo_free(VAssertMetaInfo* ami);
void builtin__IError_free(IError* ie);
void builtin__panic_option_not_set(string s);
void builtin__panic_result_not_set(string s);
void builtin___v_panic(string s);
string builtin__c_error_number_str(int errnum);
void builtin__panic_n(string s, i64 number1);
void builtin__panic_n2(string s, i64 number1, i64 number2);
VV_LOC void builtin__panic_n3(string s, i64 number1, i64 number2, i64 number3);
void builtin__panic_error_number(string basestr, int errnum);
void builtin__eprintln(string s);
void builtin__eprint(string s);
void builtin__flush_stdout(void);
void builtin__flush_stderr(void);
void builtin__unbuffer_stdout(void);
void builtin__print(string s);
void builtin__println(string s);
VV_LOC void builtin___writeln_to_fd(int fd, string s);
VV_LOC void builtin___write_buf_to_fd(int fd, u8* buf, int buf_len);
string builtin__reuse_data_as_string(Array_u8 buffer);
Array_u8 builtin__reuse_string_as_data(string s);
string builtin__rune_str(rune c);
string Array_rune_string(Array_rune ra);
string builtin__rune_repeat(rune c, int count);
Array_u8 builtin__rune_bytes(rune c);
int builtin__rune_length_in_bytes(rune c);
rune builtin__rune_to_upper(rune c);
rune builtin__rune_to_lower(rune c);
rune builtin__rune_to_title(rune c);
VV_LOC rune builtin__rune_map_to(rune c, MapMode mode);
VV_LOC int builtin__mapnode_find_key(mapnode* n, string k);
VV_LOC bool builtin__mapnode_remove_key(mapnode* n, string k);
VV_LOC void builtin__mapnode_remove_from_leaf(mapnode* n, int idx);
VV_LOC void builtin__mapnode_remove_from_non_leaf(mapnode* n, int idx);
VV_LOC void builtin__mapnode_fill(mapnode* n, int idx);
VV_LOC void builtin__mapnode_borrow_from_prev(mapnode* n, int idx);
VV_LOC void builtin__mapnode_borrow_from_next(mapnode* n, int idx);
VV_LOC void builtin__mapnode_merge(mapnode* n, int idx);
void builtin__SortedMap_delete(SortedMap* m, string key);
VV_LOC int builtin__mapnode_subkeys(mapnode* n, Array_string* keys, int at);
Array_string builtin__SortedMap_keys(SortedMap* m);
VV_LOC void builtin__mapnode_free(mapnode* n);
void builtin__SortedMap_free(SortedMap* m);
Array_rune builtin__string_runes(string s);
string builtin__cstring_to_vstring(const char* const_s);
string builtin__tos_clone(const u8* const_s);
string builtin__tos(u8* s, int len);
string builtin__tos2(u8* s);
string builtin__tos3(char* s);
string builtin__tos4(u8* s);
string builtin__tos5(char* s);
string builtin__u8_vstring(u8* bp);
string builtin__u8_vstring_with_len(u8* bp, int len);
string builtin__char_vstring(char* cp);
string builtin__char_vstring_with_len(char* cp, int len);
string builtin__u8_vstring_literal(u8* bp);
string builtin__u8_vstring_literal_with_len(u8* bp, int len);
string builtin__char_vstring_literal(char* cp);
string builtin__char_vstring_literal_with_len(char* cp, int len);
int builtin__string_len_utf8(string s);
bool builtin__string_is_pure_ascii(string s);
string builtin__string_clone(string a);
string builtin__string_replace_once(string s, string rep, string with);
string builtin__string_replace(string s, string rep, string with);
string builtin__string_replace_each(string s, Array_string vals);
string builtin__string_replace_char(string s, u8 rep, u8 with, int repeat);
string builtin__string_normalize_tabs(string s, int tab_len);
string builtin__string_expand_tabs(string s, int tab_len);
bool builtin__string_bool(string s);
i8 builtin__string_i8(string s);
i16 builtin__string_i16(string s);
i32 builtin__string_i32(string s);
int builtin__string_int(string s);
i64 builtin__string_i64(string s);
f32 builtin__string_f32(string s);
f64 builtin__string_f64(string s);
Array_u8 builtin__string_u8_array(string s);
u8 builtin__string_u8(string s);
u16 builtin__string_u16(string s);
u32 builtin__string_u32(string s);
u64 builtin__string_u64(string s);
_result_u64 builtin__string_parse_uint(string s, int _base, int _bit_size);
_result_i64 builtin__string_parse_int(string s, int _base, int _bit_size);
VV_LOC bool builtin__string__eq(string s, string a);
int builtin__string_compare(string s, string a);
VV_LOC bool builtin__string__lt(string s, string a);
VV_LOC string builtin__string__plus(string s, string a);
VV_LOC string builtin__string_plus_two(string s, string a, string b);
Array_string builtin__string_split_any(string s, string delim);
Array_string builtin__string_rsplit_any(string s, string delim);
Array_string builtin__string_split(string s, string delim);
Array_string builtin__string_rsplit(string s, string delim);
_option_multi_return_string_string builtin__string_split_once(string s, string delim);
_option_multi_return_string_string builtin__string_rsplit_once(string s, string delim);
Array_string builtin__string_split_n(string s, string delim, int n);
Array_string builtin__string_split_nth(string s, string delim, int nth);
Array_string builtin__string_rsplit_nth(string s, string delim, int nth);
Array_string builtin__string_split_into_lines(string s);
Array_string builtin__string_split_by_space(string s);
string builtin__string_substr(string s, int start, int _end);
string builtin__string_substr_unsafe(string s, int start, int _end);
_result_string builtin__string_substr_with_check(string s, int start, int _end);
string builtin__string_substr_ni(string s, int _start, int _end);
int builtin__string_index_(string s, string p);
_option_int builtin__string_index(string s, string p);
_option_int builtin__string_last_index(string s, string needle);
VV_LOC int builtin__string_index_kmp(string s, string p);
int builtin__string_index_any(string s, string chars);
VV_LOC int builtin__string_index_last_(string s, string p);
_option_int builtin__string_index_after(string s, string p, int start);
int builtin__string_index_after_(string s, string p, int start);
int builtin__string_index_u8(string s, u8 c);
int builtin__string_last_index_u8(string s, u8 c);
int builtin__string_count(string s, string substr);
bool builtin__string_contains_u8(string s, u8 x);
bool builtin__string_contains(string s, string substr);
bool builtin__string_contains_any(string s, string chars);
bool builtin__string_contains_only(string s, string chars);
bool builtin__string_contains_any_substr(string s, Array_string substrs);
bool builtin__string_starts_with(string s, string p);
bool builtin__string_ends_with(string s, string p);
string builtin__string_to_lower_ascii(string s);
string builtin__string_to_lower(string s);
bool builtin__string_is_lower(string s);
string builtin__string_to_upper_ascii(string s);
string builtin__string_to_upper(string s);
bool builtin__string_is_upper(string s);
string builtin__string_capitalize(string s);
string builtin__string_uncapitalize(string s);
bool builtin__string_is_capital(string s);
bool builtin__string_starts_with_capital(string s);
string builtin__string_title(string s);
bool builtin__string_is_title(string s);
string builtin__string_find_between(string s, string start, string end);
string builtin__string_trim_space(string s);
string builtin__string_trim_space_left(string s);
string builtin__string_trim_space_right(string s);
string builtin__string_trim(string s, string cutset);
multi_return_int_int builtin__string_trim_indexes(string s, string cutset);
VV_LOC string builtin__string_trim_chars(string s, string cutset, TrimMode mode);
VV_LOC string builtin__string_trim_runes(string s, string cutset, TrimMode mode);
string builtin__string_trim_left(string s, string cutset);
string builtin__string_trim_right(string s, string cutset);
string builtin__string_trim_string_left(string s, string str);
string builtin__string_trim_string_right(string s, string str);
int builtin__compare_strings(string* a, string* b);
VV_LOC int builtin__compare_strings_by_len(string* a, string* b);
VV_LOC int builtin__compare_lower_strings(string* a, string* b);
void Array_string_sort_ignore_case(Array_string* s);
void Array_string_sort_by_len(Array_string* s);
string builtin__string_str(string s);
VV_LOC u8 builtin__string_at(string s, int idx);
bool builtin__string_is_oct(string str);
bool builtin__string_is_bin(string str);
bool builtin__string_is_hex(string str);
bool builtin__string_is_int(string str);
bool builtin__u8_is_space(u8 c);
bool builtin__u8_is_digit(u8 c);
bool builtin__u8_is_hex_digit(u8 c);
bool builtin__u8_is_oct_digit(u8 c);
bool builtin__u8_is_bin_digit(u8 c);
bool builtin__u8_is_letter(u8 c);
bool builtin__u8_is_alnum(u8 c);
void builtin__string_free(string* s);
string builtin__string_before(string s, string sub);
string builtin__string_all_before(string s, string sub);
string builtin__string_all_before_last(string s, string sub);
string builtin__string_all_after(string s, string sub);
string builtin__string_all_after_last(string s, string sub);
string builtin__string_all_after_first(string s, string sub);
string builtin__string_after(string s, string sub);
string builtin__string_after_char(string s, u8 sub);
string Array_string_join(Array_string a, string sep);
string Array_string_join_lines(Array_string s);
string builtin__string_reverse(string s);
string builtin__string_limit(string s, int max);
int builtin__string_hash(string s);
Array_u8 builtin__string_bytes(string s);
string builtin__string_repeat(string s, int count);
Array_string builtin__string_fields(string s);
string builtin__string_strip_margin(string s);
string builtin__string_strip_margin_custom(string s, u8 del);
string builtin__string_trim_indent(string s);
int builtin__string_indent_width(string s);
bool builtin__string_is_blank(string s);
bool builtin__string_match_glob(string name, string pattern);
bool builtin__string_is_ascii(string s);
bool builtin__string_is_identifier(string s);
string builtin__string_camel_to_snake(string s);
string builtin__string_snake_to_camel(string s);
string builtin__string_wrap(string s, WrapConfig config);
string builtin__string_hex(string s);
VV_LOC string builtin__data_to_hex_string(u8* data, int len);
RunesIterator builtin__string_runes_iterator(string s);
_option_rune builtin__RunesIterator_next(RunesIterator* ri);
Array_u8 builtin__byteptr_vbytes(byteptr data, int len);
string builtin__byteptr_vstring(byteptr bp);
string builtin__byteptr_vstring_with_len(byteptr bp, int len);
string builtin__charptr_vstring(charptr cp);
string builtin__charptr_vstring_with_len(charptr cp, int len);
string builtin__byteptr_vstring_literal(byteptr bp);
string builtin__byteptr_vstring_literal_with_len(byteptr bp, int len);
string builtin__charptr_vstring_literal(charptr cp);
string builtin__charptr_vstring_literal_with_len(charptr cp, int len);
string builtin__StrIntpType_str(StrIntpType x);
VV_LOC f32 builtin__fabs32(f32 x);
VV_LOC f64 builtin__fabs64(f64 x);
VV_LOC u64 builtin__abs64(i64 x);
u64 builtin__get_str_intp_u64_format(StrIntpType fmt_type, int in_width, int in_precision, bool in_tail_zeros, bool in_sign, u8 in_pad_ch, int in_base, bool in_upper_case);
u32 builtin__get_str_intp_u32_format(StrIntpType fmt_type, int in_width, int in_precision, bool in_tail_zeros, bool in_sign, u8 in_pad_ch, int in_base, bool in_upper_case);
VV_LOC void builtin__StrIntpData_process_str_intp_data(StrIntpData* data, strings__Builder* sb);
string builtin__str_intp(int data_len, StrIntpData* input_base);
string builtin__str_intp_sq(string in_str);
string builtin__str_intp_rune(string in_str);
string builtin__str_intp_g32(string in_str);
string builtin__str_intp_g64(string in_str);
string builtin__str_intp_sub(string base_str, string in_str);
u16* builtin__string_to_wide(string _str, ToWideConfig param);
string builtin__string_from_wide(u16* _wstr);
string builtin__string_from_wide2(u16* _wstr, int len);
Array_u8 builtin__wide_to_ansi(u16* _wstr);
int builtin__utf8_char_len(u8 b);
string builtin__utf32_to_str(u32 code);
string builtin__utf32_to_str_no_malloc(u32 code, u8* buf);
int builtin__utf32_decode_to_buffer(u32 code, u8* buf);
int builtin__string_utf32_code(string _rune);
_result_rune Array_u8_utf8_to_utf32(Array_u8 _bytes);
VV_LOC rune builtin__impl_utf8_to_utf32(u8* _bytes, int _bytes_len);
int builtin__utf8_str_visible_length(string s);
Array_u8 builtin__string_to_ansi_not_null_terminated(string _str);
bool builtin__ArrayFlags_is_empty(ArrayFlags* e);
bool builtin__ArrayFlags_has(ArrayFlags* e, ArrayFlags flag_);
bool builtin__ArrayFlags_all(ArrayFlags* e, ArrayFlags flag_);
void builtin__ArrayFlags_set(ArrayFlags* e, ArrayFlags flag_);
void builtin__ArrayFlags_set_all(ArrayFlags* e);
void builtin__ArrayFlags_clear(ArrayFlags* e, ArrayFlags flag_);
void builtin__ArrayFlags_clear_all(ArrayFlags* e);
void builtin__ArrayFlags_toggle(ArrayFlags* e, ArrayFlags flag_);
ArrayFlags builtin__ArrayFlags__static__zero(void);
strings__textscanner__TextScanner strings__textscanner__new(string input);
void strings__textscanner__TextScanner_free(strings__textscanner__TextScanner* ss);
int strings__textscanner__TextScanner_remaining(strings__textscanner__TextScanner* ss);
int strings__textscanner__TextScanner_next(strings__textscanner__TextScanner* ss);
void strings__textscanner__TextScanner_skip(strings__textscanner__TextScanner* ss);
void strings__textscanner__TextScanner_skip_n(strings__textscanner__TextScanner* ss, int n);
int strings__textscanner__TextScanner_peek(strings__textscanner__TextScanner* ss);
u8 strings__textscanner__TextScanner_peek_u8(strings__textscanner__TextScanner* ss);
int strings__textscanner__TextScanner_peek_n(strings__textscanner__TextScanner* ss, int n);
u8 strings__textscanner__TextScanner_peek_n_u8(strings__textscanner__TextScanner* ss, int n);
void strings__textscanner__TextScanner_back(strings__textscanner__TextScanner* ss);
void strings__textscanner__TextScanner_back_n(strings__textscanner__TextScanner* ss, int n);
int strings__textscanner__TextScanner_peek_back(strings__textscanner__TextScanner* ss);
int strings__textscanner__TextScanner_peek_back_n(strings__textscanner__TextScanner* ss, int n);
int strings__textscanner__TextScanner_current(strings__textscanner__TextScanner* ss);
void strings__textscanner__TextScanner_reset(strings__textscanner__TextScanner* ss);
void strings__textscanner__TextScanner_goto_end(strings__textscanner__TextScanner* ss);
void strings__textscanner__TextScanner_skip_whitespace(strings__textscanner__TextScanner* ss);
term__termios__TcFlag term__termios__flag(int value);
term__termios__TcFlag term__termios__invert(term__termios__TcFlag value);
int term__termios__tcgetattr(int fd, term__termios__Termios* termios_p);
int term__termios__tcsetattr(int fd, int optional_actions, term__termios__Termios* termios_p);
int term__termios__ioctl(int fd, u64 request, voidptr arg);
int term__termios__set_state(int fd, term__termios__Termios new_state);
void term__termios__Termios_disable_echo(term__termios__Termios* t);
int vphp__Val_type_id(vphp__Val v);
bool vphp__Val_is_array(vphp__Val v);
bool vphp__Val_is_string(vphp__Val v);
bool vphp__Val_is_long(vphp__Val v);
bool vphp__Val_is_double(vphp__Val v);
bool vphp__Val_is_bool(vphp__Val v);
bool vphp__Val_is_null(vphp__Val v);
bool vphp__Val_is_object(vphp__Val v);
vphp__Val vphp__Val_invoke(vphp__Val v, Array_vphp__Val args);
void vphp__Context_return_res(vphp__Context ctx, voidptr ptr, string label);
void vphp__Context_return_map(vphp__Context ctx, Map_string_string m);
void vphp__Context_return_struct_T_main__MotionReport(vphp__Context ctx, main__MotionReport s);
void vphp__Context_return_list_T_main__HeartPoint(vphp__Context ctx, Array_main__HeartPoint list);
voidptr vphp__Val_to_res(vphp__Val v);
bool vphp__Val_to_bool(vphp__Val v);
string vphp__Val_type_name(vphp__Val v);
vphp__Val vphp__Val_call(vphp__Val v, string method, Array_vphp__Val args);
void vphp__init_framework(int module_number);
VV_LOC void vphp__vphp_framework_init(int module_number);
VV_EXP void vphp_framework_init(int module_number); // exported fn vphp.vphp_framework_init
vphp__Val vphp__Context_arg_raw(vphp__Context ctx, int index);
void vphp__Context_return_object(vphp__Context ctx, Map_string_string props);
_result_vphp__Val vphp__Val_get(vphp__Val v, string key);
void vphp__report_error(int level, string msg);
string vphp__Val_to_string(vphp__Val v);
void vphp__Val_set_string(vphp__Val v, string s);
i64 vphp__Val_as_int(vphp__Val v);
Array_vphp__Val vphp__get_args(zend_execute_data* ex);
void vphp__throw_exception(string msg, int code);
void vphp__Val_set_int(vphp__Val v, i64 val);
void vphp__Context_return_int(vphp__Context ctx, i64 val);
void vphp__Context_return_string(vphp__Context ctx, string val);
void vphp__Context_return_map_f64(vphp__Context ctx, Map_string_f64 m);
void vphp__Context_return_map_int(vphp__Context ctx, Map_string_int m);
int vphp__Context_num_args(vphp__Context ctx);
string vphp__Context_arg_T_string(vphp__Context ctx, int index);
i64 vphp__Context_arg_T_i64(vphp__Context ctx, int index);
Array_string vphp__Context_arg_T_Array_string(vphp__Context ctx, int index);
Map_string_string vphp__Context_arg_T_Map_string_string(vphp__Context ctx, int index);
Array_f64 vphp__Context_arg_T_Array_f64(vphp__Context ctx, int index);
int vphp__Context_arg_T_int(vphp__Context ctx, int index);
bool vphp__Context_arg_T_bool(vphp__Context ctx, int index);
void vphp__return_val_T_i64(vphp__Context ctx, i64 val);
void vphp__return_val_T_string(vphp__Context ctx, string val);
vphp__Context vphp__new_context(zend_execute_data* ex, zval* ret);
VV_LOC void vphp__map_callback(voidptr p_ctx, char* key, zval* val);
vphp__Val vphp__call_php(string name, Array_vphp__Val args);
bool vphp__Context_has_exception(vphp__Context ctx);
vphp__Val vphp__Val_get_prop(vphp__Val v, string name);
string vphp__Val_get_prop_string(vphp__Val v, string name);
int vphp__Val_get_prop_int(vphp__Val v, string name);
VV_LOC vphp__TaskRegistry* vphp__get_registry(void);
void vphp__ITask__static__register(string name, vphp__ITask (*creator)());
_option_anon_fn___vphp__ITask vphp__ITask__static__get_creator(string name);
VV_LOC void vphp__framework_v_spawn(zend_execute_data* ex, zval* retval);
VV_EXP void v_spawn(zend_execute_data* ex, zval* retval); // exported fn vphp.framework_v_spawn
VV_LOC void vphp__framework_v_wait(zend_execute_data* ex, zval* retval);
VV_EXP void v_wait(zend_execute_data* ex, zval* retval); // exported fn vphp.framework_v_wait
Array_string os__args_after(string cut_word);
Array_string os__args_before(string cut_word);
_result_os__Command os__start_new_command(string cmd);
_result_void os__Command_start(os__Command* c);
string os__Command_read_line(os__Command* c);
_result_void os__Command_close(os__Command* c);
bool os__debugger_present(void);
string os__getenv(string key);
_option_string os__getenv_opt(string key);
int os__setenv(string name, string value, bool overwrite);
int os__unsetenv(string name);
Map_string_string os__environ(void);
int os__fd_close(int fd);
void os__fd_write(int fd, string s);
Array_string os__fd_slurp(int fd);
multi_return_string_int os__fd_read(int fd, int maxbytes);
bool os__fd_is_pending(int fd);
VV_LOC string os__NotExpected_msg(os__NotExpected err);
VV_LOC int os__NotExpected_code(os__NotExpected err);
VV_LOC string os__fix_windows_path(string path);
_result_os__File os__open_file(string path, string mode, Array_int options);
_result_os__File os__open(string path);
_result_os__File os__create(string path);
os__File os__stdin(void);
os__File os__stdout(void);
os__File os__stderr(void);
bool os__File_eof(os__File* f);
_result_void os__File_reopen(os__File* f, string path, string mode);
_result_int os__File_read(os__File* f, Array_u8* buf);
_result_int os__File_write(os__File* f, Array_u8 buf);
_result_int os__File_writeln(os__File* f, string s);
_result_int os__File_write_string(os__File* f, string s);
_result_int os__File_write_to(os__File* f, u64 pos, Array_u8 buf);
int os__File_write_ptr(os__File* f, voidptr data, int size);
_result_void os__File_write_full_buffer(os__File* f, voidptr buffer, usize buffer_len);
int os__File_write_ptr_at(os__File* f, voidptr data, int size, u64 pos);
VV_LOC _result_int os__fread(voidptr ptr, int item_size, int items, FILE* stream);
Array_u8 os__File_read_bytes(os__File* f, int size);
Array_u8 os__File_read_bytes_at(os__File* f, int size, u64 pos);
_result_int os__File_read_bytes_with_newline(os__File* f, Array_u8* buf);
_result_int os__File_read_bytes_into(os__File* f, u64 pos, Array_u8* buf);
_result_int os__File_read_from(os__File* f, u64 pos, Array_u8* buf);
_result_int os__File_read_into_ptr(os__File* f, u8* ptr, int max_size);
void os__File_flush(os__File* f);
string os__FileNotOpenedError_msg(os__FileNotOpenedError err);
string os__SizeOfTypeIs0Error_msg(os__SizeOfTypeIs0Error err);
VV_LOC IError os__error_file_not_opened(void);
_result_void os__File_seek(os__File* f, i64 pos, os__SeekMode mode);
_result_i64 os__File_tell(os__File* f);
int os__File_setvbuf(os__File* f, char* buffer, os__FileBufferMode mode, usize size);
int os__File_set_buffer(os__File* f, Array_u8* buffer, os__FileBufferMode mode);
void os__File_set_line_buffered(os__File* f);
void os__File_set_unbuffered(os__File* f);
_result_void os__File_write_u8(os__File* f, u8 b);
_result_u8 os__File_read_u8(os__File* f);
VV_LOC _result_void os__check_cf(usize x, string label);
VV_LOC _result_void os__check_fwrite(usize x);
VV_LOC _result_void os__check_fread(usize x);
bool os__is_abs_path(string path);
string os__abs_path(string path);
string os__norm_path(string path);
_result_string os__existing_path(string path);
VV_LOC string os__clean_path(string path);
string os__to_slash(string path);
string os__from_slash(string path);
VV_LOC int os__win_volume_len(string path);
VV_LOC bool os__is_slash(u8 b);
VV_LOC bool os__has_drive_letter(string path);
VV_LOC bool os__starts_w_slash_slash(string path);
VV_LOC bool os__is_curr_dir_ref(int byte_one, int byte_two, int byte_three);
u32 os__FilePermission_bitmask(os__FilePermission p);
u32 os__FileMode_bitmask(os__FileMode m);
os__FileInfo os__inode(string path);
_result_Array_u8 os__read_bytes(string path);
_result_void os__write_bytes(string path, Array_u8 bytes);
VV_LOC _result_int os__find_cfile_size(FILE* fp);
VV_LOC _result_strings__Builder os__slurp_file_in_builder(FILE* fp);
_result_string os__read_file(string path);
_result_void os__truncate(string path, u64 len);
u64 os__file_size(string path);
_result_void os__rename_dir(string src, string dst);
_result_void os__rename(string src, string dst);
_result_void os__cp(string src, string dst, os__CopyParams config);
_result_FILE_ptr os__vfopen(string path, string mode);
int os__fileno(voidptr cfile);
VV_LOC voidptr os__vpopen(string path);
VV_LOC multi_return_int_bool os__posix_wait4_to_exit_status(int waitret);
string os__posix_get_error_msg(int code);
VV_LOC int os__vpclose(voidptr f);
int os__system(string cmd);
bool os__exists(string path);
bool os__is_executable(string path);
bool os__is_writable(string path);
bool os__is_readable(string path);
_result_void os__rm(string path);
_result_void os__rmdir(string path);
VV_LOC void os__print_c_errno(void);
string os__get_raw_line(void);
Array_u8 os__get_raw_stdin(void);
string os__executable(void);
_result_void os__chdir(string path);
string os__getwd(void);
string os__real_path(string fpath);
VV_LOC void os__normalize_drive_letter(string path);
int os__fork(void);
int os__wait(void);
i64 os__file_last_mod_unix(string path);
void os__flush(void);
_result_void os__chmod(string path, int mode);
_result_void os__chown(string path, int owner, int group);
_result_os__File os__open_append(string path);
_result_void os__execvp(string cmdpath, Array_string cmdargs);
_result_void os__execve(string cmdpath, Array_string cmdargs, Array_string envs);
int os__is_atty(int fd);
_result_void os__write_file_array(string path, array buffer);
_result_Array_string os__glob(Array_string patterns);
IError os__last_error(void);
IError os__error_posix(os__SystemError e);
IError os__error_win32(os__SystemError e);
void os__Result_free(os__Result* result);
VV_LOC string os__executable_fallback(void);
_result_void os__cp_all(string src, string dst, bool overwrite);
_result_void os__mv_by_cp(string source, string target, os__MvParams opts);
_result_void os__mv(string source, string target, os__MvParams opts);
_result_Array_string os__read_lines(string path);
_result_void os__write_lines(string path, Array_string lines);
string os__sigint_to_signal_name(int si);
_result_void os__rmdir_all(string path);
bool os__is_dir_empty(string path);
string os__file_ext(string opath);
string os__dir(string path);
string os__base(string path);
string os__file_name(string path);
multi_return_string_string_string os__split_path(string path);
_option_string os__input_opt(string prompt);
string os__input(string prompt);
string os__get_line(void);
Array_string os__get_lines(void);
string os__get_lines_joined(void);
Array_string os__get_raw_lines(void);
string os__get_raw_lines_joined(void);
Array_string os__get_trimmed_lines(void);
string os__user_os(void);
_result_Array_string os__user_names(void);
string os__home_dir(void);
string os__expand_tilde_to_home(string path);
_result_void os__write_file(string path, string text);
string os__ExecutableNotFoundError_msg(os__ExecutableNotFoundError err);
VV_LOC IError os__error_failed_to_find_executable(void);
_result_string os__find_abs_path_of_executable(string exe_name);
bool os__exists_in_system_path(string prog);
bool os__is_file(string path);
string os__join_path(string base, Array_string dirs);
string os__join_path_single(string base, string elem);
VV_LOC void os__normalize_path_in_builder(strings__Builder* sb);
Array_string os__walk_ext(string path, string ext, os__WalkParams opts);
VV_LOC void os__impl_walk_ext(string path, string ext, Array_string* out, os__WalkParams opts);
void os__walk(string path, void (*f)(string ));
void os__walk_with_context(string path, voidptr context, void (*fcb)(voidptr , string ));
void os__log(string s);
_result_void os__mkdir_all(string opath, os__MkdirParams params);
VV_LOC void os__create_folder_when_it_does_not_exist(string path);
VV_LOC string os__xdg_home_folder(string ename, string lpath);
string os__cache_dir(void);
string os__data_dir(void);
string os__state_dir(void);
string os__local_bin_dir(void);
string os__temp_dir(void);
string os__vtmp_dir(void);
VV_LOC string os__default_vmodules_path(void);
string os__vmodules_dir(void);
Array_string os__vmodules_paths(void);
string os__resource_abs_path(string path);
os__Result os__execute_or_panic(string cmd);
os__Result os__execute_or_exit(string cmd);
_result_os__Result os__execute_opt(string cmd);
string os__quoted_path(string path);
_result_string os__config_dir(void);
VV_LOC Array_string os__glob_match(string dir, string pattern, string next_pattern, Array_string* matches);
VV_LOC _result_void os__native_glob_pattern(string pattern, Array_string* matches);
_result_void os__utime(string path, int actime, int modtime);
os__Uname os__uname(void);
_result_string os__hostname(void);
_result_string os__loginname(void);
_result_Array_string os__ls(string path);
_result_void os__mkdir(string path, os__MkdirParams params);
os__Result os__execute(string cmd);
os__Result os__raw_execute(string cmd);
_result_void os__symlink(string target, string link_name);
_result_string os__readlink(string path);
_result_void os__link(string origin, string target);
string os__get_error_msg(int code);
void os__File_close(os__File* f);
_result_void os__ensure_folder_is_writable(string folder);
int os__getpid(void);
int os__getppid(void);
int os__getuid(void);
int os__geteuid(void);
int os__getgid(void);
int os__getegid(void);
void os__posix_set_permission_bit(string path_s, u32 mode, bool enable);
int os__page_size(void);
_result_os__DiskUsage os__disk_usage(string path);
_result_string os__input_password(string prompt);
int os__fd_dup(int fd);
int os__fd_dup2(int fd1, int fd2);
_result_os__Pipe os__pipe(void);
void os__Pipe_close(os__Pipe* p);
_result_int os__Pipe_read(os__Pipe* p, Array_u8* buffer);
_result_int os__Pipe_write(os__Pipe* p, Array_u8 buffer);
_result_int os__Pipe_write_string(os__Pipe* p, string s);
Array_string os__Pipe_slurp(os__Pipe* p);
_result_os__IOCapture os__stdio_capture(void);
void os__IOCapture_stop(os__IOCapture* c);
void os__IOCapture_close(os__IOCapture* c);
multi_return_Array_string_Array_string os__IOCapture_finish(os__IOCapture* c);
void os__Process_signal_kill(os__Process* p);
void os__Process_signal_term(os__Process* p);
void os__Process_signal_pgkill(os__Process* p);
void os__Process_signal_stop(os__Process* p);
void os__Process_signal_continue(os__Process* p);
void os__Process_wait(os__Process* p);
void os__Process_close(os__Process* p);
void os__Process_free(os__Process* p);
VV_LOC int os__Process__spawn(os__Process* p);
bool os__Process_is_alive(os__Process* p);
void os__Process_set_redirect_stdio(os__Process* p);
void os__Process_stdin_write(os__Process* p, string s);
string os__Process_stdout_slurp(os__Process* p);
string os__Process_stderr_slurp(os__Process* p);
string os__Process_stdout_read(os__Process* p);
string os__Process_stderr_read(os__Process* p);
_option_string os__Process_pipe_read(os__Process* p, os__ChildProcessPipeKind pkind);
bool os__Process_is_pending(os__Process* p, os__ChildProcessPipeKind pkind);
VV_LOC string os__Process__read_from(os__Process* p, os__ChildProcessPipeKind pkind);
VV_LOC string os__Process__slurp_from(os__Process* p, os__ChildProcessPipeKind pkind);
VV_LOC void os__Process__write_to(os__Process* p, os__ChildProcessPipeKind pkind, string s);
VV_LOC bool os__Process__is_pending(os__Process* p, os__ChildProcessPipeKind pkind);
VV_LOC void os__Process__check_redirection_call(os__Process* p, string fn_name);
VV_LOC void os__Process__signal_stop(os__Process* p);
VV_LOC void os__Process__signal_continue(os__Process* p);
VV_LOC void os__Process__signal_kill(os__Process* p);
VV_LOC void os__Process__signal_term(os__Process* p);
VV_LOC void os__Process__signal_pgkill(os__Process* p);
VV_LOC void os__Process__wait(os__Process* p);
VV_LOC bool os__Process__is_alive(os__Process* p);
void os__Process_run(os__Process* p);
os__Process* os__new_process(string filename);
void os__Process_set_args(os__Process* p, Array_string pargs);
void os__Process_set_work_folder(os__Process* p, string path);
void os__Process_set_environment(os__Process* p, Map_string_string envs);
VV_LOC int os__Process_unix_spawn_process(os__Process* p);
VV_LOC void os__Process_unix_stop_process(os__Process* p);
VV_LOC void os__Process_unix_resume_process(os__Process* p);
VV_LOC void os__Process_unix_term_process(os__Process* p);
VV_LOC void os__Process_unix_kill_process(os__Process* p);
VV_LOC void os__Process_unix_kill_pgroup(os__Process* p);
VV_LOC void os__Process_unix_wait(os__Process* p);
VV_LOC bool os__Process_unix_is_alive(os__Process* p);
VV_LOC bool os__Process_impl_check_pid_status(os__Process* p, bool exit_early_on_ret0, int waitpid_options);
_result_anon_fn_os__signal os__signal_opt(os__Signal signum, void (*handler)(os__Signal ));
VV_LOC void os__ignore_signal_handler(os__Signal _signal);
void os__signal_ignore(Array_os__Signal args);
bool os__is_main_thread(void);
VV_LOC void os__signal_ignore_internal(Array_os__Signal args);
VV_LOC void os__sleep_ms(i64 ms);
_result_void os__open_uri(string uri);
_result_os__Stat os__stat(string path);
_result_os__Stat os__lstat(string path);
os__FileType os__Stat_get_filetype(os__Stat st);
os__FileMode os__Stat_get_mode(os__Stat st);
bool os__is_dir(string path);
bool os__is_link(string path);
VV_LOC os__PathKind os__kind_of_existing_path(string path);
VV_LOC void main__vphp_task_auto_startup(void);
VV_LOC vphp__ITask anon_fn_e0873e5963f3179a_40___vphp__ITask_146(void);
VV_EXP void vphp_task_auto_startup(void); // exported fn main.vphp_task_auto_startup
VV_LOC void main__main(void);
VV_LOC void main__v_reverse_string(zval* z_in, zval* z_out);
VV_EXP void v_reverse_string(zval* z_in, zval* z_out); // exported fn main.v_reverse_string
VV_LOC void main__v_logic_main(zend_execute_data* ex, zval* retval);
VV_EXP void v_logic_main(zend_execute_data* ex, zval* retval); // exported fn main.v_logic_main
VV_LOC void main__v_add(zend_execute_data* ex, zval* retval);
VV_EXP void v_add(zend_execute_data* ex, zval* retval); // exported fn main.v_add
VV_LOC void main__v_greet(zend_execute_data* ex, zval* retval);
VV_EXP void v_greet(zend_execute_data* ex, zval* retval); // exported fn main.v_greet
VV_LOC void main__v_process_list(zend_execute_data* ex, zval* retval);
VV_EXP void v_process_list(zend_execute_data* ex, zval* retval); // exported fn main.v_process_list
VV_LOC void main__v_test_map(zend_execute_data* ex, zval* retval);
VV_EXP void v_test_map(zend_execute_data* ex, zval* retval); // exported fn main.v_test_map
VV_LOC void main__v_get_config(zend_execute_data* ex, zval* retval);
VV_EXP void v_get_config(zend_execute_data* ex, zval* retval); // exported fn main.v_get_config
VV_LOC void main__v_get_user(zend_execute_data* ex, zval* retval);
VV_EXP void v_get_user(zend_execute_data* ex, zval* retval); // exported fn main.v_get_user
VV_LOC void main__v_call_back(zend_execute_data* ex, zval* retval);
VV_EXP void v_call_back(zend_execute_data* ex, zval* retval); // exported fn main.v_call_back
VV_LOC void main__v_new_coach(zend_execute_data* ex, zval* retval);
VV_EXP void v_new_coach(zend_execute_data* ex, zval* retval); // exported fn main.v_new_coach
VV_LOC void main__v_new_db(zend_execute_data* ex, zval* retval);
VV_EXP void v_new_db(zend_execute_data* ex, zval* retval); // exported fn main.v_new_db
VV_LOC void main__v_check_res(zend_execute_data* ex, zval* retval);
VV_EXP void v_check_res(zend_execute_data* ex, zval* retval); // exported fn main.v_check_res
VV_LOC void main__v_analyze_fitness_data(zend_execute_data* ex, zval* retval);
VV_EXP void v_analyze_fitness_data(zend_execute_data* ex, zval* retval); // exported fn main.v_analyze_fitness_data
VV_LOC void main__v_get_alerts(zend_execute_data* ex, zval* retval);
VV_EXP void v_get_alerts(zend_execute_data* ex, zval* retval); // exported fn main.v_get_alerts
VV_LOC void main__v_complex_test(zend_execute_data* ex, zval* retval);
VV_EXP void v_complex_test(zend_execute_data* ex, zval* retval); // exported fn main.v_complex_test
VV_LOC void main__v_analyze_user_object(zend_execute_data* ex, zval* retval);
VV_EXP void v_analyze_user_object(zend_execute_data* ex, zval* retval); // exported fn main.v_analyze_user_object
VV_LOC void main__v_trigger_user_action(zend_execute_data* ex, zval* retval);
VV_EXP void v_trigger_user_action(zend_execute_data* ex, zval* retval); // exported fn main.v_trigger_user_action
VV_LOC void main__v_call_php_closure(zend_execute_data* ex, zval* retval);
VV_EXP void v_call_php_closure(zend_execute_data* ex, zval* retval); // exported fn main.v_call_php_closure
VV_LOC Array_f64 main__AnalyzeTask_run(main__AnalyzeTask t);
bool Array_rune_arr_eq(Array_rune a, Array_rune b);

// V global/const non-precomputed definitions:
string _const_math__bits__overflow_error; // a string literal, inited later
string _const_strconv__digit_pairs; // a string literal, inited later
string _const_strconv__base_digits; // a string literal, inited later
string _const_digit_pairs; // a string literal, inited later
string _const_si_s_code; // a string literal, inited later
string _const_si_g32_code; // a string literal, inited later
string _const_si_g64_code; // a string literal, inited later
string _const_os__fslash_str; // a string literal, inited later
string _const_os__dot_dot; // a string literal, inited later
string _const_os__empty_str; // a string literal, inited later
string _const_os__dot_str; // a string literal, inited later
string _const_os__path_separator; // a string literal, inited later
string _const_os__path_delimiter; // a string literal, inited later
string _const_os__path_devnull; // a string literal, inited later
builtin__closure__Closure g_closure; // global 6

Array_fixed_u8_12 _const_builtin__closure__closure_thunk; // inited later
Array_fixed_u8_8 _const_builtin__closure__closure_get_data_bytes; // inited later
const u32 _const_math__bits__de_bruijn32 = 125613361; // precomputed2
Array_fixed_u8_32 _const_math__bits__de_bruijn32tab = {((u8)(0)), 1, 28, 2, 29, 14, 24, 3, 30, 22, 20, 15, 25, 17, 4, 8, 
31, 27, 13, 23, 21, 19, 16, 7, 26, 12, 18, 6, 11, 5, 10, 9}; // fixed array const
const u64 _const_math__bits__de_bruijn64 = 285870213051353865U; // precomputed2
Array_fixed_u8_64 _const_math__bits__de_bruijn64tab = {((u8)(0)), 1, 56, 2, 57, 49, 28, 3, 61, 58, 42, 50, 38, 29, 17, 4, 
62, 47, 59, 36, 45, 43, 51, 22, 53, 39, 33, 30, 24, 18, 12, 5, 
63, 55, 48, 27, 60, 41, 37, 16, 46, 35, 44, 21, 52, 32, 23, 11, 
54, 26, 40, 15, 34, 20, 31, 10, 25, 14, 19, 9, 13, 8, 7, 6}; // fixed array const
const u64 _const_math__bits__m0 = 6148914691236517205U; // precomputed2
const u64 _const_math__bits__m1 = 3689348814741910323U; // precomputed2
const u64 _const_math__bits__m2 = 1085102592571150095U; // precomputed2
const u64 _const_math__bits__m3 = 71777214294589695U; // precomputed2
const u64 _const_math__bits__m4 = 281470681808895U; // precomputed2
const u8 _const_math__bits__n8 = 8; // precomputed2
const u16 _const_math__bits__n16 = 16; // precomputed2
const u32 _const_math__bits__n32 = 32; // precomputed2
const u64 _const_math__bits__n64 = 64U; // precomputed2
const u64 _const_math__bits__two32 = 4294967296U; // precomputed2
const u64 _const_math__bits__mask32 = 4294967295U; // precomputed2
Array_fixed_u8_256 _const_math__bits__ntz_8_tab = {((u8)(0x08)), 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 
0x04, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 
0x05, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 
0x04, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 
0x06, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 
0x04, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 
0x05, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 
0x04, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 
0x07, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 
0x04, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 
0x05, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 
0x04, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 
0x06, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 
0x04, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 
0x05, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 
0x04, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00}; // fixed array const
Array_fixed_u8_256 _const_math__bits__pop_8_tab = {((u8)(0x00)), 0x01, 0x01, 0x02, 0x01, 0x02, 0x02, 0x03, 0x01, 0x02, 0x02, 0x03, 0x02, 0x03, 0x03, 0x04, 
0x01, 0x02, 0x02, 0x03, 0x02, 0x03, 0x03, 0x04, 0x02, 0x03, 0x03, 0x04, 0x03, 0x04, 0x04, 0x05, 
0x01, 0x02, 0x02, 0x03, 0x02, 0x03, 0x03, 0x04, 0x02, 0x03, 0x03, 0x04, 0x03, 0x04, 0x04, 0x05, 
0x02, 0x03, 0x03, 0x04, 0x03, 0x04, 0x04, 0x05, 0x03, 0x04, 0x04, 0x05, 0x04, 0x05, 0x05, 0x06, 
0x01, 0x02, 0x02, 0x03, 0x02, 0x03, 0x03, 0x04, 0x02, 0x03, 0x03, 0x04, 0x03, 0x04, 0x04, 0x05, 
0x02, 0x03, 0x03, 0x04, 0x03, 0x04, 0x04, 0x05, 0x03, 0x04, 0x04, 0x05, 0x04, 0x05, 0x05, 0x06, 
0x02, 0x03, 0x03, 0x04, 0x03, 0x04, 0x04, 0x05, 0x03, 0x04, 0x04, 0x05, 0x04, 0x05, 0x05, 0x06, 
0x03, 0x04, 0x04, 0x05, 0x04, 0x05, 0x05, 0x06, 0x04, 0x05, 0x05, 0x06, 0x05, 0x06, 0x06, 0x07, 
0x01, 0x02, 0x02, 0x03, 0x02, 0x03, 0x03, 0x04, 0x02, 0x03, 0x03, 0x04, 0x03, 0x04, 0x04, 0x05, 
0x02, 0x03, 0x03, 0x04, 0x03, 0x04, 0x04, 0x05, 0x03, 0x04, 0x04, 0x05, 0x04, 0x05, 0x05, 0x06, 
0x02, 0x03, 0x03, 0x04, 0x03, 0x04, 0x04, 0x05, 0x03, 0x04, 0x04, 0x05, 0x04, 0x05, 0x05, 0x06, 
0x03, 0x04, 0x04, 0x05, 0x04, 0x05, 0x05, 0x06, 0x04, 0x05, 0x05, 0x06, 0x05, 0x06, 0x06, 0x07, 
0x02, 0x03, 0x03, 0x04, 0x03, 0x04, 0x04, 0x05, 0x03, 0x04, 0x04, 0x05, 0x04, 0x05, 0x05, 0x06, 
0x03, 0x04, 0x04, 0x05, 0x04, 0x05, 0x05, 0x06, 0x04, 0x05, 0x05, 0x06, 0x05, 0x06, 0x06, 0x07, 
0x03, 0x04, 0x04, 0x05, 0x04, 0x05, 0x05, 0x06, 0x04, 0x05, 0x05, 0x06, 0x05, 0x06, 0x06, 0x07, 
0x04, 0x05, 0x05, 0x06, 0x05, 0x06, 0x06, 0x07, 0x05, 0x06, 0x06, 0x07, 0x06, 0x07, 0x07, 0x08}; // fixed array const
Array_fixed_u8_256 _const_math__bits__rev_8_tab = {((u8)(0x00)), 0x80, 0x40, 0xc0, 0x20, 0xa0, 0x60, 0xe0, 0x10, 0x90, 0x50, 0xd0, 0x30, 0xb0, 0x70, 0xf0, 
0x08, 0x88, 0x48, 0xc8, 0x28, 0xa8, 0x68, 0xe8, 0x18, 0x98, 0x58, 0xd8, 0x38, 0xb8, 0x78, 0xf8, 
0x04, 0x84, 0x44, 0xc4, 0x24, 0xa4, 0x64, 0xe4, 0x14, 0x94, 0x54, 0xd4, 0x34, 0xb4, 0x74, 0xf4, 
0x0c, 0x8c, 0x4c, 0xcc, 0x2c, 0xac, 0x6c, 0xec, 0x1c, 0x9c, 0x5c, 0xdc, 0x3c, 0xbc, 0x7c, 0xfc, 
0x02, 0x82, 0x42, 0xc2, 0x22, 0xa2, 0x62, 0xe2, 0x12, 0x92, 0x52, 0xd2, 0x32, 0xb2, 0x72, 0xf2, 
0x0a, 0x8a, 0x4a, 0xca, 0x2a, 0xaa, 0x6a, 0xea, 0x1a, 0x9a, 0x5a, 0xda, 0x3a, 0xba, 0x7a, 0xfa, 
0x06, 0x86, 0x46, 0xc6, 0x26, 0xa6, 0x66, 0xe6, 0x16, 0x96, 0x56, 0xd6, 0x36, 0xb6, 0x76, 0xf6, 
0x0e, 0x8e, 0x4e, 0xce, 0x2e, 0xae, 0x6e, 0xee, 0x1e, 0x9e, 0x5e, 0xde, 0x3e, 0xbe, 0x7e, 0xfe, 
0x01, 0x81, 0x41, 0xc1, 0x21, 0xa1, 0x61, 0xe1, 0x11, 0x91, 0x51, 0xd1, 0x31, 0xb1, 0x71, 0xf1, 
0x09, 0x89, 0x49, 0xc9, 0x29, 0xa9, 0x69, 0xe9, 0x19, 0x99, 0x59, 0xd9, 0x39, 0xb9, 0x79, 0xf9, 
0x05, 0x85, 0x45, 0xc5, 0x25, 0xa5, 0x65, 0xe5, 0x15, 0x95, 0x55, 0xd5, 0x35, 0xb5, 0x75, 0xf5, 
0x0d, 0x8d, 0x4d, 0xcd, 0x2d, 0xad, 0x6d, 0xed, 0x1d, 0x9d, 0x5d, 0xdd, 0x3d, 0xbd, 0x7d, 0xfd, 
0x03, 0x83, 0x43, 0xc3, 0x23, 0xa3, 0x63, 0xe3, 0x13, 0x93, 0x53, 0xd3, 0x33, 0xb3, 0x73, 0xf3, 
0x0b, 0x8b, 0x4b, 0xcb, 0x2b, 0xab, 0x6b, 0xeb, 0x1b, 0x9b, 0x5b, 0xdb, 0x3b, 0xbb, 0x7b, 0xfb, 
0x07, 0x87, 0x47, 0xc7, 0x27, 0xa7, 0x67, 0xe7, 0x17, 0x97, 0x57, 0xd7, 0x37, 0xb7, 0x77, 0xf7, 
0x0f, 0x8f, 0x4f, 0xcf, 0x2f, 0xaf, 0x6f, 0xef, 0x1f, 0x9f, 0x5f, 0xdf, 0x3f, 0xbf, 0x7f, 0xff}; // fixed array const
Array_fixed_u8_256 _const_math__bits__len_8_tab = {((u8)(0x00)), 0x01, 0x02, 0x02, 0x03, 0x03, 0x03, 0x03, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 
0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 
0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 
0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 
0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 
0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 
0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 
0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 
0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 
0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 
0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 
0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 
0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 
0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 
0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 
0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08}; // fixed array const
const u32 _const_strconv__single_plus_zero = 0; // precomputed2
const u32 _const_strconv__single_minus_zero = 2147483648; // precomputed2
const u32 _const_strconv__single_plus_infinity = 2139095040; // precomputed2
const u32 _const_strconv__single_minus_infinity = 4286578688; // precomputed2
const u64 _const_strconv__double_plus_zero = 0U; // precomputed2
const u64 _const_strconv__double_minus_zero = 9223372036854775808U; // precomputed2
const u64 _const_strconv__double_plus_infinity = 9218868437227405312U; // precomputed2
const u64 _const_strconv__double_minus_infinity = 18442240474082181120U; // precomputed2
const u32 _const_strconv__c_ten = 10; // precomputed2
Array_fixed_u64_309 _const_strconv__pos_exp = {((u64)(0x3ff0000000000000LL)), ((u64)(0x4024000000000000LL)), ((u64)(0x4059000000000000LL)), ((u64)(0x408f400000000000LL)), ((u64)(0x40c3880000000000LL)), ((u64)(0x40f86a0000000000LL)), ((u64)(0x412e848000000000LL)), ((u64)(0x416312d000000000LL)), ((u64)(0x4197d78400000000LL)), ((u64)(0x41cdcd6500000000LL)), ((u64)(0x4202a05f20000000LL)), ((u64)(0x42374876e8000000LL)), ((u64)(0x426d1a94a2000000LL)), ((u64)(0x42a2309ce5400000LL)), ((u64)(0x42d6bcc41e900000LL)), ((u64)(0x430c6bf526340000LL)), 
((u64)(0x4341c37937e08000LL)), ((u64)(0x4376345785d8a000LL)), ((u64)(0x43abc16d674ec800LL)), ((u64)(0x43e158e460913d00LL)), ((u64)(0x4415af1d78b58c40LL)), ((u64)(0x444b1ae4d6e2ef50LL)), ((u64)(0x4480f0cf064dd592LL)), ((u64)(0x44b52d02c7e14af6LL)), ((u64)(0x44ea784379d99db4LL)), ((u64)(0x45208b2a2c280291LL)), ((u64)(0x4554adf4b7320335LL)), ((u64)(0x4589d971e4fe8402LL)), ((u64)(0x45c027e72f1f1281LL)), ((u64)(0x45f431e0fae6d721LL)), ((u64)(0x46293e5939a08ceaLL)), ((u64)(0x465f8def8808b024LL)), 
((u64)(0x4693b8b5b5056e17LL)), ((u64)(0x46c8a6e32246c99cLL)), ((u64)(0x46fed09bead87c03LL)), ((u64)(0x4733426172c74d82LL)), ((u64)(0x476812f9cf7920e3LL)), ((u64)(0x479e17b84357691bLL)), ((u64)(0x47d2ced32a16a1b1LL)), ((u64)(0x48078287f49c4a1dLL)), ((u64)(0x483d6329f1c35ca5LL)), ((u64)(0x48725dfa371a19e7LL)), ((u64)(0x48a6f578c4e0a061LL)), ((u64)(0x48dcb2d6f618c879LL)), ((u64)(0x4911efc659cf7d4cLL)), ((u64)(0x49466bb7f0435c9eLL)), ((u64)(0x497c06a5ec5433c6LL)), ((u64)(0x49b18427b3b4a05cLL)), 
((u64)(0x49e5e531a0a1c873LL)), ((u64)(0x4a1b5e7e08ca3a8fLL)), ((u64)(0x4a511b0ec57e649aLL)), ((u64)(0x4a8561d276ddfdc0LL)), ((u64)(0x4ababa4714957d30LL)), ((u64)(0x4af0b46c6cdd6e3eLL)), ((u64)(0x4b24e1878814c9ceLL)), ((u64)(0x4b5a19e96a19fc41LL)), ((u64)(0x4b905031e2503da9LL)), ((u64)(0x4bc4643e5ae44d13LL)), ((u64)(0x4bf97d4df19d6057LL)), ((u64)(0x4c2fdca16e04b86dLL)), ((u64)(0x4c63e9e4e4c2f344LL)), ((u64)(0x4c98e45e1df3b015LL)), ((u64)(0x4ccf1d75a5709c1bLL)), ((u64)(0x4d03726987666191LL)), 
((u64)(0x4d384f03e93ff9f5LL)), ((u64)(0x4d6e62c4e38ff872LL)), ((u64)(0x4da2fdbb0e39fb47LL)), ((u64)(0x4dd7bd29d1c87a19LL)), ((u64)(0x4e0dac74463a989fLL)), ((u64)(0x4e428bc8abe49f64LL)), ((u64)(0x4e772ebad6ddc73dLL)), ((u64)(0x4eacfa698c95390cLL)), ((u64)(0x4ee21c81f7dd43a7LL)), ((u64)(0x4f16a3a275d49491LL)), ((u64)(0x4f4c4c8b1349b9b5LL)), ((u64)(0x4f81afd6ec0e1411LL)), ((u64)(0x4fb61bcca7119916LL)), ((u64)(0x4feba2bfd0d5ff5bLL)), ((u64)(0x502145b7e285bf99LL)), ((u64)(0x50559725db272f7fLL)), 
((u64)(0x508afcef51f0fb5fLL)), ((u64)(0x50c0de1593369d1bLL)), ((u64)(0x50f5159af8044462LL)), ((u64)(0x512a5b01b605557bLL)), ((u64)(0x516078e111c3556dLL)), ((u64)(0x5194971956342ac8LL)), ((u64)(0x51c9bcdfabc1357aLL)), ((u64)(0x5200160bcb58c16cLL)), ((u64)(0x52341b8ebe2ef1c7LL)), ((u64)(0x526922726dbaae39LL)), ((u64)(0x529f6b0f092959c7LL)), ((u64)(0x52d3a2e965b9d81dLL)), ((u64)(0x53088ba3bf284e24LL)), ((u64)(0x533eae8caef261adLL)), ((u64)(0x53732d17ed577d0cLL)), ((u64)(0x53a7f85de8ad5c4fLL)), 
((u64)(0x53ddf67562d8b363LL)), ((u64)(0x5412ba095dc7701eLL)), ((u64)(0x5447688bb5394c25LL)), ((u64)(0x547d42aea2879f2eLL)), ((u64)(0x54b249ad2594c37dLL)), ((u64)(0x54e6dc186ef9f45cLL)), ((u64)(0x551c931e8ab87173LL)), ((u64)(0x5551dbf316b346e8LL)), ((u64)(0x558652efdc6018a2LL)), ((u64)(0x55bbe7abd3781ecaLL)), ((u64)(0x55f170cb642b133fLL)), ((u64)(0x5625ccfe3d35d80eLL)), ((u64)(0x565b403dcc834e12LL)), ((u64)(0x569108269fd210cbLL)), ((u64)(0x56c54a3047c694feLL)), ((u64)(0x56fa9cbc59b83a3dLL)), 
((u64)(0x5730a1f5b8132466LL)), ((u64)(0x5764ca732617ed80LL)), ((u64)(0x5799fd0fef9de8e0LL)), ((u64)(0x57d03e29f5c2b18cLL)), ((u64)(0x58044db473335defLL)), ((u64)(0x583961219000356bLL)), ((u64)(0x586fb969f40042c5LL)), ((u64)(0x58a3d3e2388029bbLL)), ((u64)(0x58d8c8dac6a0342aLL)), ((u64)(0x590efb1178484135LL)), ((u64)(0x59435ceaeb2d28c1LL)), ((u64)(0x59783425a5f872f1LL)), ((u64)(0x59ae412f0f768fadLL)), ((u64)(0x59e2e8bd69aa19ccLL)), ((u64)(0x5a17a2ecc414a03fLL)), ((u64)(0x5a4d8ba7f519c84fLL)), 
((u64)(0x5a827748f9301d32LL)), ((u64)(0x5ab7151b377c247eLL)), ((u64)(0x5aecda62055b2d9eLL)), ((u64)(0x5b22087d4358fc82LL)), ((u64)(0x5b568a9c942f3ba3LL)), ((u64)(0x5b8c2d43b93b0a8cLL)), ((u64)(0x5bc19c4a53c4e697LL)), ((u64)(0x5bf6035ce8b6203dLL)), ((u64)(0x5c2b843422e3a84dLL)), ((u64)(0x5c6132a095ce4930LL)), ((u64)(0x5c957f48bb41db7cLL)), ((u64)(0x5ccadf1aea12525bLL)), ((u64)(0x5d00cb70d24b7379LL)), ((u64)(0x5d34fe4d06de5057LL)), ((u64)(0x5d6a3de04895e46dLL)), ((u64)(0x5da066ac2d5daec4LL)), 
((u64)(0x5dd4805738b51a75LL)), ((u64)(0x5e09a06d06e26112LL)), ((u64)(0x5e400444244d7cabLL)), ((u64)(0x5e7405552d60dbd6LL)), ((u64)(0x5ea906aa78b912ccLL)), ((u64)(0x5edf485516e7577fLL)), ((u64)(0x5f138d352e5096afLL)), ((u64)(0x5f48708279e4bc5bLL)), ((u64)(0x5f7e8ca3185deb72LL)), ((u64)(0x5fb317e5ef3ab327LL)), ((u64)(0x5fe7dddf6b095ff1LL)), ((u64)(0x601dd55745cbb7edLL)), ((u64)(0x6052a5568b9f52f4LL)), ((u64)(0x60874eac2e8727b1LL)), ((u64)(0x60bd22573a28f19dLL)), ((u64)(0x60f2357684599702LL)), 
((u64)(0x6126c2d4256ffcc3LL)), ((u64)(0x615c73892ecbfbf4LL)), ((u64)(0x6191c835bd3f7d78LL)), ((u64)(0x61c63a432c8f5cd6LL)), ((u64)(0x61fbc8d3f7b3340cLL)), ((u64)(0x62315d847ad00087LL)), ((u64)(0x6265b4e5998400a9LL)), ((u64)(0x629b221effe500d4LL)), ((u64)(0x62d0f5535fef2084LL)), ((u64)(0x630532a837eae8a5LL)), ((u64)(0x633a7f5245e5a2cfLL)), ((u64)(0x63708f936baf85c1LL)), ((u64)(0x63a4b378469b6732LL)), ((u64)(0x63d9e056584240feLL)), ((u64)(0x64102c35f729689fLL)), ((u64)(0x6444374374f3c2c6LL)), 
((u64)(0x647945145230b378LL)), ((u64)(0x64af965966bce056LL)), ((u64)(0x64e3bdf7e0360c36LL)), ((u64)(0x6518ad75d8438f43LL)), ((u64)(0x654ed8d34e547314LL)), ((u64)(0x6583478410f4c7ecLL)), ((u64)(0x65b819651531f9e8LL)), ((u64)(0x65ee1fbe5a7e7861LL)), ((u64)(0x6622d3d6f88f0b3dLL)), ((u64)(0x665788ccb6b2ce0cLL)), ((u64)(0x668d6affe45f818fLL)), ((u64)(0x66c262dfeebbb0f9LL)), ((u64)(0x66f6fb97ea6a9d38LL)), ((u64)(0x672cba7de5054486LL)), ((u64)(0x6761f48eaf234ad4LL)), ((u64)(0x679671b25aec1d89LL)), 
((u64)(0x67cc0e1ef1a724ebLL)), ((u64)(0x680188d357087713LL)), ((u64)(0x6835eb082cca94d7LL)), ((u64)(0x686b65ca37fd3a0dLL)), ((u64)(0x68a11f9e62fe4448LL)), ((u64)(0x68d56785fbbdd55aLL)), ((u64)(0x690ac1677aad4ab1LL)), ((u64)(0x6940b8e0acac4eafLL)), ((u64)(0x6974e718d7d7625aLL)), ((u64)(0x69aa20df0dcd3af1LL)), ((u64)(0x69e0548b68a044d6LL)), ((u64)(0x6a1469ae42c8560cLL)), ((u64)(0x6a498419d37a6b8fLL)), ((u64)(0x6a7fe52048590673LL)), ((u64)(0x6ab3ef342d37a408LL)), ((u64)(0x6ae8eb0138858d0aLL)), 
((u64)(0x6b1f25c186a6f04cLL)), ((u64)(0x6b537798f4285630LL)), ((u64)(0x6b88557f31326bbbLL)), ((u64)(0x6bbe6adefd7f06aaLL)), ((u64)(0x6bf302cb5e6f642aLL)), ((u64)(0x6c27c37e360b3d35LL)), ((u64)(0x6c5db45dc38e0c82LL)), ((u64)(0x6c9290ba9a38c7d1LL)), ((u64)(0x6cc734e940c6f9c6LL)), ((u64)(0x6cfd022390f8b837LL)), ((u64)(0x6d3221563a9b7323LL)), ((u64)(0x6d66a9abc9424febLL)), ((u64)(0x6d9c5416bb92e3e6LL)), ((u64)(0x6dd1b48e353bce70LL)), ((u64)(0x6e0621b1c28ac20cLL)), ((u64)(0x6e3baa1e332d728fLL)), 
((u64)(0x6e714a52dffc6799LL)), ((u64)(0x6ea59ce797fb817fLL)), ((u64)(0x6edb04217dfa61dfLL)), ((u64)(0x6f10e294eebc7d2cLL)), ((u64)(0x6f451b3a2a6b9c76LL)), ((u64)(0x6f7a6208b5068394LL)), ((u64)(0x6fb07d457124123dLL)), ((u64)(0x6fe49c96cd6d16ccLL)), ((u64)(0x7019c3bc80c85c7fLL)), ((u64)(0x70501a55d07d39cfLL)), ((u64)(0x708420eb449c8843LL)), ((u64)(0x70b9292615c3aa54LL)), ((u64)(0x70ef736f9b3494e9LL)), ((u64)(0x7123a825c100dd11LL)), ((u64)(0x7158922f31411456LL)), ((u64)(0x718eb6bafd91596bLL)), 
((u64)(0x71c33234de7ad7e3LL)), ((u64)(0x71f7fec216198ddcLL)), ((u64)(0x722dfe729b9ff153LL)), ((u64)(0x7262bf07a143f6d4LL)), ((u64)(0x72976ec98994f489LL)), ((u64)(0x72cd4a7bebfa31abLL)), ((u64)(0x73024e8d737c5f0bLL)), ((u64)(0x7336e230d05b76cdLL)), ((u64)(0x736c9abd04725481LL)), ((u64)(0x73a1e0b622c774d0LL)), ((u64)(0x73d658e3ab795204LL)), ((u64)(0x740bef1c9657a686LL)), ((u64)(0x74417571ddf6c814LL)), ((u64)(0x7475d2ce55747a18LL)), ((u64)(0x74ab4781ead1989eLL)), ((u64)(0x74e10cb132c2ff63LL)), 
((u64)(0x75154fdd7f73bf3cLL)), ((u64)(0x754aa3d4df50af0bLL)), ((u64)(0x7580a6650b926d67LL)), ((u64)(0x75b4cffe4e7708c0LL)), ((u64)(0x75ea03fde214caf1LL)), ((u64)(0x7620427ead4cfed6LL)), ((u64)(0x7654531e58a03e8cLL)), ((u64)(0x768967e5eec84e2fLL)), ((u64)(0x76bfc1df6a7a61bbLL)), ((u64)(0x76f3d92ba28c7d15LL)), ((u64)(0x7728cf768b2f9c5aLL)), ((u64)(0x775f03542dfb8370LL)), ((u64)(0x779362149cbd3226LL)), ((u64)(0x77c83a99c3ec7eb0LL)), ((u64)(0x77fe494034e79e5cLL)), ((u64)(0x7832edc82110c2f9LL)), 
((u64)(0x7867a93a2954f3b8LL)), ((u64)(0x789d9388b3aa30a5LL)), ((u64)(0x78d27c35704a5e67LL)), ((u64)(0x79071b42cc5cf601LL)), ((u64)(0x793ce2137f743382LL)), ((u64)(0x79720d4c2fa8a031LL)), ((u64)(0x79a6909f3b92c83dLL)), ((u64)(0x79dc34c70a777a4dLL)), ((u64)(0x7a11a0fc668aac70LL)), ((u64)(0x7a46093b802d578cLL)), ((u64)(0x7a7b8b8a6038ad6fLL)), ((u64)(0x7ab137367c236c65LL)), ((u64)(0x7ae585041b2c477fLL)), ((u64)(0x7b1ae64521f7595eLL)), ((u64)(0x7b50cfeb353a97dbLL)), ((u64)(0x7b8503e602893dd2LL)), 
((u64)(0x7bba44df832b8d46LL)), ((u64)(0x7bf06b0bb1fb384cLL)), ((u64)(0x7c2485ce9e7a065fLL)), ((u64)(0x7c59a742461887f6LL)), ((u64)(0x7c9008896bcf54faLL)), ((u64)(0x7cc40aabc6c32a38LL)), ((u64)(0x7cf90d56b873f4c7LL)), ((u64)(0x7d2f50ac6690f1f8LL)), ((u64)(0x7d63926bc01a973bLL)), ((u64)(0x7d987706b0213d0aLL)), ((u64)(0x7dce94c85c298c4cLL)), ((u64)(0x7e031cfd3999f7b0LL)), ((u64)(0x7e37e43c8800759cLL)), ((u64)(0x7e6ddd4baa009303LL)), ((u64)(0x7ea2aa4f4a405be2LL)), ((u64)(0x7ed754e31cd072daLL)), ((u64)(0x7f0d2a1be4048f90LL)), ((u64)(0x7f423a516e82d9baLL)), ((u64)(0x7f76c8e5ca239029LL)), ((u64)(0x7fac7b1f3cac7433LL)), ((u64)(0x7fe1ccf385ebc8a0LL))}; // fixed array const
Array_fixed_u64_324 _const_strconv__neg_exp = {((u64)(0x3ff0000000000000LL)), ((u64)(0x3fb999999999999aLL)), ((u64)(0x3f847ae147ae147bLL)), ((u64)(0x3f50624dd2f1a9fcLL)), ((u64)(0x3f1a36e2eb1c432dLL)), ((u64)(0x3ee4f8b588e368f1LL)), ((u64)(0x3eb0c6f7a0b5ed8dLL)), ((u64)(0x3e7ad7f29abcaf48LL)), ((u64)(0x3e45798ee2308c3aLL)), ((u64)(0x3e112e0be826d695LL)), ((u64)(0x3ddb7cdfd9d7bdbbLL)), ((u64)(0x3da5fd7fe1796495LL)), ((u64)(0x3d719799812dea11LL)), ((u64)(0x3d3c25c268497682LL)), ((u64)(0x3d06849b86a12b9bLL)), ((u64)(0x3cd203af9ee75616LL)), 
((u64)(0x3c9cd2b297d889bcLL)), ((u64)(0x3c670ef54646d497LL)), ((u64)(0x3c32725dd1d243acLL)), ((u64)(0x3bfd83c94fb6d2acLL)), ((u64)(0x3bc79ca10c924223LL)), ((u64)(0x3b92e3b40a0e9b4fLL)), ((u64)(0x3b5e392010175ee6LL)), ((u64)(0x3b282db34012b251LL)), ((u64)(0x3af357c299a88ea7LL)), ((u64)(0x3abef2d0f5da7dd9LL)), ((u64)(0x3a88c240c4aecb14LL)), ((u64)(0x3a53ce9a36f23c10LL)), ((u64)(0x3a1fb0f6be506019LL)), ((u64)(0x39e95a5efea6b347LL)), ((u64)(0x39b4484bfeebc2a0LL)), ((u64)(0x398039d665896880LL)), 
((u64)(0x3949f623d5a8a733LL)), ((u64)(0x3914c4e977ba1f5cLL)), ((u64)(0x38e09d8792fb4c49LL)), ((u64)(0x38aa95a5b7f87a0fLL)), ((u64)(0x38754484932d2e72LL)), ((u64)(0x3841039d428a8b8fLL)), ((u64)(0x380b38fb9daa78e4LL)), ((u64)(0x37d5c72fb1552d83LL)), ((u64)(0x37a16c262777579cLL)), ((u64)(0x376be03d0bf225c7LL)), ((u64)(0x37364cfda3281e39LL)), ((u64)(0x3701d7314f534b61LL)), ((u64)(0x36cc8b8218854567LL)), ((u64)(0x3696d601ad376ab9LL)), ((u64)(0x366244ce242c5561LL)), ((u64)(0x362d3ae36d13bbceLL)), 
((u64)(0x35f7624f8a762fd8LL)), ((u64)(0x35c2b50c6ec4f313LL)), ((u64)(0x358dee7a4ad4b81fLL)), ((u64)(0x3557f1fb6f10934cLL)), ((u64)(0x352327fc58da0f70LL)), ((u64)(0x34eea6608e29b24dLL)), ((u64)(0x34b8851a0b548ea4LL)), ((u64)(0x34839dae6f76d883LL)), ((u64)(0x344f62b0b257c0d2LL)), ((u64)(0x34191bc08eac9a41LL)), ((u64)(0x33e41633a556e1ceLL)), ((u64)(0x33b011c2eaabe7d8LL)), ((u64)(0x3379b604aaaca626LL)), ((u64)(0x3344919d5556eb52LL)), ((u64)(0x3310747ddddf22a8LL)), ((u64)(0x32da53fc9631d10dLL)), 
((u64)(0x32a50ffd44f4a73dLL)), ((u64)(0x3270d9976a5d5297LL)), ((u64)(0x323af5bf109550f2LL)), ((u64)(0x32059165a6ddda5bLL)), ((u64)(0x31d1411e1f17e1e3LL)), ((u64)(0x319b9b6364f30304LL)), ((u64)(0x316615e91d8f359dLL)), ((u64)(0x3131ab20e472914aLL)), ((u64)(0x30fc45016d841baaLL)), ((u64)(0x30c69d9abe034955LL)), ((u64)(0x309217aefe690777LL)), ((u64)(0x305cf2b1970e7258LL)), ((u64)(0x3027288e1271f513LL)), ((u64)(0x2ff286d80ec190dcLL)), ((u64)(0x2fbda48ce468e7c7LL)), ((u64)(0x2f87b6d71d20b96cLL)), 
((u64)(0x2f52f8ac174d6123LL)), ((u64)(0x2f1e5aacf2156838LL)), ((u64)(0x2ee8488a5b445360LL)), ((u64)(0x2eb36d3b7c36a91aLL)), ((u64)(0x2e7f152bf9f10e90LL)), ((u64)(0x2e48ddbcc7f40ba6LL)), ((u64)(0x2e13e497065cd61fLL)), ((u64)(0x2ddfd424d6faf031LL)), ((u64)(0x2da97683df2f268dLL)), ((u64)(0x2d745ecfe5bf520bLL)), ((u64)(0x2d404bd984990e6fLL)), ((u64)(0x2d0a12f5a0f4e3e5LL)), ((u64)(0x2cd4dbf7b3f71cb7LL)), ((u64)(0x2ca0aff95cc5b092LL)), ((u64)(0x2c6ab328946f80eaLL)), ((u64)(0x2c355c2076bf9a55LL)), 
((u64)(0x2c0116805effaeaaLL)), ((u64)(0x2bcb5733cb32b111LL)), ((u64)(0x2b95df5ca28ef40dLL)), ((u64)(0x2b617f7d4ed8c33eLL)), ((u64)(0x2b2bff2ee48e0530LL)), ((u64)(0x2af665bf1d3e6a8dLL)), ((u64)(0x2ac1eaff4a98553dLL)), ((u64)(0x2a8cab3210f3bb95LL)), ((u64)(0x2a56ef5b40c2fc77LL)), ((u64)(0x2a225915cd68c9f9LL)), ((u64)(0x29ed5b561574765bLL)), ((u64)(0x29b77c44ddf6c516LL)), ((u64)(0x2982c9d0b1923745LL)), ((u64)(0x294e0fb44f50586eLL)), ((u64)(0x29180c903f7379f2LL)), ((u64)(0x28e33d4032c2c7f5LL)), 
((u64)(0x28aec866b79e0cbaLL)), ((u64)(0x2878a0522c7e7095LL)), ((u64)(0x2843b374f06526deLL)), ((u64)(0x280f8587e7083e30LL)), ((u64)(0x27d9379fec069826LL)), ((u64)(0x27a42c7ff0054685LL)), ((u64)(0x277023998cd10537LL)), ((u64)(0x2739d28f47b4d525LL)), ((u64)(0x2704a8729fc3ddb7LL)), ((u64)(0x26d086c219697e2cLL)), ((u64)(0x269a71368f0f3047LL)), ((u64)(0x2665275ed8d8f36cLL)), ((u64)(0x2630ec4be0ad8f89LL)), ((u64)(0x25fb13ac9aaf4c0fLL)), ((u64)(0x25c5a956e225d672LL)), ((u64)(0x2591544581b7dec2LL)), 
((u64)(0x255bba08cf8c979dLL)), ((u64)(0x25262e6d72d6dfb0LL)), ((u64)(0x24f1bebdf578b2f4LL)), ((u64)(0x24bc6463225ab7ecLL)), ((u64)(0x2486b6b5b5155ff0LL)), ((u64)(0x24522bc490dde65aLL)), ((u64)(0x241d12d41afca3c3LL)), ((u64)(0x23e7424348ca1c9cLL)), ((u64)(0x23b29b69070816e3LL)), ((u64)(0x237dc574d80cf16bLL)), ((u64)(0x2347d12a4670c123LL)), ((u64)(0x23130dbb6b8d674fLL)), ((u64)(0x22de7c5f127bd87eLL)), ((u64)(0x22a8637f41fcad32LL)), ((u64)(0x227382cc34ca2428LL)), ((u64)(0x223f37ad21436d0cLL)), 
((u64)(0x2208f9574dcf8a70LL)), ((u64)(0x21d3faac3e3fa1f3LL)), ((u64)(0x219ff779fd329cb9LL)), ((u64)(0x216992c7fdc216faLL)), ((u64)(0x2134756ccb01abfbLL)), ((u64)(0x21005df0a267bcc9LL)), ((u64)(0x20ca2fe76a3f9475LL)), ((u64)(0x2094f31f8832dd2aLL)), ((u64)(0x2060c27fa028b0efLL)), ((u64)(0x202ad0cc33744e4bLL)), ((u64)(0x1ff573d68f903ea2LL)), ((u64)(0x1fc1297872d9cbb5LL)), ((u64)(0x1f8b758d848fac55LL)), ((u64)(0x1f55f7a46a0c89ddLL)), ((u64)(0x1f2192e9ee706e4bLL)), ((u64)(0x1eec1e43171a4a11LL)), 
((u64)(0x1eb67e9c127b6e74LL)), ((u64)(0x1e81fee341fc585dLL)), ((u64)(0x1e4ccb0536608d61LL)), ((u64)(0x1e1708d0f84d3de7LL)), ((u64)(0x1de26d73f9d764b9LL)), ((u64)(0x1dad7becc2f23ac2LL)), ((u64)(0x1d779657025b6235LL)), ((u64)(0x1d42deac01e2b4f7LL)), ((u64)(0x1d0e3113363787f2LL)), ((u64)(0x1cd8274291c6065bLL)), ((u64)(0x1ca3529ba7d19eafLL)), ((u64)(0x1c6eea92a61c3118LL)), ((u64)(0x1c38bba884e35a7aLL)), ((u64)(0x1c03c9539d82aec8LL)), ((u64)(0x1bcfa885c8d117a6LL)), ((u64)(0x1b99539e3a40dfb8LL)), 
((u64)(0x1b6442e4fb671960LL)), ((u64)(0x1b303583fc527ab3LL)), ((u64)(0x1af9ef3993b72ab8LL)), ((u64)(0x1ac4bf6142f8eefaLL)), ((u64)(0x1a90991a9bfa58c8LL)), ((u64)(0x1a5a8e90f9908e0dLL)), ((u64)(0x1a253eda614071a4LL)), ((u64)(0x19f0ff151a99f483LL)), ((u64)(0x19bb31bb5dc320d2LL)), ((u64)(0x1985c162b168e70eLL)), ((u64)(0x1951678227871f3eLL)), ((u64)(0x191bd8d03f3e9864LL)), ((u64)(0x18e6470cff6546b6LL)), ((u64)(0x18b1d270cc51055fLL)), ((u64)(0x187c83e7ad4e6efeLL)), ((u64)(0x1846cfec8aa52598LL)), 
((u64)(0x18123ff06eea847aLL)), ((u64)(0x17dd331a4b10d3f6LL)), ((u64)(0x17a75c1508da432bLL)), ((u64)(0x1772b010d3e1cf56LL)), ((u64)(0x173de6815302e556LL)), ((u64)(0x1707eb9aa8cf1ddeLL)), ((u64)(0x16d322e220a5b17eLL)), ((u64)(0x169e9e369aa2b597LL)), ((u64)(0x16687e92154ef7acLL)), ((u64)(0x16339874ddd8c623LL)), ((u64)(0x15ff5a549627a36cLL)), ((u64)(0x15c91510781fb5f0LL)), ((u64)(0x159410d9f9b2f7f3LL)), ((u64)(0x15600d7b2e28c65cLL)), ((u64)(0x1529af2b7d0e0a2dLL)), ((u64)(0x14f48c22ca71a1bdLL)), 
((u64)(0x14c0701bd527b498LL)), ((u64)(0x148a4cf9550c5426LL)), ((u64)(0x14550a6110d6a9b8LL)), ((u64)(0x1420d51a73deee2dLL)), ((u64)(0x13eaee90b964b047LL)), ((u64)(0x13b58ba6fab6f36cLL)), ((u64)(0x13813c85955f2923LL)), ((u64)(0x134b9408eefea839LL)), ((u64)(0x1316100725988694LL)), ((u64)(0x12e1a66c1e139eddLL)), ((u64)(0x12ac3d79c9b8fe2eLL)), ((u64)(0x12769794a160cb58LL)), ((u64)(0x124212dd4de70913LL)), ((u64)(0x120ceafbafd80e85LL)), ((u64)(0x11d72262f3133ed1LL)), ((u64)(0x11a281e8c275cbdaLL)), 
((u64)(0x116d9ca79d89462aLL)), ((u64)(0x1137b08617a104eeLL)), ((u64)(0x1102f39e794d9d8bLL)), ((u64)(0x10ce5297287c2f45LL)), ((u64)(0x1098421286c9bf6bLL)), ((u64)(0x1063680ed23aff89LL)), ((u64)(0x102f0ce4839198dbLL)), ((u64)(0x0ff8d71d360e13e2LL)), ((u64)(0x0fc3df4a91a4dcb5LL)), ((u64)(0x0f8fcbaa82a16121LL)), ((u64)(0x0f596fbb9bb44db4LL)), ((u64)(0x0f245962e2f6a490LL)), ((u64)(0x0ef047824f2bb6daLL)), ((u64)(0x0eba0c03b1df8af6LL)), ((u64)(0x0e84d6695b193bf8LL)), ((u64)(0x0e50ab877c142ffaLL)), 
((u64)(0x0e1aac0bf9b9e65cLL)), ((u64)(0x0de5566ffafb1eb0LL)), ((u64)(0x0db111f32f2f4bc0LL)), ((u64)(0x0d7b4feb7eb212cdLL)), ((u64)(0x0d45d98932280f0aLL)), ((u64)(0x0d117ad428200c08LL)), ((u64)(0x0cdbf7b9d9cce00dLL)), ((u64)(0x0ca65fc7e170b33eLL)), ((u64)(0x0c71e6398126f5cbLL)), ((u64)(0x0c3ca38f350b22dfLL)), ((u64)(0x0c06e93f5da2824cLL)), ((u64)(0x0bd25432b14ecea3LL)), ((u64)(0x0b9d53844ee47dd1LL)), ((u64)(0x0b677603725064a8LL)), ((u64)(0x0b32c4cf8ea6b6ecLL)), ((u64)(0x0afe07b27dd78b14LL)), 
((u64)(0x0ac8062864ac6f43LL)), ((u64)(0x0a9338205089f29cLL)), ((u64)(0x0a5ec033b40fea93LL)), ((u64)(0x0a2899c2f6732210LL)), ((u64)(0x09f3ae3591f5b4d9LL)), ((u64)(0x09bf7d228322baf5LL)), ((u64)(0x098930e868e89591LL)), ((u64)(0x0954272053ed4474LL)), ((u64)(0x09201f4d0ff10390LL)), ((u64)(0x08e9cbae7fe805b3LL)), ((u64)(0x08b4a2f1ffecd15cLL)), ((u64)(0x0880825b3323dab0LL)), ((u64)(0x084a6a2b85062ab3LL)), ((u64)(0x081521bc6a6b555cLL)), ((u64)(0x07e0e7c9eebc444aLL)), ((u64)(0x07ab0c764ac6d3a9LL)), 
((u64)(0x0775a391d56bdc87LL)), ((u64)(0x07414fa7ddefe3a0LL)), ((u64)(0x070bb2a62fe638ffLL)), ((u64)(0x06d62884f31e93ffLL)), ((u64)(0x06a1ba03f5b21000LL)), ((u64)(0x066c5cd322b67fffLL)), ((u64)(0x0636b0a8e891ffffLL)), ((u64)(0x060226ed86db3333LL)), ((u64)(0x05cd0b15a491eb84LL)), ((u64)(0x05973c115074bc6aLL)), ((u64)(0x05629674405d6388LL)), ((u64)(0x052dbd86cd6238d9LL)), ((u64)(0x04f7cad23de82d7bLL)), ((u64)(0x04c308a831868ac9LL)), ((u64)(0x048e74404f3daadbLL)), ((u64)(0x04585d003f6488afLL)), 
((u64)(0x04237d99cc506d59LL)), ((u64)(0x03ef2f5c7a1a488eLL)), ((u64)(0x03b8f2b061aea072LL)), ((u64)(0x0383f559e7bee6c1LL)), ((u64)(0x034feef63f97d79cLL)), ((u64)(0x03198bf832dfdfb0LL)), ((u64)(0x02e46ff9c24cb2f3LL)), ((u64)(0x02b059949b708f29LL)), ((u64)(0x027a28edc580e50eLL)), ((u64)(0x0244ed8b04671da5LL)), ((u64)(0x0210be08d0527e1dLL)), ((u64)(0x01dac9a7b3b7302fLL)), ((u64)(0x01a56e1fc2f8f359LL)), ((u64)(0x017124e63593f5e1LL)), ((u64)(0x013b6e3d22865634LL)), ((u64)(0x0105f1ca820511c3LL)), 
((u64)(0x00d18e3b9b374169LL)), ((u64)(0x009c16c5c5253575LL)), ((u64)(0x0066789e3750f791LL)), ((u64)(0x0031fa182c40c60dLL)), ((u64)(0x000730d67819e8d2LL)), ((u64)(0x0000b8157268fdafLL)), ((u64)(0x000012688b70e62bLL)), ((u64)(0x000001d74124e3d1LL)), ((u64)(0x0000002f201d49fbLL)), ((u64)(0x00000004b6695433LL)), ((u64)(0x0000000078a42205)), ((u64)(0x000000000c1069cd)), ((u64)(0x000000000134d761)), ((u64)(0x00000000001ee257)), ((u64)(0x00000000000316a2)), ((u64)(0x0000000000004f10)), ((u64)(0x00000000000007e8)), ((u64)(0x00000000000000ca)), ((u64)(0x0000000000000014)), ((u64)(0x0000000000000002))}; // fixed array const
i64 _const_strconv__i64_min_int32; // inited later
i64 _const_strconv__i64_max_int32; // inited later
Array_fixed_u32_10 _const_strconv__ten_pow_table_32 = {((u32)(1)), ((u32)(10)), ((u32)(100)), ((u32)(1000)), ((u32)(10000)), ((u32)(100000)), ((u32)(1000000)), ((u32)(10000000)), ((u32)(100000000)), ((u32)(1000000000))}; // fixed array const
const u32 _const_strconv__mantbits32 = 23; // precomputed2
const u32 _const_strconv__expbits32 = 8; // precomputed2
Array_fixed_u64_20 _const_strconv__ten_pow_table_64 = {((u64)(1)), ((u64)(10)), ((u64)(100)), ((u64)(1000)), ((u64)(10000)), ((u64)(100000)), ((u64)(1000000)), ((u64)(10000000)), ((u64)(100000000)), ((u64)(1000000000)), ((u64)(10000000000LL)), ((u64)(100000000000LL)), ((u64)(1000000000000LL)), ((u64)(10000000000000LL)), ((u64)(100000000000000LL)), ((u64)(1000000000000000LL)), ((u64)(10000000000000000LL)), ((u64)(100000000000000000LL)), ((u64)(1000000000000000000LL)), ((u64)(10000000000000000000ULL))}; // fixed array const
const u32 _const_strconv__mantbits64 = 52; // precomputed2
const u32 _const_strconv__expbits64 = 11; // precomputed2
Array_fixed_f64_36 _const_strconv__dec_round = {((f64)(0.5)), 0.05, 0.005, 0.0005, 0.00005, 0.000005, 0.0000005, 0.00000005, 0.000000005, 0.0000000005, 0.00000000005, 0.000000000005, 0.0000000000005, 0.00000000000005, 0.000000000000005, 0.0000000000000005, 
0.00000000000000005, 0.000000000000000005, 0.0000000000000000005, 0.00000000000000000005, 0.000000000000000000005, 0.0000000000000000000005, 0.00000000000000000000005, 0.000000000000000000000005, 0.0000000000000000000000005, 0.00000000000000000000000005, 0.000000000000000000000000005, 0.0000000000000000000000000005, 0.00000000000000000000000000005, 0.000000000000000000000000000005, 0.0000000000000000000000000000005, 0.00000000000000000000000000000005, 0.000000000000000000000000000000005, 0.0000000000000000000000000000000005, 0.00000000000000000000000000000000005, 0.000000000000000000000000000000000005}; // fixed array const
Array_fixed_u64_47 _const_strconv__pow5_split_32 = {((u64)(1152921504606846976LL)), ((u64)(1441151880758558720LL)), ((u64)(1801439850948198400LL)), ((u64)(2251799813685248000LL)), ((u64)(1407374883553280000LL)), ((u64)(1759218604441600000LL)), ((u64)(2199023255552000000LL)), ((u64)(1374389534720000000LL)), ((u64)(1717986918400000000LL)), ((u64)(2147483648000000000LL)), ((u64)(1342177280000000000LL)), ((u64)(1677721600000000000LL)), ((u64)(2097152000000000000LL)), ((u64)(1310720000000000000LL)), ((u64)(1638400000000000000LL)), ((u64)(2048000000000000000LL)), 
((u64)(1280000000000000000LL)), ((u64)(1600000000000000000LL)), ((u64)(2000000000000000000LL)), ((u64)(1250000000000000000LL)), ((u64)(1562500000000000000LL)), ((u64)(1953125000000000000LL)), ((u64)(1220703125000000000LL)), ((u64)(1525878906250000000LL)), ((u64)(1907348632812500000LL)), ((u64)(1192092895507812500LL)), ((u64)(1490116119384765625LL)), ((u64)(1862645149230957031LL)), ((u64)(1164153218269348144LL)), ((u64)(1455191522836685180LL)), ((u64)(1818989403545856475LL)), ((u64)(2273736754432320594LL)), 
((u64)(1421085471520200371LL)), ((u64)(1776356839400250464LL)), ((u64)(2220446049250313080LL)), ((u64)(1387778780781445675LL)), ((u64)(1734723475976807094LL)), ((u64)(2168404344971008868LL)), ((u64)(1355252715606880542LL)), ((u64)(1694065894508600678LL)), ((u64)(2117582368135750847LL)), ((u64)(1323488980084844279LL)), ((u64)(1654361225106055349LL)), ((u64)(2067951531382569187LL)), ((u64)(1292469707114105741LL)), ((u64)(1615587133892632177LL)), ((u64)(2019483917365790221LL))}; // fixed array const
Array_fixed_u64_31 _const_strconv__pow5_inv_split_32 = {((u64)(576460752303423489LL)), ((u64)(461168601842738791LL)), ((u64)(368934881474191033LL)), ((u64)(295147905179352826LL)), ((u64)(472236648286964522LL)), ((u64)(377789318629571618LL)), ((u64)(302231454903657294LL)), ((u64)(483570327845851670LL)), ((u64)(386856262276681336LL)), ((u64)(309485009821345069LL)), ((u64)(495176015714152110LL)), ((u64)(396140812571321688LL)), ((u64)(316912650057057351LL)), ((u64)(507060240091291761LL)), ((u64)(405648192073033409LL)), ((u64)(324518553658426727LL)), 
((u64)(519229685853482763LL)), ((u64)(415383748682786211LL)), ((u64)(332306998946228969LL)), ((u64)(531691198313966350LL)), ((u64)(425352958651173080LL)), ((u64)(340282366920938464LL)), ((u64)(544451787073501542LL)), ((u64)(435561429658801234LL)), ((u64)(348449143727040987LL)), ((u64)(557518629963265579LL)), ((u64)(446014903970612463LL)), ((u64)(356811923176489971LL)), ((u64)(570899077082383953LL)), ((u64)(456719261665907162LL)), ((u64)(365375409332725730LL))}; // fixed array const
Array_fixed_u64_652 _const_strconv__pow5_split_64_x = {((u64)(0x0000000000000000)), ((u64)(0x0100000000000000LL)), ((u64)(0x0000000000000000)), ((u64)(0x0140000000000000LL)), ((u64)(0x0000000000000000)), ((u64)(0x0190000000000000LL)), ((u64)(0x0000000000000000)), ((u64)(0x01f4000000000000LL)), ((u64)(0x0000000000000000)), ((u64)(0x0138800000000000LL)), ((u64)(0x0000000000000000)), ((u64)(0x0186a00000000000LL)), ((u64)(0x0000000000000000)), ((u64)(0x01e8480000000000LL)), ((u64)(0x0000000000000000)), ((u64)(0x01312d0000000000LL)), 
((u64)(0x0000000000000000)), ((u64)(0x017d784000000000LL)), ((u64)(0x0000000000000000)), ((u64)(0x01dcd65000000000LL)), ((u64)(0x0000000000000000)), ((u64)(0x012a05f200000000LL)), ((u64)(0x0000000000000000)), ((u64)(0x0174876e80000000LL)), ((u64)(0x0000000000000000)), ((u64)(0x01d1a94a20000000LL)), ((u64)(0x0000000000000000)), ((u64)(0x012309ce54000000LL)), ((u64)(0x0000000000000000)), ((u64)(0x016bcc41e9000000LL)), ((u64)(0x0000000000000000)), ((u64)(0x01c6bf5263400000LL)), 
((u64)(0x0000000000000000)), ((u64)(0x011c37937e080000LL)), ((u64)(0x0000000000000000)), ((u64)(0x016345785d8a0000LL)), ((u64)(0x0000000000000000)), ((u64)(0x01bc16d674ec8000LL)), ((u64)(0x0000000000000000)), ((u64)(0x01158e460913d000LL)), ((u64)(0x0000000000000000)), ((u64)(0x015af1d78b58c400LL)), ((u64)(0x0000000000000000)), ((u64)(0x01b1ae4d6e2ef500LL)), ((u64)(0x0000000000000000)), ((u64)(0x010f0cf064dd5920LL)), ((u64)(0x0000000000000000)), ((u64)(0x0152d02c7e14af68LL)), 
((u64)(0x0000000000000000)), ((u64)(0x01a784379d99db42LL)), ((u64)(0x4000000000000000LL)), ((u64)(0x0108b2a2c2802909LL)), ((u64)(0x9000000000000000ULL)), ((u64)(0x014adf4b7320334bLL)), ((u64)(0x7400000000000000LL)), ((u64)(0x019d971e4fe8401eLL)), ((u64)(0x0880000000000000LL)), ((u64)(0x01027e72f1f12813LL)), ((u64)(0xcaa0000000000000ULL)), ((u64)(0x01431e0fae6d7217LL)), ((u64)(0xbd48000000000000ULL)), ((u64)(0x0193e5939a08ce9dLL)), ((u64)(0x2c9a000000000000LL)), ((u64)(0x01f8def8808b0245LL)), 
((u64)(0x3be0400000000000LL)), ((u64)(0x013b8b5b5056e16bLL)), ((u64)(0x0ad8500000000000LL)), ((u64)(0x018a6e32246c99c6LL)), ((u64)(0x8d8e640000000000ULL)), ((u64)(0x01ed09bead87c037LL)), ((u64)(0xb878fe8000000000ULL)), ((u64)(0x013426172c74d822LL)), ((u64)(0x66973e2000000000LL)), ((u64)(0x01812f9cf7920e2bLL)), ((u64)(0x403d0da800000000LL)), ((u64)(0x01e17b84357691b6LL)), ((u64)(0xe826288900000000ULL)), ((u64)(0x012ced32a16a1b11LL)), ((u64)(0x622fb2ab40000000LL)), ((u64)(0x0178287f49c4a1d6LL)), 
((u64)(0xfabb9f5610000000ULL)), ((u64)(0x01d6329f1c35ca4bLL)), ((u64)(0x7cb54395ca000000LL)), ((u64)(0x0125dfa371a19e6fLL)), ((u64)(0x5be2947b3c800000LL)), ((u64)(0x016f578c4e0a060bLL)), ((u64)(0x32db399a0ba00000LL)), ((u64)(0x01cb2d6f618c878eLL)), ((u64)(0xdfc9040047440000ULL)), ((u64)(0x011efc659cf7d4b8LL)), ((u64)(0x17bb450059150000LL)), ((u64)(0x0166bb7f0435c9e7LL)), ((u64)(0xddaa16406f5a4000ULL)), ((u64)(0x01c06a5ec5433c60LL)), ((u64)(0x8a8a4de845986800ULL)), ((u64)(0x0118427b3b4a05bcLL)), 
((u64)(0xad2ce16256fe8200ULL)), ((u64)(0x015e531a0a1c872bLL)), ((u64)(0x987819baecbe2280ULL)), ((u64)(0x01b5e7e08ca3a8f6LL)), ((u64)(0x1f4b1014d3f6d590LL)), ((u64)(0x0111b0ec57e6499aLL)), ((u64)(0xa71dd41a08f48af4ULL)), ((u64)(0x01561d276ddfdc00LL)), ((u64)(0xd0e549208b31adb1ULL)), ((u64)(0x01aba4714957d300LL)), ((u64)(0x828f4db456ff0c8eULL)), ((u64)(0x010b46c6cdd6e3e0LL)), ((u64)(0xa33321216cbecfb2ULL)), ((u64)(0x014e1878814c9cd8LL)), ((u64)(0xcbffe969c7ee839eULL)), ((u64)(0x01a19e96a19fc40eLL)), 
((u64)(0x3f7ff1e21cf51243LL)), ((u64)(0x0105031e2503da89LL)), ((u64)(0x8f5fee5aa43256d4ULL)), ((u64)(0x014643e5ae44d12bLL)), ((u64)(0x7337e9f14d3eec89LL)), ((u64)(0x0197d4df19d60576LL)), ((u64)(0x1005e46da08ea7abLL)), ((u64)(0x01fdca16e04b86d4LL)), ((u64)(0x8a03aec4845928cbULL)), ((u64)(0x013e9e4e4c2f3444LL)), ((u64)(0xac849a75a56f72fdULL)), ((u64)(0x018e45e1df3b0155LL)), ((u64)(0x17a5c1130ecb4fbdLL)), ((u64)(0x01f1d75a5709c1abLL)), ((u64)(0xeec798abe93f11d6ULL)), ((u64)(0x013726987666190aLL)), 
((u64)(0xaa797ed6e38ed64bULL)), ((u64)(0x0184f03e93ff9f4dLL)), ((u64)(0x1517de8c9c728bdeLL)), ((u64)(0x01e62c4e38ff8721LL)), ((u64)(0xad2eeb17e1c7976bULL)), ((u64)(0x012fdbb0e39fb474LL)), ((u64)(0xd87aa5ddda397d46ULL)), ((u64)(0x017bd29d1c87a191LL)), ((u64)(0x4e994f5550c7dc97LL)), ((u64)(0x01dac74463a989f6LL)), ((u64)(0xf11fd195527ce9deULL)), ((u64)(0x0128bc8abe49f639LL)), ((u64)(0x6d67c5faa71c2456LL)), ((u64)(0x0172ebad6ddc73c8LL)), ((u64)(0x88c1b77950e32d6cULL)), ((u64)(0x01cfa698c95390baLL)), 
((u64)(0x957912abd28dfc63ULL)), ((u64)(0x0121c81f7dd43a74LL)), ((u64)(0xbad75756c7317b7cULL)), ((u64)(0x016a3a275d494911LL)), ((u64)(0x298d2d2c78fdda5bLL)), ((u64)(0x01c4c8b1349b9b56LL)), ((u64)(0xd9f83c3bcb9ea879ULL)), ((u64)(0x011afd6ec0e14115LL)), ((u64)(0x50764b4abe865297LL)), ((u64)(0x0161bcca7119915bLL)), ((u64)(0x2493de1d6e27e73dLL)), ((u64)(0x01ba2bfd0d5ff5b2LL)), ((u64)(0x56dc6ad264d8f086LL)), ((u64)(0x01145b7e285bf98fLL)), ((u64)(0x2c938586fe0f2ca8LL)), ((u64)(0x0159725db272f7f3LL)), 
((u64)(0xf7b866e8bd92f7d2ULL)), ((u64)(0x01afcef51f0fb5efLL)), ((u64)(0xfad34051767bdae3ULL)), ((u64)(0x010de1593369d1b5LL)), ((u64)(0x79881065d41ad19cLL)), ((u64)(0x015159af80444623LL)), ((u64)(0x57ea147f49218603LL)), ((u64)(0x01a5b01b605557acLL)), ((u64)(0xb6f24ccf8db4f3c1ULL)), ((u64)(0x01078e111c3556cbLL)), ((u64)(0xa4aee003712230b2ULL)), ((u64)(0x014971956342ac7eLL)), ((u64)(0x4dda98044d6abcdfLL)), ((u64)(0x019bcdfabc13579eLL)), ((u64)(0xf0a89f02b062b60bULL)), ((u64)(0x010160bcb58c16c2LL)), 
((u64)(0xacd2c6c35c7b638eULL)), ((u64)(0x0141b8ebe2ef1c73LL)), ((u64)(0x98077874339a3c71ULL)), ((u64)(0x01922726dbaae390LL)), ((u64)(0xbe0956914080cb8eULL)), ((u64)(0x01f6b0f092959c74LL)), ((u64)(0xf6c5d61ac8507f38ULL)), ((u64)(0x013a2e965b9d81c8LL)), ((u64)(0x34774ba17a649f07LL)), ((u64)(0x0188ba3bf284e23bLL)), ((u64)(0x01951e89d8fdc6c8LL)), ((u64)(0x01eae8caef261acaLL)), ((u64)(0x40fd3316279e9c3dLL)), ((u64)(0x0132d17ed577d0beLL)), ((u64)(0xd13c7fdbb186434cULL)), ((u64)(0x017f85de8ad5c4edLL)), 
((u64)(0x458b9fd29de7d420LL)), ((u64)(0x01df67562d8b3629LL)), ((u64)(0xcb7743e3a2b0e494ULL)), ((u64)(0x012ba095dc7701d9LL)), ((u64)(0x3e5514dc8b5d1db9LL)), ((u64)(0x017688bb5394c250LL)), ((u64)(0x4dea5a13ae346527LL)), ((u64)(0x01d42aea2879f2e4LL)), ((u64)(0xb0b2784c4ce0bf38ULL)), ((u64)(0x01249ad2594c37ceLL)), ((u64)(0x5cdf165f6018ef06LL)), ((u64)(0x016dc186ef9f45c2LL)), ((u64)(0xf416dbf7381f2ac8ULL)), ((u64)(0x01c931e8ab871732LL)), ((u64)(0xd88e497a83137abdULL)), ((u64)(0x011dbf316b346e7fLL)), 
((u64)(0xceb1dbd923d8596cULL)), ((u64)(0x01652efdc6018a1fLL)), ((u64)(0xc25e52cf6cce6fc7ULL)), ((u64)(0x01be7abd3781eca7LL)), ((u64)(0xd97af3c1a40105dcULL)), ((u64)(0x01170cb642b133e8LL)), ((u64)(0x0fd9b0b20d014754LL)), ((u64)(0x015ccfe3d35d80e3LL)), ((u64)(0xd3d01cde90419929ULL)), ((u64)(0x01b403dcc834e11bLL)), ((u64)(0x6462120b1a28ffb9LL)), ((u64)(0x01108269fd210cb1LL)), ((u64)(0xbd7a968de0b33fa8ULL)), ((u64)(0x0154a3047c694fddLL)), ((u64)(0x2cd93c3158e00f92LL)), ((u64)(0x01a9cbc59b83a3d5LL)), 
((u64)(0x3c07c59ed78c09bbLL)), ((u64)(0x010a1f5b81324665LL)), ((u64)(0x8b09b7068d6f0c2aULL)), ((u64)(0x014ca732617ed7feLL)), ((u64)(0x2dcc24c830cacf34LL)), ((u64)(0x019fd0fef9de8dfeLL)), ((u64)(0xdc9f96fd1e7ec180ULL)), ((u64)(0x0103e29f5c2b18beLL)), ((u64)(0x93c77cbc661e71e1ULL)), ((u64)(0x0144db473335deeeLL)), ((u64)(0x38b95beb7fa60e59LL)), ((u64)(0x01961219000356aaLL)), ((u64)(0xc6e7b2e65f8f91efULL)), ((u64)(0x01fb969f40042c54LL)), ((u64)(0xfc50cfcffbb9bb35ULL)), ((u64)(0x013d3e2388029bb4LL)), 
((u64)(0x3b6503c3faa82a03LL)), ((u64)(0x018c8dac6a0342a2LL)), ((u64)(0xca3e44b4f9523484ULL)), ((u64)(0x01efb1178484134aLL)), ((u64)(0xbe66eaf11bd360d2ULL)), ((u64)(0x0135ceaeb2d28c0eLL)), ((u64)(0x6e00a5ad62c83907LL)), ((u64)(0x0183425a5f872f12LL)), ((u64)(0x0980cf18bb7a4749LL)), ((u64)(0x01e412f0f768fad7LL)), ((u64)(0x65f0816f752c6c8dLL)), ((u64)(0x012e8bd69aa19cc6LL)), ((u64)(0xff6ca1cb527787b1ULL)), ((u64)(0x017a2ecc414a03f7LL)), ((u64)(0xff47ca3e2715699dULL)), ((u64)(0x01d8ba7f519c84f5LL)), 
((u64)(0xbf8cde66d86d6202ULL)), ((u64)(0x0127748f9301d319LL)), ((u64)(0x2f7016008e88ba83LL)), ((u64)(0x017151b377c247e0LL)), ((u64)(0x3b4c1b80b22ae923LL)), ((u64)(0x01cda62055b2d9d8LL)), ((u64)(0x250f91306f5ad1b6LL)), ((u64)(0x012087d4358fc827LL)), ((u64)(0xee53757c8b318623ULL)), ((u64)(0x0168a9c942f3ba30LL)), ((u64)(0x29e852dbadfde7acLL)), ((u64)(0x01c2d43b93b0a8bdLL)), ((u64)(0x3a3133c94cbeb0ccLL)), ((u64)(0x0119c4a53c4e6976LL)), ((u64)(0xc8bd80bb9fee5cffULL)), ((u64)(0x016035ce8b6203d3LL)), 
((u64)(0xbaece0ea87e9f43eULL)), ((u64)(0x01b843422e3a84c8LL)), ((u64)(0x74d40c9294f238a7LL)), ((u64)(0x01132a095ce492fdLL)), ((u64)(0xd2090fb73a2ec6d1ULL)), ((u64)(0x0157f48bb41db7bcLL)), ((u64)(0x068b53a508ba7885LL)), ((u64)(0x01adf1aea12525acLL)), ((u64)(0x8417144725748b53ULL)), ((u64)(0x010cb70d24b7378bLL)), ((u64)(0x651cd958eed1ae28LL)), ((u64)(0x014fe4d06de5056eLL)), ((u64)(0xfe640faf2a8619b2ULL)), ((u64)(0x01a3de04895e46c9LL)), ((u64)(0x3efe89cd7a93d00fLL)), ((u64)(0x01066ac2d5daec3eLL)), 
((u64)(0xcebe2c40d938c413ULL)), ((u64)(0x014805738b51a74dLL)), ((u64)(0x426db7510f86f518LL)), ((u64)(0x019a06d06e261121LL)), ((u64)(0xc9849292a9b4592fULL)), ((u64)(0x0100444244d7cab4LL)), ((u64)(0xfbe5b73754216f7aULL)), ((u64)(0x01405552d60dbd61LL)), ((u64)(0x7adf25052929cb59LL)), ((u64)(0x01906aa78b912cbaLL)), ((u64)(0x1996ee4673743e2fLL)), ((u64)(0x01f485516e7577e9LL)), ((u64)(0xaffe54ec0828a6ddULL)), ((u64)(0x0138d352e5096af1LL)), ((u64)(0x1bfdea270a32d095LL)), ((u64)(0x018708279e4bc5aeLL)), 
((u64)(0xa2fd64b0ccbf84baULL)), ((u64)(0x01e8ca3185deb719LL)), ((u64)(0x05de5eee7ff7b2f4LL)), ((u64)(0x01317e5ef3ab3270LL)), ((u64)(0x0755f6aa1ff59fb1LL)), ((u64)(0x017dddf6b095ff0cLL)), ((u64)(0x092b7454a7f3079eLL)), ((u64)(0x01dd55745cbb7ecfLL)), ((u64)(0x65bb28b4e8f7e4c3LL)), ((u64)(0x012a5568b9f52f41LL)), ((u64)(0xbf29f2e22335ddf3ULL)), ((u64)(0x0174eac2e8727b11LL)), ((u64)(0x2ef46f9aac035570LL)), ((u64)(0x01d22573a28f19d6LL)), ((u64)(0xdd58c5c0ab821566ULL)), ((u64)(0x0123576845997025LL)), 
((u64)(0x54aef730d6629ac0LL)), ((u64)(0x016c2d4256ffcc2fLL)), ((u64)(0x29dab4fd0bfb4170LL)), ((u64)(0x01c73892ecbfbf3bLL)), ((u64)(0xfa28b11e277d08e6ULL)), ((u64)(0x011c835bd3f7d784LL)), ((u64)(0x38b2dd65b15c4b1fLL)), ((u64)(0x0163a432c8f5cd66LL)), ((u64)(0xc6df94bf1db35de7ULL)), ((u64)(0x01bc8d3f7b3340bfLL)), ((u64)(0xdc4bbcf772901ab0ULL)), ((u64)(0x0115d847ad000877LL)), ((u64)(0xd35eac354f34215cULL)), ((u64)(0x015b4e5998400a95LL)), ((u64)(0x48365742a30129b4LL)), ((u64)(0x01b221effe500d3bLL)), 
((u64)(0x0d21f689a5e0ba10LL)), ((u64)(0x010f5535fef20845LL)), ((u64)(0x506a742c0f58e894LL)), ((u64)(0x01532a837eae8a56LL)), ((u64)(0xe4851137132f22b9ULL)), ((u64)(0x01a7f5245e5a2cebLL)), ((u64)(0x6ed32ac26bfd75b4LL)), ((u64)(0x0108f936baf85c13LL)), ((u64)(0x4a87f57306fcd321LL)), ((u64)(0x014b378469b67318LL)), ((u64)(0x5d29f2cfc8bc07e9LL)), ((u64)(0x019e056584240fdeLL)), ((u64)(0xfa3a37c1dd7584f1ULL)), ((u64)(0x0102c35f729689eaLL)), ((u64)(0xb8c8c5b254d2e62eULL)), ((u64)(0x014374374f3c2c65LL)), 
((u64)(0x26faf71eea079fb9LL)), ((u64)(0x01945145230b377fLL)), ((u64)(0xf0b9b4e6a48987a8ULL)), ((u64)(0x01f965966bce055eLL)), ((u64)(0x5674111026d5f4c9LL)), ((u64)(0x013bdf7e0360c35bLL)), ((u64)(0x2c111554308b71fbLL)), ((u64)(0x018ad75d8438f432LL)), ((u64)(0xb7155aa93cae4e7aULL)), ((u64)(0x01ed8d34e547313eLL)), ((u64)(0x326d58a9c5ecf10cLL)), ((u64)(0x013478410f4c7ec7LL)), ((u64)(0xff08aed437682d4fULL)), ((u64)(0x01819651531f9e78LL)), ((u64)(0x3ecada89454238a3LL)), ((u64)(0x01e1fbe5a7e78617LL)), 
((u64)(0x873ec895cb496366ULL)), ((u64)(0x012d3d6f88f0b3ceLL)), ((u64)(0x290e7abb3e1bbc3fLL)), ((u64)(0x01788ccb6b2ce0c2LL)), ((u64)(0xb352196a0da2ab4fULL)), ((u64)(0x01d6affe45f818f2LL)), ((u64)(0xb0134fe24885ab11ULL)), ((u64)(0x01262dfeebbb0f97LL)), ((u64)(0x9c1823dadaa715d6ULL)), ((u64)(0x016fb97ea6a9d37dLL)), ((u64)(0x031e2cd19150db4bLL)), ((u64)(0x01cba7de5054485dLL)), ((u64)(0x21f2dc02fad2890fLL)), ((u64)(0x011f48eaf234ad3aLL)), ((u64)(0xaa6f9303b9872b53ULL)), ((u64)(0x01671b25aec1d888LL)), 
((u64)(0xd50b77c4a7e8f628ULL)), ((u64)(0x01c0e1ef1a724eaaLL)), ((u64)(0xc5272adae8f199d9ULL)), ((u64)(0x01188d357087712aLL)), ((u64)(0x7670f591a32e004fLL)), ((u64)(0x015eb082cca94d75LL)), ((u64)(0xd40d32f60bf98063ULL)), ((u64)(0x01b65ca37fd3a0d2LL)), ((u64)(0xc4883fd9c77bf03eULL)), ((u64)(0x0111f9e62fe44483LL)), ((u64)(0xb5aa4fd0395aec4dULL)), ((u64)(0x0156785fbbdd55a4LL)), ((u64)(0xe314e3c447b1a760ULL)), ((u64)(0x01ac1677aad4ab0dLL)), ((u64)(0xaded0e5aaccf089cULL)), ((u64)(0x010b8e0acac4eae8LL)), 
((u64)(0xd96851f15802cac3ULL)), ((u64)(0x014e718d7d7625a2LL)), ((u64)(0x8fc2666dae037d74ULL)), ((u64)(0x01a20df0dcd3af0bLL)), ((u64)(0x39d980048cc22e68LL)), ((u64)(0x010548b68a044d67LL)), ((u64)(0x084fe005aff2ba03LL)), ((u64)(0x01469ae42c8560c1LL)), ((u64)(0x4a63d8071bef6883LL)), ((u64)(0x0198419d37a6b8f1LL)), ((u64)(0x9cfcce08e2eb42a4ULL)), ((u64)(0x01fe52048590672dLL)), ((u64)(0x821e00c58dd309a7ULL)), ((u64)(0x013ef342d37a407cLL)), ((u64)(0xa2a580f6f147cc10ULL)), ((u64)(0x018eb0138858d09bLL)), 
((u64)(0x8b4ee134ad99bf15ULL)), ((u64)(0x01f25c186a6f04c2LL)), ((u64)(0x97114cc0ec80176dULL)), ((u64)(0x0137798f428562f9LL)), ((u64)(0xfcd59ff127a01d48ULL)), ((u64)(0x018557f31326bbb7LL)), ((u64)(0xfc0b07ed7188249aULL)), ((u64)(0x01e6adefd7f06aa5LL)), ((u64)(0xbd86e4f466f516e0ULL)), ((u64)(0x01302cb5e6f642a7LL)), ((u64)(0xace89e3180b25c98ULL)), ((u64)(0x017c37e360b3d351LL)), ((u64)(0x1822c5bde0def3beLL)), ((u64)(0x01db45dc38e0c826LL)), ((u64)(0xcf15bb96ac8b5857ULL)), ((u64)(0x01290ba9a38c7d17LL)), 
((u64)(0xc2db2a7c57ae2e6dULL)), ((u64)(0x01734e940c6f9c5dLL)), ((u64)(0x3391f51b6d99ba08LL)), ((u64)(0x01d022390f8b8375LL)), ((u64)(0x403b393124801445LL)), ((u64)(0x01221563a9b73229LL)), ((u64)(0x904a077d6da01956ULL)), ((u64)(0x016a9abc9424feb3LL)), ((u64)(0x745c895cc9081facLL)), ((u64)(0x01c5416bb92e3e60LL)), ((u64)(0x48b9d5d9fda513cbLL)), ((u64)(0x011b48e353bce6fcLL)), ((u64)(0x5ae84b507d0e58beLL)), ((u64)(0x01621b1c28ac20bbLL)), ((u64)(0x31a25e249c51eeeeLL)), ((u64)(0x01baa1e332d728eaLL)), 
((u64)(0x5f057ad6e1b33554LL)), ((u64)(0x0114a52dffc67992LL)), ((u64)(0xf6c6d98c9a2002aaULL)), ((u64)(0x0159ce797fb817f6LL)), ((u64)(0xb4788fefc0a80354ULL)), ((u64)(0x01b04217dfa61df4LL)), ((u64)(0xf0cb59f5d8690214ULL)), ((u64)(0x010e294eebc7d2b8LL)), ((u64)(0x2cfe30734e83429aLL)), ((u64)(0x0151b3a2a6b9c767LL)), ((u64)(0xf83dbc9022241340ULL)), ((u64)(0x01a6208b50683940LL)), ((u64)(0x9b2695da15568c08ULL)), ((u64)(0x0107d457124123c8LL)), ((u64)(0xc1f03b509aac2f0aULL)), ((u64)(0x0149c96cd6d16cbaLL)), 
((u64)(0x726c4a24c1573acdLL)), ((u64)(0x019c3bc80c85c7e9LL)), ((u64)(0xe783ae56f8d684c0ULL)), ((u64)(0x0101a55d07d39cf1LL)), ((u64)(0x616499ecb70c25f0LL)), ((u64)(0x01420eb449c8842eLL)), ((u64)(0xf9bdc067e4cf2f6cULL)), ((u64)(0x019292615c3aa539LL)), ((u64)(0x782d3081de02fb47LL)), ((u64)(0x01f736f9b3494e88LL)), ((u64)(0x4b1c3e512ac1dd0cLL)), ((u64)(0x013a825c100dd115LL)), ((u64)(0x9de34de57572544fULL)), ((u64)(0x018922f31411455aLL)), ((u64)(0x455c215ed2cee963LL)), ((u64)(0x01eb6bafd91596b1LL)), 
((u64)(0xcb5994db43c151deULL)), ((u64)(0x0133234de7ad7e2eLL)), ((u64)(0x7e2ffa1214b1a655LL)), ((u64)(0x017fec216198ddbaLL)), ((u64)(0x1dbbf89699de0febLL)), ((u64)(0x01dfe729b9ff1529LL)), ((u64)(0xb2957b5e202ac9f3ULL)), ((u64)(0x012bf07a143f6d39LL)), ((u64)(0x1f3ada35a8357c6fLL)), ((u64)(0x0176ec98994f4888LL)), ((u64)(0x270990c31242db8bLL)), ((u64)(0x01d4a7bebfa31aaaLL)), ((u64)(0x5865fa79eb69c937LL)), ((u64)(0x0124e8d737c5f0aaLL)), ((u64)(0xee7f791866443b85ULL)), ((u64)(0x016e230d05b76cd4LL)), 
((u64)(0x2a1f575e7fd54a66LL)), ((u64)(0x01c9abd04725480aLL)), ((u64)(0x5a53969b0fe54e80LL)), ((u64)(0x011e0b622c774d06LL)), ((u64)(0xf0e87c41d3dea220ULL)), ((u64)(0x01658e3ab7952047LL)), ((u64)(0xed229b5248d64aa8ULL)), ((u64)(0x01bef1c9657a6859LL)), ((u64)(0x3435a1136d85eea9LL)), ((u64)(0x0117571ddf6c8138LL)), ((u64)(0x4143095848e76a53LL)), ((u64)(0x015d2ce55747a186LL)), ((u64)(0xd193cbae5b2144e8ULL)), ((u64)(0x01b4781ead1989e7LL)), ((u64)(0xe2fc5f4cf8f4cb11ULL)), ((u64)(0x0110cb132c2ff630LL)), 
((u64)(0x1bbb77203731fdd5LL)), ((u64)(0x0154fdd7f73bf3bdLL)), ((u64)(0x62aa54e844fe7d4aLL)), ((u64)(0x01aa3d4df50af0acLL)), ((u64)(0xbdaa75112b1f0e4eULL)), ((u64)(0x010a6650b926d66bLL)), ((u64)(0xad15125575e6d1e2ULL)), ((u64)(0x014cffe4e7708c06LL)), ((u64)(0x585a56ead360865bLL)), ((u64)(0x01a03fde214caf08LL)), ((u64)(0x37387652c41c53f8LL)), ((u64)(0x010427ead4cfed65LL)), ((u64)(0x850693e7752368f7ULL)), ((u64)(0x014531e58a03e8beLL)), ((u64)(0x264838e1526c4334LL)), ((u64)(0x01967e5eec84e2eeLL)), 
((u64)(0xafda4719a7075402ULL)), ((u64)(0x01fc1df6a7a61ba9LL)), ((u64)(0x0de86c7008649481LL)), ((u64)(0x013d92ba28c7d14aLL)), ((u64)(0x9162878c0a7db9a1ULL)), ((u64)(0x018cf768b2f9c59cLL)), ((u64)(0xb5bb296f0d1d280aULL)), ((u64)(0x01f03542dfb83703LL)), ((u64)(0x5194f9e568323906LL)), ((u64)(0x01362149cbd32262LL)), ((u64)(0xe5fa385ec23ec747ULL)), ((u64)(0x0183a99c3ec7eafaLL)), ((u64)(0x9f78c67672ce7919ULL)), ((u64)(0x01e494034e79e5b9LL)), ((u64)(0x03ab7c0a07c10bb0LL)), ((u64)(0x012edc82110c2f94LL)), 
((u64)(0x04965b0c89b14e9cLL)), ((u64)(0x017a93a2954f3b79LL)), ((u64)(0x45bbf1cfac1da243LL)), ((u64)(0x01d9388b3aa30a57LL)), ((u64)(0x8b957721cb92856aULL)), ((u64)(0x0127c35704a5e676LL)), ((u64)(0x2e7ad4ea3e7726c4LL)), ((u64)(0x0171b42cc5cf6014LL)), ((u64)(0x3a198a24ce14f075LL)), ((u64)(0x01ce2137f7433819LL)), ((u64)(0xc44ff65700cd1649ULL)), ((u64)(0x0120d4c2fa8a030fLL)), ((u64)(0xb563f3ecc1005bdbULL)), ((u64)(0x016909f3b92c83d3LL)), ((u64)(0xa2bcf0e7f14072d2ULL)), ((u64)(0x01c34c70a777a4c8LL)), 
((u64)(0x65b61690f6c847c3LL)), ((u64)(0x011a0fc668aac6fdLL)), ((u64)(0xbf239c35347a59b4ULL)), ((u64)(0x016093b802d578bcLL)), ((u64)(0xeeec83428198f021ULL)), ((u64)(0x01b8b8a6038ad6ebLL)), ((u64)(0x7553d20990ff9615LL)), ((u64)(0x01137367c236c653LL)), ((u64)(0x52a8c68bf53f7b9aLL)), ((u64)(0x01585041b2c477e8LL)), ((u64)(0x6752f82ef28f5a81LL)), ((u64)(0x01ae64521f7595e2LL)), ((u64)(0x8093db1d57999890ULL)), ((u64)(0x010cfeb353a97dadLL)), ((u64)(0xe0b8d1e4ad7ffeb4ULL)), ((u64)(0x01503e602893dd18LL)), 
((u64)(0x18e7065dd8dffe62LL)), ((u64)(0x01a44df832b8d45fLL)), ((u64)(0x6f9063faa78bfefdLL)), ((u64)(0x0106b0bb1fb384bbLL)), ((u64)(0x4b747cf9516efebcLL)), ((u64)(0x01485ce9e7a065eaLL)), ((u64)(0xde519c37a5cabe6bULL)), ((u64)(0x019a742461887f64LL)), ((u64)(0x0af301a2c79eb703LL)), ((u64)(0x01008896bcf54f9fLL)), ((u64)(0xcdafc20b798664c4ULL)), ((u64)(0x0140aabc6c32a386LL)), ((u64)(0x811bb28e57e7fdf5ULL)), ((u64)(0x0190d56b873f4c68LL)), ((u64)(0xa1629f31ede1fd72ULL)), ((u64)(0x01f50ac6690f1f82LL)), 
((u64)(0xa4dda37f34ad3e67ULL)), ((u64)(0x013926bc01a973b1LL)), ((u64)(0x0e150c5f01d88e01LL)), ((u64)(0x0187706b0213d09eLL)), ((u64)(0x919a4f76c24eb181ULL)), ((u64)(0x01e94c85c298c4c5LL)), ((u64)(0x7b0071aa39712ef1LL)), ((u64)(0x0131cfd3999f7afbLL)), ((u64)(0x59c08e14c7cd7aadLL)), ((u64)(0x017e43c8800759baLL)), ((u64)(0xf030b199f9c0d958ULL)), ((u64)(0x01ddd4baa0093028LL)), ((u64)(0x961e6f003c1887d7ULL)), ((u64)(0x012aa4f4a405be19LL)), ((u64)(0xfba60ac04b1ea9cdULL)), ((u64)(0x01754e31cd072d9fLL)), 
((u64)(0xfa8f8d705de65440ULL)), ((u64)(0x01d2a1be4048f907LL)), ((u64)(0xfc99b8663aaff4a8ULL)), ((u64)(0x0123a516e82d9ba4LL)), ((u64)(0x3bc0267fc95bf1d2LL)), ((u64)(0x016c8e5ca239028eLL)), ((u64)(0xcab0301fbbb2ee47ULL)), ((u64)(0x01c7b1f3cac74331LL)), ((u64)(0x1eae1e13d54fd4ecLL)), ((u64)(0x011ccf385ebc89ffLL)), ((u64)(0xe659a598caa3ca27ULL)), ((u64)(0x01640306766bac7eLL)), ((u64)(0x9ff00efefd4cbcb1ULL)), ((u64)(0x01bd03c81406979eLL)), ((u64)(0x23f6095f5e4ff5efLL)), ((u64)(0x0116225d0c841ec3LL)), 
((u64)(0xecf38bb735e3f36aULL)), ((u64)(0x015baaf44fa52673LL)), ((u64)(0xe8306ea5035cf045ULL)), ((u64)(0x01b295b1638e7010LL)), ((u64)(0x911e4527221a162bULL)), ((u64)(0x010f9d8ede39060aLL)), ((u64)(0x3565d670eaa09bb6LL)), ((u64)(0x015384f295c7478dLL)), ((u64)(0x82bf4c0d2548c2a3ULL)), ((u64)(0x01a8662f3b391970LL)), ((u64)(0x51b78f88374d79a6LL)), ((u64)(0x01093fdd8503afe6LL)), ((u64)(0xe625736a4520d810ULL)), ((u64)(0x014b8fd4e6449bdfLL)), ((u64)(0xdfaed044d6690e14ULL)), ((u64)(0x019e73ca1fd5c2d7LL)), ((u64)(0xebcd422b0601a8ccULL)), ((u64)(0x0103085e53e599c6LL)), ((u64)(0xa6c092b5c78212ffULL)), ((u64)(0x0143ca75e8df0038LL)), ((u64)(0xd070b763396297bfULL)), ((u64)(0x0194bd136316c046LL)), ((u64)(0x848ce53c07bb3dafULL)), ((u64)(0x01f9ec583bdc7058LL)), ((u64)(0x52d80f4584d5068dLL)), ((u64)(0x013c33b72569c637LL)), ((u64)(0x278e1316e60a4831LL)), ((u64)(0x018b40a4eec437c5LL))}; // fixed array const
Array_fixed_u64_584 _const_strconv__pow5_inv_split_64_x = {((u64)(0x0000000000000001)), ((u64)(0x0400000000000000LL)), ((u64)(0x3333333333333334LL)), ((u64)(0x0333333333333333LL)), ((u64)(0x28f5c28f5c28f5c3LL)), ((u64)(0x028f5c28f5c28f5cLL)), ((u64)(0xed916872b020c49cULL)), ((u64)(0x020c49ba5e353f7cLL)), ((u64)(0xaf4f0d844d013a93ULL)), ((u64)(0x0346dc5d63886594LL)), ((u64)(0x8c3f3e0370cdc876ULL)), ((u64)(0x029f16b11c6d1e10LL)), ((u64)(0xd698fe69270b06c5ULL)), ((u64)(0x0218def416bdb1a6LL)), ((u64)(0xf0f4ca41d811a46eULL)), ((u64)(0x035afe535795e90aLL)), 
((u64)(0xf3f70834acdae9f1ULL)), ((u64)(0x02af31dc4611873bLL)), ((u64)(0x5cc5a02a23e254c1LL)), ((u64)(0x0225c17d04dad296LL)), ((u64)(0xfad5cd10396a2135ULL)), ((u64)(0x036f9bfb3af7b756LL)), ((u64)(0xfbde3da69454e75eULL)), ((u64)(0x02bfaffc2f2c92abLL)), ((u64)(0x2fe4fe1edd10b918LL)), ((u64)(0x0232f33025bd4223LL)), ((u64)(0x4ca19697c81ac1bfLL)), ((u64)(0x0384b84d092ed038LL)), ((u64)(0x3d4e1213067bce33LL)), ((u64)(0x02d09370d4257360LL)), ((u64)(0x643e74dc052fd829LL)), ((u64)(0x024075f3dceac2b3LL)), 
((u64)(0x6d30baf9a1e626a7LL)), ((u64)(0x039a5652fb113785LL)), ((u64)(0x2426fbfae7eb5220LL)), ((u64)(0x02e1dea8c8da92d1LL)), ((u64)(0x1cebfcc8b9890e80LL)), ((u64)(0x024e4bba3a487574LL)), ((u64)(0x94acc7a78f41b0ccULL)), ((u64)(0x03b07929f6da5586LL)), ((u64)(0xaa23d2ec729af3d7ULL)), ((u64)(0x02f394219248446bLL)), ((u64)(0xbb4fdbf05baf2979ULL)), ((u64)(0x025c768141d369efLL)), ((u64)(0xc54c931a2c4b758dULL)), ((u64)(0x03c7240202ebdcb2LL)), ((u64)(0x9dd6dc14f03c5e0bULL)), ((u64)(0x0305b66802564a28LL)), 
((u64)(0x4b1249aa59c9e4d6LL)), ((u64)(0x026af8533511d4edLL)), ((u64)(0x44ea0f76f60fd489LL)), ((u64)(0x03de5a1ebb4fbb15LL)), ((u64)(0x6a54d92bf80caa07LL)), ((u64)(0x0318481895d96277LL)), ((u64)(0x21dd7a89933d54d2LL)), ((u64)(0x0279d346de4781f9LL)), ((u64)(0x362f2a75b8622150LL)), ((u64)(0x03f61ed7ca0c0328LL)), ((u64)(0xf825bb91604e810dULL)), ((u64)(0x032b4bdfd4d668ecLL)), ((u64)(0xc684960de6a5340bULL)), ((u64)(0x0289097fdd7853f0LL)), ((u64)(0xd203ab3e521dc33cULL)), ((u64)(0x02073accb12d0ff3LL)), 
((u64)(0xe99f7863b696052cULL)), ((u64)(0x033ec47ab514e652LL)), ((u64)(0x87b2c6b62bab3757ULL)), ((u64)(0x02989d2ef743eb75LL)), ((u64)(0xd2f56bc4efbc2c45ULL)), ((u64)(0x0213b0f25f69892aLL)), ((u64)(0x1e55793b192d13a2LL)), ((u64)(0x0352b4b6ff0f41deLL)), ((u64)(0x4b77942f475742e8LL)), ((u64)(0x02a8909265a5ce4bLL)), ((u64)(0xd5f9435905df68baULL)), ((u64)(0x022073a8515171d5LL)), ((u64)(0x565b9ef4d6324129LL)), ((u64)(0x03671f73b54f1c89LL)), ((u64)(0xdeafb25d78283421ULL)), ((u64)(0x02b8e5f62aa5b06dLL)), 
((u64)(0x188c8eb12cecf681LL)), ((u64)(0x022d84c4eeeaf38bLL)), ((u64)(0x8dadb11b7b14bd9bULL)), ((u64)(0x037c07a17e44b8deLL)), ((u64)(0x7157c0e2c8dd647cLL)), ((u64)(0x02c99fb46503c718LL)), ((u64)(0x8ddfcd823a4ab6caULL)), ((u64)(0x023ae629ea696c13LL)), ((u64)(0x1632e269f6ddf142LL)), ((u64)(0x0391704310a8acecLL)), ((u64)(0x44f581ee5f17f435LL)), ((u64)(0x02dac035a6ed5723LL)), ((u64)(0x372ace584c1329c4LL)), ((u64)(0x024899c4858aac1cLL)), ((u64)(0xbeaae3c079b842d3ULL)), ((u64)(0x03a75c6da27779c6LL)), 
((u64)(0x6555830061603576LL)), ((u64)(0x02ec49f14ec5fb05LL)), ((u64)(0xb7779c004de6912bULL)), ((u64)(0x0256a18dd89e626aLL)), ((u64)(0xf258f99a163db512ULL)), ((u64)(0x03bdcf495a9703ddLL)), ((u64)(0x5b7a614811caf741LL)), ((u64)(0x02fe3f6de212697eLL)), ((u64)(0xaf951aa00e3bf901ULL)), ((u64)(0x0264ff8b1b41edfeLL)), ((u64)(0x7f54f7667d2cc19bLL)), ((u64)(0x03d4cc11c5364997LL)), ((u64)(0x32aa5f8530f09ae3LL)), ((u64)(0x0310a3416a91d479LL)), ((u64)(0xf55519375a5a1582ULL)), ((u64)(0x0273b5cdeedb1060LL)), 
((u64)(0xbbbb5b8bc3c3559dULL)), ((u64)(0x03ec56164af81a34LL)), ((u64)(0x2fc916096969114aLL)), ((u64)(0x03237811d593482aLL)), ((u64)(0x596dab3ababa743cLL)), ((u64)(0x0282c674aadc39bbLL)), ((u64)(0x478aef622efb9030LL)), ((u64)(0x0202385d557cfafcLL)), ((u64)(0xd8de4bd04b2c19e6ULL)), ((u64)(0x0336c0955594c4c6LL)), ((u64)(0xad7ea30d08f014b8ULL)), ((u64)(0x029233aaaadd6a38LL)), ((u64)(0x24654f3da0c01093LL)), ((u64)(0x020e8fbbbbe454faLL)), ((u64)(0x3a3bb1fc346680ebLL)), ((u64)(0x034a7f92c63a2190LL)), 
((u64)(0x94fc8e635d1ecd89ULL)), ((u64)(0x02a1ffa89e94e7a6LL)), ((u64)(0xaa63a51c4a7f0ad4ULL)), ((u64)(0x021b32ed4baa52ebLL)), ((u64)(0xdd6c3b607731aaedULL)), ((u64)(0x035eb7e212aa1e45LL)), ((u64)(0x1789c919f8f488bdLL)), ((u64)(0x02b22cb4dbbb4b6bLL)), ((u64)(0xac6e3a7b2d906d64ULL)), ((u64)(0x022823c3e2fc3c55LL)), ((u64)(0x13e390c515b3e23aLL)), ((u64)(0x03736c6c9e606089LL)), ((u64)(0xdcb60d6a77c31b62ULL)), ((u64)(0x02c2bd23b1e6b3a0LL)), ((u64)(0x7d5e7121f968e2b5LL)), ((u64)(0x0235641c8e52294dLL)), 
((u64)(0xc8971b698f0e3787ULL)), ((u64)(0x0388a02db0837548LL)), ((u64)(0xa078e2bad8d82c6cULL)), ((u64)(0x02d3b357c0692aa0LL)), ((u64)(0xe6c71bc8ad79bd24ULL)), ((u64)(0x0242f5dfcd20eee6LL)), ((u64)(0x0ad82c7448c2c839LL)), ((u64)(0x039e5632e1ce4b0bLL)), ((u64)(0x3be023903a356cfaLL)), ((u64)(0x02e511c24e3ea26fLL)), ((u64)(0x2fe682d9c82abd95LL)), ((u64)(0x0250db01d8321b8cLL)), ((u64)(0x4ca4048fa6aac8eeLL)), ((u64)(0x03b4919c8d1cf8e0LL)), ((u64)(0x3d5003a61eef0725LL)), ((u64)(0x02f6dae3a4172d80LL)), 
((u64)(0x9773361e7f259f51ULL)), ((u64)(0x025f1582e9ac2466LL)), ((u64)(0x8beb89ca6508fee8ULL)), ((u64)(0x03cb559e42ad070aLL)), ((u64)(0x6fefa16eb73a6586LL)), ((u64)(0x0309114b688a6c08LL)), ((u64)(0xf3261abef8fb846bULL)), ((u64)(0x026da76f86d52339LL)), ((u64)(0x51d691318e5f3a45LL)), ((u64)(0x03e2a57f3e21d1f6LL)), ((u64)(0x0e4540f471e5c837LL)), ((u64)(0x031bb798fe8174c5LL)), ((u64)(0xd8376729f4b7d360ULL)), ((u64)(0x027c92e0cb9ac3d0LL)), ((u64)(0xf38bd84321261effULL)), ((u64)(0x03fa849adf5e061aLL)), 
((u64)(0x293cad0280eb4bffLL)), ((u64)(0x032ed07be5e4d1afLL)), ((u64)(0xedca240200bc3cccULL)), ((u64)(0x028bd9fcb7ea4158LL)), ((u64)(0xbe3b50019a3030a4ULL)), ((u64)(0x02097b309321cde0LL)), ((u64)(0xc9f88002904d1a9fULL)), ((u64)(0x03425eb41e9c7c9aLL)), ((u64)(0x3b2d3335403daee6LL)), ((u64)(0x029b7ef67ee396e2LL)), ((u64)(0x95bdc291003158b8ULL)), ((u64)(0x0215ff2b98b6124eLL)), ((u64)(0x892f9db4cd1bc126ULL)), ((u64)(0x035665128df01d4aLL)), ((u64)(0x07594af70a7c9a85LL)), ((u64)(0x02ab840ed7f34aa2LL)), 
((u64)(0x6c476f2c0863aed1LL)), ((u64)(0x0222d00bdff5d54eLL)), ((u64)(0x13a57eacda3917b4LL)), ((u64)(0x036ae67966562217LL)), ((u64)(0x0fb7988a482dac90LL)), ((u64)(0x02bbeb9451de81acLL)), ((u64)(0xd95fad3b6cf156daULL)), ((u64)(0x022fefa9db1867bcLL)), ((u64)(0xf565e1f8ae4ef15cULL)), ((u64)(0x037fe5dc91c0a5faLL)), ((u64)(0x911e4e608b725ab0ULL)), ((u64)(0x02ccb7e3a7cd5195LL)), ((u64)(0xda7ea51a0928488dULL)), ((u64)(0x023d5fe9530aa7aaLL)), ((u64)(0xf7310829a8407415ULL)), ((u64)(0x039566421e7772aaLL)), 
((u64)(0x2c2739baed005cdeLL)), ((u64)(0x02ddeb68185f8eefLL)), ((u64)(0xbcec2e2f24004a4bULL)), ((u64)(0x024b22b9ad193f25LL)), ((u64)(0x94ad16b1d333aa11ULL)), ((u64)(0x03ab6ac2ae8ecb6fLL)), ((u64)(0xaa241227dc2954dbULL)), ((u64)(0x02ef889bbed8a2bfLL)), ((u64)(0x54e9a81fe35443e2LL)), ((u64)(0x02593a163246e899LL)), ((u64)(0x2175d9cc9eed396aLL)), ((u64)(0x03c1f689ea0b0dc2LL)), ((u64)(0xe7917b0a18bdc788ULL)), ((u64)(0x03019207ee6f3e34LL)), ((u64)(0xb9412f3b46fe393aULL)), ((u64)(0x0267a8065858fe90LL)), 
((u64)(0xf535185ed7fd285cULL)), ((u64)(0x03d90cd6f3c1974dLL)), ((u64)(0xc42a79e57997537dULL)), ((u64)(0x03140a458fce12a4LL)), ((u64)(0x03552e512e12a931LL)), ((u64)(0x02766e9e0ca4dbb7LL)), ((u64)(0x9eeeb081e3510eb4ULL)), ((u64)(0x03f0b0fce107c5f1LL)), ((u64)(0x4bf226ce4f740bc3LL)), ((u64)(0x0326f3fd80d304c1LL)), ((u64)(0xa3281f0b72c33c9cULL)), ((u64)(0x02858ffe00a8d09aLL)), ((u64)(0x1c2018d5f568fd4aLL)), ((u64)(0x020473319a20a6e2LL)), ((u64)(0xf9ccf48988a7fba9ULL)), ((u64)(0x033a51e8f69aa49cLL)), 
((u64)(0xfb0a5d3ad3b99621ULL)), ((u64)(0x02950e53f87bb6e3LL)), ((u64)(0x2f3b7dc8a96144e7LL)), ((u64)(0x0210d8432d2fc583LL)), ((u64)(0xe52bfc7442353b0cULL)), ((u64)(0x034e26d1e1e608d1LL)), ((u64)(0xb756639034f76270ULL)), ((u64)(0x02a4ebdb1b1e6d74LL)), ((u64)(0x2c451c735d92b526LL)), ((u64)(0x021d897c15b1f12aLL)), ((u64)(0x13a1c71efc1deea3LL)), ((u64)(0x0362759355e981ddLL)), ((u64)(0x761b05b2634b2550LL)), ((u64)(0x02b52adc44bace4aLL)), ((u64)(0x91af37c1e908eaa6ULL)), ((u64)(0x022a88b036fbd83bLL)), 
((u64)(0x82b1f2cfdb417770ULL)), ((u64)(0x03774119f192f392LL)), ((u64)(0xcef4c23fe29ac5f3ULL)), ((u64)(0x02c5cdae5adbf60eLL)), ((u64)(0x3f2a34ffe87bd190LL)), ((u64)(0x0237d7beaf165e72LL)), ((u64)(0x984387ffda5fb5b2ULL)), ((u64)(0x038c8c644b56fd83LL)), ((u64)(0xe0360666484c915bULL)), ((u64)(0x02d6d6b6a2abfe02LL)), ((u64)(0x802b3851d3707449ULL)), ((u64)(0x024578921bbccb35LL)), ((u64)(0x99dec082ebe72075ULL)), ((u64)(0x03a25a835f947855LL)), ((u64)(0xae4bcd358985b391ULL)), ((u64)(0x02e8486919439377LL)), 
((u64)(0xbea30a913ad15c74ULL)), ((u64)(0x02536d20e102dc5fLL)), ((u64)(0xfdd1aa81f7b560b9ULL)), ((u64)(0x03b8ae9b019e2d65LL)), ((u64)(0x97daeece5fc44d61ULL)), ((u64)(0x02fa2548ce182451LL)), ((u64)(0xdfe258a51969d781ULL)), ((u64)(0x0261b76d71ace9daLL)), ((u64)(0x996a276e8f0fbf34ULL)), ((u64)(0x03cf8be24f7b0fc4LL)), ((u64)(0xe121b9253f3fcc2aULL)), ((u64)(0x030c6fe83f95a636LL)), ((u64)(0xb41afa8432997022ULL)), ((u64)(0x02705986994484f8LL)), ((u64)(0xecf7f739ea8f19cfULL)), ((u64)(0x03e6f5a4286da18dLL)), 
((u64)(0x23f99294bba5ae40LL)), ((u64)(0x031f2ae9b9f14e0bLL)), ((u64)(0x4ffadbaa2fb7be99LL)), ((u64)(0x027f5587c7f43e6fLL)), ((u64)(0x7ff7c5dd1925fdc2LL)), ((u64)(0x03feef3fa6539718LL)), ((u64)(0xccc637e4141e649bULL)), ((u64)(0x033258ffb842df46LL)), ((u64)(0xd704f983434b83afULL)), ((u64)(0x028ead9960357f6bLL)), ((u64)(0x126a6135cf6f9c8cLL)), ((u64)(0x020bbe144cf79923LL)), ((u64)(0x83dd685618b29414ULL)), ((u64)(0x0345fced47f28e9eLL)), ((u64)(0x9cb12044e08edcddULL)), ((u64)(0x029e63f1065ba54bLL)), 
((u64)(0x16f419d0b3a57d7dLL)), ((u64)(0x02184ff405161dd6LL)), ((u64)(0x8b20294dec3bfbfbULL)), ((u64)(0x035a19866e89c956LL)), ((u64)(0x3c19baa4bcfcc996LL)), ((u64)(0x02ae7ad1f207d445LL)), ((u64)(0xc9ae2eea30ca3adfULL)), ((u64)(0x02252f0e5b39769dLL)), ((u64)(0x0f7d17dd1add2afdLL)), ((u64)(0x036eb1b091f58a96LL)), ((u64)(0x3f97464a7be42264LL)), ((u64)(0x02bef48d41913babLL)), ((u64)(0xcc790508631ce850ULL)), ((u64)(0x02325d3dce0dc955LL)), ((u64)(0xe0c1a1a704fb0d4dULL)), ((u64)(0x0383c862e3494222LL)), 
((u64)(0x4d67b4859d95a43eLL)), ((u64)(0x02cfd3824f6dce82LL)), ((u64)(0x711fc39e17aae9cbLL)), ((u64)(0x023fdc683f8b0b9bLL)), ((u64)(0xe832d2968c44a945ULL)), ((u64)(0x039960a6cc11ac2bLL)), ((u64)(0xecf575453d03ba9eULL)), ((u64)(0x02e11a1f09a7bcefLL)), ((u64)(0x572ac4376402fbb1LL)), ((u64)(0x024dae7f3aec9726LL)), ((u64)(0x58446d256cd192b5LL)), ((u64)(0x03af7d985e47583dLL)), ((u64)(0x79d0575123dadbc4LL)), ((u64)(0x02f2cae04b6c4697LL)), ((u64)(0x94a6ac40e97be303ULL)), ((u64)(0x025bd5803c569edfLL)), 
((u64)(0x8771139b0f2c9e6cULL)), ((u64)(0x03c62266c6f0fe32LL)), ((u64)(0x9f8da948d8f07ebdULL)), ((u64)(0x0304e85238c0cb5bLL)), ((u64)(0xe60aedd3e0c06564ULL)), ((u64)(0x026a5374fa33d5e2LL)), ((u64)(0xa344afb9679a3bd2ULL)), ((u64)(0x03dd5254c3862304LL)), ((u64)(0xe903bfc78614fca8ULL)), ((u64)(0x031775109c6b4f36LL)), ((u64)(0xba6966393810ca20ULL)), ((u64)(0x02792a73b055d8f8LL)), ((u64)(0x2a423d2859b4769aLL)), ((u64)(0x03f510b91a22f4c1LL)), ((u64)(0xee9b642047c39215ULL)), ((u64)(0x032a73c7481bf700LL)), 
((u64)(0xbee2b680396941aaULL)), ((u64)(0x02885c9f6ce32c00LL)), ((u64)(0xff1bc53361210155ULL)), ((u64)(0x0206b07f8a4f5666LL)), ((u64)(0x31c6085235019bbbLL)), ((u64)(0x033de73276e5570bLL)), ((u64)(0x27d1a041c4014963LL)), ((u64)(0x0297ec285f1ddf3cLL)), ((u64)(0xeca7b367d0010782ULL)), ((u64)(0x021323537f4b18fcLL)), ((u64)(0xadd91f0c8001a59dULL)), ((u64)(0x0351d21f3211c194LL)), ((u64)(0xf17a7f3d3334847eULL)), ((u64)(0x02a7db4c280e3476LL)), ((u64)(0x279532975c2a0398LL)), ((u64)(0x021fe2a3533e905fLL)), 
((u64)(0xd8eeb75893766c26ULL)), ((u64)(0x0366376bb8641a31LL)), ((u64)(0x7a5892ad42c52352LL)), ((u64)(0x02b82c562d1ce1c1LL)), ((u64)(0xfb7a0ef102374f75ULL)), ((u64)(0x022cf044f0e3e7cdLL)), ((u64)(0xc59017e8038bb254ULL)), ((u64)(0x037b1a07e7d30c7cLL)), ((u64)(0x37a67986693c8eaaLL)), ((u64)(0x02c8e19feca8d6caLL)), ((u64)(0xf951fad1edca0bbbULL)), ((u64)(0x023a4e198a20abd4LL)), ((u64)(0x28832ae97c76792bLL)), ((u64)(0x03907cf5a9cddfbbLL)), ((u64)(0x2068ef21305ec756LL)), ((u64)(0x02d9fd9154a4b2fcLL)), 
((u64)(0x19ed8c1a8d189f78LL)), ((u64)(0x0247fe0ddd508f30LL)), ((u64)(0x5caf4690e1c0ff26LL)), ((u64)(0x03a66349621a7eb3LL)), ((u64)(0x4a25d20d81673285LL)), ((u64)(0x02eb82a11b48655cLL)), ((u64)(0x3b5174d79ab8f537LL)), ((u64)(0x0256021a7c39eab0LL)), ((u64)(0x921bee25c45b21f1ULL)), ((u64)(0x03bcd02a605caab3LL)), ((u64)(0xdb498b5169e2818eULL)), ((u64)(0x02fd735519e3bbc2LL)), ((u64)(0x15d46f7454b53472LL)), ((u64)(0x02645c4414b62fcfLL)), ((u64)(0xefba4bed545520b6ULL)), ((u64)(0x03d3c6d35456b2e4LL)), 
((u64)(0xf2fb6ff110441a2bULL)), ((u64)(0x030fd242a9def583LL)), ((u64)(0x8f2f8cc0d9d014efULL)), ((u64)(0x02730e9bbb18c469LL)), ((u64)(0xb1e5ae015c80217fULL)), ((u64)(0x03eb4a92c4f46d75LL)), ((u64)(0xc1848b344a001accULL)), ((u64)(0x0322a20f03f6bdf7LL)), ((u64)(0xce03a2903b3348a3ULL)), ((u64)(0x02821b3f365efe5fLL)), ((u64)(0xd802e873628f6d4fULL)), ((u64)(0x0201af65c518cb7fLL)), ((u64)(0x599e40b89db2487fLL)), ((u64)(0x0335e56fa1c14599LL)), ((u64)(0xe14b66fa17c1d399ULL)), ((u64)(0x029184594e3437adLL)), 
((u64)(0x81091f2e7967dc7aULL)), ((u64)(0x020e037aa4f692f1LL)), ((u64)(0x9b41cb7d8f0c93f6ULL)), ((u64)(0x03499f2aa18a84b5LL)), ((u64)(0xaf67d5fe0c0a0ff8ULL)), ((u64)(0x02a14c221ad536f7LL)), ((u64)(0xf2b977fe70080cc7ULL)), ((u64)(0x021aa34e7bddc592LL)), ((u64)(0x1df58cca4cd9ae0bLL)), ((u64)(0x035dd2172c9608ebLL)), ((u64)(0xe4c470a1d7148b3cULL)), ((u64)(0x02b174df56de6d88LL)), ((u64)(0x83d05a1b1276d5caULL)), ((u64)(0x022790b2abe5246dLL)), ((u64)(0x9fb3c35e83f1560fULL)), ((u64)(0x0372811ddfd50715LL)), 
((u64)(0xb2f635e5365aab3fULL)), ((u64)(0x02c200e4b310d277LL)), ((u64)(0xf591c4b75eaeef66ULL)), ((u64)(0x0234cd83c273db92LL)), ((u64)(0xef4fa125644b18a3ULL)), ((u64)(0x0387af39371fc5b7LL)), ((u64)(0x8c3fb41de9d5ad4fULL)), ((u64)(0x02d2f2942c196af9LL)), ((u64)(0x3cffc34b2177bdd9LL)), ((u64)(0x02425ba9bce12261LL)), ((u64)(0x94cc6bab68bf9628ULL)), ((u64)(0x039d5f75fb01d09bLL)), ((u64)(0x10a38955ed6611b9LL)), ((u64)(0x02e44c5e6267da16LL)), ((u64)(0xda1c6dde5784dafbULL)), ((u64)(0x02503d184eb97b44LL)), 
((u64)(0xf693e2fd58d49191ULL)), ((u64)(0x03b394f3b128c53aLL)), ((u64)(0xc5431bfde0aa0e0eULL)), ((u64)(0x02f610c2f4209dc8LL)), ((u64)(0x6a9c1664b3bb3e72LL)), ((u64)(0x025e73cf29b3b16dLL)), ((u64)(0x10f9bd6dec5eca4fLL)), ((u64)(0x03ca52e50f85e8afLL)), ((u64)(0xda616457f04bd50cULL)), ((u64)(0x03084250d937ed58LL)), ((u64)(0xe1e783798d09773dULL)), ((u64)(0x026d01da475ff113LL)), ((u64)(0x030c058f480f252eLL)), ((u64)(0x03e19c9072331b53LL)), ((u64)(0x68d66ad906728425LL)), ((u64)(0x031ae3a6c1c27c42LL)), 
((u64)(0x8711ef14052869b7ULL)), ((u64)(0x027be952349b969bLL)), ((u64)(0x0b4fe4ecd50d75f2LL)), ((u64)(0x03f97550542c242cLL)), ((u64)(0xa2a650bd773df7f5ULL)), ((u64)(0x032df7737689b689LL)), ((u64)(0xb551da312c31932aULL)), ((u64)(0x028b2c5c5ed49207LL)), ((u64)(0x5ddb14f4235adc22LL)), ((u64)(0x0208f049e576db39LL)), ((u64)(0x2fc4ee536bc49369LL)), ((u64)(0x034180763bf15ec2LL)), ((u64)(0xbfd0bea92303a921ULL)), ((u64)(0x029acd2b63277f01LL)), ((u64)(0x9973cbba8269541aULL)), ((u64)(0x021570ef8285ff34LL)), 
((u64)(0x5bec792a6a42202aLL)), ((u64)(0x0355817f373ccb87LL)), ((u64)(0xe3239421ee9b4cefULL)), ((u64)(0x02aacdff5f63d605LL)), ((u64)(0xb5b6101b25490a59ULL)), ((u64)(0x02223e65e5e97804LL)), ((u64)(0x22bce691d541aa27LL)), ((u64)(0x0369fd6fd64259a1LL)), ((u64)(0xb563eba7ddce21b9ULL)), ((u64)(0x02bb31264501e14dLL)), ((u64)(0xf78322ecb171b494ULL)), ((u64)(0x022f5a850401810aLL)), ((u64)(0x259e9e47824f8753LL)), ((u64)(0x037ef73b399c01abLL)), ((u64)(0x1e187e9f9b72d2a9LL)), ((u64)(0x02cbf8fc2e1667bcLL)), 
((u64)(0x4b46cbb2e2c24221LL)), ((u64)(0x023cc73024deb963LL)), ((u64)(0x120adf849e039d01LL)), ((u64)(0x039471e6a1645bd2LL)), ((u64)(0xdb3be603b19c7d9aULL)), ((u64)(0x02dd27ebb4504974LL)), ((u64)(0x7c2feb3627b0647cLL)), ((u64)(0x024a865629d9d45dLL)), ((u64)(0x2d197856a5e7072cLL)), ((u64)(0x03aa7089dc8fba2fLL)), ((u64)(0x8a7ac6abb7ec05bdULL)), ((u64)(0x02eec06e4a0c94f2LL)), ((u64)(0xd52f05562cbcd164ULL)), ((u64)(0x025899f1d4d6dd8eLL)), ((u64)(0x21e4d556adfae8a0LL)), ((u64)(0x03c0f64fbaf1627eLL)), 
((u64)(0xe7ea444557fbed4dULL)), ((u64)(0x0300c50c958de864LL)), ((u64)(0xecbb69d1132ff10aULL)), ((u64)(0x0267040a113e5383LL)), ((u64)(0xadf8a94e851981aaULL)), ((u64)(0x03d8067681fd526cLL)), ((u64)(0x8b2d543ed0e13488ULL)), ((u64)(0x0313385ece6441f0LL)), ((u64)(0xd5bddcff0d80f6d3ULL)), ((u64)(0x0275c6b23eb69b26LL)), ((u64)(0x892fc7fe7c018aebULL)), ((u64)(0x03efa45064575ea4LL)), ((u64)(0x3a8c9ffec99ad589LL)), ((u64)(0x03261d0d1d12b21dLL)), ((u64)(0xc8707fff07af113bULL)), ((u64)(0x0284e40a7da88e7dLL)), 
((u64)(0x39f39998d2f2742fLL)), ((u64)(0x0203e9a1fe2071feLL)), ((u64)(0x8fec28f484b7204bULL)), ((u64)(0x033975cffd00b663LL)), ((u64)(0xd989ba5d36f8e6a2ULL)), ((u64)(0x02945e3ffd9a2b82LL)), ((u64)(0x47a161e42bfa521cLL)), ((u64)(0x02104b66647b5602LL)), ((u64)(0x0c35696d132a1cf9LL)), ((u64)(0x034d4570a0c5566aLL)), ((u64)(0x09c454574288172dLL)), ((u64)(0x02a4378d4d6aab88LL)), ((u64)(0xa169dd129ba0128bULL)), ((u64)(0x021cf93dd7888939LL)), ((u64)(0x0242fb50f9001dabLL)), ((u64)(0x03618ec958da7529LL)), 
((u64)(0x9b68c90d940017bcULL)), ((u64)(0x02b4723aad7b90edLL)), ((u64)(0x4920a0d7a999ac96LL)), ((u64)(0x0229f4fbbdfc73f1LL)), ((u64)(0x750101590f5c4757LL)), ((u64)(0x037654c5fcc71fe8LL)), ((u64)(0x2a6734473f7d05dfLL)), ((u64)(0x02c5109e63d27fedLL)), ((u64)(0xeeb8f69f65fd9e4cULL)), ((u64)(0x0237407eb641fff0LL)), ((u64)(0xe45b24323cc8fd46ULL)), ((u64)(0x038b9a6456cfffe7LL)), ((u64)(0xb6af502830a0ca9fULL)), ((u64)(0x02d6151d123fffecLL)), ((u64)(0xf88c402026e7087fULL)), ((u64)(0x0244ddb0db666656LL)), 
((u64)(0x2746cd003e3e73feLL)), ((u64)(0x03a162b4923d708bLL)), ((u64)(0x1f6bd73364fec332LL)), ((u64)(0x02e7822a0e978d3cLL)), ((u64)(0xe5efdf5c50cbcf5bULL)), ((u64)(0x0252ce880bac70fcLL)), ((u64)(0x3cb2fefa1adfb22bLL)), ((u64)(0x03b7b0d9ac471b2eLL)), ((u64)(0x308f3261af195b56LL)), ((u64)(0x02f95a47bd05af58LL)), ((u64)(0x5a0c284e25ade2abLL)), ((u64)(0x0261150630d15913LL)), ((u64)(0x29ad0d49d5e30445LL)), ((u64)(0x03ce8809e7b55b52LL)), ((u64)(0x548a7107de4f369dLL)), ((u64)(0x030ba007ec9115dbLL)), ((u64)(0xdd3b8d9fe50c2bb1ULL)), ((u64)(0x026fb3398a0dab15LL)), ((u64)(0x952c15cca1ad12b5ULL)), ((u64)(0x03e5eb8f434911bcLL)), ((u64)(0x775677d6e7bda891LL)), ((u64)(0x031e560c35d40e30LL)), ((u64)(0xc5dec645863153a7ULL)), ((u64)(0x027eab3cf7dcd826LL))}; // fixed array const
bool v_memory_panic = false; // global 6

int g_main_argc = ((int)(0)); // global 6

voidptr g_main_argv = ((void*)0); // global 6

voidptr g_live_reload_info; // global 6

IError _const_none__; // inited later
const i8 _const_min_i8 = -128; // precomputed2
const i8 _const_max_i8 = 127; // precomputed2
const i16 _const_min_i16 = -32768; // precomputed2
const i16 _const_max_i16 = 32767; // precomputed2
const i32 _const_min_i32 = -2147483648; // precomputed2
const i32 _const_max_i32 = 2147483647; // precomputed2
i64 _const_min_i64; // inited later
i64 _const_max_i64; // inited later
const u8 _const_min_u8 = 0; // precomputed2
const u8 _const_max_u8 = 255; // precomputed2
const u16 _const_min_u16 = 0; // precomputed2
const u16 _const_max_u16 = 65535; // precomputed2
const u32 _const_min_u32 = 0; // precomputed2
const u32 _const_max_u32 = 4294967295; // precomputed2
const u64 _const_min_u64 = 0U; // precomputed2
const u64 _const_max_u64 = 18446744073709551615U; // precomputed2
const f64 _const_max_load_factor = 0.8; // precomputed2
const u32 _const_hash_mask = 16777215; // precomputed2
const u32 _const_probe_inc = 16777216; // precomputed2
Array_fixed_i32_1264 _const_rune_maps = {((i32)(0xB5)), 0xB5, 743, 0, 0xC0, 0xD6, 0, 32, 0xD8, 0xDE, 0, 32, 0xE0, 0xF6, -32, 0, 
0xF8, 0xFE, -32, 0, 0xFF, 0xFF, 121, 0, 0x100, 0x12F, -3, -3, 0x130, 0x130, 0, -199, 
0x131, 0x131, -232, 0, 0x132, 0x137, -3, -3, 0x139, 0x148, -3, -3, 0x14A, 0x177, -3, -3, 
0x178, 0x178, 0, -121, 0x179, 0x17E, -3, -3, 0x17F, 0x17F, -300, 0, 0x180, 0x180, 195, 0, 
0x181, 0x181, 0, 210, 0x182, 0x185, -3, -3, 0x186, 0x186, 0, 206, 0x187, 0x188, -3, -3, 
0x189, 0x18A, 0, 205, 0x18B, 0x18C, -3, -3, 0x18E, 0x18E, 0, 79, 0x18F, 0x18F, 0, 202, 
0x190, 0x190, 0, 203, 0x191, 0x192, -3, -3, 0x193, 0x193, 0, 205, 0x194, 0x194, 0, 207, 
0x195, 0x195, 97, 0, 0x196, 0x196, 0, 211, 0x197, 0x197, 0, 209, 0x198, 0x199, -3, -3, 
0x19A, 0x19A, 163, 0, 0x19C, 0x19C, 0, 211, 0x19D, 0x19D, 0, 213, 0x19E, 0x19E, 130, 0, 
0x19F, 0x19F, 0, 214, 0x1A0, 0x1A5, -3, -3, 0x1A6, 0x1A6, 0, 218, 0x1A7, 0x1A8, -3, -3, 
0x1A9, 0x1A9, 0, 218, 0x1AC, 0x1AD, -3, -3, 0x1AE, 0x1AE, 0, 218, 0x1AF, 0x1B0, -3, -3, 
0x1B1, 0x1B2, 0, 217, 0x1B3, 0x1B6, -3, -3, 0x1B7, 0x1B7, 0, 219, 0x1B8, 0x1B9, -3, -3, 
0x1BC, 0x1BD, -3, -3, 0x1BF, 0x1BF, 56, 0, 0x1C4, 0x1CC, -2, -2, 0x1CD, 0x1DC, -3, -3, 
0x1DD, 0x1DD, -79, 0, 0x1DE, 0x1EF, -3, -3, 0x1F1, 0x1F3, -2, -2, 0x1F4, 0x1F5, -3, -3, 
0x1F6, 0x1F6, 0, -97, 0x1F7, 0x1F7, 0, -56, 0x1F8, 0x21F, -3, -3, 0x220, 0x220, 0, -130, 
0x222, 0x233, -3, -3, 0x23A, 0x23A, 0, 10795, 0x23B, 0x23C, -3, -3, 0x23D, 0x23D, 0, -163, 
0x23E, 0x23E, 0, 10792, 0x23F, 0x240, 10815, 0, 0x241, 0x242, -3, -3, 0x243, 0x243, 0, -195, 
0x244, 0x244, 0, 69, 0x245, 0x245, 0, 71, 0x246, 0x24F, -3, -3, 0x250, 0x250, 10783, 0, 
0x251, 0x251, 10780, 0, 0x252, 0x252, 10782, 0, 0x253, 0x253, -210, 0, 0x254, 0x254, -206, 0, 
0x256, 0x257, -205, 0, 0x259, 0x259, -202, 0, 0x25B, 0x25B, -203, 0, 0x25C, 0x25C, 42319, 0, 
0x260, 0x260, -205, 0, 0x261, 0x261, 42315, 0, 0x263, 0x263, -207, 0, 0x265, 0x265, 42280, 0, 
0x266, 0x266, 42308, 0, 0x268, 0x268, -209, 0, 0x269, 0x269, -211, 0, 0x26A, 0x26A, 42308, 0, 
0x26B, 0x26B, 10743, 0, 0x26C, 0x26C, 42305, 0, 0x26F, 0x26F, -211, 0, 0x271, 0x271, 10749, 0, 
0x272, 0x272, -213, 0, 0x275, 0x275, -214, 0, 0x27D, 0x27D, 10727, 0, 0x280, 0x280, -218, 0, 
0x282, 0x282, 42307, 0, 0x283, 0x283, -218, 0, 0x287, 0x287, 42282, 0, 0x288, 0x288, -218, 0, 
0x289, 0x289, -69, 0, 0x28A, 0x28B, -217, 0, 0x28C, 0x28C, -71, 0, 0x292, 0x292, -219, 0, 
0x29D, 0x29D, 42261, 0, 0x29E, 0x29E, 42258, 0, 0x345, 0x345, 84, 0, 0x370, 0x373, -3, -3, 
0x376, 0x377, -3, -3, 0x37B, 0x37D, 130, 0, 0x37F, 0x37F, 0, 116, 0x386, 0x386, 0, 38, 
0x388, 0x38A, 0, 37, 0x38C, 0x38C, 0, 64, 0x38E, 0x38F, 0, 63, 0x391, 0x3A1, 0, 32, 
0x3A3, 0x3AB, 0, 32, 0x3AC, 0x3AC, -38, 0, 0x3AD, 0x3AF, -37, 0, 0x3B1, 0x3C1, -32, 0, 
0x3C2, 0x3C2, -31, 0, 0x3C3, 0x3CB, -32, 0, 0x3CC, 0x3CC, -64, 0, 0x3CD, 0x3CE, -63, 0, 
0x3CF, 0x3CF, 0, 8, 0x3D0, 0x3D0, -62, 0, 0x3D1, 0x3D1, -57, 0, 0x3D5, 0x3D5, -47, 0, 
0x3D6, 0x3D6, -54, 0, 0x3D7, 0x3D7, -8, 0, 0x3D8, 0x3EF, -3, -3, 0x3F0, 0x3F0, -86, 0, 
0x3F1, 0x3F1, -80, 0, 0x3F2, 0x3F2, 7, 0, 0x3F3, 0x3F3, -116, 0, 0x3F4, 0x3F4, 0, -60, 
0x3F5, 0x3F5, -96, 0, 0x3F7, 0x3F8, -3, -3, 0x3F9, 0x3F9, 0, -7, 0x3FA, 0x3FB, -3, -3, 
0x3FD, 0x3FF, 0, -130, 0x400, 0x40F, 0, 80, 0x410, 0x42F, 0, 32, 0x430, 0x44F, -32, 0, 
0x450, 0x45F, -80, 0, 0x460, 0x481, -3, -3, 0x48A, 0x4BF, -3, -3, 0x4C0, 0x4C0, 0, 15, 
0x4C1, 0x4CE, -3, -3, 0x4CF, 0x4CF, -15, 0, 0x4D0, 0x52F, -3, -3, 0x531, 0x556, 0, 48, 
0x561, 0x586, -48, 0, 0x10A0, 0x10C5, 0, 7264, 0x10C7, 0x10C7, 0, 7264, 0x10CD, 0x10CD, 0, 7264, 
0x10D0, 0x10FA, 3008, 0, 0x10FD, 0x10FF, 3008, 0, 0x13A0, 0x13EF, 0, 38864, 0x13F0, 0x13F5, 0, 8, 
0x13F8, 0x13FD, -8, 0, 0x1C80, 0x1C80, -6254, 0, 0x1C81, 0x1C81, -6253, 0, 0x1C82, 0x1C82, -6244, 0, 
0x1C83, 0x1C84, -6242, 0, 0x1C85, 0x1C85, -6243, 0, 0x1C86, 0x1C86, -6236, 0, 0x1C87, 0x1C87, -6181, 0, 
0x1C88, 0x1C88, 35266, 0, 0x1C90, 0x1CBA, 0, -3008, 0x1CBD, 0x1CBF, 0, -3008, 0x1D79, 0x1D79, 35332, 0, 
0x1D7D, 0x1D7D, 3814, 0, 0x1D8E, 0x1D8E, 35384, 0, 0x1E00, 0x1E95, -3, -3, 0x1E9B, 0x1E9B, -59, 0, 
0x1E9E, 0x1E9E, 0, -7615, 0x1EA0, 0x1EFF, -3, -3, 0x1F00, 0x1F07, 8, 0, 0x1F08, 0x1F0F, 0, -8, 
0x1F10, 0x1F15, 8, 0, 0x1F18, 0x1F1D, 0, -8, 0x1F20, 0x1F27, 8, 0, 0x1F28, 0x1F2F, 0, -8, 
0x1F30, 0x1F37, 8, 0, 0x1F38, 0x1F3F, 0, -8, 0x1F40, 0x1F45, 8, 0, 0x1F48, 0x1F4D, 0, -8, 
0x1F51, 0x1F51, 8, 0, 0x1F53, 0x1F53, 8, 0, 0x1F55, 0x1F55, 8, 0, 0x1F57, 0x1F57, 8, 0, 
0x1F59, 0x1F59, 0, -8, 0x1F5B, 0x1F5B, 0, -8, 0x1F5D, 0x1F5D, 0, -8, 0x1F5F, 0x1F5F, 0, -8, 
0x1F60, 0x1F67, 8, 0, 0x1F68, 0x1F6F, 0, -8, 0x1F70, 0x1F71, 74, 0, 0x1F72, 0x1F75, 86, 0, 
0x1F76, 0x1F77, 100, 0, 0x1F78, 0x1F79, 128, 0, 0x1F7A, 0x1F7B, 112, 0, 0x1F7C, 0x1F7D, 126, 0, 
0x1F80, 0x1F87, 8, 0, 0x1F88, 0x1F8F, 0, -8, 0x1F90, 0x1F97, 8, 0, 0x1F98, 0x1F9F, 0, -8, 
0x1FA0, 0x1FA7, 8, 0, 0x1FA8, 0x1FAF, 0, -8, 0x1FB0, 0x1FB1, 8, 0, 0x1FB3, 0x1FB3, 9, 0, 
0x1FB8, 0x1FB9, 0, -8, 0x1FBA, 0x1FBB, 0, -74, 0x1FBC, 0x1FBC, 0, -9, 0x1FBE, 0x1FBE, -7205, 0, 
0x1FC3, 0x1FC3, 9, 0, 0x1FC8, 0x1FCB, 0, -86, 0x1FCC, 0x1FCC, 0, -9, 0x1FD0, 0x1FD1, 8, 0, 
0x1FD8, 0x1FD9, 0, -8, 0x1FDA, 0x1FDB, 0, -100, 0x1FE0, 0x1FE1, 8, 0, 0x1FE5, 0x1FE5, 7, 0, 
0x1FE8, 0x1FE9, 0, -8, 0x1FEA, 0x1FEB, 0, -112, 0x1FEC, 0x1FEC, 0, -7, 0x1FF3, 0x1FF3, 9, 0, 
0x1FF8, 0x1FF9, 0, -128, 0x1FFA, 0x1FFB, 0, -126, 0x1FFC, 0x1FFC, 0, -9, 0x2126, 0x2126, 0, -7517, 
0x212A, 0x212A, 0, -8383, 0x212B, 0x212B, 0, -8262, 0x2132, 0x2132, 0, 28, 0x214E, 0x214E, -28, 0, 
0x2160, 0x216F, 0, 16, 0x2170, 0x217F, -16, 0, 0x2183, 0x2184, -3, -3, 0x24B6, 0x24CF, 0, 26, 
0x24D0, 0x24E9, -26, 0, 0x2C00, 0x2C2F, 0, 48, 0x2C30, 0x2C5F, -48, 0, 0x2C60, 0x2C61, -3, -3, 
0x2C62, 0x2C62, 0, -10743, 0x2C63, 0x2C63, 0, -3814, 0x2C64, 0x2C64, 0, -10727, 0x2C65, 0x2C65, -10795, 0, 
0x2C66, 0x2C66, -10792, 0, 0x2C67, 0x2C6C, -3, -3, 0x2C6D, 0x2C6D, 0, -10780, 0x2C6E, 0x2C6E, 0, -10749, 
0x2C6F, 0x2C6F, 0, -10783, 0x2C70, 0x2C70, 0, -10782, 0x2C72, 0x2C73, -3, -3, 0x2C75, 0x2C76, -3, -3, 
0x2C7E, 0x2C7F, 0, -10815, 0x2C80, 0x2CE3, -3, -3, 0x2CEB, 0x2CEE, -3, -3, 0x2CF2, 0x2CF3, -3, -3, 
0x2D00, 0x2D25, -7264, 0, 0x2D27, 0x2D27, -7264, 0, 0x2D2D, 0x2D2D, -7264, 0, 0xA640, 0xA66D, -3, -3, 
0xA680, 0xA69B, -3, -3, 0xA722, 0xA72F, -3, -3, 0xA732, 0xA76F, -3, -3, 0xA779, 0xA77C, -3, -3, 
0xA77D, 0xA77D, 0, -35332, 0xA77E, 0xA787, -3, -3, 0xA78B, 0xA78C, -3, -3, 0xA78D, 0xA78D, 0, -42280, 
0xA790, 0xA793, -3, -3, 0xA794, 0xA794, 48, 0, 0xA796, 0xA7A9, -3, -3, 0xA7AA, 0xA7AA, 0, -42308, 
0xA7AB, 0xA7AB, 0, -42319, 0xA7AC, 0xA7AC, 0, -42315, 0xA7AD, 0xA7AD, 0, -42305, 0xA7AE, 0xA7AE, 0, -42308, 
0xA7B0, 0xA7B0, 0, -42258, 0xA7B1, 0xA7B1, 0, -42282, 0xA7B2, 0xA7B2, 0, -42261, 0xA7B3, 0xA7B3, 0, 928, 
0xA7B4, 0xA7C3, -3, -3, 0xA7C4, 0xA7C4, 0, -48, 0xA7C5, 0xA7C5, 0, -42307, 0xA7C6, 0xA7C6, 0, -35384, 
0xA7C7, 0xA7CA, -3, -3, 0xA7D0, 0xA7D1, -3, -3, 0xA7D6, 0xA7D9, -3, -3, 0xA7F5, 0xA7F6, -3, -3, 
0xAB53, 0xAB53, -928, 0, 0xAB70, 0xABBF, -38864, 0, 0xFF21, 0xFF3A, 0, 32, 0xFF41, 0xFF5A, -32, 0, 
0x10400, 0x10427, 0, 40, 0x10428, 0x1044F, -40, 0, 0x104B0, 0x104D3, 0, 40, 0x104D8, 0x104FB, -40, 0, 
0x10570, 0x1057A, 0, 39, 0x1057C, 0x1058A, 0, 39, 0x1058C, 0x10592, 0, 39, 0x10594, 0x10595, 0, 39, 
0x10597, 0x105A1, -39, 0, 0x105A3, 0x105B1, -39, 0, 0x105B3, 0x105B9, -39, 0, 0x105BB, 0x105BC, -39, 0, 
0x10C80, 0x10CB2, 0, 64, 0x10CC0, 0x10CF2, -64, 0, 0x118A0, 0x118BF, 0, 32, 0x118C0, 0x118DF, -32, 0, 
0x16E40, 0x16E5F, 0, 32, 0x16E60, 0x16E7F, -32, 0, 0x1E900, 0x1E921, 0, 34, 0x1E922, 0x1E943, -34, 0}; // fixed array const
vphp__TaskRegistry* g_registry; // global 6

int _const_os__o_rdonly; // inited later
int _const_os__o_wronly; // inited later
int _const_os__o_rdwr; // inited later
int _const_os__o_create; // inited later
int _const_os__o_noctty; // inited later
int _const_os__o_trunc; // inited later
int _const_os__o_append; // inited later
int _const_os__o_nonblock; // inited later
int _const_os__o_sync; // inited later
string _const_os__wd_at_startup; // inited later
Array_string _const_os__executable_suffixes; // inited later
int _const_os__fd_stdout; // inited later
int _const_os__fd_stderr; // inited later
u64 g_main_thread_id; // global 6

u32 _const_builtin__closure__closure_size_1; // inited later
Array_string _const_os__args; // inited later
int _const_builtin__closure__closure_size; // inited later

// V interface table:
static IError I_None___to_Interface_IError(None__* x);
const u32 _IError_None___index = 0;
static IError I_voidptr_to_Interface_IError(voidptr* x);
const u32 _IError_voidptr_index = 1;
static IError I_Error_to_Interface_IError(Error* x);
const u32 _IError_Error_index = 2;
static IError I_MessageError_to_Interface_IError(MessageError* x);
const u32 _IError_MessageError_index = 3;
static IError I_os__Eof_to_Interface_IError(os__Eof* x);
const u32 _IError_os__Eof_index = 4;
static IError I_os__NotExpected_to_Interface_IError(os__NotExpected* x);
const u32 _IError_os__NotExpected_index = 5;
static IError I_os__FileNotOpenedError_to_Interface_IError(os__FileNotOpenedError* x);
const u32 _IError_os__FileNotOpenedError_index = 6;
static IError I_os__SizeOfTypeIs0Error_to_Interface_IError(os__SizeOfTypeIs0Error* x);
const u32 _IError_os__SizeOfTypeIs0Error_index = 7;
static IError I_os__ExecutableNotFoundError_to_Interface_IError(os__ExecutableNotFoundError* x);
const u32 _IError_os__ExecutableNotFoundError_index = 8;
// ^^^ number of types for interface IError: 9

// Methods wrapper for interface "IError"
static inline int builtin__None___code_Interface_IError_method_wrapper(None__* err) {
	return builtin__Error_code(err->Error);
}
static inline string builtin__None___msg_Interface_IError_method_wrapper(None__* err) {
	return builtin__Error_msg(err->Error);
}
static inline int builtin__Error_code_Interface_IError_method_wrapper(Error* err) {
	return builtin__Error_code(*err);
}
static inline string builtin__Error_msg_Interface_IError_method_wrapper(Error* err) {
	return builtin__Error_msg(*err);
}
static inline int builtin__MessageError_code_Interface_IError_method_wrapper(MessageError* err) {
	return builtin__MessageError_code(*err);
}
static inline string builtin__MessageError_msg_Interface_IError_method_wrapper(MessageError* err) {
	return builtin__MessageError_msg(*err);
}
static inline int builtin__os__Eof_code_Interface_IError_method_wrapper(os__Eof* err) {
	return builtin__Error_code(err->Error);
}
static inline string builtin__os__Eof_msg_Interface_IError_method_wrapper(os__Eof* err) {
	return builtin__Error_msg(err->Error);
}
static inline int os__NotExpected_code_Interface_IError_method_wrapper(os__NotExpected* err) {
	return os__NotExpected_code(*err);
}
static inline string os__NotExpected_msg_Interface_IError_method_wrapper(os__NotExpected* err) {
	return os__NotExpected_msg(*err);
}
static inline int builtin__os__FileNotOpenedError_code_Interface_IError_method_wrapper(os__FileNotOpenedError* err) {
	return builtin__Error_code(err->Error);
}
static inline string os__FileNotOpenedError_msg_Interface_IError_method_wrapper(os__FileNotOpenedError* err) {
	return os__FileNotOpenedError_msg(*err);
}
static inline int builtin__os__SizeOfTypeIs0Error_code_Interface_IError_method_wrapper(os__SizeOfTypeIs0Error* err) {
	return builtin__Error_code(err->Error);
}
static inline string os__SizeOfTypeIs0Error_msg_Interface_IError_method_wrapper(os__SizeOfTypeIs0Error* err) {
	return os__SizeOfTypeIs0Error_msg(*err);
}
static inline int builtin__os__ExecutableNotFoundError_code_Interface_IError_method_wrapper(os__ExecutableNotFoundError* err) {
	return builtin__Error_code(err->Error);
}
static inline string os__ExecutableNotFoundError_msg_Interface_IError_method_wrapper(os__ExecutableNotFoundError* err) {
	return os__ExecutableNotFoundError_msg(*err);
}

struct _IError_interface_methods {
	int (*_method_code)(void* _);
	string (*_method_msg)(void* _);
};

struct _IError_interface_methods IError_name_table[9] = {
	{
		._method_code = (void*) builtin__None___code_Interface_IError_method_wrapper,
		._method_msg = (void*) builtin__None___msg_Interface_IError_method_wrapper,
	},
	{
		._method_code = (void*) 0,
		._method_msg = (void*) 0,
	},
	{
		._method_code = (void*) builtin__Error_code_Interface_IError_method_wrapper,
		._method_msg = (void*) builtin__Error_msg_Interface_IError_method_wrapper,
	},
	{
		._method_code = (void*) builtin__MessageError_code_Interface_IError_method_wrapper,
		._method_msg = (void*) builtin__MessageError_msg_Interface_IError_method_wrapper,
	},
	{
		._method_code = (void*) builtin__os__Eof_code_Interface_IError_method_wrapper,
		._method_msg = (void*) builtin__os__Eof_msg_Interface_IError_method_wrapper,
	},
	{
		._method_code = (void*) os__NotExpected_code_Interface_IError_method_wrapper,
		._method_msg = (void*) os__NotExpected_msg_Interface_IError_method_wrapper,
	},
	{
		._method_code = (void*) builtin__os__FileNotOpenedError_code_Interface_IError_method_wrapper,
		._method_msg = (void*) os__FileNotOpenedError_msg_Interface_IError_method_wrapper,
	},
	{
		._method_code = (void*) builtin__os__SizeOfTypeIs0Error_code_Interface_IError_method_wrapper,
		._method_msg = (void*) os__SizeOfTypeIs0Error_msg_Interface_IError_method_wrapper,
	},
	{
		._method_code = (void*) builtin__os__ExecutableNotFoundError_code_Interface_IError_method_wrapper,
		._method_msg = (void*) os__ExecutableNotFoundError_msg_Interface_IError_method_wrapper,
	},
};


// Casting functions for converting "None__" to interface "IError"

static inline IError I_None___to_Interface_IError(None__* x) {
return (IError) {
		._None__ = x,
		._typ = _IError_None___index,
	};
}

// Casting functions for converting "voidptr" to interface "IError"

static inline IError I_voidptr_to_Interface_IError(voidptr* x) {
return (IError) {
		._voidptr = x,
		._typ = _IError_voidptr_index,
	};
}

// Casting functions for converting "Error" to interface "IError"

static inline IError I_Error_to_Interface_IError(Error* x) {
return (IError) {
		._Error = x,
		._typ = _IError_Error_index,
	};
}

// Casting functions for converting "MessageError" to interface "IError"

static inline IError I_MessageError_to_Interface_IError(MessageError* x) {
return (IError) {
		._MessageError = x,
		._typ = _IError_MessageError_index,
	};
}

// Casting functions for converting "os__Eof" to interface "IError"

static inline IError I_os__Eof_to_Interface_IError(os__Eof* x) {
return (IError) {
		._os__Eof = x,
		._typ = _IError_os__Eof_index,
	};
}

// Casting functions for converting "os__NotExpected" to interface "IError"

static inline IError I_os__NotExpected_to_Interface_IError(os__NotExpected* x) {
return (IError) {
		._os__NotExpected = x,
		._typ = _IError_os__NotExpected_index,
	};
}

// Casting functions for converting "os__FileNotOpenedError" to interface "IError"

static inline IError I_os__FileNotOpenedError_to_Interface_IError(os__FileNotOpenedError* x) {
return (IError) {
		._os__FileNotOpenedError = x,
		._typ = _IError_os__FileNotOpenedError_index,
	};
}

// Casting functions for converting "os__SizeOfTypeIs0Error" to interface "IError"

static inline IError I_os__SizeOfTypeIs0Error_to_Interface_IError(os__SizeOfTypeIs0Error* x) {
return (IError) {
		._os__SizeOfTypeIs0Error = x,
		._typ = _IError_os__SizeOfTypeIs0Error_index,
	};
}

// Casting functions for converting "os__ExecutableNotFoundError" to interface "IError"

static inline IError I_os__ExecutableNotFoundError_to_Interface_IError(os__ExecutableNotFoundError* x) {
return (IError) {
		._os__ExecutableNotFoundError = x,
		._typ = _IError_os__ExecutableNotFoundError_index,
	};
}

static vphp__ITask I_main__AnalyzeTask_to_Interface_vphp__ITask(main__AnalyzeTask* x);
const u32 _vphp__ITask_main__AnalyzeTask_index = 0;
static vphp__ITask I_voidptr_to_Interface_vphp__ITask(voidptr* x);
const u32 _vphp__ITask_voidptr_index = 1;
// ^^^ number of types for interface vphp__ITask: 2

// Methods wrapper for interface "vphp__ITask"
static inline Array_f64 main__AnalyzeTask_run_Interface_vphp__ITask_method_wrapper(main__AnalyzeTask* t) {
	return main__AnalyzeTask_run(*t);
}

struct _vphp__ITask_interface_methods {
	Array_f64 (*_method_run)(void* _);
};

struct _vphp__ITask_interface_methods vphp__ITask_name_table[2] = {
	{
		._method_run = (void*) main__AnalyzeTask_run_Interface_vphp__ITask_method_wrapper,
	},
	{
		._method_run = (void*) 0,
	},
};


// Casting functions for converting "main__AnalyzeTask" to interface "vphp__ITask"

static inline vphp__ITask I_main__AnalyzeTask_to_Interface_vphp__ITask(main__AnalyzeTask* x) {
return (vphp__ITask) {
		._main__AnalyzeTask = x,
		._typ = _vphp__ITask_main__AnalyzeTask_index,
	};
}

// Casting functions for converting "voidptr" to interface "vphp__ITask"

static inline vphp__ITask I_voidptr_to_Interface_vphp__ITask(voidptr* x) {
return (vphp__ITask) {
		._voidptr = x,
		._typ = _vphp__ITask_voidptr_index,
	};
}


// V sort fn definitions:
VV_LOC  int compare_11835712493692648452_RepIndex_by_idx(RepIndex* a, RepIndex* b) {
	if (a->idx < b->idx) return -1;
	else return 1;
}

VV_LOC  int compare_1065768667300548517_string(string* a, string* b) {
	if (builtin__string__lt(*a, *b)) return -1;
	else return 1;
}


// end of V out (header)

// V gowrappers waiter fns:
Array_f64 __v_thread_Array_f64_wait(__v_thread_Array_f64 thread);
void* vphp__ITask_run_thread_wrapper(thread_arg_vphp__ITask_run *arg);

// V auto functions:
static bool Array_u8_contains(Array_u8 a, u8 v) {
	for (int i = 0; i < a.len; ++i) {
		if (((u8*)a.data)[i] == v) {
			return true;
		}
	}
	return false;
}

static bool Array_string_contains(Array_string a, string v) {
	for (int i = 0; i < a.len; ++i) {
		if (builtin__fast_string_eq(((string*)a.data)[i], v)) {
			return true;
		}
	}
	return false;
}

inline bool Array_rune_arr_eq(Array_rune a, Array_rune b) {
	if (a.len != b.len) {
		return false;
	}
	for (int i = 0; i < a.len; ++i) {
		if (*((rune*)((byte*)a.data+(i*a.element_size))) != *((rune*)((byte*)b.data+(i*b.element_size)))) {
			return false;
		}
	}
	return true;
}


// V gowrappers:

Array_f64 __v_thread_Array_f64_wait(__v_thread_Array_f64 thread) {
	Array_f64* ret_ptr;
	if ((unsigned long int)thread == 0) { builtin___v_panic(_S("unable to join thread")); }
	int stat = pthread_join(thread, (void **)&ret_ptr);
	if (stat != 0) { builtin___v_panic(_S("unable to join thread")); }
	Array_f64 ret = *ret_ptr;
	builtin___v_free(ret_ptr);
	return ret;
}
void* vphp__ITask_run_thread_wrapper(thread_arg_vphp__ITask_run *arg) {
	Array_f64* ret_ptr = (Array_f64*) builtin___v_malloc(sizeof(Array_f64));
	*ret_ptr = vphp__ITask_name_table[arg->arg0._typ]._method_run(arg->arg0._object);
	builtin___v_free(arg);
	return ret_ptr;
}

// V anon functions:
VV_LOC vphp__ITask anon_fn_e0873e5963f3179a_40___vphp__ITask_146(void) {
	return I_main__AnalyzeTask_to_Interface_vphp__ITask(((main__AnalyzeTask*)builtin__memdup(&(main__AnalyzeTask){.data = builtin____new_array(0, 0, sizeof(f64)),}, sizeof(main__AnalyzeTask))));
}


// >> typeof() support for sum types / interfaces
static char * v_typeof_interface_IError(u32 sidx) {
	if (sidx == _IError_None___index) return "None__";
	if (sidx == _IError_voidptr_index) return "voidptr";
	if (sidx == _IError_Error_index) return "Error";
	if (sidx == _IError_MessageError_index) return "MessageError";
	if (sidx == _IError_os__Eof_index) return "os.Eof";
	if (sidx == _IError_os__NotExpected_index) return "os.NotExpected";
	if (sidx == _IError_os__FileNotOpenedError_index) return "os.FileNotOpenedError";
	if (sidx == _IError_os__SizeOfTypeIs0Error_index) return "os.SizeOfTypeIs0Error";
	if (sidx == _IError_os__ExecutableNotFoundError_index) return "os.ExecutableNotFoundError";
	return "unknown IError";
}

u32 v_typeof_interface_idx_IError(u32 sidx) {
	if (sidx == _IError_None___index) return 62;
	if (sidx == _IError_voidptr_index) return 2;
	if (sidx == _IError_Error_index) return 63;
	if (sidx == _IError_MessageError_index) return 64;
	if (sidx == _IError_os__Eof_index) return 167;
	if (sidx == _IError_os__NotExpected_index) return 168;
	if (sidx == _IError_os__FileNotOpenedError_index) return 170;
	if (sidx == _IError_os__SizeOfTypeIs0Error_index) return 171;
	if (sidx == _IError_os__ExecutableNotFoundError_index) return 189;
	return 30;
}
static char * v_typeof_interface_vphp__ITask(u32 sidx) {
	if (sidx == _vphp__ITask_main__AnalyzeTask_index) return "AnalyzeTask";
	if (sidx == _vphp__ITask_voidptr_index) return "voidptr";
	return "unknown vphp.ITask";
}

u32 v_typeof_interface_idx_vphp__ITask(u32 sidx) {
	if (sidx == _vphp__ITask_main__AnalyzeTask_index) return 109;
	if (sidx == _vphp__ITask_voidptr_index) return 2;
	return 108;
}
// << typeof() support for sum types

strings__Builder strings__new_builder(int initial_size) {
	strings__Builder res = ((builtin____new_array_with_default(0, initial_size, sizeof(u8), 0)));
	builtin__ArrayFlags_set(&res.flags, ArrayFlags__noslices);
	return res;
}
Array_u8 strings__Builder_reuse_as_plain_u8_array(strings__Builder* b) {
	builtin__ArrayFlags_clear(&b->flags, ArrayFlags__noslices);
	return *b;
}
void strings__Builder_write_ptr(strings__Builder* b, u8* ptr, int len) {
	if (len == 0) {
		return;
	}
	builtin__array_push_many(b, ptr, len);
}
void strings__Builder_write_rune(strings__Builder* b, rune r) {
	Array_fixed_u8_5 buffer = {0};
	string res = builtin__utf32_to_str_no_malloc(((u32)(r)), &buffer[0]);
	if (res.len == 0) {
		return;
	}
	builtin__array_push_many(b, res.str, res.len);
}
void strings__Builder_write_runes(strings__Builder* b, Array_rune runes) {
	Array_fixed_u8_5 buffer = {0};
	for (int _t1 = 0; _t1 < runes.len; ++_t1) {
		rune r = ((rune*)runes.data)[_t1];
		string res = builtin__utf32_to_str_no_malloc(((u32)(r)), &buffer[0]);
		if (res.len == 0) {
			continue;
		}
		builtin__array_push_many(b, res.str, res.len);
	}
}
inline void strings__Builder_write_u8(strings__Builder* b, u8 data) {
	builtin__array_push((array*)b, _MOV((u8[]){ data }));
}
inline void strings__Builder_write_byte(strings__Builder* b, u8 data) {
	builtin__array_push((array*)b, _MOV((u8[]){ data }));
}
void strings__Builder_write_decimal(strings__Builder* b, i64 n) {
	if (n == 0) {
		strings__Builder_write_u8(b, 0x30);
		return;
	}
	if (n == _const_min_i64) {
		strings__Builder_write_string(b, builtin__i64_str(n));
		return;
	}
	Array_fixed_u8_25 buf = {0};
	i64 x = (n < 0 ? (-n) : (n));
	int i = 24;
	for (;;) {
		if (!(x != 0)) break;
		i64 nextx = (i64)(x / 10);
		i64 r = (i64)(x % 10);
		buf[i] = (u8)(((u8)(r)) + 0x30);
		x = nextx;
		i--;
	}
	if (n < 0) {
		buf[i] = '-';
		i--;
	}
	strings__Builder_write_ptr(b, &buf[(int)(i + 1)], (int)(24 - i));
}
_result_int strings__Builder_write(strings__Builder* b, Array_u8 data) {
	if (data.len == 0) {
		_result_int _t1;
		builtin___result_ok(&(int[]) { 0 }, (_result*)(&_t1), sizeof(int));
		 
		return _t1;
	}
	builtin__array_push_many(b, data.data, data.len);
	_result_int _t2;
	builtin___result_ok(&(int[]) { data.len }, (_result*)(&_t2), sizeof(int));
	 
	return _t2;
}
void strings__Builder_drain_builder(strings__Builder* b, strings__Builder* other, int other_new_cap) {
	if (other->len > 0) {
		_PUSH_MANY(b, (*other), _t1, strings__Builder);
	}
	strings__Builder_free(other);
	*other = strings__new_builder(other_new_cap);
}
inline u8 strings__Builder_byte_at(strings__Builder* b, int n) {
	return (*(u8*)builtin__array_get(*(((Array_u8*)(b))), n));
}
inline void strings__Builder_write_string(strings__Builder* b, string s) {
	if (s.len == 0) {
		return;
	}
	builtin__array_push_many(b, s.str, s.len);
}
inline void strings__Builder_write_string2(strings__Builder* b, string s1, string s2) {
	if (s1.len != 0) {
		builtin__array_push_many(b, s1.str, s1.len);
	}
	if (s2.len != 0) {
		builtin__array_push_many(b, s2.str, s2.len);
	}
}
void strings__Builder_go_back(strings__Builder* b, int n) {
	builtin__array_trim(b, (int)(b->len - n));
}
inline string strings__Builder_spart(strings__Builder* b, int start_pos, int n) {
	{ // Unsafe block
		u8* x = builtin__malloc_noscan((int)(n + 1));
		builtin__vmemcpy(x, ((u8*)(b->data)) + start_pos, n);
		x[n] = 0;
		return builtin__tos(x, n);
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
string strings__Builder_cut_last(strings__Builder* b, int n) {
	int cut_pos = (int)(b->len - n);
	string res = strings__Builder_spart(b, cut_pos, n);
	builtin__array_trim(b, cut_pos);
	return res;
}
string strings__Builder_cut_to(strings__Builder* b, int pos) {
	if (pos > b->len) {
		return _S("");
	}
	return strings__Builder_cut_last(b, (int)(b->len - pos));
}
void strings__Builder_go_back_to(strings__Builder* b, int pos) {
	builtin__array_trim(b, pos);
}
inline void strings__Builder_writeln(strings__Builder* b, string s) {
	if ((s).len != 0) {
		builtin__array_push_many(b, s.str, s.len);
	}
	builtin__array_push((array*)b, _MOV((u8[]){ ((u8)('\n')) }));
}
inline void strings__Builder_writeln2(strings__Builder* b, string s1, string s2) {
	if ((s1).len != 0) {
		builtin__array_push_many(b, s1.str, s1.len);
	}
	builtin__array_push((array*)b, _MOV((u8[]){ ((u8)('\n')) }));
	if ((s2).len != 0) {
		builtin__array_push_many(b, s2.str, s2.len);
	}
	builtin__array_push((array*)b, _MOV((u8[]){ ((u8)('\n')) }));
}
string strings__Builder_last_n(strings__Builder* b, int n) {
	if (n > b->len) {
		return _S("");
	}
	return strings__Builder_spart(b, (int)(b->len - n), n);
}
string strings__Builder_after(strings__Builder* b, int n) {
	if (n >= b->len) {
		return _S("");
	}
	return strings__Builder_spart(b, n, (int)(b->len - n));
}
string strings__Builder_str(strings__Builder* b) {
	builtin__array_push((array*)b, _MOV((u8[]){ ((u8)(0)) }));
	u8* bcopy = ((u8*)(builtin__memdup_noscan(b->data, b->len)));
	string s = builtin__u8_vstring_with_len(bcopy, (int)(b->len - 1));
	builtin__array_clear(b);
	return s;
}
void strings__Builder_ensure_cap(strings__Builder* b, int n) {
	if (n <= b->cap) {
		return;
	}
	u8* new_data = builtin__vcalloc((int)(n * b->element_size));
	if (b->data != ((void*)0)) {
		builtin__vmemcpy(new_data, b->data, (int)(b->len * b->element_size));
		if (builtin__ArrayFlags_has(&b->flags, ArrayFlags__noslices)) {
			builtin___v_free(b->data);
		}
	}
	{ // Unsafe block
		b->data = new_data;
		b->offset = 0;
		b->cap = n;
	}
}
void strings__Builder_grow_len(strings__Builder* b, int n) {
	if (n <= 0) {
		return;
	}
	int new_len = (int)(b->len + n);
	strings__Builder_ensure_cap(b, new_len);
	{ // Unsafe block
		b->len = new_len;
	}
}
void strings__Builder_free(strings__Builder* b) {
	if (b->data != 0) {
		builtin___v_free(b->data);
		{ // Unsafe block
			b->data = ((void*)0);
		}
	}
}
void strings__Builder_write_repeated_rune(strings__Builder* b, rune r, int count) {
	if (count <= 0) {
		return;
	}
	Array_fixed_u8_5 buffer = {0};
	string res = builtin__utf32_to_str_no_malloc(((u32)(r)), &buffer[0]);
	if (res.len == 0) {
		return;
	}
	if (res.len == 1) {
		strings__Builder_ensure_cap(b, (int)(b->len + count));
		{ // Unsafe block
			builtin__vmemset(((u8*)(b->data)) + b->len, buffer[0], count);
			b->len += count;
		}
		return;
	} else {
		int total_needed = (int)(count * res.len);
		strings__Builder_ensure_cap(b, (int)(b->len + total_needed));
		u8* dest = ((u8*)(b->data)) + b->len;
		for (int _t1 = 0; _t1 < count; ++_t1) {
			{ // Unsafe block
				builtin__vmemcpy(dest, res.str, res.len);
				dest += res.len;
			}
		}
		{ // Unsafe block
			b->len += total_needed;
		}
	}
}
void strings__Builder_indent(strings__Builder* b, string s, strings__IndentParam param) {
	if (s.len == 0) {
		return;
	}
	strings__IndentState state = strings__IndentState__normal;
	int indent_level = param.starting_level;
	rune string_char = '\0';
	bool at_line_start = true;
	for (int i = 0; i < s.len; i++) {
		u8 c = s.str[ i];

		if (state == (strings__IndentState__normal)) {

			if (c == ('"') || c == ('\'')) {
				state = strings__IndentState__in_string;
				string_char = c;
				if (at_line_start) {
					strings__Builder_write_repeated_rune(b, param.indent_char, (int)(indent_level * param.indent_count));
					at_line_start = false;
				}
				strings__Builder_write_rune(b, c);
			}
			else if (c == (param.block_start)) {
				if (at_line_start) {
					strings__Builder_write_repeated_rune(b, param.indent_char, (int)(indent_level * param.indent_count));
					at_line_start = false;
				}
				strings__Builder_write_rune(b, c);
				if ((int)(i + 1) < s.len && s.str[ (int)(i + 1)] == param.block_end) {
					strings__Builder_write_rune(b, param.block_end);
					i++;
				} else {
					indent_level++;
					strings__Builder_write_rune(b, '\n');
					at_line_start = true;
				}
			}
			else if (c == (param.block_end)) {
				if (indent_level > 0) {
					indent_level--;
				}
				if (!at_line_start) {
					strings__Builder_write_rune(b, '\n');
				}
				strings__Builder_write_repeated_rune(b, param.indent_char, (int)(indent_level * param.indent_count));
				at_line_start = false;
				strings__Builder_write_rune(b, c);
			}
			else if (c == (' ') || c == ('\t') || c == ('\r') || c == ('\n')) {
				if (!at_line_start) {
					strings__Builder_write_rune(b, c);
				}
				if (c == '\n') {
					at_line_start = true;
				}
			}
			else {
				if (at_line_start) {
					strings__Builder_write_repeated_rune(b, param.indent_char, (int)(indent_level * param.indent_count));
					at_line_start = false;
				}
				strings__Builder_write_rune(b, c);
			}
		}
		else if (state == (strings__IndentState__in_string)) {
			strings__Builder_write_rune(b, c);
			if (c == string_char) {
				if (s.str[ (int)(i - 1)] != '\\') {
					state = strings__IndentState__normal;
					string_char = '\0';
				}
			}
		}
	}
}
inline VV_LOC int strings__min(int a, int b, int c) {
	int m = a;
	if (b < m) {
		m = b;
	}
	if (c < m) {
		m = c;
	}
	return m;
}
inline VV_LOC int strings__max2(int a, int b) {
	if (a < b) {
		return b;
	}
	return a;
}
inline VV_LOC int strings__min2(int a, int b) {
	if (a < b) {
		return a;
	}
	return b;
}
inline VV_LOC int strings__abs2(int a, int b) {
	if (a < b) {
		return (int)(b - a);
	}
	return (int)(a - b);
}
int strings__levenshtein_distance(string a, string b) {
	if (a.len == 0) {
		return b.len;
	}
	if (b.len == 0) {
		return a.len;
	}
	if (builtin__string__eq(a, b)) {
		return 0;
	}
	Array_int row = 	builtin____new_array_with_default((int)(a.len + 1), 0, sizeof(int), 0);
	{
		int* pelem = (int*)row.data;
		for (int index=0; index<row.len; index++, pelem++) {
			int it = index;
			*pelem = index;
		}
	}
	;
	for (int i = 1; i < (int)(b.len + 1); i++) {
		int prev = i;
		for (int j = 1; j < (int)(a.len + 1); j++) {
			int current = ((int*)row.data)[(int)(j - 1)];
			if (b.str[ (int)(i - 1)] != a.str[ (int)(j - 1)]) {
				current = strings__min((int)(((int*)row.data)[(int)(j - 1)] + 1), (int)(prev + 1), (int)(((int*)row.data)[j] + 1));
			}
			((int*)row.data)[(int)(j - 1)] = prev;
			prev = current;
		}
		((int*)row.data)[a.len] = prev;
	}
	return ((int*)row.data)[a.len];
}
f32 strings__levenshtein_distance_percentage(string a, string b) {
	int d = strings__levenshtein_distance(a, b);
	int l = (a.len >= b.len ? (a.len) : (b.len));
	return (f32)(((f32)(((f32)(1.00)) - (f32)(((f32)(d)) / ((f32)(l))))) * ((f32)(100.00)));
}
f32 strings__dice_coefficient(string s1, string s2) {
	if (s1.len == 0 || s2.len == 0) {
		return 0.0;
	}
	if (builtin__string__eq(s1, s2)) {
		return 1.0;
	}
	if (s1.len < 2 || s2.len < 2) {
		return 0.0;
	}
	string a = (s1.len > s2.len ? (s1) : (s2));
	string b = (builtin__string__eq(a, s1) ? (s2) : (s1));
	Map_string_int first_bigrams = builtin__new_map(sizeof(string), sizeof(int), &builtin__map_hash_string, &builtin__map_eq_string, &builtin__map_clone_string, &builtin__map_free_string)
	;
	for (int i = 0; i < (int)(a.len - 1); ++i) {
		string bigram = builtin__string_substr(a, i, (int_literal)(i + 2));
		int q = (_IN_MAP(ADDR(string, bigram), ADDR(map, first_bigrams)) ? ((int)((*(int*)builtin__map_get(ADDR(map, first_bigrams), &(string[]){bigram}, &(int[]){ 0 })) + 1)) : (1));
		builtin__map_set(&first_bigrams, &(string[]){bigram}, &(int[]) { q });
	}
	int intersection_size = 0;
	for (int i = 0; i < (int)(b.len - 1); ++i) {
		string bigram = builtin__string_substr(b, i, (int_literal)(i + 2));
		int count = (_IN_MAP(ADDR(string, bigram), ADDR(map, first_bigrams)) ? ((*(int*)builtin__map_get(ADDR(map, first_bigrams), &(string[]){bigram}, &(int[]){ 0 }))) : (0));
		if (count > 0) {
			builtin__map_set(&first_bigrams, &(string[]){bigram}, &(int[]) { (int)(count - 1) });
			intersection_size++;
		}
	}
	return (f32)(((f32)(((f32)(2.0)) * ((f32)(intersection_size)))) / ((f32)((f32)(((f32)(a.len)) + ((f32)(b.len))) - 2)));
}
int strings__hamming_distance(string a, string b) {
	if (a.len == 0 && b.len == 0) {
		return 0;
	}
	int match_len = strings__min2(a.len, b.len);
	int diff_count = strings__abs2(a.len, b.len);
	for (int i = 0; i < match_len; ++i) {
		if (a.str[ i] != b.str[ i]) {
			diff_count++;
		}
	}
	return diff_count;
}
f32 strings__hamming_similarity(string a, string b) {
	int l = strings__max2(a.len, b.len);
	if (l == 0) {
		return 1.0;
	}
	int d = strings__hamming_distance(a, b);
	return (f32)(((f32)(1.00)) - (f32)(((f32)(d)) / ((f32)(l))));
}
f64 strings__jaro_similarity(string a, string b) {
	int a_len = a.len;
	int b_len = b.len;
	if (a_len == 0 && b_len == 0) {
		return 1.0;
	}
	if (a_len == 0 || b_len == 0) {
		return 0;
	}
	int match_distance = (int)((int)(strings__max2(a_len, b_len) / 2) - 1);
	Array_bool a_matches = builtin____new_array_with_default(a_len, 0, sizeof(bool), 0);
	Array_bool b_matches = builtin____new_array_with_default(b_len, 0, sizeof(bool), 0);
	int matches = 0;
	f64 transpositions = 0.0;
	for (int i = 0; i < a_len; ++i) {
		int start = strings__max2(0, (int)(i - match_distance));
		int end = strings__min2(b_len, (int)((int)(i + match_distance) + 1));
		for (int k = start; k < end; ++k) {
			if (((bool*)b_matches.data)[k]) {
				continue;
			}
			if (a.str[ i] != b.str[ k]) {
				continue;
			}
			((bool*)a_matches.data)[i] = true;
			((bool*)b_matches.data)[k] = true;
			matches++;
			break;
		}
	}
	if (matches == 0) {
		return 0;
	}
	int k = 0;
	for (int i = 0; i < a_len; ++i) {
		if (!((bool*)a_matches.data)[i]) {
			continue;
		}
		for (;;) {
			if (!(!((bool*)b_matches.data)[k])) break;
			k++;
		}
		if (a.str[ i] != b.str[ k]) {
			transpositions++;
		}
		k++;
	}
	transpositions /= 2;
	return (f64)(((f64)((f64)((f64)(matches / ((f64)(a_len))) + (f64)(matches / ((f64)(b_len)))) + (f64)(((f64)(matches - transpositions)) / matches))) / 3);
}
f64 strings__jaro_winkler_similarity(string a, string b) {
	int lmax = strings__min2(4, strings__min2(a.len, b.len));
	int l = 0;
	for (int i = 0; i < lmax; ++i) {
		if (a.str[ i] == b.str[ i]) {
			l++;
		}
	}
	f64 js = strings__jaro_similarity(a, b);
	f64 p = 0.1;
	f64 ws = (f64)(js + (f64)((f64)(((f64)(l)) * p) * ((f64)(1 - js))));
	return ws;
}
string strings__repeat(u8 c, int n) {
	if (n <= 0) {
		return _S("");
	}
	u8* bytes = builtin__malloc_noscan((int)(n + 1));
	{ // Unsafe block
		memset(bytes, c, n);
		bytes[n] = 0;
	}
	return builtin__u8_vstring_with_len(bytes, n);
}
string strings__repeat_string(string s, int n) {
	if (n <= 0 || s.len == 0) {
		return _S("");
	}
	int slen = s.len;
	int blen = (int)(slen * n);
	u8* bytes = builtin__malloc_noscan((int)(blen + 1));
	for (int bi = 0; bi < n; ++bi) {
		int bislen = (int)(bi * slen);
		for (int si = 0; si < slen; ++si) {
			{ // Unsafe block
				bytes[(int)(bislen + si)] = s.str[ si];
			}
		}
	}
	{ // Unsafe block
		bytes[blen] = 0;
	}
	return builtin__u8_vstring_with_len(bytes, blen);
}
string strings__find_between_pair_u8(string input, u8 start, u8 end) {
	int marks = 0;
	int start_index = -1;
	for (int i = 0; i < input.len; ++i) {
		u8 b = input.str[i];
		if (b == start) {
			if (start_index == -1) {
				start_index = (int)(i + 1);
			}
			marks++;
			continue;
		}
		if (start_index > 0) {
			if (b == end) {
				marks--;
				if (marks == 0) {
					return builtin__string_substr(input, start_index, i);
				}
			}
		}
	}
	return _S("");
}
string strings__find_between_pair_rune(string input, rune start, rune end) {
	int marks = 0;
	int start_index = -1;
	Array_rune runes = builtin__string_runes(input);
	for (int i = 0; i < runes.len; ++i) {
		rune r = ((rune*)runes.data)[i];
		if (r == start) {
			if (start_index == -1) {
				start_index = (int)(i + 1);
			}
			marks++;
			continue;
		}
		if (start_index > 0) {
			if (r == end) {
				marks--;
				if (marks == 0) {
					return Array_rune_string(builtin__array_slice(runes, start_index, i));
				}
			}
		}
	}
	return _S("");
}
string strings__find_between_pair_string(string input, string start, string end) {
	int start_index = -1;
	int marks = 0;
	Array_rune start_runes = builtin__string_runes(start);
	Array_rune end_runes = builtin__string_runes(end);
	Array_rune runes = builtin__string_runes(input);
	int i = 0;
	for (; i < runes.len; i++) {
		Array_rune start_slice = builtin__array_slice_ni(runes, i, (int)(i + start_runes.len));
		if (Array_rune_arr_eq(start_slice, start_runes)) {
			i = (int)((int)(i + start_runes.len) - 1);
			if (start_index < 0) {
				start_index = (int)(i + 1);
			}
			marks++;
			continue;
		}
		if (start_index > 0) {
			Array_rune end_slice = builtin__array_slice_ni(runes, i, (int)(i + end_runes.len));
			if (Array_rune_arr_eq(end_slice, end_runes)) {
				marks--;
				if (marks == 0) {
					return Array_rune_string(builtin__array_slice(runes, start_index, i));
				}
				i = (int)((int)(i + end_runes.len) - 1);
				continue;
			}
		}
	}
	return _S("");
}
Array_string strings__split_capital(string s) {
	Array_string res = builtin____new_array_with_default(0, 0, sizeof(string), 0);
	int word_start = 0;
	for (int idx = 0; idx < s.len; ++idx) {
		u8 c = s.str[idx];
		if (builtin__u8_is_capital(c)) {
			if (word_start != idx) {
				builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_substr_ni(s, word_start, idx) }));
			}
			word_start = idx;
			continue;
		}
	}
	if (word_start != s.len) {
		builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_substr_ni(s, word_start, 2147483647) }));
	}
	return res;
}
VV_LOC void builtin__closure__closure_alloc(void) {
	u8* p = builtin__closure__closure_alloc_platform();
	if (builtin__isnil(p)) {
		return;
	}
	u8* x = p + g_closure.v_page_size;
	int remaining = (int)(g_closure.v_page_size / _const_builtin__closure__closure_size);
	g_closure.closure_ptr = x;
	g_closure.closure_cap = remaining;
	for (;;) {
		if (!(remaining > 0)) break;
		builtin__vmemcpy(x, &_const_builtin__closure__closure_thunk[0], 12);
		remaining--;
		{ // Unsafe block
			x += _const_builtin__closure__closure_size;
		}
	}
	builtin__closure__closure_memory_protect_platform(g_closure.closure_ptr, g_closure.v_page_size, builtin__closure__MemoryProtectAtrr__read_exec);
}
VV_LOC void builtin__closure__closure_init(void) {
	int page_size = builtin__closure__get_page_size_platform();
	g_closure.v_page_size = page_size;
	builtin__closure__closure_mtx_lock_init_platform();
	builtin__closure__closure_alloc();
	{ // Unsafe block
		builtin__closure__closure_memory_protect_platform(g_closure.closure_ptr, page_size, builtin__closure__MemoryProtectAtrr__read_write);
		builtin__vmemcpy(g_closure.closure_ptr, &_const_builtin__closure__closure_get_data_bytes[0], 8);
		builtin__closure__closure_memory_protect_platform(g_closure.closure_ptr, page_size, builtin__closure__MemoryProtectAtrr__read_exec);
	}
	g_closure.closure_get_data = (voidptr)g_closure.closure_ptr;
	{ // Unsafe block
		g_closure.closure_ptr = ((u8*)(g_closure.closure_ptr)) + _const_builtin__closure__closure_size;
	}
	g_closure.closure_cap--;
}
VV_LOC voidptr builtin__closure__closure_create(voidptr func, voidptr data) {
	builtin__closure__closure_mtx_lock_platform();
	if (g_closure.closure_cap == 0) {
		builtin__closure__closure_alloc();
	}
	g_closure.closure_cap--;
	voidptr curr_closure = g_closure.closure_ptr;
	{ // Unsafe block
		g_closure.closure_ptr = ((u8*)(g_closure.closure_ptr)) + _const_builtin__closure__closure_size;
		voidptr* p = ((voidptr*)(((u8*)(curr_closure)) - _const_builtin__closure__assumed_page_size));
		p[0] = data;
		p[1] = func;
	}
	builtin__closure__closure_mtx_unlock_platform();
	return curr_closure;
}
#if !defined(_VFREESTANDING) && !defined(__vinix__)
#endif
inline VV_LOC u8* builtin__closure__closure_alloc_platform(void) {
	u8* p = ((u8*)(((void*)0)));
	#if defined(_VFREESTANDING)
	{
	}
	#else
	{
		p = mmap(0, (int)(g_closure.v_page_size * 2), (PROT_READ | PROT_WRITE), (MAP_ANONYMOUS | MAP_PRIVATE), -1, 0);
		if (p == ((u8*)(MAP_FAILED))) {
			return ((void*)0);
		}
	}
	#endif
	return p;
}
inline VV_LOC void builtin__closure__closure_memory_protect_platform(voidptr ptr, isize size, builtin__closure__MemoryProtectAtrr attr) {
	#if defined(_VFREESTANDING)
	{
	}
	#else
	{

		if (attr == (builtin__closure__MemoryProtectAtrr__read_exec)) {
			mprotect(ptr, size, (PROT_READ | PROT_EXEC));
		}
		else if (attr == (builtin__closure__MemoryProtectAtrr__read_write)) {
			mprotect(ptr, size, (PROT_READ | PROT_WRITE));
		}
	}
	#endif
}
inline VV_LOC int builtin__closure__get_page_size_platform(void) {
	int page_size = 0x4000;
	#if !defined(_VFREESTANDING)
	{
		page_size = ((int)(sysconf(_SC_PAGESIZE)));
	}
	#endif
	page_size = (int)(page_size * ((int)(((int)(((int)(_const_builtin__closure__assumed_page_size - 1)) / page_size)) + 1)));
	return page_size;
}
inline VV_LOC void builtin__closure__closure_mtx_lock_init_platform(void) {
	#if !defined(_VFREESTANDING) || defined(__vinix__)
	{
		pthread_mutex_init(&g_closure.ClosureMutex.closure_mtx, 0);
	}
	#endif
}
inline VV_LOC void builtin__closure__closure_mtx_lock_platform(void) {
	#if !defined(_VFREESTANDING) || defined(__vinix__)
	{
		pthread_mutex_lock(&g_closure.ClosureMutex.closure_mtx);
	}
	#endif
}
inline VV_LOC void builtin__closure__closure_mtx_unlock_platform(void) {
	#if !defined(_VFREESTANDING) || defined(__vinix__)
	{
		pthread_mutex_unlock(&g_closure.ClosureMutex.closure_mtx);
	}
	#endif
}
inline multi_return_u64_u64 math__bits__mul_64(u64 x, u64 y) {
	u64 hi = ((u64)(0));
	u64 lo = ((u64)(0));
	#if defined(__V_arm64) && !defined(__TINYC__)
	{
		__asm__ (
			"mul %[lo], %[x], %[y]\n\t"
			"umulh %[hi], %[x], %[y]\n\t"
			: [hi] "=&r" (hi),
			[lo] "=&r" (lo)
			: [x] "r" (x),
			[y] "r" (y)
			: "cc"
		);
		return (multi_return_u64_u64){.arg0=hi, .arg1=lo};
	}
	#endif
	return math__bits__mul_64_default(x, y);
}
inline multi_return_u64_u64 math__bits__mul_add_64(u64 x, u64 y, u64 z) {
	u64 hi = ((u64)(0));
	u64 lo = ((u64)(0));
	#if defined(__V_arm64) && !defined(__TINYC__)
	{
		__asm__ (
			"mul %[lo], %[x], %[y]\n\t"
			"umulh %[hi], %[x], %[y]\n\t"
			"adds %[lo], %[lo], %[z]\n\t"
			"adc %[hi], %[hi], xzr\n\t"
			: [hi] "=&r" (hi),
			[lo] "=&r" (lo)
			: [x] "r" (x),
			[y] "r" (y),
			[z] "r" (z)
			: "cc"
		);
		return (multi_return_u64_u64){.arg0=hi, .arg1=lo};
	}
	#endif
	return math__bits__mul_add_64_default(x, y, z);
}
inline int math__bits__leading_zeros_8(u8 x) {
	if (x == 0) {
		return 8;
	}
	#if defined(_MSC_VER)
	{
	}
	#elif !defined(__TINYC__)
	{
		return (i32)(__builtin_clz(x) - 24);
	}
	#endif
	return math__bits__leading_zeros_8_default(x);
}
inline int math__bits__leading_zeros_16(u16 x) {
	if (x == 0) {
		return 16;
	}
	#if defined(_MSC_VER)
	{
	}
	#elif !defined(__TINYC__)
	{
		return (i32)(__builtin_clz(x) - 16);
	}
	#endif
	return math__bits__leading_zeros_16_default(x);
}
inline int math__bits__leading_zeros_32(u32 x) {
	if (x == 0) {
		return 32;
	}
	#if defined(_MSC_VER)
	{
	}
	#elif !defined(__TINYC__)
	{
		return __builtin_clz(x);
	}
	#endif
	return math__bits__leading_zeros_32_default(x);
}
inline int math__bits__leading_zeros_64(u64 x) {
	if (x == 0) {
		return 64;
	}
	#if defined(_MSC_VER)
	{
	}
	#elif !defined(__TINYC__)
	{
		return __builtin_clzll(x);
	}
	#endif
	return math__bits__leading_zeros_64_default(x);
}
inline int math__bits__trailing_zeros_8(u8 x) {
	if (x == 0) {
		return 8;
	}
	#if defined(_MSC_VER)
	{
	}
	#elif !defined(__TINYC__)
	{
		return __builtin_ctz(x);
	}
	#endif
	return math__bits__trailing_zeros_8_default(x);
}
inline int math__bits__trailing_zeros_16(u16 x) {
	if (x == 0) {
		return 16;
	}
	#if defined(_MSC_VER)
	{
	}
	#elif !defined(__TINYC__)
	{
		return __builtin_ctz(x);
	}
	#endif
	return math__bits__trailing_zeros_16_default(x);
}
inline int math__bits__trailing_zeros_32(u32 x) {
	if (x == 0) {
		return 32;
	}
	#if defined(_MSC_VER)
	{
	}
	#elif !defined(__TINYC__)
	{
		return __builtin_ctz(x);
	}
	#endif
	return math__bits__trailing_zeros_32_default(x);
}
inline int math__bits__trailing_zeros_64(u64 x) {
	if (x == 0) {
		return 64;
	}
	#if defined(_MSC_VER)
	{
	}
	#elif !defined(__TINYC__)
	{
		return __builtin_ctzll(x);
	}
	#endif
	return math__bits__trailing_zeros_64_default(x);
}
inline int math__bits__ones_count_8(u8 x) {
	#if defined(_MSC_VER)
	{
	}
	#elif !defined(__TINYC__)
	{
		return __builtin_popcount(x);
	}
	#endif
	return math__bits__ones_count_8_default(x);
}
inline int math__bits__ones_count_16(u16 x) {
	#if defined(_MSC_VER)
	{
	}
	#elif !defined(__TINYC__)
	{
		return __builtin_popcount(x);
	}
	#endif
	return math__bits__ones_count_16_default(x);
}
inline int math__bits__ones_count_32(u32 x) {
	#if defined(_MSC_VER)
	{
	}
	#elif !defined(__TINYC__)
	{
		return __builtin_popcount(x);
	}
	#endif
	return math__bits__ones_count_32_default(x);
}
inline int math__bits__ones_count_64(u64 x) {
	#if defined(_MSC_VER)
	{
	}
	#elif !defined(__TINYC__)
	{
		return __builtin_popcountll(x);
	}
	#endif
	return math__bits__ones_count_64_default(x);
}
inline int math__bits__pure_v_but_overridden_by_c_leading_zeros_8(u8 x) {
	return math__bits__leading_zeros_8_default(x);
}
inline VV_LOC int math__bits__leading_zeros_8_default(u8 x) {
	return (int)(8 - math__bits__len_8(x));
}
inline int math__bits__pure_v_but_overridden_by_c_leading_zeros_16(u16 x) {
	return math__bits__leading_zeros_16_default(x);
}
inline VV_LOC int math__bits__leading_zeros_16_default(u16 x) {
	return (int)(16 - math__bits__len_16(x));
}
inline int math__bits__pure_v_but_overridden_by_c_leading_zeros_32(u32 x) {
	return math__bits__leading_zeros_32_default(x);
}
inline VV_LOC int math__bits__leading_zeros_32_default(u32 x) {
	return (int)(32 - math__bits__len_32(x));
}
inline int math__bits__pure_v_but_overridden_by_c_leading_zeros_64(u64 x) {
	return math__bits__leading_zeros_64_default(x);
}
inline VV_LOC int math__bits__leading_zeros_64_default(u64 x) {
	return (int)(64 - math__bits__len_64(x));
}
inline int math__bits__pure_v_but_overridden_by_c_trailing_zeros_8(u8 x) {
	return math__bits__trailing_zeros_8_default(x);
}
inline VV_LOC int math__bits__trailing_zeros_8_default(u8 x) {
	return ((int)(_const_math__bits__ntz_8_tab[x]));
}
inline int math__bits__pure_v_but_overridden_by_c_trailing_zeros_16(u16 x) {
	return math__bits__trailing_zeros_16_default(x);
}
inline VV_LOC int math__bits__trailing_zeros_16_default(u16 x) {
	if (x == 0) {
		return 16;
	}
	return ((int)(_const_math__bits__de_bruijn32tab[((u32)(((u32)((x & -x))) * _const_math__bits__de_bruijn32) >> 27)]));
}
inline int math__bits__pure_v_but_overridden_by_c_trailing_zeros_32(u32 x) {
	return math__bits__trailing_zeros_32_default(x);
}
inline VV_LOC int math__bits__trailing_zeros_32_default(u32 x) {
	if (x == 0) {
		return 32;
	}
	return ((int)(_const_math__bits__de_bruijn32tab[((u32)(((x & -x)) * _const_math__bits__de_bruijn32) >> 27)]));
}
inline int math__bits__pure_v_but_overridden_by_c_trailing_zeros_64(u64 x) {
	return math__bits__trailing_zeros_64_default(x);
}
inline VV_LOC int math__bits__trailing_zeros_64_default(u64 x) {
	if (x == 0) {
		return 64;
	}
	return ((int)(_const_math__bits__de_bruijn64tab[((u64)(((x & -x)) * _const_math__bits__de_bruijn64) >> 58)]));
}
inline int math__bits__pure_v_but_overridden_by_c_ones_count_8(u8 x) {
	return math__bits__ones_count_8_default(x);
}
inline VV_LOC int math__bits__ones_count_8_default(u8 x) {
	return ((int)(_const_math__bits__pop_8_tab[x]));
}
inline int math__bits__pure_v_but_overridden_by_c_ones_count_16(u16 x) {
	return math__bits__ones_count_16_default(x);
}
inline VV_LOC int math__bits__ones_count_16_default(u16 x) {
	return ((int)((u8)(_const_math__bits__pop_8_tab[(x >> 8)] + _const_math__bits__pop_8_tab[(x & ((u16)(0xff)))])));
}
inline int math__bits__pure_v_but_overridden_by_c_ones_count_32(u32 x) {
	return math__bits__ones_count_32_default(x);
}
inline VV_LOC int math__bits__ones_count_32_default(u32 x) {
	return ((int)((u8)((u8)((u8)(_const_math__bits__pop_8_tab[(x >> 24)] + _const_math__bits__pop_8_tab[(((x >> 16)) & 0xff)]) + _const_math__bits__pop_8_tab[(((x >> 8)) & 0xff)]) + _const_math__bits__pop_8_tab[(x & ((u32)(0xff)))])));
}
inline int math__bits__pure_v_but_overridden_by_c_ones_count_64(u64 x) {
	return math__bits__ones_count_64_default(x);
}
VV_LOC int math__bits__ones_count_64_default(u64 x) {
	u64 y = (u64)(((((x >> ((u64)(1)))) & ((_const_math__bits__m0 & _const_max_u64)))) + ((x & ((_const_math__bits__m0 & _const_max_u64)))));
	y = (u64)(((((y >> ((u64)(2)))) & ((_const_math__bits__m1 & _const_max_u64)))) + ((y & ((_const_math__bits__m1 & _const_max_u64)))));
	y = (((u64)(((y >> 4)) + y)) & ((_const_math__bits__m2 & _const_max_u64)));
	y += (y >> 8);
	y += (y >> 16);
	y += (y >> 32);
	return (((int)(y)) & 127);
}
inline u8 math__bits__rotate_left_8(u8 x, int k) {
	u8 s = (((u8)(k)) & ((u8)(_const_math__bits__n8 - ((u8)(1)))));
	return (((x << s)) | ((x >> ((u8)(_const_math__bits__n8 - s)))));
}
inline u16 math__bits__rotate_left_16(u16 x, int k) {
	u16 s = (((u16)(k)) & ((u16)(_const_math__bits__n16 - ((u16)(1)))));
	return (((x << s)) | ((x >> ((u16)(_const_math__bits__n16 - s)))));
}
inline u32 math__bits__rotate_left_32(u32 x, int k) {
	u32 s = (((u32)(k)) & ((u32)(_const_math__bits__n32 - ((u32)(1)))));
	return (((x << s)) | ((x >> ((u32)(_const_math__bits__n32 - s)))));
}
inline u64 math__bits__rotate_left_64(u64 x, int k) {
	u64 s = (((u64)(k)) & ((u64)(_const_math__bits__n64 - ((u64)(1)))));
	return (((x << s)) | ((x >> ((u64)(_const_math__bits__n64 - s)))));
}
inline u8 math__bits__reverse_8(u8 x) {
	return _const_math__bits__rev_8_tab[x];
}
inline u16 math__bits__reverse_16(u16 x) {
	return (((u16)(_const_math__bits__rev_8_tab[(x >> 8)])) | ((((u16)(_const_math__bits__rev_8_tab[(x & ((u16)(0xff)))])) << 8)));
}
inline u32 math__bits__reverse_32(u32 x) {
	u64 y = ((((((x >> ((u32)(1)))) & ((_const_math__bits__m0 & _const_max_u32)))) | ((((x & ((_const_math__bits__m0 & _const_max_u32)))) << 1))));
	y = ((((((y >> ((u32)(2)))) & ((_const_math__bits__m1 & _const_max_u32)))) | ((((y & ((_const_math__bits__m1 & _const_max_u32)))) << ((u32)(2))))));
	y = ((((((y >> ((u32)(4)))) & ((_const_math__bits__m2 & _const_max_u32)))) | ((((y & ((_const_math__bits__m2 & _const_max_u32)))) << ((u32)(4))))));
	return math__bits__reverse_bytes_32(((u32)(y)));
}
inline u64 math__bits__reverse_64(u64 x) {
	u64 y = ((((((x >> ((u64)(1)))) & ((_const_math__bits__m0 & _const_max_u64)))) | ((((x & ((_const_math__bits__m0 & _const_max_u64)))) << 1))));
	y = ((((((y >> ((u64)(2)))) & ((_const_math__bits__m1 & _const_max_u64)))) | ((((y & ((_const_math__bits__m1 & _const_max_u64)))) << 2))));
	y = ((((((y >> ((u64)(4)))) & ((_const_math__bits__m2 & _const_max_u64)))) | ((((y & ((_const_math__bits__m2 & _const_max_u64)))) << 4))));
	return math__bits__reverse_bytes_64(y);
}
inline u16 math__bits__reverse_bytes_16(u16 x) {
	return (((x >> 8)) | ((x << 8)));
}
inline u32 math__bits__reverse_bytes_32(u32 x) {
	u64 y = ((((((x >> ((u32)(8)))) & ((_const_math__bits__m3 & _const_max_u32)))) | ((((x & ((_const_math__bits__m3 & _const_max_u32)))) << ((u32)(8))))));
	return ((u32)((((y >> 16)) | ((y << 16)))));
}
inline u64 math__bits__reverse_bytes_64(u64 x) {
	u64 y = ((((((x >> ((u64)(8)))) & ((_const_math__bits__m3 & _const_max_u64)))) | ((((x & ((_const_math__bits__m3 & _const_max_u64)))) << ((u64)(8))))));
	y = ((((((y >> ((u64)(16)))) & ((_const_math__bits__m4 & _const_max_u64)))) | ((((y & ((_const_math__bits__m4 & _const_max_u64)))) << ((u64)(16))))));
	return (((y >> 32)) | ((y << 32)));
}
int math__bits__len_8(u8 x) {
	return ((int)(_const_math__bits__len_8_tab[x]));
}
int math__bits__len_16(u16 x) {
	u16 y = x;
	int n = 0;
	if (y >= 256) {
		y >>= 8;
		n = 8;
	}
	return (int)(n + ((int)(_const_math__bits__len_8_tab[y])));
}
int math__bits__len_32(u32 x) {
	u32 y = x;
	int n = 0;
	if (y >= 65536) {
		y >>= 16;
		n = 16;
	}
	if (y >= 256) {
		y >>= 8;
		n += 8;
	}
	return (int)(n + ((int)(_const_math__bits__len_8_tab[y])));
}
int math__bits__len_64(u64 x) {
	u64 y = x;
	int n = 0;
	if (y >= (((u64)(1)) << ((u64)(32)))) {
		y >>= 32;
		n = 32;
	}
	if (y >= (((u64)(1)) << ((u64)(16)))) {
		y >>= 16;
		n += 16;
	}
	if (y >= (((u64)(1)) << ((u64)(8)))) {
		y >>= 8;
		n += 8;
	}
	return (int)(n + ((int)(_const_math__bits__len_8_tab[y])));
}
multi_return_u32_u32 math__bits__add_32(u32 x, u32 y, u32 carry) {
	u64 sum64 = (u64)((u64)(((u64)(x)) + ((u64)(y))) + ((u64)(carry)));
	u32 sum = ((u32)(sum64));
	u32 carry_out = ((u32)((sum64 >> 32)));
	return (multi_return_u32_u32){.arg0=sum, .arg1=carry_out};
}
multi_return_u64_u64 math__bits__add_64(u64 x, u64 y, u64 carry) {
	u64 sum = (u64)((u64)(x + y) + carry);
	u64 carry_out = (((((x & y)) | ((((x | y)) & ~sum)))) >> 63);
	return (multi_return_u64_u64){.arg0=sum, .arg1=carry_out};
}
multi_return_u32_u32 math__bits__sub_32(u32 x, u32 y, u32 borrow) {
	u32 diff = (u32)((u32)(x - y) - borrow);
	u32 borrow_out = (((((~x & y)) | ((~((x ^ y)) & diff)))) >> 31);
	return (multi_return_u32_u32){.arg0=diff, .arg1=borrow_out};
}
multi_return_u64_u64 math__bits__sub_64(u64 x, u64 y, u64 borrow) {
	u64 diff = (u64)((u64)(x - y) - borrow);
	u64 borrow_out = (((((~x & y)) | ((~((x ^ y)) & diff)))) >> 63);
	return (multi_return_u64_u64){.arg0=diff, .arg1=borrow_out};
}
inline multi_return_u32_u32 math__bits__mul_32(u32 x, u32 y) {
	return math__bits__mul_32_default(x, y);
}
inline VV_LOC multi_return_u32_u32 math__bits__mul_32_default(u32 x, u32 y) {
	u64 tmp = (u64)(((u64)(x)) * ((u64)(y)));
	u32 hi = ((u32)((tmp >> 32)));
	u32 lo = ((u32)(tmp));
	return (multi_return_u32_u32){.arg0=hi, .arg1=lo};
}
inline multi_return_u64_u64 math__bits__pure_v_but_overridden_by_arm64_mul_64(u64 x, u64 y) {
	return math__bits__mul_64_default(x, y);
}
VV_LOC multi_return_u64_u64 math__bits__mul_64_default(u64 x, u64 y) {
	u64 x0 = (x & _const_math__bits__mask32);
	u64 x1 = (x >> 32);
	u64 y0 = (y & _const_math__bits__mask32);
	u64 y1 = (y >> 32);
	u64 w0 = (u64)(x0 * y0);
	u64 t = (u64)((u64)(x1 * y0) + ((w0 >> 32)));
	u64 w1 = (t & _const_math__bits__mask32);
	u64 w2 = (t >> 32);
	w1 += (u64)(x0 * y1);
	u64 hi = (u64)((u64)((u64)(x1 * y1) + w2) + ((w1 >> 32)));
	u64 lo = (u64)(x * y);
	return (multi_return_u64_u64){.arg0=hi, .arg1=lo};
}
inline multi_return_u32_u32 math__bits__mul_add_32(u32 x, u32 y, u32 z) {
	return math__bits__mul_add_32_default(x, y, z);
}
inline VV_LOC multi_return_u32_u32 math__bits__mul_add_32_default(u32 x, u32 y, u32 z) {
	u64 tmp = (u64)((u64)(((u64)(x)) * ((u64)(y))) + ((u64)(z)));
	u32 hi = ((u32)((tmp >> 32)));
	u32 lo = ((u32)(tmp));
	return (multi_return_u32_u32){.arg0=hi, .arg1=lo};
}
inline multi_return_u64_u64 math__bits__pure_v_but_overridden_by_arm64_mul_add_64(u64 x, u64 y, u64 z) {
	return math__bits__mul_add_64_default(x, y, z);
}
inline VV_LOC multi_return_u64_u64 math__bits__mul_add_64_default(u64 x, u64 y, u64 z) {
	multi_return_u64_u64 mr_15516 = math__bits__mul_64(x, y);
	u64 h = mr_15516.arg0;
	u64 l = mr_15516.arg1;
	u64 lo = (u64)(l + z);
	u64 hi = (u64)(h + (u64[]){(lo < l)?1:0}[0]);
	return (multi_return_u64_u64){.arg0=hi, .arg1=lo};
}
inline multi_return_u32_u32 math__bits__div_32(u32 hi, u32 lo, u32 y) {
	return math__bits__div_32_default(hi, lo, y);
}
VV_LOC multi_return_u32_u32 math__bits__div_32_default(u32 hi, u32 lo, u32 y) {
	if (y != 0 && y <= hi) {
		builtin___v_panic(_const_math__bits__overflow_error);
		VUNREACHABLE();
	}
	u64 z = (((((u64)(hi)) << 32)) | ((u64)(lo)));
	u32 quo = ((u32)((u64)(z / ((u64)(y)))));
	u32 rem = ((u32)((u64)(z % ((u64)(y)))));
	return (multi_return_u32_u32){.arg0=quo, .arg1=rem};
}
inline multi_return_u64_u64 math__bits__div_64(u64 hi, u64 lo, u64 y1) {
	return math__bits__div_64_default(hi, lo, y1);
}
VV_LOC multi_return_u64_u64 math__bits__div_64_default(u64 hi, u64 lo, u64 y1) {
	u64 y = y1;
	if (y == 0) {
		builtin___v_panic(_const_math__bits__overflow_error);
		VUNREACHABLE();
	}
	if (y <= hi) {
		builtin___v_panic(_const_math__bits__overflow_error);
		VUNREACHABLE();
	}
	u32 s = ((u32)(math__bits__leading_zeros_64(y)));
	y <<= s;
	u64 yn1 = (y >> 32);
	u64 yn0 = (y & _const_math__bits__mask32);
	u64 ss1 = ((hi << s));
	u32 xxx = (u32)(64 - s);
	u64 ss2 = (lo >> xxx);
	if (xxx == 64) {
		ss2 = 0;
	}
	u64 un32 = (ss1 | ss2);
	u64 un10 = (lo << s);
	u64 un1 = (un10 >> 32);
	u64 un0 = (un10 & _const_math__bits__mask32);
	u64 q1 = (u64)(un32 / yn1);
	u64 rhat = (u64)(un32 - ((u64)(q1 * yn1)));
	for (;;) {
		if (!(q1 >= _const_math__bits__two32 || ((u64)(q1 * yn0)) > ((u64)(((u64)(_const_math__bits__two32 * rhat)) + un1)))) break;
		q1--;
		rhat += yn1;
		if (rhat >= _const_math__bits__two32) {
			break;
		}
	}
	u64 un21 = (u64)(((u64)(un32 * _const_math__bits__two32)) + ((u64)(un1 - ((u64)(q1 * y)))));
	u64 q0 = (u64)(un21 / yn1);
	rhat = (u64)(un21 - (u64)(q0 * yn1));
	for (;;) {
		if (!(q0 >= _const_math__bits__two32 || ((u64)(q0 * yn0)) > ((u64)(((u64)(_const_math__bits__two32 * rhat)) + un0)))) break;
		q0--;
		rhat += yn1;
		if (rhat >= _const_math__bits__two32) {
			break;
		}
	}
	u64 qq = ((u64)(((u64)(q1 * _const_math__bits__two32)) + q0));
	u64 rr = (((u64)((u64)(((u64)(un21 * _const_math__bits__two32)) + un0) - ((u64)(q0 * y)))) >> s);
	return (multi_return_u64_u64){.arg0=qq, .arg1=rr};
}
u32 math__bits__rem_32(u32 hi, u32 lo, u32 y) {
	return ((u32)((u64)(((((((u64)(hi)) << 32)) | ((u64)(lo)))) % ((u64)(y)))));
}
u64 math__bits__rem_64(u64 hi, u64 lo, u64 y) {
	multi_return_u64_u64 mr_19031 = math__bits__div_64((u64)(hi % y), lo, y);
	u64 rem = mr_19031.arg1;
	return rem;
}
multi_return_f64_int math__bits__normalize(f64 x) {
	f64 smallest_normal = 2.2250738585072014e-308;
	if (((x > ((f64)(0.0)) ? (x) : (-x))) < smallest_normal) {
		return (multi_return_f64_int){.arg0=(f64)(x * ((((u64)(1)) << ((u64)(52))))), .arg1=-52};
	}
	return (multi_return_f64_int){.arg0=x, .arg1=0};
}
inline u32 math__bits__f32_bits(f32 f) {
	u32 p = *((u32*)(&f));
	return p;
}
inline f32 math__bits__f32_from_bits(u32 b) {
	f32 p = *((f32*)(&b));
	return p;
}
inline u64 math__bits__f64_bits(f64 f) {
	u64 p = *((u64*)(&f));
	return p;
}
inline f64 math__bits__f64_from_bits(u64 b) {
	f64 p = *((f64*)(&b));
	return p;
}
VV_LOC multi_return_u32_u32_u32 strconv__lsr96(u32 s2, u32 s1, u32 s0) {
	u32 r0 = ((u32)(0));
	u32 r1 = ((u32)(0));
	u32 r2 = ((u32)(0));
	r0 = (((s0 >> 1)) | ((((s1 & ((u32)(1)))) << 31)));
	r1 = (((s1 >> 1)) | ((((s2 & ((u32)(1)))) << 31)));
	r2 = (s2 >> 1);
	return (multi_return_u32_u32_u32){.arg0=r2, .arg1=r1, .arg2=r0};
}
VV_LOC multi_return_u32_u32_u32 strconv__lsl96(u32 s2, u32 s1, u32 s0) {
	u32 r0 = ((u32)(0));
	u32 r1 = ((u32)(0));
	u32 r2 = ((u32)(0));
	r2 = (((s2 << 1)) | ((((s1 & ((((u32)(1)) << 31)))) >> 31)));
	r1 = (((s1 << 1)) | ((((s0 & ((((u32)(1)) << 31)))) >> 31)));
	r0 = (s0 << 1);
	return (multi_return_u32_u32_u32){.arg0=r2, .arg1=r1, .arg2=r0};
}
VV_LOC multi_return_u32_u32_u32 strconv__add96(u32 s2, u32 s1, u32 s0, u32 d2, u32 d1, u32 d0) {
	u64 w = ((u64)(0));
	u32 r0 = ((u32)(0));
	u32 r1 = ((u32)(0));
	u32 r2 = ((u32)(0));
	w = (u64)(((u64)(s0)) + ((u64)(d0)));
	r0 = ((u32)(w));
	w >>= 32;
	w += (u64)(((u64)(s1)) + ((u64)(d1)));
	r1 = ((u32)(w));
	w >>= 32;
	w += (u64)(((u64)(s2)) + ((u64)(d2)));
	r2 = ((u32)(w));
	return (multi_return_u32_u32_u32){.arg0=r2, .arg1=r1, .arg2=r0};
}
VV_LOC multi_return_strconv__ParserState_strconv__PrepNumber strconv__parser(string s) {
	int digx = 0;
	strconv__ParserState result = strconv__ParserState__ok;
	bool expneg = false;
	int expexp = 0;
	int i = 0;
	strconv__PrepNumber pn = ((strconv__PrepNumber){.negative = 0,.exponent = 0,.mantissa = 0,});
	for (;;) {
		if (!(i < s.len && builtin__u8_is_space(s.str[ i]))) break;
		i++;
	}
	if (s.str[ i] == '-') {
		pn.negative = true;
		i++;
	}
	if (s.str[ i] == '+') {
		i++;
	}
	for (;;) {
		if (!(i < s.len && builtin__u8_is_digit(s.str[ i]))) break;
		if (digx < 18) {
			pn.mantissa *= 10;
			pn.mantissa += ((u64)((rune)(s.str[ i] - _const_strconv__c_zero)));
			digx++;
		} else if (pn.exponent < 2147483647) {
			pn.exponent++;
		}
		i++;
	}
	if (i < s.len && s.str[ i] == '.') {
		i++;
		for (;;) {
			if (!(i < s.len && builtin__u8_is_digit(s.str[ i]))) break;
			if (digx < 18) {
				pn.mantissa *= 10;
				pn.mantissa += ((u64)((rune)(s.str[ i] - _const_strconv__c_zero)));
				pn.exponent--;
				digx++;
			}
			i++;
		}
	}
	if (i < s.len && (s.str[ i] == 'e' || s.str[ i] == 'E')) {
		i++;
		if (i < s.len) {
			if (s.str[ i] == _const_strconv__c_plus) {
				i++;
			} else if (s.str[ i] == _const_strconv__c_minus) {
				expneg = true;
				i++;
			}
			for (;;) {
				if (!(i < s.len && builtin__u8_is_digit(s.str[ i]))) break;
				if (expexp < 214748364) {
					expexp *= 10;
					expexp += ((int)((rune)(s.str[ i] - _const_strconv__c_zero)));
				}
				i++;
			}
		}
	}
	if (expneg) {
		expexp = -expexp;
	}
	pn.exponent += expexp;
	if (pn.mantissa == 0) {
		if (pn.negative) {
			result = strconv__ParserState__mzero;
		} else {
			result = strconv__ParserState__pzero;
		}
	} else if (pn.exponent > 309) {
		if (pn.negative) {
			result = strconv__ParserState__minf;
		} else {
			result = strconv__ParserState__pinf;
		}
	} else if (pn.exponent < -328) {
		if (pn.negative) {
			result = strconv__ParserState__mzero;
		} else {
			result = strconv__ParserState__pzero;
		}
	}
	if (i == 0 && s.len > 0) {
		return (multi_return_strconv__ParserState_strconv__PrepNumber){.arg0=strconv__ParserState__invalid_number, .arg1=pn};
	}
	if (i != s.len) {
		return (multi_return_strconv__ParserState_strconv__PrepNumber){.arg0=strconv__ParserState__extra_char, .arg1=pn};
	}
	return (multi_return_strconv__ParserState_strconv__PrepNumber){.arg0=result, .arg1=pn};
}
VV_LOC u64 strconv__converter(strconv__PrepNumber* pn) {
	int binexp = 92;
	u32 s2 = ((u32)(0));
	u32 s1 = ((u32)(0));
	u32 s0 = ((u32)(0));
	u32 q2 = ((u32)(0));
	u32 q1 = ((u32)(0));
	u32 q0 = ((u32)(0));
	u32 r2 = ((u32)(0));
	u32 r1 = ((u32)(0));
	u32 r0 = ((u32)(0));
	u32 mask28 = ((u32)((((u64)(0xF)) << 28)));
	u64 result = ((u64)(0));
	s0 = ((u32)((pn->mantissa & ((u64)(0x00000000FFFFFFFFU)))));
	s1 = ((u32)((pn->mantissa >> 32)));
	s2 = ((u32)(0));
	if (pn->mantissa == 0 && pn->exponent <= 0) {
		return (pn->negative ? (_const_strconv__double_minus_zero) : (_const_strconv__double_plus_zero));
	}
	for (;;) {
		if (!(pn->exponent > 0)) break;
		multi_return_u32_u32_u32 mr_5729 = strconv__lsl96(s2, s1, s0);
		q2 = mr_5729.arg0;
		q1 = mr_5729.arg1;
		q0 = mr_5729.arg2;
		multi_return_u32_u32_u32 mr_5775 = strconv__lsl96(q2, q1, q0);
		r2 = mr_5775.arg0;
		r1 = mr_5775.arg1;
		r0 = mr_5775.arg2;
		multi_return_u32_u32_u32 mr_5831 = strconv__lsl96(r2, r1, r0);
		s2 = mr_5831.arg0;
		s1 = mr_5831.arg1;
		s0 = mr_5831.arg2;
		multi_return_u32_u32_u32 mr_5887 = strconv__add96(s2, s1, s0, q2, q1, q0);
		s2 = mr_5887.arg0;
		s1 = mr_5887.arg1;
		s0 = mr_5887.arg2;
		pn->exponent--;
		for (;;) {
			if (!(((s2 & mask28)) != 0)) break;
			multi_return_u32_u32_u32 mr_6010 = strconv__lsr96(s2, s1, s0);
			q2 = mr_6010.arg0;
			q1 = mr_6010.arg1;
			q0 = mr_6010.arg2;
			binexp++;
			s2 = q2;
			s1 = q1;
			s0 = q0;
		}
	}
	for (;;) {
		if (!(pn->exponent < 0)) break;
		for (;;) {
			if (!(!(((s2 & ((((u32)(1)) << 31)))) != 0))) break;
			multi_return_u32_u32_u32 mr_6157 = strconv__lsl96(s2, s1, s0);
			q2 = mr_6157.arg0;
			q1 = mr_6157.arg1;
			q0 = mr_6157.arg2;
			binexp--;
			s2 = q2;
			s1 = q1;
			s0 = q0;
		}
		q2 = (u32)(s2 / _const_strconv__c_ten);
		r1 = (u32)(s2 % _const_strconv__c_ten);
		r2 = (((s1 >> 8)) | ((r1 << 24)));
		q1 = (u32)(r2 / _const_strconv__c_ten);
		r1 = (u32)(r2 % _const_strconv__c_ten);
		r2 = ((((((s1 & ((u32)(0xFF)))) << 16)) | ((s0 >> 16))) | ((r1 << 24)));
		r0 = (u32)(r2 / _const_strconv__c_ten);
		r1 = (u32)(r2 % _const_strconv__c_ten);
		q1 = (((q1 << 8)) | ((((r0 & ((u32)(0x00FF0000)))) >> 16)));
		q0 = (r0 << 16);
		r2 = (((s0 & ((u32)(0xFFFF)))) | ((r1 << 16)));
		q0 |= (u32)(r2 / _const_strconv__c_ten);
		s2 = q2;
		s1 = q1;
		s0 = q0;
		pn->exponent++;
	}
	if (s2 != 0 || s1 != 0 || s0 != 0) {
		for (;;) {
			if (!(((s2 & mask28)) == 0)) break;
			multi_return_u32_u32_u32 mr_6837 = strconv__lsl96(s2, s1, s0);
			q2 = mr_6837.arg0;
			q1 = mr_6837.arg1;
			q0 = mr_6837.arg2;
			binexp--;
			s2 = q2;
			s1 = q1;
			s0 = q0;
		}
	}
	if (binexp < -1022 && ((s2 | s1)) != 0) {
		int shift = (int)(-1022 - binexp);
		if (shift > 60) {
			return (pn->negative ? (_const_strconv__double_minus_zero) : (_const_strconv__double_plus_zero));
		}
		u64 shifted = (((((((u64)(s2)) << 32)) | ((u64)(s1)))) >> ((u32)(shift)));
		u64 q = (u64)(((shifted >> 8)) + (u64[]){((((shifted >> 7)) & 1) != 0 && (((shifted & 0x7F)) != 0 || (((shifted >> 8)) & 1) != 0))?1:0}[0]);
		return (((q & 0x000FFFFFFFFFFFFFLL)) | (((u64[]){(pn->negative)?1:0}[0] << 63)));
	}
	int nbit = 7;
	u32 check_round_bit = (((u32)(1)) << ((u32)(nbit)));
	u32 check_round_mask = (((u32)(0xFFFFFFFFU)) << ((u32)(nbit)));
	if (((s1 & check_round_bit)) != 0) {
		if (((s1 & ~check_round_mask)) != 0) {
			multi_return_u32_u32_u32 mr_9030 = strconv__add96(s2, s1, s0, 0, check_round_bit, 0);
			s2 = mr_9030.arg0;
			s1 = mr_9030.arg1;
			s0 = mr_9030.arg2;
		} else {
			if (((s1 & ((check_round_bit << ((u32)(1)))))) != 0) {
				multi_return_u32_u32_u32 mr_9224 = strconv__add96(s2, s1, s0, 0, check_round_bit, 0);
				s2 = mr_9224.arg0;
				s1 = mr_9224.arg1;
				s0 = mr_9224.arg2;
			}
		}
		s1 = (s1 & check_round_mask);
		s0 = ((u32)(0));
		if ((s2 & ((mask28 << ((u32)(1))))) != 0) {
			multi_return_u32_u32_u32 mr_9431 = strconv__lsr96(s2, s1, s0);
			q2 = mr_9431.arg0;
			q1 = mr_9431.arg1;
			q0 = mr_9431.arg2;
			binexp++;
			s2 = q2;
			s1 = q1;
			s0 = q0;
		}
	}
	binexp += 1023;
	if (binexp > 2046) {
		if (pn->negative) {
			result = _const_strconv__double_minus_infinity;
		} else {
			result = _const_strconv__double_plus_infinity;
		}
	} else if (binexp < 1) {
		if (pn->negative) {
			result = _const_strconv__double_minus_zero;
		} else {
			result = _const_strconv__double_plus_zero;
		}
	} else if (s2 != 0) {
		u64 q = ((u64)(0));
		u64 binexs2 = (((u64)(binexp)) << 52);
		q = ((((((u64)((s2 & ~mask28))) << 24)) | ((((u64)(((u64)(s1)) + ((u64)(128)))) >> 8))) | binexs2);
		if (pn->negative) {
			q |= ((((u64)(1)) << 63));
		}
		result = q;
	}
	return result;
}
_result_f64 strconv__atof64(string s, strconv__AtoF64Param param) {
	if (s.len == 0) {
		return (_result_f64){ .is_error=true, .err=builtin___v_error(_S("expected a number found an empty string")), .data={E_STRUCT} };
	}
	strconv__Float64u res = ((strconv__Float64u){0});
	multi_return_strconv__ParserState_strconv__PrepNumber mr_10716 = strconv__parser(s);
	strconv__ParserState res_parsing = mr_10716.arg0;
	strconv__PrepNumber pn = mr_10716.arg1;
	switch (res_parsing) {
		case strconv__ParserState__ok: {
			res.u = strconv__converter((voidptr)&pn);
			break;
		}
		case strconv__ParserState__pzero: {
			res.u = _const_strconv__double_plus_zero;
			break;
		}
		case strconv__ParserState__mzero: {
			res.u = _const_strconv__double_minus_zero;
			break;
		}
		case strconv__ParserState__pinf: {
			res.u = _const_strconv__double_plus_infinity;
			break;
		}
		case strconv__ParserState__minf: {
			res.u = _const_strconv__double_minus_infinity;
			break;
		}
		case strconv__ParserState__extra_char: {
			if (param.allow_extra_chars) {
				res.u = strconv__converter((voidptr)&pn);
			} else {
				return (_result_f64){ .is_error=true, .err=builtin___v_error(_S("extra char after number")), .data={E_STRUCT} };
			}
			break;
		}
		case strconv__ParserState__invalid_number: {
			return (_result_f64){ .is_error=true, .err=builtin___v_error(_S("not a number")), .data={E_STRUCT} };
		}
	}
	
	_result_f64 _t4;
	builtin___result_ok(&(f64[]) { res.f }, (_result*)(&_t4), sizeof(f64));
	 
	return _t4;
}
f64 strconv__atof_quick(string s) {
	strconv__Float64u f = ((strconv__Float64u){0});
	f64 sign = ((f64)(1.0));
	int i = 0;
	for (;;) {
		if (!(i < s.len && s.str[ i] == ' ')) break;
		i++;
	}
	if (i < s.len) {
		if (s.str[ i] == '-') {
			sign = -1.0;
			i++;
		} else if (s.str[ i] == '+') {
			i++;
		}
	}
	if (s.str[ i] == 'i' && (int)(i + 2) < s.len && s.str[ (int)(i + 1)] == 'n' && s.str[ (int)(i + 2)] == 'f') {
		if (sign > ((f64)(0.0))) {
			f.u = _const_strconv__double_plus_infinity;
		} else {
			f.u = _const_strconv__double_minus_infinity;
		}
		return f.f;
	}
	for (;;) {
		if (!(i < s.len && s.str[ i] == '0')) break;
		i++;
		if (i >= s.len) {
			if (sign > ((f64)(0.0))) {
				f.u = _const_strconv__double_plus_zero;
			} else {
				f.u = _const_strconv__double_minus_zero;
			}
			return f.f;
		}
	}
	for (;;) {
		if (!(i < s.len && (s.str[ i] >= '0' && s.str[ i] <= '9'))) break;
		f.f *= ((f64)(10.0));
		f.f += ((f64)((rune)(s.str[ i] - '0')));
		i++;
	}
	if (i < s.len && s.str[ i] == '.') {
		i++;
		f64 frac_mul = ((f64)(0.1));
		for (;;) {
			if (!(i < s.len && (s.str[ i] >= '0' && s.str[ i] <= '9'))) break;
			f.f += (f64)(((f64)((rune)(s.str[ i] - '0'))) * frac_mul);
			frac_mul *= ((f64)(0.1));
			i++;
		}
	}
	if (i < s.len && (s.str[ i] == 'e' || s.str[ i] == 'E')) {
		i++;
		int exp = 0;
		int exp_sign = 1;
		if (i < s.len) {
			if (s.str[ i] == '-') {
				exp_sign = -1;
				i++;
			} else if (s.str[ i] == '+') {
				i++;
			}
		}
		for (;;) {
			if (!(i < s.len && s.str[ i] == '0')) break;
			i++;
		}
		for (;;) {
			if (!(i < s.len && (s.str[ i] >= '0' && s.str[ i] <= '9'))) break;
			exp *= 10;
			exp += ((int)((rune)(s.str[ i] - '0')));
			i++;
		}
		if (exp_sign == 1) {
			if (exp > 309) {
				if (sign > 0) {
					f.u = _const_strconv__double_plus_infinity;
				} else {
					f.u = _const_strconv__double_minus_infinity;
				}
				return f.f;
			}
			strconv__Float64u tmp_mul = ((strconv__Float64u){.u = _const_strconv__pos_exp[exp],});
			f.f = (f64)(f.f * tmp_mul.f);
		} else {
			if (exp > 324) {
				if (sign > 0) {
					f.u = _const_strconv__double_plus_zero;
				} else {
					f.u = _const_strconv__double_minus_zero;
				}
				return f.f;
			}
			strconv__Float64u tmp_mul = ((strconv__Float64u){.u = _const_strconv__neg_exp[exp],});
			f.f = (f64)(f.f * tmp_mul.f);
		}
	}
	{ // Unsafe block
		f.f = (f64)(f.f * sign);
		return f.f;
	}
	return 0;
}
inline u8 strconv__byte_to_lower(u8 c) {
	return (c | 32);
}
_result_u64 strconv__common_parse_uint(string s, int _base, int _bit_size, bool error_on_non_digit, bool error_on_high_digit) {
	multi_return_u64_int mr_730 = strconv__common_parse_uint2(s, _base, _bit_size);
	u64 result = mr_730.arg0;
	int err = mr_730.arg1;
	if (err != 0 && (error_on_non_digit || error_on_high_digit)) {
		switch (err) {
			case -1: {
				return (_result_u64){ .is_error=true, .err=builtin___v_error(builtin__str_intp(3, _MOV((StrIntpData[]){{_S("common_parse_uint: wrong base "), 0xfe07, {.d_i32 = _base}}, {_S(" for "), 0xfe10, {.d_s = s}}, {_SLIT0, 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
			}
			case -2: {
				return (_result_u64){ .is_error=true, .err=builtin___v_error(builtin__str_intp(3, _MOV((StrIntpData[]){{_S("common_parse_uint: wrong bit size "), 0xfe07, {.d_i32 = _bit_size}}, {_S(" for "), 0xfe10, {.d_s = s}}, {_SLIT0, 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
			}
			case -3: {
				return (_result_u64){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("common_parse_uint: integer overflow "), 0xfe10, {.d_s = s}}, {_SLIT0, 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
			}
			default: {
				{
					return (_result_u64){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("common_parse_uint: syntax error "), 0xfe10, {.d_s = s}}, {_SLIT0, 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
				}
			}
		}
		
	}
	_result_u64 _t5;
	builtin___result_ok(&(u64[]) { result }, (_result*)(&_t5), sizeof(u64));
	 
	return _t5;
}
multi_return_u64_int strconv__common_parse_uint2(string s, int _base, int _bit_size) {
	if ((s).len == 0) {
		return (multi_return_u64_int){.arg0=((u64)(0)), .arg1=1};
	}
	int bit_size = _bit_size;
	int base = _base;
	int start_index = 0;
	if (base == 0) {
		base = 10;
		if (s.str[ 0] == '0') {
			u8 ch = (s.len > 1 ? ((s.str[ 1] | 32)) : ('0'));
			if (s.len >= 3) {
				if (ch == 'b') {
					base = 2;
					start_index += 2;
				} else if (ch == 'o') {
					base = 8;
					start_index += 2;
				} else if (ch == 'x') {
					base = 16;
					start_index += 2;
				}
				if (s.str[ start_index] == '_') {
					start_index++;
				}
			} else if (s.len >= 2 && (s.str[ 1] >= '0' && s.str[ 1] <= '9')) {
				base = 10;
				start_index++;
			} else {
				base = 8;
				start_index++;
			}
		}
	}
	if (bit_size == 0) {
		bit_size = _const_strconv__int_size;
	} else if (bit_size < 0 || bit_size > 64) {
		return (multi_return_u64_int){.arg0=((u64)(0)), .arg1=-2};
	}
	u64 cutoff = (u64)((u64)(_const_max_u64 / ((u64)(base))) + ((u64)(1)));
	u64 max_val = (bit_size == 64 ? (_const_max_u64) : ((u64)(((((u64)(1)) << ((u64)(bit_size)))) - ((u64)(1)))));
	int basem1 = (int)(base - 1);
	u64 n = ((u64)(0));
	for (int i = start_index; i < s.len; ++i) {
		u8 c = s.str[ i];
		if (c == '_') {
			if (i == start_index || i >= ((int)(s.len - 1))) {
				return (multi_return_u64_int){.arg0=((u64)(0)), .arg1=1};
			}
			if (s.str[ (int)(i - 1)] == '_' || s.str[ (int)(i + 1)] == '_') {
				return (multi_return_u64_int){.arg0=((u64)(0)), .arg1=1};
			}
			continue;
		}
		int sub_count = 0;
		c -= 48;
		if (c >= 17) {
			sub_count++;
			c -= 7;
			if (c >= 42) {
				sub_count++;
				c -= 32;
			}
		}
		if (c > basem1 || (sub_count == 0 && c > 9)) {
			return (multi_return_u64_int){.arg0=n, .arg1=(int)(i + 1)};
		}
		if (n >= cutoff) {
			return (multi_return_u64_int){.arg0=max_val, .arg1=-3};
		}
		n *= ((u64)(base));
		u64 n1 = (u64)(n + ((u64)(c)));
		if (n1 < n || n1 > max_val) {
			return (multi_return_u64_int){.arg0=max_val, .arg1=-3};
		}
		n = n1;
	}
	return (multi_return_u64_int){.arg0=n, .arg1=0};
}
_result_u64 strconv__parse_uint(string s, int _base, int _bit_size) {
	return strconv__common_parse_uint(s, _base, _bit_size, true, true);
}
_result_i64 strconv__common_parse_int(string _s, int base, int _bit_size, bool error_on_non_digit, bool error_on_high_digit) {
	if ((_s).len == 0) {
		_result_i64 _t1;
		builtin___result_ok(&(i64[]) { ((i64)(0)) }, (_result*)(&_t1), sizeof(i64));
		 
		return _t1;
	}
	int bit_size = _bit_size;
	if (bit_size == 0) {
		bit_size = _const_strconv__int_size;
	}
	string s = _s;
	bool neg = false;
	if (s.str[ 0] == '+') {
		{ // Unsafe block
			s = builtin__tos(s.str + 1, (int)(s.len - 1));
		}
	} else if (s.str[ 0] == '-') {
		neg = true;
		{ // Unsafe block
			s = builtin__tos(s.str + 1, (int)(s.len - 1));
		}
	}
	_result_u64 _t2 = strconv__common_parse_uint(s, base, bit_size, error_on_non_digit, error_on_high_digit);
	if (_t2.is_error) {
		_result_i64 _t3 = {0};
		_t3.is_error = true;
		_t3.err = _t2.err;
		return _t3;
	}
	
 	u64 un = (*(u64*)_t2.data);
	if (un == 0) {
		_result_i64 _t4;
		builtin___result_ok(&(i64[]) { ((i64)(0)) }, (_result*)(&_t4), sizeof(i64));
		 
		return _t4;
	}
	u64 cutoff = (((u64)(1)) << ((u64)((int)(bit_size - 1))));
	if (!neg && un >= cutoff) {
		_result_i64 _t5;
		builtin___result_ok(&(i64[]) { ((i64)((u64)(cutoff - ((u64)(1))))) }, (_result*)(&_t5), sizeof(i64));
		 
		return _t5;
	}
	if (neg && un > cutoff) {
		_result_i64 _t6;
		builtin___result_ok(&(i64[]) { -((i64)(cutoff)) }, (_result*)(&_t6), sizeof(i64));
		 
		return _t6;
	}
	_result_i64 _t8; /* if prepend */
	if (neg) {
		builtin___result_ok(&(i64[]) { -((i64)(un)) }, (_result*)(&_t8), sizeof(i64));
		goto _t9;
	};
	{
		builtin___result_ok(&(i64[]) { ((i64)(un)) }, (_result*)(&_t8), sizeof(i64));
	}
	_t9: {};
		return _t8;
}
_result_i64 strconv__parse_int(string _s, int base, int _bit_size) {
	return strconv__common_parse_int(_s, base, _bit_size, true, true);
}
VV_LOC _result_multi_return_i64_int strconv__atoi_common_check(string s) {
	if ((s).len == 0) {
		return (_result_multi_return_i64_int){ .is_error=true, .err=builtin___v_error(_S("strconv.atoi: parsing \"\": empty string")), .data={E_STRUCT} };
	}
	int start_idx = 0;
	i64 sign = ((i64)(1));
	if (s.str[ 0] == '-' || s.str[ 0] == '+') {
		start_idx++;
		if (s.str[ 0] == '-') {
			sign = -1;
		}
	}
	if ((int)(s.len - start_idx) < 1) {
		return (_result_multi_return_i64_int){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("strconv.atoi: parsing \""), 0xfe10, {.d_s = s}}, {_S("\": no number after sign"), 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
	}
	if (s.str[ start_idx] == '_' || s.str[ (int)(s.len - 1)] == '_') {
		return (_result_multi_return_i64_int){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("strconv.atoi: parsing \""), 0xfe10, {.d_s = s}}, {_S("\": values cannot start or end with underscores"), 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
	}
	_result_multi_return_i64_int _t4;
	builtin___result_ok(&(multi_return_i64_int[]) { (multi_return_i64_int){.arg0=sign, .arg1=start_idx} }, (_result*)(&_t4), sizeof(multi_return_i64_int));
	return _t4;
}
VV_LOC _result_i64 strconv__atoi_common(string s, i64 type_min, i64 type_max) {
	_result_multi_return_i64_int _t1 = strconv__atoi_common_check(s);
	if (_t1.is_error) {
		_result_i64 _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 	multi_return_i64_int mr_7367 = (*(multi_return_i64_int*)_t1.data);
	i64 sign = mr_7367.arg0;
	int start_idx = mr_7367.arg1;
	i64 x = ((i64)(0));
	bool underscored = false;
	for (int i = start_idx; i < s.len; ++i) {
		rune c = (rune)(s.str[ i] - '0');
		if (c == 47) {
			if (underscored == true) {
				return (_result_i64){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("strconv.atoi: parsing \""), 0xfe10, {.d_s = s}}, {_S("\": consecutives underscores are not allowed"), 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
			}
			underscored = true;
			continue;
		} else {
			if (c > 9) {
				return (_result_i64){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("strconv.atoi: parsing \""), 0xfe10, {.d_s = s}}, {_S("\": invalid radix 10 character"), 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
			}
			underscored = false;
			x = (i64)(((i64)(x * 10)) + ((i64)(c * sign)));
			if (sign == 1 && x > type_max) {
				return (_result_i64){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("strconv.atoi: parsing \""), 0xfe10, {.d_s = s}}, {_S("\": integer overflow"), 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
			} else {
				if (x < type_min) {
					return (_result_i64){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("strconv.atoi: parsing \""), 0xfe10, {.d_s = s}}, {_S("\": integer underflow"), 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
				}
			}
		}
	}
	_result_i64 _t7;
	builtin___result_ok(&(i64[]) { x }, (_result*)(&_t7), sizeof(i64));
	 
	return _t7;
}
_result_int strconv__atoi(string s) {
	_result_i64 _t2 = strconv__atoi_common(s, _const_strconv__i64_min_int32, _const_strconv__i64_max_int32);
	if (_t2.is_error) {
		_result_int _t3 = {0};
		_t3.is_error = true;
		_t3.err = _t2.err;
		return _t3;
	}
	
 	_result_int _t1;
	builtin___result_ok(&(int[]) { ((int)((*(i64*)_t2.data))) }, (_result*)(&_t1), sizeof(int));
	 
	return _t1;
}
_result_i8 strconv__atoi8(string s) {
	_result_i64 _t2 = strconv__atoi_common(s, _const_min_i8, _const_max_i8);
	if (_t2.is_error) {
		_result_i8 _t3 = {0};
		_t3.is_error = true;
		_t3.err = _t2.err;
		return _t3;
	}
	
 	_result_i8 _t1;
	builtin___result_ok(&(i8[]) { ((i8)((*(i64*)_t2.data))) }, (_result*)(&_t1), sizeof(i8));
	 
	return _t1;
}
_result_i16 strconv__atoi16(string s) {
	_result_i64 _t2 = strconv__atoi_common(s, _const_min_i16, _const_max_i16);
	if (_t2.is_error) {
		_result_i16 _t3 = {0};
		_t3.is_error = true;
		_t3.err = _t2.err;
		return _t3;
	}
	
 	_result_i16 _t1;
	builtin___result_ok(&(i16[]) { ((i16)((*(i64*)_t2.data))) }, (_result*)(&_t1), sizeof(i16));
	 
	return _t1;
}
_result_i32 strconv__atoi32(string s) {
	_result_i64 _t2 = strconv__atoi_common(s, _const_min_i32, _const_max_i32);
	if (_t2.is_error) {
		_result_i32 _t3 = {0};
		_t3.is_error = true;
		_t3.err = _t2.err;
		return _t3;
	}
	
 	_result_i32 _t1;
	builtin___result_ok(&(i32[]) { ((i32)((*(i64*)_t2.data))) }, (_result*)(&_t1), sizeof(i32));
	 
	return _t1;
}
_result_i64 strconv__atoi64(string s) {
	_result_multi_return_i64_int _t1 = strconv__atoi_common_check(s);
	if (_t1.is_error) {
		_result_i64 _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 	multi_return_i64_int mr_9119 = (*(multi_return_i64_int*)_t1.data);
	i64 sign = mr_9119.arg0;
	int start_idx = mr_9119.arg1;
	i64 x = ((i64)(0));
	bool underscored = false;
	for (int i = start_idx; i < s.len; ++i) {
		rune c = (rune)(s.str[ i] - '0');
		if (c == 47) {
			if (underscored == true) {
				return (_result_i64){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("strconv.atoi64: parsing \""), 0xfe10, {.d_s = s}}, {_S("\": consecutives underscores are not allowed"), 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
			}
			underscored = true;
			continue;
		} else {
			if (c > 9) {
				return (_result_i64){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("strconv.atoi64: parsing \""), 0xfe10, {.d_s = s}}, {_S("\": invalid radix 10 character"), 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
			}
			underscored = false;
			_result_i64 _t5 = strconv__safe_mul10_64bits(x);
			if (_t5.is_error) {
				IError err = _t5.err;
				return (_result_i64){ .is_error=true, .err=builtin___v_error(builtin__str_intp(3, _MOV((StrIntpData[]){{_S("strconv.atoi64: parsing \""), 0xfe10, {.d_s = s}}, {_S("\": "), 0xfe10, {.d_s = builtin__IError_str(err)}}, {_SLIT0, 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
			}
			
 			x = (*(i64*)_t5.data);
			_result_i64 _t7 = strconv__safe_add_64bits(x, ((int)((i64)(c * sign))));
			if (_t7.is_error) {
				IError err = _t7.err;
				return (_result_i64){ .is_error=true, .err=builtin___v_error(builtin__str_intp(3, _MOV((StrIntpData[]){{_S("strconv.atoi64: parsing \""), 0xfe10, {.d_s = s}}, {_S("\": "), 0xfe10, {.d_s = builtin__IError_str(err)}}, {_SLIT0, 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
			}
			
 			x = (*(i64*)_t7.data);
		}
	}
	_result_i64 _t9;
	builtin___result_ok(&(i64[]) { x }, (_result*)(&_t9), sizeof(i64));
	 
	return _t9;
}
inline VV_LOC _result_i64 strconv__safe_add_64bits(i64 a, i64 b) {
	if (a > 0 && b > ((i64)(_const_max_i64 - a))) {
		return (_result_i64){ .is_error=true, .err=builtin___v_error(_S("integer overflow")), .data={E_STRUCT} };
	} else if (a < 0 && b < ((i64)(_const_min_i64 - a))) {
		return (_result_i64){ .is_error=true, .err=builtin___v_error(_S("integer underflow")), .data={E_STRUCT} };
	}
	_result_i64 _t3;
	builtin___result_ok(&(i64[]) { (i64)(a + b) }, (_result*)(&_t3), sizeof(i64));
	 
	return _t3;
}
inline VV_LOC _result_i64 strconv__safe_mul10_64bits(i64 a) {
	if (a > 0 && a > ((i64)(_const_max_i64 / 10))) {
		return (_result_i64){ .is_error=true, .err=builtin___v_error(_S("integer overflow")), .data={E_STRUCT} };
	}
	if (a < 0 && a < ((i64)(_const_min_i64 / 10))) {
		return (_result_i64){ .is_error=true, .err=builtin___v_error(_S("integer underflow")), .data={E_STRUCT} };
	}
	_result_i64 _t3;
	builtin___result_ok(&(i64[]) { (i64)(a * 10) }, (_result*)(&_t3), sizeof(i64));
	 
	return _t3;
}
VV_LOC _result_int strconv__atou_common_check(string s) {
	if ((s).len == 0) {
		return (_result_int){ .is_error=true, .err=builtin___v_error(_S("strconv.atou: parsing \"\": empty string")), .data={E_STRUCT} };
	}
	int start_idx = 0;
	if (s.str[ 0] == '-') {
		return (_result_int){ .is_error=true, .err=builtin___v_error(_S("strconv.atou: parsing \"{s}\" : negative value")), .data={E_STRUCT} };
	}
	if (s.str[ 0] == '+') {
		start_idx++;
	}
	if ((int)(s.len - start_idx) < 1) {
		return (_result_int){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("strconv.atou: parsing \""), 0xfe10, {.d_s = s}}, {_S("\": no number after sign"), 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
	}
	if (s.str[ start_idx] == '_' || s.str[ (int)(s.len - 1)] == '_') {
		return (_result_int){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("strconv.atou: parsing \""), 0xfe10, {.d_s = s}}, {_S("\": values cannot start or end with underscores"), 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
	}
	_result_int _t5;
	builtin___result_ok(&(int[]) { start_idx }, (_result*)(&_t5), sizeof(int));
	 
	return _t5;
}
VV_LOC _result_u64 strconv__atou_common(string s, u64 type_max) {
	_result_int _t1 = strconv__atou_common_check(s);
	if (_t1.is_error) {
		_result_u64 _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 	int start_idx = ((int)((*(int*)_t1.data)));
	u64 x = ((u64)(0));
	bool underscored = false;
	for (int i = start_idx; i < s.len; ++i) {
		rune c = (rune)(s.str[ i] - '0');
		if (c == 47) {
			if (underscored == true) {
				return (_result_u64){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("strconv.atou: parsing \""), 0xfe10, {.d_s = s}}, {_S("\": consecutives underscores are not allowed"), 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
			}
			underscored = true;
			continue;
		} else {
			if (c > 9) {
				return (_result_u64){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("strconv.atou: parsing \""), 0xfe10, {.d_s = s}}, {_S("\": invalid radix 10 character"), 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
			}
			underscored = false;
			u64 oldx = x;
			x = (u64)(((u64)(x * 10)) + ((u64)(c)));
			if (x > type_max || oldx > x) {
				return (_result_u64){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("strconv.atou: parsing \""), 0xfe10, {.d_s = s}}, {_S("\": integer overflow"), 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
			}
		}
	}
	_result_u64 _t6;
	builtin___result_ok(&(u64[]) { x }, (_result*)(&_t6), sizeof(u64));
	 
	return _t6;
}
_result_u8 strconv__atou8(string s) {
	_result_u64 _t2 = strconv__atou_common(s, _const_max_u8);
	if (_t2.is_error) {
		_result_u8 _t3 = {0};
		_t3.is_error = true;
		_t3.err = _t2.err;
		return _t3;
	}
	
 	_result_u8 _t1;
	builtin___result_ok(&(u8[]) { ((u8)((*(u64*)_t2.data))) }, (_result*)(&_t1), sizeof(u8));
	 
	return _t1;
}
_result_u16 strconv__atou16(string s) {
	_result_u64 _t2 = strconv__atou_common(s, _const_max_u16);
	if (_t2.is_error) {
		_result_u16 _t3 = {0};
		_t3.is_error = true;
		_t3.err = _t2.err;
		return _t3;
	}
	
 	_result_u16 _t1;
	builtin___result_ok(&(u16[]) { ((u16)((*(u64*)_t2.data))) }, (_result*)(&_t1), sizeof(u16));
	 
	return _t1;
}
_result_u32 strconv__atou(string s) {
	_result_u64 _t2 = strconv__atou_common(s, _const_max_u32);
	if (_t2.is_error) {
		_result_u32 _t3 = {0};
		_t3.is_error = true;
		_t3.err = _t2.err;
		return _t3;
	}
	
 	_result_u32 _t1;
	builtin___result_ok(&(u32[]) { ((u32)((*(u64*)_t2.data))) }, (_result*)(&_t1), sizeof(u32));
	 
	return _t1;
}
_result_u32 strconv__atou32(string s) {
	_result_u64 _t2 = strconv__atou_common(s, _const_max_u32);
	if (_t2.is_error) {
		_result_u32 _t3 = {0};
		_t3.is_error = true;
		_t3.err = _t2.err;
		return _t3;
	}
	
 	_result_u32 _t1;
	builtin___result_ok(&(u32[]) { ((u32)((*(u64*)_t2.data))) }, (_result*)(&_t1), sizeof(u32));
	 
	return _t1;
}
_result_u64 strconv__atou64(string s) {
	_result_u64 _t2 = strconv__atou_common(s, _const_max_u64);
	if (_t2.is_error) {
		_result_u64 _t3 = {0};
		_t3.is_error = true;
		_t3.err = _t2.err;
		return _t3;
	}
	
 	_result_u64 _t1;
	builtin___result_ok(&(u64[]) { ((u64)((*(u64*)_t2.data))) }, (_result*)(&_t1), sizeof(u64));
	 
	return _t1;
}
string strconv__Dec32_get_string_32(strconv__Dec32 d, bool neg, int i_n_digit, int i_pad_digit) {
	int n_digit = (int)(i_n_digit + 1);
	int pad_digit = (int)(i_pad_digit + 1);
	u32 out = d.m;
	int out_len = strconv__dec_digits(out);
	int out_len_original = out_len;
	int fw_zeros = 0;
	if (pad_digit > out_len) {
		fw_zeros = (int)(pad_digit - out_len);
	}
	Array_u8 buf = builtin____new_array_with_default(((int)((int)((int)((int)(out_len + 5) + 1) + 1))), 0, sizeof(u8), 0);
	int i = 0;
	if (neg) {
		if (buf.data != 0) {
			((u8*)buf.data)[i] = '-';
		}
		i++;
	}
	int disp = 0;
	if (out_len <= 1) {
		disp = 1;
	}
	if (n_digit < out_len) {
		out += (u32)(_const_strconv__ten_pow_table_32[(int)((int)(out_len - n_digit) - 1)] * 5);
		out /= _const_strconv__ten_pow_table_32[(int)(out_len - n_digit)];
		out_len = n_digit;
	}
	int y = (int)(i + out_len);
	int x = 0;
	for (;;) {
		if (!(x < ((int)((int)(out_len - disp) - 1)))) break;
		((u8*)buf.data)[(int)(y - x)] = (rune)('0' + ((u8)((u32)(out % 10))));
		out /= 10;
		i++;
		x++;
	}
	if (i_n_digit == 0) {
		{ // Unsafe block
			((u8*)buf.data)[i] = 0;
			return builtin__tos(((u8*)(&((u8*)buf.data)[0])), i);
		}
	}
	if (out_len > 1 || fw_zeros > 0) {
		((u8*)buf.data)[(int)(y - x)] = '.';
		i++;
	}
	x++;
	if ((int)(y - x) >= 0) {
		((u8*)buf.data)[(int)(y - x)] = (rune)('0' + ((u8)((u32)(out % 10))));
		i++;
	}
	for (;;) {
		if (!(fw_zeros > 0)) break;
		((u8*)buf.data)[i] = '0';
		i++;
		fw_zeros--;
	}
	((u8*)buf.data)[i] = 'e';
	i++;
	int exp = (int)((int)(d.e + out_len_original) - 1);
	if (exp < 0) {
		((u8*)buf.data)[i] = '-';
		i++;
		exp = -exp;
	} else {
		((u8*)buf.data)[i] = '+';
		i++;
	}
	int d1 = (int)(exp % 10);
	int d0 = (int)(exp / 10);
	((u8*)buf.data)[i] = (rune)('0' + ((u8)(d0)));
	i++;
	((u8*)buf.data)[i] = (rune)('0' + ((u8)(d1)));
	i++;
	((u8*)buf.data)[i] = 0;
	return builtin__tos(((u8*)(&((u8*)buf.data)[0])), i);
}
VV_LOC multi_return_strconv__Dec32_bool strconv__f32_to_decimal_exact_int(u32 i_mant, u32 exp) {
	strconv__Dec32 d = ((strconv__Dec32){.m = 0,.e = 0,});
	u32 e = (u32)(exp - 127);
	if (e > _const_strconv__mantbits32) {
		return (multi_return_strconv__Dec32_bool){.arg0=d, .arg1=false};
	}
	u32 shift = (u32)(_const_strconv__mantbits32 - e);
	u32 mant = (i_mant | 0x00800000);
	d.m = (mant >> shift);
	if (((d.m << shift)) != mant) {
		return (multi_return_strconv__Dec32_bool){.arg0=d, .arg1=false};
	}
	for (;;) {
		if (!(((u32)(d.m % 10)) == 0)) break;
		d.m /= 10;
		d.e++;
	}
	return (multi_return_strconv__Dec32_bool){.arg0=d, .arg1=true};
}
VV_LOC strconv__Dec32 strconv__f32_to_decimal(u32 mant, u32 exp) {
	int e2 = 0;
	u32 m2 = ((u32)(0));
	if (exp == 0) {
		e2 = (int)((int)(-126 - ((int)(_const_strconv__mantbits32))) - 2);
		m2 = mant;
	} else {
		e2 = (int)((int)((int)(((int)(exp)) - 127) - ((int)(_const_strconv__mantbits32))) - 2);
		m2 = (((((u32)(1)) << _const_strconv__mantbits32)) | mant);
	}
	bool even = ((m2 & 1)) == 0;
	bool accept_bounds = even;
	u32 mv = ((u32)((u32)(4 * m2)));
	u32 mp = ((u32)((u32)((u32)(4 * m2) + 2)));
	u32 mm_shift = strconv__bool_to_u32(mant != 0 || exp <= 1);
	u32 mm = ((u32)((u32)((u32)((u32)(4 * m2) - 1) - mm_shift)));
	u32 vr = ((u32)(0));
	u32 vp = ((u32)(0));
	u32 vm = ((u32)(0));
	int e10 = 0;
	bool vm_is_trailing_zeros = false;
	bool vr_is_trailing_zeros = false;
	u8 last_removed_digit = ((u8)(0));
	if (e2 >= 0) {
		u32 q = strconv__log10_pow2(e2);
		e10 = ((int)(q));
		int k = (int)((int)(59 + strconv__pow5_bits(((int)(q)))) - 1);
		int i = (int)((int)(-e2 + ((int)(q))) + k);
		vr = strconv__mul_pow5_invdiv_pow2(mv, q, i);
		vp = strconv__mul_pow5_invdiv_pow2(mp, q, i);
		vm = strconv__mul_pow5_invdiv_pow2(mm, q, i);
		if (q != 0 && (u32)(((u32)(vp - 1)) / 10) <= (u32)(vm / 10)) {
			int l = (int)((int)(59 + strconv__pow5_bits(((int)((u32)(q - 1))))) - 1);
			last_removed_digit = ((u8)((u32)(strconv__mul_pow5_invdiv_pow2(mv, (u32)(q - 1), (int)((int)(-e2 + ((int)((u32)(q - 1)))) + l)) % 10)));
		}
		if (q <= 9) {
			if ((u32)(mv % 5) == 0) {
				vr_is_trailing_zeros = strconv__multiple_of_power_of_five_32(mv, q);
			} else if (accept_bounds) {
				vm_is_trailing_zeros = strconv__multiple_of_power_of_five_32(mm, q);
			} else if (strconv__multiple_of_power_of_five_32(mp, q)) {
				vp--;
			}
		}
	} else {
		u32 q = strconv__log10_pow5(-e2);
		e10 = (int)(((int)(q)) + e2);
		int i = (int)(-e2 - ((int)(q)));
		int k = (int)(strconv__pow5_bits(i) - 61);
		int j = (int)(((int)(q)) - k);
		vr = strconv__mul_pow5_div_pow2(mv, ((u32)(i)), j);
		vp = strconv__mul_pow5_div_pow2(mp, ((u32)(i)), j);
		vm = strconv__mul_pow5_div_pow2(mm, ((u32)(i)), j);
		if (q != 0 && ((u32)(((u32)(vp - 1)) / 10)) <= (u32)(vm / 10)) {
			j = (int)((int)(((int)(q)) - 1) - ((int)(strconv__pow5_bits((int)(i + 1)) - 61)));
			last_removed_digit = ((u8)((u32)(strconv__mul_pow5_div_pow2(mv, ((u32)((int)(i + 1))), j) % 10)));
		}
		if (q <= 1) {
			vr_is_trailing_zeros = true;
			if (accept_bounds) {
				vm_is_trailing_zeros = mm_shift == 1;
			} else {
				vp--;
			}
		} else if (q < 31) {
			vr_is_trailing_zeros = strconv__multiple_of_power_of_two_32(mv, (u32)(q - 1));
		}
	}
	int removed = 0;
	u32 out = ((u32)(0));
	if (vm_is_trailing_zeros || vr_is_trailing_zeros) {
		for (;;) {
			if (!((u32)(vp / 10) > (u32)(vm / 10))) break;
			vm_is_trailing_zeros = vm_is_trailing_zeros && ((u32)(vm % 10)) == 0;
			vr_is_trailing_zeros = vr_is_trailing_zeros && last_removed_digit == 0;
			last_removed_digit = ((u8)((u32)(vr % 10)));
			vr /= 10;
			vp /= 10;
			vm /= 10;
			removed++;
		}
		if (vm_is_trailing_zeros) {
			for (;;) {
				if (!((u32)(vm % 10) == 0)) break;
				vr_is_trailing_zeros = vr_is_trailing_zeros && last_removed_digit == 0;
				last_removed_digit = ((u8)((u32)(vr % 10)));
				vr /= 10;
				vp /= 10;
				vm /= 10;
				removed++;
			}
		}
		if (vr_is_trailing_zeros && last_removed_digit == 5 && ((u32)(vr % 2)) == 0) {
			last_removed_digit = 4;
		}
		out = vr;
		if ((vr == vm && (!accept_bounds || !vm_is_trailing_zeros)) || last_removed_digit >= 5) {
			out++;
		}
	} else {
		for (;;) {
			if (!((u32)(vp / 10) > (u32)(vm / 10))) break;
			last_removed_digit = ((u8)((u32)(vr % 10)));
			vr /= 10;
			vp /= 10;
			vm /= 10;
			removed++;
		}
		out = (u32)(vr + strconv__bool_to_u32(vr == vm || last_removed_digit >= 5));
	}
	return ((strconv__Dec32){.m = out,.e = (int)(e10 + removed),});
}
string strconv__f32_to_str(f32 f, int n_digit) {
	strconv__Uf32 u1 = ((strconv__Uf32){0});
	u1.f = f;
	u32 u = u1.u;
	bool neg = ((u >> ((u32)(_const_strconv__mantbits32 + _const_strconv__expbits32)))) != 0;
	u32 mant = (u & ((u32)(((((u32)(1)) << _const_strconv__mantbits32)) - ((u32)(1)))));
	u32 exp = (((u >> _const_strconv__mantbits32)) & ((u32)(((((u32)(1)) << _const_strconv__expbits32)) - ((u32)(1)))));
	if (exp == 255 || (exp == 0 && mant == 0)) {
		return strconv__get_string_special(neg, exp == 0, mant == 0);
	}
	multi_return_strconv__Dec32_bool mr_8580 = strconv__f32_to_decimal_exact_int(mant, exp);
	strconv__Dec32 d = mr_8580.arg0;
	bool ok = mr_8580.arg1;
	if (!ok) {
		d = strconv__f32_to_decimal(mant, exp);
	}
	return strconv__Dec32_get_string_32(d, neg, n_digit, 0);
}
string strconv__f32_to_str_pad(f32 f, int n_digit) {
	strconv__Uf32 u1 = ((strconv__Uf32){0});
	u1.f = f;
	u32 u = u1.u;
	bool neg = ((u >> ((u32)(_const_strconv__mantbits32 + _const_strconv__expbits32)))) != 0;
	u32 mant = (u & ((u32)(((((u32)(1)) << _const_strconv__mantbits32)) - ((u32)(1)))));
	u32 exp = (((u >> _const_strconv__mantbits32)) & ((u32)(((((u32)(1)) << _const_strconv__expbits32)) - ((u32)(1)))));
	if (exp == 255 || (exp == 0 && mant == 0)) {
		return strconv__get_string_special(neg, exp == 0, mant == 0);
	}
	multi_return_strconv__Dec32_bool mr_9314 = strconv__f32_to_decimal_exact_int(mant, exp);
	strconv__Dec32 d = mr_9314.arg0;
	bool ok = mr_9314.arg1;
	if (!ok) {
		d = strconv__f32_to_decimal(mant, exp);
	}
	return strconv__Dec32_get_string_32(d, neg, n_digit, n_digit);
}
VV_LOC string strconv__Dec64_get_string_64(strconv__Dec64 d, bool neg, int i_n_digit, int i_pad_digit) {
	int n_digit = (i_n_digit < 1 ? (1) : ((int)(i_n_digit + 1)));
	int pad_digit = (int)(i_pad_digit + 1);
	u64 out = d.m;
	int d_exp = d.e;
	int out_len = strconv__dec_digits(out);
	int out_len_original = out_len;
	int fw_zeros = 0;
	if (pad_digit > out_len) {
		fw_zeros = (int)(pad_digit - out_len);
	}
	Array_u8 buf = builtin____new_array_with_default(((int)((int)((int)((int)(out_len + 6) + 1) + 1) + fw_zeros)), 0, sizeof(u8), 0);
	int i = 0;
	if (neg) {
		((u8*)buf.data)[i] = '-';
		i++;
	}
	int disp = 0;
	if (out_len <= 1) {
		disp = 1;
	}
	if (n_digit < out_len) {
		out += (u64)(_const_strconv__ten_pow_table_64[(int)((int)(out_len - n_digit) - 1)] * 5);
		out /= _const_strconv__ten_pow_table_64[(int)(out_len - n_digit)];
		u64 out_div = (u64)(d.m / _const_strconv__ten_pow_table_64[(int)(out_len - n_digit)]);
		if (out_div < out && strconv__dec_digits(out_div) < strconv__dec_digits(out)) {
			d_exp++;
			n_digit++;
		}
		out_len = n_digit;
	}
	int y = (int)(i + out_len);
	int x = 0;
	for (;;) {
		if (!(x < ((int)((int)(out_len - disp) - 1)))) break;
		((u8*)buf.data)[(int)(y - x)] = (rune)('0' + ((u8)((u64)(out % 10))));
		out /= 10;
		i++;
		x++;
	}
	if (out_len > 1 || fw_zeros > 0) {
		((u8*)buf.data)[(int)(y - x)] = '.';
		i++;
	}
	x++;
	if ((int)(y - x) >= 0) {
		((u8*)buf.data)[(int)(y - x)] = (rune)('0' + ((u8)((u64)(out % 10))));
		i++;
	}
	for (;;) {
		if (!(fw_zeros > 0)) break;
		((u8*)buf.data)[i] = '0';
		i++;
		fw_zeros--;
	}
	((u8*)buf.data)[i] = 'e';
	i++;
	int exp = (int)((int)(d_exp + out_len_original) - 1);
	if (exp < 0) {
		((u8*)buf.data)[i] = '-';
		i++;
		exp = -exp;
	} else {
		((u8*)buf.data)[i] = '+';
		i++;
	}
	int d2 = (int)(exp % 10);
	exp /= 10;
	int d1 = (int)(exp % 10);
	int d0 = (int)(exp / 10);
	if (d0 > 0) {
		((u8*)buf.data)[i] = (rune)('0' + ((u8)(d0)));
		i++;
	}
	((u8*)buf.data)[i] = (rune)('0' + ((u8)(d1)));
	i++;
	((u8*)buf.data)[i] = (rune)('0' + ((u8)(d2)));
	i++;
	((u8*)buf.data)[i] = 0;
	return builtin__tos(((u8*)(&((u8*)buf.data)[0])), i);
}
VV_LOC multi_return_strconv__Dec64_bool strconv__f64_to_decimal_exact_int(u64 i_mant, u64 exp) {
	strconv__Dec64 d = ((strconv__Dec64){.m = 0,.e = 0,});
	u64 e = (u64)(exp - 1023);
	if (e > _const_strconv__mantbits64) {
		return (multi_return_strconv__Dec64_bool){.arg0=d, .arg1=false};
	}
	u64 shift = (u64)(_const_strconv__mantbits64 - e);
	u64 mant = (i_mant | ((u64)(0x0010000000000000LL)));
	d.m = (mant >> shift);
	if (((d.m << shift)) != mant) {
		return (multi_return_strconv__Dec64_bool){.arg0=d, .arg1=false};
	}
	for (;;) {
		if (!(((u64)(d.m % 10)) == 0)) break;
		d.m /= 10;
		d.e++;
	}
	return (multi_return_strconv__Dec64_bool){.arg0=d, .arg1=true};
}
VV_LOC strconv__Dec64 strconv__f64_to_decimal(u64 mant, u64 exp) {
	int e2 = 0;
	u64 m2 = ((u64)(0));
	if (exp == 0) {
		e2 = (int)((int)(-1022 - ((int)(_const_strconv__mantbits64))) - 2);
		m2 = mant;
	} else {
		e2 = (int)((int)((int)(((int)(exp)) - 1023) - ((int)(_const_strconv__mantbits64))) - 2);
		m2 = (((((u64)(1)) << _const_strconv__mantbits64)) | mant);
	}
	bool even = ((m2 & 1)) == 0;
	bool accept_bounds = even;
	u64 mv = ((u64)((u64)(4 * m2)));
	u64 mm_shift = strconv__bool_to_u64(mant != 0 || exp <= 1);
	u64 vr = ((u64)(0));
	u64 vp = ((u64)(0));
	u64 vm = ((u64)(0));
	int e10 = 0;
	bool vm_is_trailing_zeros = false;
	bool vr_is_trailing_zeros = false;
	if (e2 >= 0) {
		u32 q = (u32)(strconv__log10_pow2(e2) - strconv__bool_to_u32(e2 > 3));
		e10 = ((int)(q));
		int k = (int)((int)(122 + strconv__pow5_bits(((int)(q)))) - 1);
		int i = (int)((int)(-e2 + ((int)(q))) + k);
		strconv__Uint128 mul = *(((strconv__Uint128*)(&_const_strconv__pow5_inv_split_64_x[builtin__v_fixed_index((u32)(q * 2), 584)])));
		vr = strconv__mul_shift_64((u64)(((u64)(4)) * m2), mul, i);
		vp = strconv__mul_shift_64((u64)((u64)(((u64)(4)) * m2) + ((u64)(2))), mul, i);
		vm = strconv__mul_shift_64((u64)((u64)((u64)(((u64)(4)) * m2) - ((u64)(1))) - mm_shift), mul, i);
		if (q <= 21) {
			if ((u64)(mv % 5) == 0) {
				vr_is_trailing_zeros = strconv__multiple_of_power_of_five_64(mv, q);
			} else if (accept_bounds) {
				vm_is_trailing_zeros = strconv__multiple_of_power_of_five_64((u64)((u64)(mv - 1) - mm_shift), q);
			} else if (strconv__multiple_of_power_of_five_64((u64)(mv + 2), q)) {
				vp--;
			}
		}
	} else {
		u32 q = (u32)(strconv__log10_pow5(-e2) - strconv__bool_to_u32(-e2 > 1));
		e10 = (int)(((int)(q)) + e2);
		int i = (int)(-e2 - ((int)(q)));
		int k = (int)(strconv__pow5_bits(i) - 121);
		int j = (int)(((int)(q)) - k);
		strconv__Uint128 mul = *(((strconv__Uint128*)(&_const_strconv__pow5_split_64_x[builtin__v_fixed_index((int)(i * 2), 652)])));
		vr = strconv__mul_shift_64((u64)(((u64)(4)) * m2), mul, j);
		vp = strconv__mul_shift_64((u64)((u64)(((u64)(4)) * m2) + ((u64)(2))), mul, j);
		vm = strconv__mul_shift_64((u64)((u64)((u64)(((u64)(4)) * m2) - ((u64)(1))) - mm_shift), mul, j);
		if (q <= 1) {
			vr_is_trailing_zeros = true;
			if (accept_bounds) {
				vm_is_trailing_zeros = (mm_shift == 1);
			} else {
				vp--;
			}
		} else if (q < 63) {
			vr_is_trailing_zeros = strconv__multiple_of_power_of_two_64(mv, (u32)(q - 1));
		}
	}
	int removed = 0;
	u8 last_removed_digit = ((u8)(0));
	u64 out = ((u64)(0));
	if (vm_is_trailing_zeros || vr_is_trailing_zeros) {
		for (;;) {
			u64 vp_div_10 = (u64)(vp / 10);
			u64 vm_div_10 = (u64)(vm / 10);
			if (vp_div_10 <= vm_div_10) {
				break;
			}
			u64 vm_mod_10 = (u64)(vm % 10);
			u64 vr_div_10 = (u64)(vr / 10);
			u64 vr_mod_10 = (u64)(vr % 10);
			vm_is_trailing_zeros = vm_is_trailing_zeros && vm_mod_10 == 0;
			vr_is_trailing_zeros = vr_is_trailing_zeros && last_removed_digit == 0;
			last_removed_digit = ((u8)(vr_mod_10));
			vr = vr_div_10;
			vp = vp_div_10;
			vm = vm_div_10;
			removed++;
		}
		if (vm_is_trailing_zeros) {
			for (;;) {
				u64 vm_div_10 = (u64)(vm / 10);
				u64 vm_mod_10 = (u64)(vm % 10);
				if (vm_mod_10 != 0) {
					break;
				}
				u64 vp_div_10 = (u64)(vp / 10);
				u64 vr_div_10 = (u64)(vr / 10);
				u64 vr_mod_10 = (u64)(vr % 10);
				vr_is_trailing_zeros = vr_is_trailing_zeros && last_removed_digit == 0;
				last_removed_digit = ((u8)(vr_mod_10));
				vr = vr_div_10;
				vp = vp_div_10;
				vm = vm_div_10;
				removed++;
			}
		}
		if (vr_is_trailing_zeros && last_removed_digit == 5 && ((u64)(vr % 2)) == 0) {
			last_removed_digit = 4;
		}
		out = vr;
		if ((vr == vm && (!accept_bounds || !vm_is_trailing_zeros)) || last_removed_digit >= 5) {
			out++;
		}
	} else {
		bool round_up = false;
		for (;;) {
			if (!((u64)(vp / 100) > (u64)(vm / 100))) break;
			round_up = ((u64)(vr % 100)) >= 50;
			vr /= 100;
			vp /= 100;
			vm /= 100;
			removed += 2;
		}
		for (;;) {
			if (!((u64)(vp / 10) > (u64)(vm / 10))) break;
			round_up = ((u64)(vr % 10)) >= 5;
			vr /= 10;
			vp /= 10;
			vm /= 10;
			removed++;
		}
		out = (u64)(vr + strconv__bool_to_u64(vr == vm || round_up));
	}
	return ((strconv__Dec64){.m = out,.e = (int)(e10 + removed),});
}
string strconv__f64_to_str(f64 f, int n_digit) {
	strconv__Uf64 u1 = ((strconv__Uf64){0});
	u1.f = f;
	u64 u = u1.u;
	bool neg = ((u >> ((u32)(_const_strconv__mantbits64 + _const_strconv__expbits64)))) != 0;
	u64 mant = (u & ((u64)(((((u64)(1)) << _const_strconv__mantbits64)) - ((u64)(1)))));
	u64 exp = (((u >> _const_strconv__mantbits64)) & ((u64)(((((u64)(1)) << _const_strconv__expbits64)) - ((u64)(1)))));
	if (exp == 2047 || (exp == 0 && mant == 0)) {
		return strconv__get_string_special(neg, exp == 0, mant == 0);
	}
	multi_return_strconv__Dec64_bool mr_9590 = strconv__f64_to_decimal_exact_int(mant, exp);
	strconv__Dec64 d = mr_9590.arg0;
	bool ok = mr_9590.arg1;
	if (!ok) {
		d = strconv__f64_to_decimal(mant, exp);
	}
	return strconv__Dec64_get_string_64(d, neg, n_digit, 0);
}
string strconv__f64_to_str_pad(f64 f, int n_digit) {
	strconv__Uf64 u1 = ((strconv__Uf64){0});
	u1.f = f;
	u64 u = u1.u;
	bool neg = ((u >> ((u32)(_const_strconv__mantbits64 + _const_strconv__expbits64)))) != 0;
	u64 mant = (u & ((u64)(((((u64)(1)) << _const_strconv__mantbits64)) - ((u64)(1)))));
	u64 exp = (((u >> _const_strconv__mantbits64)) & ((u64)(((((u64)(1)) << _const_strconv__expbits64)) - ((u64)(1)))));
	if (exp == 2047 || (exp == 0 && mant == 0)) {
		return strconv__get_string_special(neg, exp == 0, mant == 0);
	}
	multi_return_strconv__Dec64_bool mr_10371 = strconv__f64_to_decimal_exact_int(mant, exp);
	strconv__Dec64 d = mr_10371.arg0;
	bool ok = mr_10371.arg1;
	if (!ok) {
		d = strconv__f64_to_decimal(mant, exp);
	}
	return strconv__Dec64_get_string_64(d, neg, n_digit, n_digit);
}
string strconv__format_str(string s, strconv__BF_param p) {
	if (p.len0 <= 0) {
		return builtin__string_clone(s);
	}
	int dif = (int)(p.len0 - builtin__utf8_str_visible_length(s));
	if (dif <= 0) {
		return builtin__string_clone(s);
	}
	strings__Builder res = strings__new_builder((int)(s.len + dif));
	if (p.align == strconv__Align_text__right) {
		for (int i1 = 0; i1 < dif; i1++) {
			strings__Builder_write_u8(&res, p.pad_ch);
		}
	}
	strings__Builder_write_string(&res, s);
	if (p.align == strconv__Align_text__left) {
		for (int i1 = 0; i1 < dif; i1++) {
			strings__Builder_write_u8(&res, p.pad_ch);
		}
	}
	string _t3 = strings__Builder_str(&res);
		{ // defer begin
			strings__Builder_free(&res);
		} // defer end
	return _t3;
}
void strconv__format_str_sb(string s, strconv__BF_param p, strings__Builder* sb) {
	if (p.len0 <= 0) {
		strings__Builder_write_string(sb, s);
		return;
	}
	int dif = (int)(p.len0 - builtin__utf8_str_visible_length(s));
	if (dif <= 0) {
		strings__Builder_write_string(sb, s);
		return;
	}
	if (p.align == strconv__Align_text__right) {
		for (int i1 = 0; i1 < dif; i1++) {
			strings__Builder_write_u8(sb, p.pad_ch);
		}
	}
	strings__Builder_write_string(sb, s);
	if (p.align == strconv__Align_text__left) {
		for (int i1 = 0; i1 < dif; i1++) {
			strings__Builder_write_u8(sb, p.pad_ch);
		}
	}
}
void strconv__format_dec_sb(u64 d, strconv__BF_param p, strings__Builder* res) {
	int n_char = strconv__dec_digits(d);
	int sign_len = (!p.positive || p.sign_flag ? (1) : (0));
	int number_len = (int)(sign_len + n_char);
	int dif = (int)(p.len0 - number_len);
	bool sign_written = false;
	if (p.align == strconv__Align_text__right) {
		if (p.pad_ch == '0') {
			if (p.positive) {
				if (p.sign_flag) {
					strings__Builder_write_u8(res, '+');
					sign_written = true;
				}
			} else {
				strings__Builder_write_u8(res, '-');
				sign_written = true;
			}
		}
		for (int i1 = 0; i1 < dif; i1++) {
			strings__Builder_write_u8(res, p.pad_ch);
		}
	}
	if (!sign_written) {
		if (p.positive) {
			if (p.sign_flag) {
				strings__Builder_write_u8(res, '+');
			}
		} else {
			strings__Builder_write_u8(res, '-');
		}
	}
	Array_fixed_u8_32 buf = {0};
	int i = 20;
	u64 n = d;
	u64 d_i = ((u64)(0));
	if (n > 0) {
		for (;;) {
			if (!(n > 0)) break;
			u64 n1 = (u64)(n / 100);
			d_i = (((u64)(n - ((u64)(n1 * 100)))) << 1);
			n = n1;
			{ // Unsafe block
				buf[i] = _const_strconv__digit_pairs.str[d_i];
			}
			i--;
			d_i++;
			{ // Unsafe block
				buf[i] = _const_strconv__digit_pairs.str[d_i];
			}
			i--;
		}
		i++;
		if (d_i < 20) {
			i++;
		}
		strings__Builder_write_ptr(res, &buf[i], n_char);
	} else {
		strings__Builder_write_u8(res, '0');
	}
	if (p.align == strconv__Align_text__left) {
		for (int i1 = 0; i1 < dif; i1++) {
			strings__Builder_write_u8(res, p.pad_ch);
		}
	}
	return;
}
string strconv__f64_to_str_lnd1(f64 f, int dec_digit) {
	{ // Unsafe block
		string s = strconv__f64_to_str((f64)(f + _const_strconv__dec_round[dec_digit]), 18);
		if (s.len > 2 && (s.str[ 0] == 'n' || s.str[ 1] == 'i')) {
			return s;
		}
		bool m_sgn_flag = false;
		int sgn = 1;
		Array_fixed_u8_26 b = {0};
		int d_pos = 1;
		int i = 0;
		int i1 = 0;
		int exp = 0;
		int exp_sgn = 1;
		int dot_res_sp = -1;
		for (int _t2 = 0; _t2 < s.len; ++_t2) {
			u8 c = s.str[_t2];

			if (c == ('-')) {
				sgn = -1;
				i++;
			}
			else if (c == ('+')) {
				sgn = 1;
				i++;
			}
			else if ((c >= '0' && c <= '9')) {
				b[i1] = c;
				i1++;
				i++;
			}
			else if (c == ('.')) {
				if (sgn > 0) {
					d_pos = i;
				} else {
					d_pos = (int)(i - 1);
				}
				i++;
			}
			else if (c == ('e')) {
				i++;
				break;
			}
			else {
				builtin__string_free(&s);
				return _S("[Float conversion error!!]");
			}
		}
		b[i1] = 0;
		if (s.str[ i] == '-') {
			exp_sgn = -1;
			i++;
		} else if (s.str[ i] == '+') {
			exp_sgn = 1;
			i++;
		}
		int c = i;
		for (;;) {
			if (!(c < s.len)) break;
			exp = (int)((int)(exp * 10) + ((int)((rune)(s.str[ c] - '0'))));
			c++;
		}
		Array_u8 res = builtin____new_array_with_default((int)(exp + 40), 0, sizeof(u8), &(u8[]){0});
		int r_i = 0;
		builtin__string_free(&s);
		if (sgn == 1) {
			if (m_sgn_flag) {
				((u8*)res.data)[r_i] = '+';
				r_i++;
			}
		} else {
			((u8*)res.data)[r_i] = '-';
			r_i++;
		}
		i = 0;
		if (exp_sgn >= 0) {
			for (;;) {
				if (!(b[i] != 0)) break;
				((u8*)res.data)[r_i] = b[i];
				r_i++;
				i++;
				if (i >= d_pos && exp >= 0) {
					if (exp == 0) {
						dot_res_sp = r_i;
						((u8*)res.data)[r_i] = '.';
						r_i++;
					}
					exp--;
				}
			}
			for (;;) {
				if (!(exp >= 0)) break;
				((u8*)res.data)[r_i] = '0';
				r_i++;
				exp--;
			}
		} else {
			bool dot_p = true;
			for (;;) {
				if (!(exp > 0)) break;
				((u8*)res.data)[r_i] = '0';
				r_i++;
				exp--;
				if (dot_p) {
					dot_res_sp = r_i;
					((u8*)res.data)[r_i] = '.';
					r_i++;
					dot_p = false;
				}
			}
			for (;;) {
				if (!(b[i] != 0)) break;
				((u8*)res.data)[r_i] = b[i];
				r_i++;
				i++;
			}
		}
		if (dec_digit <= 0) {
			if (dot_res_sp < 0) {
				dot_res_sp = (int)(i + 1);
			}
			string tmp_res = builtin__string_clone(builtin__tos(res.data, dot_res_sp));
			builtin__array_free(&res);
			return tmp_res;
		}
		if (dot_res_sp >= 0) {
			r_i = (int)((int)(dot_res_sp + dec_digit) + 1);
			((u8*)res.data)[r_i] = 0;
			for (int c1 = 1; c1 < (int)(dec_digit + 1); ++c1) {
				if (((u8*)res.data)[(int)(r_i - c1)] == 0) {
					((u8*)res.data)[(int)(r_i - c1)] = '0';
				}
			}
			string tmp_res = builtin__string_clone(builtin__tos(res.data, r_i));
			builtin__array_free(&res);
			return tmp_res;
		} else {
			if (dec_digit > 0) {
				int c1 = 0;
				((u8*)res.data)[r_i] = '.';
				r_i++;
				for (;;) {
					if (!(c1 < dec_digit)) break;
					((u8*)res.data)[r_i] = '0';
					r_i++;
					c1++;
				}
				((u8*)res.data)[r_i] = 0;
			}
			string tmp_res = builtin__string_clone(builtin__tos(res.data, r_i));
			builtin__array_free(&res);
			return tmp_res;
		}
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
string strconv__format_fl(f64 f, strconv__BF_param p) {
	{ // Unsafe block
		string fs = strconv__f64_to_str_lnd1((f >= ((f64)(0.0)) ? (f) : (-f)), p.len1);
		if (fs.str[ 0] == '[') {
			return fs;
		}
		if (p.rm_tail_zero) {
			string tmp = fs;
			fs = strconv__remove_tail_zeros(fs);
			builtin__string_free(&tmp);
		}
		Array_fixed_u8_512 buf = {0};
		Array_fixed_u8_512 out = {0};
		int buf_i = 0;
		int out_i = 0;
		int sign_len_diff = 0;
		if (p.pad_ch == '0') {
			if (p.positive) {
				if (p.sign_flag) {
					out[out_i] = '+';
					out_i++;
					sign_len_diff = -1;
				}
			} else {
				out[out_i] = '-';
				out_i++;
				sign_len_diff = -1;
			}
		} else {
			if (p.positive) {
				if (p.sign_flag) {
					buf[buf_i] = '+';
					buf_i++;
				}
			} else {
				buf[buf_i] = '-';
				buf_i++;
			}
		}
		builtin__vmemcpy(&buf[buf_i], fs.str, fs.len);
		buf_i += fs.len;
		int dif = (int)((int)(p.len0 - buf_i) + sign_len_diff);
		if (p.align == strconv__Align_text__right) {
			for (int i1 = 0; i1 < dif; i1++) {
				out[out_i] = p.pad_ch;
				out_i++;
			}
		}
		builtin__vmemcpy(&out[out_i], &buf[0], buf_i);
		out_i += buf_i;
		if (p.align == strconv__Align_text__left) {
			for (int i1 = 0; i1 < dif; i1++) {
				out[out_i] = p.pad_ch;
				out_i++;
			}
		}
		out[out_i] = 0;
		string tmp = fs;
		fs = builtin__tos_clone(&out[0]);
		builtin__string_free(&tmp);
		return fs;
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
string strconv__format_es(f64 f, strconv__BF_param p) {
	{ // Unsafe block
		string fs = strconv__f64_to_str_pad((f > 0 ? (f) : (-f)), p.len1);
		if (p.rm_tail_zero) {
			string tmp = fs;
			fs = strconv__remove_tail_zeros(fs);
			builtin__string_free(&tmp);
		}
		Array_fixed_u8_512 buf = {0};
		Array_fixed_u8_512 out = {0};
		int buf_i = 0;
		int out_i = 0;
		int sign_len_diff = 0;
		if (p.pad_ch == '0') {
			if (p.positive) {
				if (p.sign_flag) {
					out[out_i] = '+';
					out_i++;
					sign_len_diff = -1;
				}
			} else {
				out[out_i] = '-';
				out_i++;
				sign_len_diff = -1;
			}
		} else {
			if (p.positive) {
				if (p.sign_flag) {
					buf[buf_i] = '+';
					buf_i++;
				}
			} else {
				buf[buf_i] = '-';
				buf_i++;
			}
		}
		builtin__vmemcpy(&buf[buf_i], fs.str, fs.len);
		buf_i += fs.len;
		int dif = (int)((int)(p.len0 - buf_i) + sign_len_diff);
		if (p.align == strconv__Align_text__right) {
			for (int i1 = 0; i1 < dif; i1++) {
				out[out_i] = p.pad_ch;
				out_i++;
			}
		}
		builtin__vmemcpy(&out[out_i], &buf[0], buf_i);
		out_i += buf_i;
		if (p.align == strconv__Align_text__left) {
			for (int i1 = 0; i1 < dif; i1++) {
				out[out_i] = p.pad_ch;
				out_i++;
			}
		}
		out[out_i] = 0;
		string tmp = fs;
		fs = builtin__tos_clone(&out[0]);
		builtin__string_free(&tmp);
		return fs;
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
string strconv__remove_tail_zeros(string s) {
	{ // Unsafe block
		u8* buf = builtin__malloc_noscan((int)(s.len + 1));
		int i_d = 0;
		int i_s = 0;
		for (;;) {
			if (!(i_s < s.len && !(s.str[ i_s] == '-' || s.str[ i_s] == '+') && (s.str[ i_s] > '9' || s.str[ i_s] < '0'))) break;
			buf[i_d] = s.str[ i_s];
			i_s++;
			i_d++;
		}
		if (i_s < s.len && (s.str[ i_s] == '-' || s.str[ i_s] == '+')) {
			buf[i_d] = s.str[ i_s];
			i_s++;
			i_d++;
		}
		for (;;) {
			if (!(i_s < s.len && s.str[ i_s] >= '0' && s.str[ i_s] <= '9')) break;
			buf[i_d] = s.str[ i_s];
			i_s++;
			i_d++;
		}
		if (i_s < s.len && s.str[ i_s] == '.') {
			int i_s1 = (int)(i_s + 1);
			int sum = 0;
			int i_s2 = i_s1;
			for (;;) {
				if (!(i_s1 < s.len && s.str[ i_s1] >= '0' && s.str[ i_s1] <= '9')) break;
				sum += (u8)(s.str[ i_s1] - ((u8)('0')));
				if (s.str[ i_s1] != '0') {
					i_s2 = i_s1;
				}
				i_s1++;
			}
			if (sum > 0) {
				for (int c_i = i_s; c_i < (int)(i_s2 + 1); ++c_i) {
					buf[i_d] = s.str[ c_i];
					i_d++;
				}
			}
			i_s = i_s1;
		}
		if (i_s < s.len && s.str[ i_s] != '.') {
			for (;;) {
				buf[i_d] = s.str[ i_s];
				i_s++;
				i_d++;
				if (i_s >= s.len) {
					break;
				}
			}
		}
		buf[i_d] = 0;
		return builtin__tos(buf, i_d);
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
inline string strconv__ftoa_64(f64 f) {
	return strconv__f64_to_str(f, 17);
}
inline string strconv__ftoa_long_64(f64 f) {
	return strconv__f64_to_str_l(f);
}
inline string strconv__ftoa_32(f32 f) {
	return strconv__f32_to_str(f, 8);
}
inline string strconv__ftoa_long_32(f32 f) {
	return strconv__f32_to_str_l(f);
}
string strconv__format_int(i64 n, int radix) {
	{ // Unsafe block
		if (radix < 2 || radix > 36) {
			builtin__panic_n(_S("invalid radix, it should be => 2 and <= 36, actual:"), radix);
			VUNREACHABLE();
		}
		if (n == 0) {
			return _S("0");
		}
		i64 n_copy = n;
		bool have_minus = false;
		if (n < 0) {
			have_minus = true;
			n_copy = -n_copy;
		}
		string res = _S("");
		for (;;) {
			if (!(n_copy != 0)) break;
			string tmp_0 = res;
			int bdx = ((int)((i64)(n_copy % radix)));
			string tmp_1 = builtin__u8_ascii_str(_const_strconv__base_digits.str[ bdx]);
			res = builtin__string__plus(tmp_1, res);
			builtin__string_free(&tmp_0);
			builtin__string_free(&tmp_1);
			n_copy /= radix;
		}
		if (have_minus) {
			string final_res = builtin__string__plus(_S("-"), res);
			builtin__string_free(&res);
			return final_res;
		}
		return res;
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
string strconv__format_uint(u64 n, int radix) {
	{ // Unsafe block
		if (radix < 2 || radix > 36) {
			builtin__panic_n(_S("invalid radix, it should be => 2 and <= 36, actual:"), radix);
			VUNREACHABLE();
		}
		if (n == 0) {
			return _S("0");
		}
		u64 n_copy = n;
		string res = _S("");
		u64 uradix = ((u64)(radix));
		for (;;) {
			if (!(n_copy != 0)) break;
			string tmp_0 = res;
			string tmp_1 = builtin__u8_ascii_str(_const_strconv__base_digits.str[ (u64)(n_copy % uradix)]);
			res = builtin__string__plus(tmp_1, res);
			builtin__string_free(&tmp_0);
			builtin__string_free(&tmp_1);
			n_copy /= uradix;
		}
		return res;
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
string strconv__f32_to_str_l(f32 f) {
	string s = strconv__f32_to_str(f, 8);
	string res = strconv__fxx_to_str_l_parse(s);
	builtin__string_free(&s);
	return res;
}
string strconv__f32_to_str_l_with_dot(f32 f) {
	string s = strconv__f32_to_str(f, 8);
	string res = strconv__fxx_to_str_l_parse_with_dot(s);
	builtin__string_free(&s);
	return res;
}
string strconv__f64_to_str_l(f64 f) {
	string s = strconv__f64_to_str(f, 18);
	string res = strconv__fxx_to_str_l_parse(s);
	builtin__string_free(&s);
	return res;
}
string strconv__f64_to_str_l_with_dot(f64 f) {
	string s = strconv__f64_to_str(f, 18);
	string res = strconv__fxx_to_str_l_parse_with_dot(s);
	builtin__string_free(&s);
	return res;
}
string strconv__fxx_to_str_l_parse(string s) {
	if (s.len > 2 && (s.str[ 0] == 'n' || s.str[ 1] == 'i')) {
		return builtin__string_clone(s);
	}
	bool m_sgn_flag = false;
	int sgn = 1;
	Array_fixed_u8_26 b = {0};
	int d_pos = 1;
	int i = 0;
	int i1 = 0;
	int exp = 0;
	int exp_sgn = 1;
	for (int _t2 = 0; _t2 < s.len; ++_t2) {
		u8 c = s.str[_t2];
		if (c == '-') {
			sgn = -1;
			i++;
		} else if (c == '+') {
			sgn = 1;
			i++;
		} else if (c >= '0' && c <= '9') {
			b[i1] = c;
			i1++;
			i++;
		} else if (c == '.') {
			if (sgn > 0) {
				d_pos = i;
			} else {
				d_pos = (int)(i - 1);
			}
			i++;
		} else if (c == 'e') {
			i++;
			break;
		} else {
			return _S("Float conversion error!!");
		}
	}
	b[i1] = 0;
	if (s.str[ i] == '-') {
		exp_sgn = -1;
		i++;
	} else if (s.str[ i] == '+') {
		exp_sgn = 1;
		i++;
	}
	int c = i;
	for (;;) {
		if (!(c < s.len)) break;
		exp = (int)((int)(exp * 10) + ((int)((rune)(s.str[ c] - '0'))));
		c++;
	}
	Array_u8 res = builtin____new_array_with_default((int)(exp + 32), 0, sizeof(u8), &(u8[]){0});
	int r_i = 0;
	if (sgn == 1) {
		if (m_sgn_flag) {
			((u8*)res.data)[r_i] = '+';
			r_i++;
		}
	} else {
		((u8*)res.data)[r_i] = '-';
		r_i++;
	}
	i = 0;
	if (exp_sgn >= 0) {
		for (;;) {
			if (!(b[i] != 0)) break;
			((u8*)res.data)[r_i] = b[i];
			r_i++;
			i++;
			if (i >= d_pos && exp >= 0) {
				if (exp == 0) {
					((u8*)res.data)[r_i] = '.';
					r_i++;
				}
				exp--;
			}
		}
		for (;;) {
			if (!(exp >= 0)) break;
			((u8*)res.data)[r_i] = '0';
			r_i++;
			exp--;
		}
	} else {
		bool dot_p = true;
		for (;;) {
			if (!(exp > 0)) break;
			((u8*)res.data)[r_i] = '0';
			r_i++;
			exp--;
			if (dot_p) {
				((u8*)res.data)[r_i] = '.';
				r_i++;
				dot_p = false;
			}
		}
		for (;;) {
			if (!(b[i] != 0)) break;
			((u8*)res.data)[r_i] = b[i];
			r_i++;
			i++;
		}
	}
	if (r_i > 1 && ((u8*)res.data)[(int)(r_i - 1)] == '.') {
		((u8*)res.data)[r_i] = '0';
		r_i++;
	} else if (!(Array_u8_contains(res, '.'))) {
		((u8*)res.data)[r_i] = '.';
		r_i++;
		((u8*)res.data)[r_i] = '0';
		r_i++;
	}
	((u8*)res.data)[r_i] = 0;
	return builtin__tos(res.data, r_i);
}
string strconv__fxx_to_str_l_parse_with_dot(string s) {
	if (s.len > 2 && (s.str[ 0] == 'n' || s.str[ 1] == 'i')) {
		return builtin__string_clone(s);
	}
	bool m_sgn_flag = false;
	int sgn = 1;
	Array_fixed_u8_26 b = {0};
	int d_pos = 1;
	int i = 0;
	int i1 = 0;
	int exp = 0;
	int exp_sgn = 1;
	for (int _t2 = 0; _t2 < s.len; ++_t2) {
		u8 c = s.str[_t2];
		if (c == '-') {
			sgn = -1;
			i++;
		} else if (c == '+') {
			sgn = 1;
			i++;
		} else if (c >= '0' && c <= '9') {
			b[i1] = c;
			i1++;
			i++;
		} else if (c == '.') {
			if (sgn > 0) {
				d_pos = i;
			} else {
				d_pos = (int)(i - 1);
			}
			i++;
		} else if (c == 'e') {
			i++;
			break;
		} else {
			return _S("Float conversion error!!");
		}
	}
	b[i1] = 0;
	if (s.str[ i] == '-') {
		exp_sgn = -1;
		i++;
	} else if (s.str[ i] == '+') {
		exp_sgn = 1;
		i++;
	}
	int c = i;
	for (;;) {
		if (!(c < s.len)) break;
		exp = (int)((int)(exp * 10) + ((int)((rune)(s.str[ c] - '0'))));
		c++;
	}
	Array_u8 res = builtin____new_array_with_default((int)(exp + 32), 0, sizeof(u8), &(u8[]){0});
	int r_i = 0;
	if (sgn == 1) {
		if (m_sgn_flag) {
			((u8*)res.data)[r_i] = '+';
			r_i++;
		}
	} else {
		((u8*)res.data)[r_i] = '-';
		r_i++;
	}
	i = 0;
	if (exp_sgn >= 0) {
		for (;;) {
			if (!(b[i] != 0)) break;
			((u8*)res.data)[r_i] = b[i];
			r_i++;
			i++;
			if (i >= d_pos && exp >= 0) {
				if (exp == 0) {
					((u8*)res.data)[r_i] = '.';
					r_i++;
				}
				exp--;
			}
		}
		for (;;) {
			if (!(exp >= 0)) break;
			((u8*)res.data)[r_i] = '0';
			r_i++;
			exp--;
		}
	} else {
		bool dot_p = true;
		for (;;) {
			if (!(exp > 0)) break;
			((u8*)res.data)[r_i] = '0';
			r_i++;
			exp--;
			if (dot_p) {
				((u8*)res.data)[r_i] = '.';
				r_i++;
				dot_p = false;
			}
		}
		for (;;) {
			if (!(b[i] != 0)) break;
			((u8*)res.data)[r_i] = b[i];
			r_i++;
			i++;
		}
	}
	if (r_i > 1 && ((u8*)res.data)[(int)(r_i - 1)] == '.') {
		((u8*)res.data)[r_i] = '0';
		r_i++;
	} else if (!(Array_u8_contains(res, '.'))) {
		((u8*)res.data)[r_i] = '.';
		r_i++;
		((u8*)res.data)[r_i] = '0';
		r_i++;
	}
	((u8*)res.data)[r_i] = 0;
	return builtin__tos(res.data, r_i);
}
inline VV_LOC u32 strconv__bool_to_u32(bool b) {
	if (b) {
		return ((u32)(1));
	}
	return ((u32)(0));
}
inline VV_LOC u64 strconv__bool_to_u64(bool b) {
	if (b) {
		return ((u64)(1));
	}
	return ((u64)(0));
}
VV_LOC string strconv__get_string_special(bool neg, bool expZero, bool mantZero) {
	if (!mantZero) {
		return _S("nan");
	}
	if (!expZero) {
		if (neg) {
			return _S("-inf");
		} else {
			return _S("+inf");
		}
	}
	if (neg) {
		return _S("-0e+00");
	}
	return _S("0e+00");
}
VV_LOC u32 strconv__mul_shift_32(u32 m, u64 mul, int ishift) {
	multi_return_u64_u64 mr_750 = math__bits__mul_64(((u64)(m)), mul);
	u64 hi = mr_750.arg0;
	u64 lo = mr_750.arg1;
	u64 shifted_sum = (u64)(((lo >> ((u64)(ishift)))) + ((hi << ((u64)((int)(64 - ishift))))));
	;
	return ((u32)(shifted_sum));
}
inline VV_LOC u32 strconv__mul_pow5_invdiv_pow2(u32 m, u32 q, int j) {
	;
	return strconv__mul_shift_32(m, _const_strconv__pow5_inv_split_32[q], j);
}
inline VV_LOC u32 strconv__mul_pow5_div_pow2(u32 m, u32 i, int j) {
	;
	return strconv__mul_shift_32(m, _const_strconv__pow5_split_32[i], j);
}
VV_LOC u32 strconv__pow5_factor_32(u32 i_v) {
	u32 v = i_v;
	for (u32 n = ((u32)(0)); true; n++) {
		u32 q = (u32)(v / 5);
		u32 r = (u32)(v % 5);
		if (r != 0) {
			return n;
		}
		v = q;
	}
	return v;
}
VV_LOC bool strconv__multiple_of_power_of_five_32(u32 v, u32 p) {
	return strconv__pow5_factor_32(v) >= p;
}
VV_LOC bool strconv__multiple_of_power_of_two_32(u32 v, u32 p) {
	return ((u32)(math__bits__trailing_zeros_32(v))) >= p;
}
VV_LOC u32 strconv__log10_pow2(int e) {
	;
	;
	return (((u32)(((u32)(e)) * 78913)) >> 18);
}
VV_LOC u32 strconv__log10_pow5(int e) {
	;
	;
	return (((u32)(((u32)(e)) * 732923)) >> 20);
}
VV_LOC int strconv__pow5_bits(int e) {
	;
	;
	return ((int)((u32)(((((u32)(((u32)(e)) * 1217359)) >> 19)) + 1)));
}
VV_LOC u64 strconv__shift_right_128(strconv__Uint128 v, int shift) {
	;
	return (((v.hi << ((u64)((int)(64 - shift))))) | ((v.lo >> ((u32)(shift)))));
}
VV_LOC u64 strconv__mul_shift_64(u64 m, strconv__Uint128 mul, int shift) {
	multi_return_u64_u64 mr_3253 = math__bits__mul_64(m, mul.hi);
	u64 hihi = mr_3253.arg0;
	u64 hilo = mr_3253.arg1;
	multi_return_u64_u64 mr_3288 = math__bits__mul_64(m, mul.lo);
	u64 lohi = mr_3288.arg0;
	strconv__Uint128 sum = ((strconv__Uint128){.lo = (u64)(lohi + hilo),.hi = hihi,});
	if (sum.lo < lohi) {
		sum.hi++;
	}
	return strconv__shift_right_128(sum, (int)(shift - 64));
}
VV_LOC u32 strconv__pow5_factor_64(u64 v_i) {
	u64 v = v_i;
	for (u32 n = ((u32)(0)); true; n++) {
		u64 q = (u64)(v / 5);
		u64 r = (u64)(v % 5);
		if (r != 0) {
			return n;
		}
		v = q;
	}
	return ((u32)(0));
}
VV_LOC bool strconv__multiple_of_power_of_five_64(u64 v, u32 p) {
	return strconv__pow5_factor_64(v) >= p;
}
VV_LOC bool strconv__multiple_of_power_of_two_64(u64 v, u32 p) {
	return ((u32)(math__bits__trailing_zeros_64(v))) >= p;
}
int strconv__dec_digits(u64 n) {
	if (n <= 9999999999LL) {
		if (n <= 99999) {
			if (n <= 99) {
				if (n <= 9) {
					return 1;
				} else {
					return 2;
				}
			} else {
				if (n <= 999) {
					return 3;
				} else {
					if (n <= 9999) {
						return 4;
					} else {
						return 5;
					}
				}
			}
		} else {
			if (n <= 9999999) {
				if (n <= 999999) {
					return 6;
				} else {
					return 7;
				}
			} else {
				if (n <= 99999999) {
					return 8;
				} else {
					if (n <= 999999999) {
						return 9;
					}
					return 10;
				}
			}
		}
	} else {
		if (n <= 999999999999999LL) {
			if (n <= 999999999999LL) {
				if (n <= 99999999999LL) {
					return 11;
				} else {
					return 12;
				}
			} else {
				if (n <= 9999999999999LL) {
					return 13;
				} else {
					if (n <= 99999999999999LL) {
						return 14;
					} else {
						return 15;
					}
				}
			}
		} else {
			if (n <= 99999999999999999LL) {
				if (n <= 9999999999999999LL) {
					return 16;
				} else {
					return 17;
				}
			} else {
				if (n <= 999999999999999999LL) {
					return 18;
				} else {
					if (n <= 9999999999999999999ULL) {
						return 19;
					}
					return 20;
				}
			}
		}
	}
	return 0;
}
void strconv__v_printf(string str, Array_voidptr pt) {
	builtin__print(strconv__v_sprintf(str, pt));
}
string strconv__v_sprintf(string str, Array_voidptr pt) {
	strings__Builder res = strings__new_builder((int)(pt.len * 16));
	int i = 0;
	int p_index = 0;
	bool sign = false;
	strconv__Align_text align = strconv__Align_text__right;
	int len0 = -1;
	int len1 = -1;
	int def_len1 = 6;
	u8 pad_ch = ((u8)(' '));
	rune ch1 = '0';
	rune ch2 = '0';
	strconv__Char_parse_state status = strconv__Char_parse_state__norm_char;
	for (;;) {
		if (!(i < str.len)) break;
		if (status == strconv__Char_parse_state__reset_params) {
			sign = false;
			align = strconv__Align_text__right;
			len0 = -1;
			len1 = -1;
			pad_ch = ' ';
			status = strconv__Char_parse_state__norm_char;
			ch1 = '0';
			ch2 = '0';
			continue;
		}
		u8 ch = str.str[ i];
		if (ch != '%' && status == strconv__Char_parse_state__norm_char) {
			strings__Builder_write_u8(&res, ch);
			i++;
			continue;
		}
		if (ch == '%' && status == strconv__Char_parse_state__field_char) {
			status = strconv__Char_parse_state__norm_char;
			strings__Builder_write_u8(&res, ch);
			i++;
			continue;
		}
		if (ch == '%' && status == strconv__Char_parse_state__norm_char) {
			status = strconv__Char_parse_state__field_char;
			i++;
			continue;
		}
		if (ch == 'c' && status == strconv__Char_parse_state__field_char) {
			strconv__v_sprintf_panic(p_index, pt.len);
			u8 d1 = *(((u8*)(((voidptr*)pt.data)[p_index])));
			strings__Builder_write_u8(&res, d1);
			status = strconv__Char_parse_state__reset_params;
			p_index++;
			i++;
			continue;
		}
		if (ch == 'p' && status == strconv__Char_parse_state__field_char) {
			strconv__v_sprintf_panic(p_index, pt.len);
			strings__Builder_write_string(&res, _S("0x"));
			strings__Builder_write_string(&res, builtin__ptr_str(((voidptr*)pt.data)[p_index]));
			status = strconv__Char_parse_state__reset_params;
			p_index++;
			i++;
			continue;
		}
		if (status == strconv__Char_parse_state__field_char) {
			rune fc_ch1 = '0';
			rune fc_ch2 = '0';
			if (((int)(i + 1)) < str.len) {
				fc_ch1 = str.str[ (int)(i + 1)];
				if (((int)(i + 2)) < str.len) {
					fc_ch2 = str.str[ (int)(i + 2)];
				}
			}
			if (ch == '+') {
				sign = true;
				i++;
				continue;
			} else if (ch == '-') {
				align = strconv__Align_text__left;
				i++;
				continue;
			} else if (ch == '0' || ch == ' ') {
				if (align == strconv__Align_text__right) {
					pad_ch = ch;
				}
				i++;
				continue;
			} else if (ch == '\'') {
				i++;
				continue;
			} else if (ch == '.' && fc_ch1 >= '1' && fc_ch1 <= '9') {
				status = strconv__Char_parse_state__check_float;
				i++;
				continue;
			} else if (ch == '.' && fc_ch1 == '*' && fc_ch2 == 's') {
				strconv__v_sprintf_panic(p_index, pt.len);
				int len = *(((int*)(((voidptr*)pt.data)[p_index])));
				p_index++;
				strconv__v_sprintf_panic(p_index, pt.len);
				string s = *(((string*)(((voidptr*)pt.data)[p_index])));
				s = builtin__string_substr(s, 0, len);
				p_index++;
				strings__Builder_write_string(&res, s);
				status = strconv__Char_parse_state__reset_params;
				i += 3;
				continue;
			}
			status = strconv__Char_parse_state__len_set_start;
			continue;
		}
		if (status == strconv__Char_parse_state__len_set_start) {
			if (ch >= '1' && ch <= '9') {
				len0 = ((int)((rune)(ch - '0')));
				status = strconv__Char_parse_state__len_set_in;
				i++;
				continue;
			}
			if (ch == '.') {
				status = strconv__Char_parse_state__check_float;
				i++;
				continue;
			}
			status = strconv__Char_parse_state__check_type;
			continue;
		}
		if (status == strconv__Char_parse_state__len_set_in) {
			if (ch >= '0' && ch <= '9') {
				len0 *= 10;
				len0 += ((int)((rune)(ch - '0')));
				i++;
				continue;
			}
			if (ch == '.') {
				status = strconv__Char_parse_state__check_float;
				i++;
				continue;
			}
			status = strconv__Char_parse_state__check_type;
			continue;
		}
		if (status == strconv__Char_parse_state__check_float) {
			if (ch >= '0' && ch <= '9') {
				len1 = ((int)((rune)(ch - '0')));
				status = strconv__Char_parse_state__check_float_in;
				i++;
				continue;
			}
			status = strconv__Char_parse_state__check_type;
			continue;
		}
		if (status == strconv__Char_parse_state__check_float_in) {
			if (ch >= '0' && ch <= '9') {
				len1 *= 10;
				len1 += ((int)((rune)(ch - '0')));
				i++;
				continue;
			}
			status = strconv__Char_parse_state__check_type;
			continue;
		}
		if (status == strconv__Char_parse_state__check_type) {
			if (ch == 'l') {
				if (ch1 == '0') {
					ch1 = 'l';
					i++;
					continue;
				} else {
					ch2 = 'l';
					i++;
					continue;
				}
			} else if (ch == 'h') {
				if (ch1 == '0') {
					ch1 = 'h';
					i++;
					continue;
				} else {
					ch2 = 'h';
					i++;
					continue;
				}
			} else if (ch == 'd' || ch == 'i') {
				u64 d1 = ((u64)(0));
				bool positive = true;

				if (ch1 == ('h')) {
					if (ch2 == 'h') {
						strconv__v_sprintf_panic(p_index, pt.len);
						i8 x = *(((i8*)(((voidptr*)pt.data)[p_index])));
						positive = (x >= 0 ? (true) : (false));
						d1 = (positive ? (((u64)(x))) : (((u64)(-x))));
					} else {
						i16 x = *(((i16*)(((voidptr*)pt.data)[p_index])));
						positive = (x >= 0 ? (true) : (false));
						d1 = (positive ? (((u64)(x))) : (((u64)(-x))));
					}
				}
				else if (ch1 == ('l')) {
					strconv__v_sprintf_panic(p_index, pt.len);
					i64 x = *(((i64*)(((voidptr*)pt.data)[p_index])));
					positive = (x >= 0 ? (true) : (false));
					d1 = (positive ? (((u64)(x))) : (((u64)(-x))));
				}
				else {
					strconv__v_sprintf_panic(p_index, pt.len);
					int x = *(((int*)(((voidptr*)pt.data)[p_index])));
					positive = (x >= 0 ? (true) : (false));
					d1 = (positive ? (((u64)(x))) : (((u64)(-x))));
				}
				string tmp = strconv__format_dec_old(d1, ((strconv__BF_param){
					.pad_ch = pad_ch,
					.len0 = len0,
					.len1 = 0,
					.positive = positive,
					.sign_flag = sign,
					.align = align,
					.rm_tail_zero = 0,
				}));
				strings__Builder_write_string(&res, tmp);
				builtin__string_free(&tmp);
				status = strconv__Char_parse_state__reset_params;
				p_index++;
				i++;
				ch1 = '0';
				ch2 = '0';
				continue;
			} else if (ch == 'u') {
				u64 d1 = ((u64)(0));
				bool positive = true;
				strconv__v_sprintf_panic(p_index, pt.len);

				if (ch1 == ('h')) {
					if (ch2 == 'h') {
						d1 = ((u64)(*(((u8*)(((voidptr*)pt.data)[p_index])))));
					} else {
						d1 = ((u64)(*(((u16*)(((voidptr*)pt.data)[p_index])))));
					}
				}
				else if (ch1 == ('l')) {
					d1 = ((u64)(*(((u64*)(((voidptr*)pt.data)[p_index])))));
				}
				else {
					d1 = ((u64)(*(((u32*)(((voidptr*)pt.data)[p_index])))));
				}
				string tmp = strconv__format_dec_old(d1, ((strconv__BF_param){
					.pad_ch = pad_ch,
					.len0 = len0,
					.len1 = 0,
					.positive = positive,
					.sign_flag = sign,
					.align = align,
					.rm_tail_zero = 0,
				}));
				strings__Builder_write_string(&res, tmp);
				builtin__string_free(&tmp);
				status = strconv__Char_parse_state__reset_params;
				p_index++;
				i++;
				continue;
			} else if (ch == 'x' || ch == 'X') {
				strconv__v_sprintf_panic(p_index, pt.len);
				string s = _S("");

				if (ch1 == ('h')) {
					if (ch2 == 'h') {
						i8 x = *(((i8*)(((voidptr*)pt.data)[p_index])));
						s = builtin__i8_hex(x);
					} else {
						i16 x = *(((i16*)(((voidptr*)pt.data)[p_index])));
						s = builtin__i16_hex(x);
					}
				}
				else if (ch1 == ('l')) {
					i64 x = *(((i64*)(((voidptr*)pt.data)[p_index])));
					s = builtin__i64_hex(x);
				}
				else {
					int x = *(((int*)(((voidptr*)pt.data)[p_index])));
					s = builtin__int_hex(x);
				}
				if (ch == 'X') {
					string tmp = s;
					s = builtin__string_to_upper(s);
					builtin__string_free(&tmp);
				}
				string tmp = strconv__format_str(s, ((strconv__BF_param){
					.pad_ch = pad_ch,
					.len0 = len0,
					.len1 = 0,
					.positive = true,
					.sign_flag = false,
					.align = align,
					.rm_tail_zero = 0,
				}));
				strings__Builder_write_string(&res, tmp);
				builtin__string_free(&tmp);
				builtin__string_free(&s);
				status = strconv__Char_parse_state__reset_params;
				p_index++;
				i++;
				continue;
			}
			if (ch == 'f' || ch == 'F') {
				#if !defined(CUSTOM_DEFINE_nofloat)
				{
					strconv__v_sprintf_panic(p_index, pt.len);
					f64 x = *(((f64*)(((voidptr*)pt.data)[p_index])));
					bool positive = x >= ((f64)(0.0));
					len1 = (len1 >= 0 ? (len1) : (def_len1));
					string s = strconv__format_fl_old(((f64)(x)), ((strconv__BF_param){
						.pad_ch = pad_ch,
						.len0 = len0,
						.len1 = len1,
						.positive = positive,
						.sign_flag = sign,
						.align = align,
						.rm_tail_zero = 0,
					}));
					if (ch == 'F') {
						string tmp = builtin__string_to_upper(s);
						strings__Builder_write_string(&res, tmp);
						builtin__string_free(&tmp);
					} else {
						strings__Builder_write_string(&res, s);
					}
					builtin__string_free(&s);
				}
				#endif
				status = strconv__Char_parse_state__reset_params;
				p_index++;
				i++;
				continue;
			} else if (ch == 'e' || ch == 'E') {
				#if !defined(CUSTOM_DEFINE_nofloat)
				{
					strconv__v_sprintf_panic(p_index, pt.len);
					f64 x = *(((f64*)(((voidptr*)pt.data)[p_index])));
					bool positive = x >= ((f64)(0.0));
					len1 = (len1 >= 0 ? (len1) : (def_len1));
					string s = strconv__format_es_old(((f64)(x)), ((strconv__BF_param){
						.pad_ch = pad_ch,
						.len0 = len0,
						.len1 = len1,
						.positive = positive,
						.sign_flag = sign,
						.align = align,
						.rm_tail_zero = 0,
					}));
					if (ch == 'E') {
						string tmp = builtin__string_to_upper(s);
						strings__Builder_write_string(&res, tmp);
						builtin__string_free(&tmp);
					} else {
						strings__Builder_write_string(&res, s);
					}
					builtin__string_free(&s);
				}
				#endif
				status = strconv__Char_parse_state__reset_params;
				p_index++;
				i++;
				continue;
			} else if (ch == 'g' || ch == 'G') {
				#if !defined(CUSTOM_DEFINE_nofloat)
				{
					strconv__v_sprintf_panic(p_index, pt.len);
					f64 x = *(((f64*)(((voidptr*)pt.data)[p_index])));
					bool positive = x >= ((f64)(0.0));
					string s = _S("");
					f64 tx = strconv__fabs(x);
					if (tx < ((f64)(999999.0)) && tx >= ((f64)(0.00001))) {
						len1 = (len1 >= 0 ? ((int)(len1 + 1)) : (def_len1));
						string tmp = s;
						s = strconv__format_fl_old(x, ((strconv__BF_param){
							.pad_ch = pad_ch,
							.len0 = len0,
							.len1 = len1,
							.positive = positive,
							.sign_flag = sign,
							.align = align,
							.rm_tail_zero = true,
						}));
						builtin__string_free(&tmp);
					} else {
						len1 = (len1 >= 0 ? ((int)(len1 + 1)) : (def_len1));
						string tmp = s;
						s = strconv__format_es_old(x, ((strconv__BF_param){
							.pad_ch = pad_ch,
							.len0 = len0,
							.len1 = len1,
							.positive = positive,
							.sign_flag = sign,
							.align = align,
							.rm_tail_zero = true,
						}));
						builtin__string_free(&tmp);
					}
					if (ch == 'G') {
						string tmp = builtin__string_to_upper(s);
						strings__Builder_write_string(&res, tmp);
						builtin__string_free(&tmp);
					} else {
						strings__Builder_write_string(&res, s);
					}
					builtin__string_free(&s);
				}
				#endif
				status = strconv__Char_parse_state__reset_params;
				p_index++;
				i++;
				continue;
			} else if (ch == 's') {
				strconv__v_sprintf_panic(p_index, pt.len);
				string s1 = *(((string*)(((voidptr*)pt.data)[p_index])));
				pad_ch = ' ';
				string tmp = strconv__format_str(s1, ((strconv__BF_param){
					.pad_ch = pad_ch,
					.len0 = len0,
					.len1 = 0,
					.positive = true,
					.sign_flag = false,
					.align = align,
					.rm_tail_zero = 0,
				}));
				strings__Builder_write_string(&res, tmp);
				builtin__string_free(&tmp);
				status = strconv__Char_parse_state__reset_params;
				p_index++;
				i++;
				continue;
			}
		}
		status = strconv__Char_parse_state__reset_params;
		p_index++;
		i++;
	}
	if (p_index != pt.len) {
		builtin__panic_n2(_S("% conversion specifiers number mismatch (expected %, given args)"), p_index, pt.len);
		VUNREACHABLE();
	}
	string _t4 = strings__Builder_str(&res);
		{ // defer begin
			strings__Builder_free(&res);
		} // defer end
	return _t4;
}
inline VV_LOC void strconv__v_sprintf_panic(int idx, int len) {
	if (idx >= len) {
		builtin__panic_n2(_S("% conversion specifiers number mismatch (expected %, given args)"), (int)(idx + 1), len);
		VUNREACHABLE();
	}
}
VV_LOC f64 strconv__fabs(f64 x) {
	if (x < ((f64)(0.0))) {
		return -x;
	}
	return x;
}
string strconv__format_fl_old(f64 f, strconv__BF_param p) {
	{ // Unsafe block
		string s = _S("");
		string fs = strconv__f64_to_str_lnd1((f >= ((f64)(0.0)) ? (f) : (-f)), p.len1);
		if (fs.str[ 0] == '[') {
			builtin__string_free(&s);
			return fs;
		}
		if (p.rm_tail_zero) {
			string tmp = fs;
			fs = strconv__remove_tail_zeros_old(fs);
			builtin__string_free(&tmp);
		}
		strings__Builder res = strings__new_builder((p.len0 > fs.len ? (p.len0) : (fs.len)));
		int sign_len_diff = 0;
		if (p.pad_ch == '0') {
			if (p.positive) {
				if (p.sign_flag) {
					strings__Builder_write_u8(&res, '+');
					sign_len_diff = -1;
				}
			} else {
				strings__Builder_write_u8(&res, '-');
				sign_len_diff = -1;
			}
			string tmp = s;
			s = builtin__string_clone(fs);
			builtin__string_free(&tmp);
		} else {
			if (p.positive) {
				if (p.sign_flag) {
					string tmp = s;
					s = builtin__string__plus(_S("+"), fs);
					builtin__string_free(&tmp);
				} else {
					string tmp = s;
					s = builtin__string_clone(fs);
					builtin__string_free(&tmp);
				}
			} else {
				string tmp = s;
				s = builtin__string__plus(_S("-"), fs);
				builtin__string_free(&tmp);
			}
		}
		int dif = (int)((int)(p.len0 - s.len) + sign_len_diff);
		if (p.align == strconv__Align_text__right) {
			for (int i1 = 0; i1 < dif; i1++) {
				strings__Builder_write_u8(&res, p.pad_ch);
			}
		}
		strings__Builder_write_string(&res, s);
		if (p.align == strconv__Align_text__left) {
			for (int i1 = 0; i1 < dif; i1++) {
				strings__Builder_write_u8(&res, p.pad_ch);
			}
		}
		builtin__string_free(&s);
		builtin__string_free(&fs);
		string _t2 = strings__Builder_str(&res);
			{ // defer begin
				strings__Builder_free(&res);
			} // defer end
		return _t2;
		{ // defer begin
			strings__Builder_free(&res);
		} // defer end
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
VV_LOC string strconv__format_es_old(f64 f, strconv__BF_param p) {
	{ // Unsafe block
		string s = _S("");
		string fs = strconv__f64_to_str_pad((f > 0 ? (f) : (-f)), p.len1);
		if (p.rm_tail_zero) {
			string tmp = fs;
			fs = strconv__remove_tail_zeros_old(fs);
			builtin__string_free(&tmp);
		}
		strings__Builder res = strings__new_builder((p.len0 > fs.len ? (p.len0) : (fs.len)));
		int sign_len_diff = 0;
		if (p.pad_ch == '0') {
			if (p.positive) {
				if (p.sign_flag) {
					strings__Builder_write_u8(&res, '+');
					sign_len_diff = -1;
				}
			} else {
				strings__Builder_write_u8(&res, '-');
				sign_len_diff = -1;
			}
			string tmp = s;
			s = builtin__string_clone(fs);
			builtin__string_free(&tmp);
		} else {
			if (p.positive) {
				if (p.sign_flag) {
					string tmp = s;
					s = builtin__string__plus(_S("+"), fs);
					builtin__string_free(&tmp);
				} else {
					string tmp = s;
					s = builtin__string_clone(fs);
					builtin__string_free(&tmp);
				}
			} else {
				string tmp = s;
				s = builtin__string__plus(_S("-"), fs);
				builtin__string_free(&tmp);
			}
		}
		int dif = (int)((int)(p.len0 - s.len) + sign_len_diff);
		if (p.align == strconv__Align_text__right) {
			for (int i1 = 0; i1 < dif; i1++) {
				strings__Builder_write_u8(&res, p.pad_ch);
			}
		}
		strings__Builder_write_string(&res, s);
		if (p.align == strconv__Align_text__left) {
			for (int i1 = 0; i1 < dif; i1++) {
				strings__Builder_write_u8(&res, p.pad_ch);
			}
		}
		string _t1 = strings__Builder_str(&res);
			{ // defer begin
				strings__Builder_free(&res);
				builtin__string_free(&fs);
				builtin__string_free(&s);
			} // defer end
		return _t1;
		{ // defer begin
			strings__Builder_free(&res);
			builtin__string_free(&fs);
			builtin__string_free(&s);
		} // defer end
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
VV_LOC string strconv__remove_tail_zeros_old(string s) {
	int i = 0;
	int last_zero_start = -1;
	int dot_pos = -1;
	bool in_decimal = false;
	u8 prev_ch = ((u8)(0));
	for (;;) {
		if (!(i < s.len)) break;
		u8 ch = s.str[i];
		if (ch == '.') {
			in_decimal = true;
			dot_pos = i;
		} else if (in_decimal) {
			if (ch == '0' && prev_ch != '0') {
				last_zero_start = i;
			} else if (ch >= '1' && ch <= '9') {
				last_zero_start = -1;
			} else if (ch == 'e') {
				break;
			}
		}
		prev_ch = ch;
		i++;
	}
	string tmp = _S("");
	if (last_zero_start > 0) {
		if (last_zero_start == (int)(dot_pos + 1)) {
			tmp = builtin__string__plus(builtin__string_substr(s, 0, dot_pos), builtin__string_substr(s, i, 2147483647));
		} else {
			tmp = builtin__string__plus(builtin__string_substr(s, 0, last_zero_start), builtin__string_substr(s, i, 2147483647));
		}
	} else {
		tmp = builtin__string_clone(s);
	}
	if (tmp.str[(int)(tmp.len - 1)] == '.') {
		return builtin__string_substr(tmp, 0, (int)(tmp.len - 1));
	}
	return tmp;
}
string strconv__format_dec_old(u64 d, strconv__BF_param p) {
	string s = _S("");
	strings__Builder res = strings__new_builder(20);
	int sign_len_diff = 0;
	if (p.pad_ch == '0') {
		if (p.positive) {
			if (p.sign_flag) {
				strings__Builder_write_u8(&res, '+');
				sign_len_diff = -1;
			}
		} else {
			strings__Builder_write_u8(&res, '-');
			sign_len_diff = -1;
		}
		string tmp = s;
		s = builtin__u64_str(d);
		builtin__string_free(&tmp);
	} else {
		if (p.positive) {
			if (p.sign_flag) {
				string tmp = s;
				s = builtin__string__plus(_S("+"), builtin__u64_str(d));
				builtin__string_free(&tmp);
			} else {
				string tmp = s;
				s = builtin__u64_str(d);
				builtin__string_free(&tmp);
			}
		} else {
			string tmp = s;
			s = builtin__string__plus(_S("-"), builtin__u64_str(d));
			builtin__string_free(&tmp);
		}
	}
	int dif = (int)((int)(p.len0 - s.len) + sign_len_diff);
	if (p.align == strconv__Align_text__right) {
		for (int i1 = 0; i1 < dif; i1++) {
			strings__Builder_write_u8(&res, p.pad_ch);
		}
	}
	strings__Builder_write_string(&res, s);
	if (p.align == strconv__Align_text__left) {
		for (int i1 = 0; i1 < dif; i1++) {
			strings__Builder_write_u8(&res, p.pad_ch);
		}
	}
	string _t1 = strings__Builder_str(&res);
		{ // defer begin
			strings__Builder_free(&res);
			builtin__string_free(&s);
		} // defer end
	return _t1;
}
VNORETURN VV_LOC void builtin___memory_panic(string fname, isize size) {
	v_memory_panic = true;
	builtin__eprint(fname);
	builtin__eprint(_S("("));
	#if defined(_VFREESTANDING) || defined(__vinix__)
	{
	}
	#else
	{
		fprintf(stderr, "%p", ((voidptr)(size)));
	}
	#endif
	if (size < 0) {
		builtin__eprint(_S(" < 0"));
	}
	builtin__eprintln(_S(")"));
	builtin___v_panic(_S("memory allocation failure"));
	VUNREACHABLE();
	while(1);
}
u8* builtin___v_malloc(isize n) {
	if (n < 0) {
		builtin___memory_panic(_S("malloc"), n);
		VUNREACHABLE();
	} else if (n == 0) {
		return ((u8*)(((void*)0)));
	}
	u8* res = ((u8*)(((void*)0)));
	#if defined(_VPREALLOC)
	{
	}
	#elif defined(CUSTOM_DEFINE_gcboehm)
	{
	}
	#elif defined(_VFREESTANDING)
	{
	}
	#else
	{
		#if defined(_WIN32)
		{
		}
		#else
		{
			res = malloc(n);
		}
		#endif
	}
	#endif
	if (res == 0) {
		builtin___memory_panic(_S("malloc"), n);
		VUNREACHABLE();
	}
	return res;
}
u8* builtin__malloc_noscan(isize n) {
	if (n < 0) {
		builtin___memory_panic(_S("malloc_noscan"), n);
		VUNREACHABLE();
	}
	u8* res = ((u8*)(((void*)0)));
	#if defined(_VNATIVE)
	{
	}
	#elif defined(_VPREALLOC)
	{
	}
	#elif defined(CUSTOM_DEFINE_gcboehm)
	{
	}
	#elif defined(_VFREESTANDING)
	{
	}
	#else
	{
		#if defined(_WIN32)
		{
		}
		#else
		{
			res = malloc(n);
		}
		#endif
	}
	#endif
	if (res == 0) {
		builtin___memory_panic(_S("malloc_noscan"), n);
		VUNREACHABLE();
	}
	return res;
}
inline VV_LOC u64 builtin____at_least_one(u64 how_many) {
	if (how_many == 0) {
		return 1;
	}
	return how_many;
}
u8* builtin__malloc_uncollectable(isize n) {
	if (n < 0) {
		builtin___memory_panic(_S("malloc_uncollectable"), n);
		VUNREACHABLE();
	}
	u8* res = ((u8*)(((void*)0)));
	#if defined(_VPREALLOC)
	{
	}
	#elif defined(CUSTOM_DEFINE_gcboehm)
	{
	}
	#elif defined(_VFREESTANDING)
	{
	}
	#else
	{
		#if defined(_WIN32)
		{
		}
		#else
		{
			res = malloc(n);
		}
		#endif
	}
	#endif
	if (res == 0) {
		builtin___memory_panic(_S("malloc_uncollectable"), n);
		VUNREACHABLE();
	}
	return res;
}
u8* builtin__v_realloc(u8* b, isize n) {
	u8* new_ptr = ((u8*)(((void*)0)));
	#if defined(_VPREALLOC)
	{
	}
	#elif defined(CUSTOM_DEFINE_gcboehm)
	{
	}
	#else
	{
		#if defined(_WIN32)
		{
		}
		#else
		{
			new_ptr = realloc(b, n);
		}
		#endif
	}
	#endif
	if (new_ptr == 0) {
		builtin___memory_panic(_S("v_realloc"), n);
		VUNREACHABLE();
	}
	return new_ptr;
}
u8* builtin__realloc_data(u8* old_data, int old_size, int new_size) {
	u8* nptr = ((u8*)(((void*)0)));
	#if defined(CUSTOM_DEFINE_gcboehm)
	{
	}
	#else
	{
		#if defined(_WIN32)
		{
		}
		#else
		{
			nptr = realloc(old_data, new_size);
		}
		#endif
	}
	#endif
	if (nptr == 0) {
		builtin___memory_panic(_S("realloc_data"), ((isize)(new_size)));
		VUNREACHABLE();
	}
	return nptr;
}
u8* builtin__vcalloc(isize n) {
	if (n < 0) {
		builtin___memory_panic(_S("vcalloc"), n);
		VUNREACHABLE();
	} else if (n == 0) {
		return ((u8*)(((void*)0)));
	}
	#if defined(_VPREALLOC)
	{
	}
	#elif defined(_VNATIVE)
	{
	}
	#elif defined(CUSTOM_DEFINE_gcboehm)
	{
	}
	#else
	{
		#if defined(_WIN32)
		{
		}
		#else
		{
			return calloc(1, n);
		}
		#endif
	}
	#endif
	return ((u8*)(((void*)0)));
}
u8* builtin__vcalloc_noscan(isize n) {
	#if defined(_VPREALLOC)
	{
	}
	#elif defined(CUSTOM_DEFINE_gcboehm)
	{
	}
	#else
	{
		return builtin__vcalloc(n);
	}
	#endif
	return ((u8*)(((void*)0)));
}
void builtin___v_free(voidptr ptr) {
	if (ptr == 0) {
		return;
	}
	#if defined(_VPREALLOC)
	{
	}
	#elif defined(CUSTOM_DEFINE_gcboehm)
	{
	}
	#else
	{
		#if defined(_WIN32)
		{
		}
		#else
		{
			free(ptr);
		}
		#endif
	}
	#endif
}
voidptr builtin__memdup(voidptr src, isize sz) {
	if (sz == 0) {
		return builtin__vcalloc(1);
	}
	{ // Unsafe block
		u8* mem = builtin___v_malloc(sz);
		return memcpy(mem, src, sz);
	}
	return 0;
}
voidptr builtin__memdup_noscan(voidptr src, isize sz) {
	if (sz == 0) {
		return builtin__vcalloc_noscan(1);
	}
	{ // Unsafe block
		u8* mem = builtin__malloc_noscan(sz);
		return memcpy(mem, src, sz);
	}
	return 0;
}
voidptr builtin__memdup_uncollectable(voidptr src, isize sz) {
	if (sz == 0) {
		return builtin__vcalloc(1);
	}
	{ // Unsafe block
		u8* mem = builtin__malloc_uncollectable(sz);
		return memcpy(mem, src, sz);
	}
	return 0;
}
voidptr builtin__memdup_align(voidptr src, isize sz, isize align) {
	if (sz == 0) {
		return builtin__vcalloc(1);
	}
	isize n = sz;
	if (n < 0) {
		builtin___memory_panic(_S("memdup_align"), n);
		VUNREACHABLE();
	}
	u8* res = ((u8*)(((void*)0)));
	#if defined(_VPREALLOC)
	{
	}
	#elif defined(CUSTOM_DEFINE_gcboehm)
	{
	}
	#elif defined(_VFREESTANDING)
	{
	}
	#else
	{
		#if defined(_WIN32)
		{
		}
		#else
		{
			res = aligned_alloc(align, n);
		}
		#endif
	}
	#endif
	if (res == 0) {
		builtin___memory_panic(_S("memdup_align"), n);
		VUNREACHABLE();
	}
	return memcpy(res, src, sz);
}
GCHeapUsage builtin__gc_heap_usage(void) {
	#if defined(CUSTOM_DEFINE_gcboehm)
	{
	}
	#else
	{
		return ((GCHeapUsage){.heap_size = 0,.free_bytes = 0,.total_bytes = 0,.unmapped_bytes = 0,.bytes_since_gc = 0,});
	}
	#endif
	return (GCHeapUsage){0};
}
usize builtin__gc_memory_use(void) {
	#if defined(CUSTOM_DEFINE_gcboehm)
	{
	}
	#else
	{
		return 0;
	}
	#endif
	return 0;
}
VV_LOC array builtin____new_array(int mylen, int cap, int elm_size) {
	builtin__panic_on_negative_len(mylen);
	builtin__panic_on_negative_cap(cap);
	int cap_ = (cap < mylen ? (mylen) : (cap));
	array arr = ((array){.data = (voidptr)builtin__vcalloc((u64)(((u64)(cap_)) * ((u64)(elm_size)))),.offset = 0,.len = mylen,.cap = cap_,.flags = 0,.element_size = elm_size,});
	return arr;
}
VV_LOC array builtin____new_array_with_default(int mylen, int cap, int elm_size, voidptr val) {
	builtin__panic_on_negative_len(mylen);
	builtin__panic_on_negative_cap(cap);
	int cap_ = (cap < mylen ? (mylen) : (cap));
	array arr = ((array){.data = 0,.offset = 0,.len = mylen,.cap = cap_,.flags = 0,.element_size = elm_size,});
	u64 total_size = (u64)(((u64)(cap_)) * ((u64)(elm_size)));
	if (cap_ > 0 && mylen == 0) {
		arr.data = builtin___v_malloc(builtin____at_least_one(total_size));
	} else {
		arr.data = builtin__vcalloc(total_size);
	}
	if (val != 0) {
		u8* eptr = ((u8*)(arr.data));
		{ // Unsafe block
			if (eptr != ((void*)0)) {
				if (arr.element_size == 1) {
					u8 byte_value = *(((u8*)(val)));
					for (int i = 0; i < arr.len; ++i) {
						eptr[i] = byte_value;
					}
				} else {
					for (int _t1 = 0; _t1 < arr.len; ++_t1) {
						builtin__vmemcpy(eptr, val, arr.element_size);
						eptr += arr.element_size;
					}
				}
			}
		}
	}
	return arr;
}
VV_LOC array builtin____new_array_with_multi_default(int mylen, int cap, int elm_size, voidptr val) {
	builtin__panic_on_negative_len(mylen);
	builtin__panic_on_negative_cap(cap);
	int cap_ = (cap < mylen ? (mylen) : (cap));
	array arr = ((array){.data = 0,.offset = 0,.len = mylen,.cap = cap_,.flags = 0,.element_size = elm_size,});
	u64 total_size = (u64)(((u64)(cap_)) * ((u64)(elm_size)));
	arr.data = builtin__vcalloc(builtin____at_least_one(total_size));
	if (val != 0) {
		u8* eptr = ((u8*)(arr.data));
		{ // Unsafe block
			if (eptr != ((void*)0)) {
				for (int i = 0; i < arr.len; ++i) {
					builtin__vmemcpy(eptr, ((charptr)(val)) + (int)(i * arr.element_size), arr.element_size);
					eptr += arr.element_size;
				}
			}
		}
	}
	return arr;
}
VV_LOC array builtin____new_array_with_array_default(int mylen, int cap, int elm_size, array val, int depth) {
	builtin__panic_on_negative_len(mylen);
	builtin__panic_on_negative_cap(cap);
	int cap_ = (cap < mylen ? (mylen) : (cap));
	array arr = ((array){.data = (voidptr)builtin___v_malloc(builtin____at_least_one((u64)(((u64)(cap_)) * ((u64)(elm_size))))),.offset = 0,.len = mylen,.cap = cap_,.flags = 0,.element_size = elm_size,});
	u8* eptr = ((u8*)(arr.data));
	{ // Unsafe block
		if (eptr != ((void*)0)) {
			for (int _t1 = 0; _t1 < arr.len; ++_t1) {
				array val_clone = builtin__array_clone_to_depth(&val, depth);
				builtin__vmemcpy(eptr, &val_clone, arr.element_size);
				eptr += arr.element_size;
			}
		}
	}
	return arr;
}
VV_LOC array builtin__new_array_from_c_array(int len, int cap, int elm_size, voidptr c_array) {
	builtin__panic_on_negative_len(len);
	builtin__panic_on_negative_cap(cap);
	int cap_ = (cap < len ? (len) : (cap));
	array arr = ((array){.data = (voidptr)builtin__vcalloc((u64)(((u64)(cap_)) * ((u64)(elm_size)))),.offset = 0,.len = len,.cap = cap_,.flags = 0,.element_size = elm_size,});
	builtin__vmemcpy(arr.data, c_array, (u64)(((u64)(len)) * ((u64)(elm_size))));
	return arr;
}
void builtin__array_ensure_cap(array* a, int required) {
	if (required <= a->cap) {
		return;
	}
	if (builtin__ArrayFlags_has(&a->flags, ArrayFlags__nogrow)) {
		builtin__panic_n(_S("array.ensure_cap: array with the flag `.nogrow` cannot grow in size, array required new size:"), required);
		VUNREACHABLE();
	}
	i64 cap = (a->cap > 0 ? (((i64)(a->cap))) : (((i64)(2))));
	for (;;) {
		if (!(required > cap)) break;
		cap *= 2;
	}
	if (cap > _const_max_int) {
		if (a->cap < _const_max_int) {
			cap = _const_max_int;
		} else {
			builtin__panic_n(_S("array.ensure_cap: array needs to grow to cap (which is > 2^31):"), cap);
			VUNREACHABLE();
		}
	}
	u64 new_size = (u64)(((u64)(cap)) * ((u64)(a->element_size)));
	u8* new_data = builtin___v_malloc(builtin____at_least_one(new_size));
	if (a->data != ((void*)0)) {
		builtin__vmemcpy(new_data, a->data, (u64)(((u64)(a->len)) * ((u64)(a->element_size))));
		if (builtin__ArrayFlags_has(&a->flags, ArrayFlags__noslices)) {
			builtin___v_free(a->data);
		}
	}
	a->data = new_data;
	a->offset = 0;
	a->cap = ((int)(cap));
}
array builtin__array_repeat(array a, int count) {
	return builtin__array_repeat_to_depth(a, count, 0);
}
array builtin__array_repeat_to_depth(array a, int count, int depth) {
	if (count < 0) {
		builtin__panic_n(_S("array.repeat: count is negative:"), count);
		VUNREACHABLE();
	}
	u64 size = (u64)((u64)(((u64)(count)) * ((u64)(a.len))) * ((u64)(a.element_size)));
	if (size == 0) {
		size = ((u64)(a.element_size));
	}
	array arr = ((array){.data = (voidptr)builtin__vcalloc(size),.offset = 0,.len = (int)(count * a.len),.cap = (int)(count * a.len),.flags = 0,.element_size = a.element_size,});
	if (a.len > 0) {
		u64 a_total_size = (u64)(((u64)(a.len)) * ((u64)(a.element_size)));
		u64 arr_step_size = (u64)(((u64)(a.len)) * ((u64)(arr.element_size)));
		u8* eptr = ((u8*)(arr.data));
		{ // Unsafe block
			if (eptr != ((void*)0)) {
				for (int _t1 = 0; _t1 < count; ++_t1) {
					if (depth > 0) {
						array ary_clone = builtin__array_clone_to_depth(&a, depth);
						builtin__vmemcpy(eptr, ((u8*)(ary_clone.data)), a_total_size);
					} else {
						builtin__vmemcpy(eptr, ((u8*)(a.data)), a_total_size);
					}
					eptr += arr_step_size;
				}
			}
		}
	}
	return arr;
}
void builtin__array_insert(array* a, int i, voidptr val) {
	if (i < 0 || i > a->len) {
		builtin__panic_n2(_S("array.insert: index out of range (i,a.len):"), i, a->len);
		VUNREACHABLE();
	}
	if (a->len == _const_max_int) {
		builtin___v_panic(_S("array.insert: a.len reached max_int"));
		VUNREACHABLE();
	}
	if (a->len >= a->cap) {
		builtin__array_ensure_cap(a, (int)(a->len + 1));
	}
	{ // Unsafe block
		builtin__vmemmove(builtin__array_get_unsafe(*a, (int)(i + 1)), builtin__array_get_unsafe(*a, i), (u64)(((u64)(((int)(a->len - i)))) * ((u64)(a->element_size))));
		builtin__array_set_unsafe(a, i, val);
	}
	a->len++;
}
VV_LOC void builtin__array_insert_many(array* a, int i, voidptr val, int size) {
	if (i < 0 || i > a->len) {
		builtin__panic_n2(_S("array.insert_many: index out of range (i,a.len):"), i, a->len);
		VUNREACHABLE();
	}
	i64 new_len = (i64)(((i64)(a->len)) + ((i64)(size)));
	if (new_len > _const_max_int) {
		builtin__panic_n(_S("array.insert_many: max_int will be exceeded by a.len:"), new_len);
		VUNREACHABLE();
	}
	builtin__array_ensure_cap(a, ((int)(new_len)));
	int elem_size = a->element_size;
	{ // Unsafe block
		voidptr iptr = builtin__array_get_unsafe(*a, i);
		builtin__vmemmove(builtin__array_get_unsafe(*a, (int)(i + size)), iptr, (u64)(((u64)((int)(a->len - i))) * ((u64)(elem_size))));
		builtin__vmemcpy(iptr, val, (u64)(((u64)(size)) * ((u64)(elem_size))));
	}
	a->len = ((int)(new_len));
}
void builtin__array_prepend(array* a, voidptr val) {
	builtin__array_insert(a, 0, val);
}
VV_LOC void builtin__array_prepend_many(array* a, voidptr val, int size) {
	builtin__array_insert_many(a, 0, val, size);
}
void builtin__array_delete(array* a, int i) {
	builtin__array_delete_many(a, i, 1);
}
void builtin__array_delete_many(array* a, int i, int size) {
	if (i < 0 || (i64)(((i64)(i)) + ((i64)(size))) > ((i64)(a->len))) {
		if (size > 1) {
			builtin__panic_n3(_S("array.delete: index out of range (i,i+size,a.len):"), i, (int)(i + size), a->len);
			VUNREACHABLE();
		} else {
			builtin__panic_n2(_S("array.delete: index out of range (i,a.len):"), i, a->len);
			VUNREACHABLE();
		}
	}
	if (builtin__ArrayFlags_all(&a->flags, (ArrayFlags__noshrink | ArrayFlags__noslices))) {
		builtin__vmemmove(((u8*)(a->data)) + (u64)(((u64)(i)) * ((u64)(a->element_size))), ((u8*)(a->data)) + (u64)(((u64)((int)(i + size))) * ((u64)(a->element_size))), (u64)(((u64)((int)((int)(a->len - i) - size))) * ((u64)(a->element_size))));
		a->len -= size;
		return;
	}
	voidptr old_data = a->data;
	int new_size = (int)(a->len - size);
	int new_cap = (new_size == 0 ? (1) : (new_size));
	a->data = builtin__vcalloc((u64)(((u64)(new_cap)) * ((u64)(a->element_size))));
	builtin__vmemcpy(a->data, old_data, (u64)(((u64)(i)) * ((u64)(a->element_size))));
	builtin__vmemcpy(((u8*)(a->data)) + (u64)(((u64)(i)) * ((u64)(a->element_size))), ((u8*)(old_data)) + (u64)(((u64)((int)(i + size))) * ((u64)(a->element_size))), (u64)(((u64)((int)((int)(a->len - i) - size))) * ((u64)(a->element_size))));
	if (builtin__ArrayFlags_has(&a->flags, ArrayFlags__noslices)) {
		builtin___v_free(old_data);
	}
	a->len = new_size;
	a->cap = new_cap;
}
void builtin__array_clear(array* a) {
	a->len = 0;
}
void builtin__array_reset(array* a) {
	builtin__vmemset(a->data, 0, (int)(a->len * a->element_size));
}
void builtin__array_trim(array* a, int index) {
	if (index < a->len) {
		a->len = index;
	}
}
void builtin__array_drop(array* a, int num) {
	if (num <= 0) {
		return;
	}
	int n = (num <= a->len ? (num) : (a->len));
	u64 blen = (u64)(((u64)(n)) * ((u64)(a->element_size)));
	a->data = ((u8*)(a->data)) + blen;
	a->offset += ((int)(blen));
	a->len -= n;
	a->cap -= n;
}
inline VV_LOC voidptr builtin__array_get_unsafe(array a, int i) {
	{ // Unsafe block
		return ((u8*)(a.data)) + (u64)(((u64)(i)) * ((u64)(a.element_size)));
	}
	return 0;
}
VV_LOC voidptr builtin__array_get(array a, int i) {
	#if !defined(CUSTOM_DEFINE_no_bounds_checking)
	{
		if (i < 0 || i >= a.len) {
			builtin__panic_n2(_S("array.get: index out of range (i,a.len):"), i, a.len);
			VUNREACHABLE();
		}
	}
	#endif
	{ // Unsafe block
		return ((u8*)(a.data)) + (u64)(((u64)(i)) * ((u64)(a.element_size)));
	}
	return 0;
}
VV_LOC voidptr builtin__array_get_with_check(array a, int i) {
	if (i < 0 || i >= a.len) {
		return 0;
	}
	{ // Unsafe block
		return ((u8*)(a.data)) + (u64)(((u64)(i)) * ((u64)(a.element_size)));
	}
	return 0;
}
voidptr builtin__array_first(array a) {
	if (a.len == 0) {
		builtin___v_panic(_S("array.first: array is empty"));
		VUNREACHABLE();
	}
	return a.data;
}
voidptr builtin__array_last(array a) {
	if (a.len == 0) {
		builtin___v_panic(_S("array.last: array is empty"));
		VUNREACHABLE();
	}
	{ // Unsafe block
		return ((u8*)(a.data)) + (u64)(((u64)((int)(a.len - 1))) * ((u64)(a.element_size)));
	}
	return 0;
}
voidptr builtin__array_pop_left(array* a) {
	if (a->len == 0) {
		builtin___v_panic(_S("array.pop_left: array is empty"));
		VUNREACHABLE();
	}
	voidptr first_elem = a->data;
	{ // Unsafe block
		a->data = ((u8*)(a->data)) + ((u64)(a->element_size));
	}
	a->offset += a->element_size;
	a->len--;
	a->cap--;
	return first_elem;
}
voidptr builtin__array_pop(array* a) {
	if (a->len == 0) {
		builtin___v_panic(_S("array.pop: array is empty"));
		VUNREACHABLE();
	}
	int new_len = (int)(a->len - 1);
	u8* last_elem = ((u8*)(a->data)) + (u64)(((u64)(new_len)) * ((u64)(a->element_size)));
	a->len = new_len;
	return last_elem;
}
void builtin__array_delete_last(array* a) {
	if (a->len == 0) {
		builtin___v_panic(_S("array.delete_last: array is empty"));
		VUNREACHABLE();
	}
	a->len--;
}
VV_LOC array builtin__array_slice(array a, int start, int _end) {
	int end = (_end == _const_max_i64 || _end == _const_max_i32 ? (a.len) : (_end));
	#if !defined(CUSTOM_DEFINE_no_bounds_checking)
	{
		if (start > end) {
			builtin___v_panic(builtin__string__plus(builtin__string__plus(builtin__string__plus(_S("array.slice: invalid slice index (start>end):"), builtin__impl_i64_to_string(((i64)(start)))), _S(", ")), builtin__impl_i64_to_string(end)));
			VUNREACHABLE();
		}
		if (end > a.len) {
			builtin___v_panic(builtin__string__plus(builtin__string__plus(builtin__string__plus(builtin__string__plus(_S("array.slice: slice bounds out of range ("), builtin__impl_i64_to_string(end)), _S(" >= ")), builtin__impl_i64_to_string(a.len)), _S(")")));
			VUNREACHABLE();
		}
		if (start < 0) {
			builtin___v_panic(builtin__string__plus(_S("array.slice: slice bounds out of range (start<0):"), builtin__impl_i64_to_string(start)));
			VUNREACHABLE();
		}
	}
	#endif
	u64 offset = (u64)(((u64)(start)) * ((u64)(a.element_size)));
	u8* data = ((u8*)(a.data)) + offset;
	int l = (int)(end - start);
	array res = ((array){.data = (voidptr)data,.offset = (int)(a.offset + ((int)(offset))),.len = l,.cap = l,.flags = 0,.element_size = a.element_size,});
	return res;
}
VV_LOC array builtin__array_slice_ni(array a, int _start, int _end) {
	int end = (_end == _const_max_i64 || _end == _const_max_i32 ? (a.len) : (_end));
	int start = _start;
	if (start < 0) {
		start = (int)(a.len + start);
		if (start < 0) {
			start = 0;
		}
	}
	if (end < 0) {
		end = (int)(a.len + end);
		if (end < 0) {
			end = 0;
		}
	}
	if (end >= a.len) {
		end = a.len;
	}
	if (start >= a.len || start > end) {
		array res = ((array){.data = a.data,.offset = 0,.len = 0,.cap = 0,.flags = 0,.element_size = a.element_size,});
		return res;
	}
	u64 offset = (u64)(((u64)(start)) * ((u64)(a.element_size)));
	u8* data = ((u8*)(a.data)) + offset;
	int l = (int)(end - start);
	array res = ((array){.data = (voidptr)data,.offset = (int)(a.offset + ((int)(offset))),.len = l,.cap = l,.flags = 0,.element_size = a.element_size,});
	return res;
}
VV_LOC array builtin__array_clone_static_to_depth(array a, int depth) {
	return builtin__array_clone_to_depth(&a, depth);
}
array builtin__array_clone(array* a) {
	return builtin__array_clone_to_depth(a, 0);
}
array builtin__array_clone_to_depth(array* a, int depth) {
	u64 source_capacity_in_bytes = (u64)(((u64)(a->cap)) * ((u64)(a->element_size)));
	array arr = ((array){.data = (voidptr)builtin__vcalloc(source_capacity_in_bytes),.offset = 0,.len = a->len,.cap = a->cap,.flags = 0,.element_size = a->element_size,});
	if (depth > 0 && _us32_eq(sizeof(array),a->element_size) && a->len >= 0 && a->cap >= a->len) {
		array ar = ((array){.data = 0,.offset = 0,.len = 0,.cap = 0,.flags = 0,.element_size = 0,});
		int asize = ((int)(sizeof(array)));
		for (int i = 0; i < a->len; ++i) {
			builtin__vmemcpy(&ar, builtin__array_get_unsafe(*a, i), asize);
			array ar_clone = builtin__array_clone_to_depth(&ar, (int)(depth - 1));
			builtin__array_set_unsafe(&arr, i, &ar_clone);
		}
		return arr;
	} else if (depth > 0 && _us32_eq(sizeof(string),a->element_size) && a->len >= 0 && a->cap >= a->len) {
		for (int i = 0; i < a->len; ++i) {
			string* str_ptr = ((string*)(builtin__array_get_unsafe(*a, i)));
			string str_clone = builtin__string_clone((*str_ptr));
			builtin__array_set_unsafe(&arr, i, &str_clone);
		}
		return arr;
	} else {
		if (a->data != 0 && source_capacity_in_bytes > 0) {
			builtin__vmemcpy(((u8*)(arr.data)), a->data, source_capacity_in_bytes);
		}
		return arr;
	}
	return (array){.data = 0,.offset = 0,.len = 0,.cap = 0,.flags = 0,.element_size = 0,};
}
inline VV_LOC void builtin__array_set_unsafe(array* a, int i, voidptr val) {
	builtin__vmemcpy(((u8*)(a->data)) + (u64)(((u64)(a->element_size)) * ((u64)(i))), val, a->element_size);
}
VV_LOC void builtin__array_set(array* a, int i, voidptr val) {
	#if !defined(CUSTOM_DEFINE_no_bounds_checking)
	{
		if (i < 0 || i >= a->len) {
			builtin__panic_n2(_S("array.set: index out of range (i,a.len):"), i, a->len);
			VUNREACHABLE();
		}
	}
	#endif
	builtin__vmemcpy(((u8*)(a->data)) + (u64)(((u64)(a->element_size)) * ((u64)(i))), val, a->element_size);
}
VV_LOC void builtin__array_push(array* a, voidptr val) {
	if (a->len < 0) {
		builtin___v_panic(_S("array.push: negative len"));
		VUNREACHABLE();
	}
	if (a->len >= _const_max_int) {
		builtin___v_panic(_S("array.push: len bigger than max_int"));
		VUNREACHABLE();
	}
	if (a->len >= a->cap) {
		builtin__array_ensure_cap(a, (int)(a->len + 1));
	}
	builtin__vmemcpy(((u8*)(a->data)) + (u64)(((u64)(a->element_size)) * ((u64)(a->len))), val, a->element_size);
	a->len++;
}
void builtin__array_push_many(array* a, voidptr val, int size) {
	if (size <= 0 || val == ((void*)0)) {
		return;
	}
	i64 new_len = (i64)(((i64)(a->len)) + ((i64)(size)));
	if (new_len > _const_max_int) {
		builtin___v_panic(_S("array.push_many: new len exceeds max_int"));
		VUNREACHABLE();
	}
	if (new_len >= a->cap) {
		builtin__array_ensure_cap(a, ((int)(new_len)));
	}
	if (a->data == val && a->data != 0) {
		array copy = builtin__array_clone(a);
		builtin__vmemcpy(((u8*)(a->data)) + (u64)(((u64)(a->element_size)) * ((u64)(a->len))), copy.data, (u64)(((u64)(a->element_size)) * ((u64)(size))));
	} else {
		if (a->data != 0 && val != 0) {
			builtin__vmemcpy(((u8*)(a->data)) + (u64)(((u64)(a->element_size)) * ((u64)(a->len))), val, (u64)(((u64)(a->element_size)) * ((u64)(size))));
		}
	}
	a->len = ((int)(new_len));
}
void builtin__array_reverse_in_place(array* a) {
	if (a->len < 2 || a->element_size == 0) {
		return;
	}
	{ // Unsafe block
		u8* tmp_value = builtin___v_malloc(a->element_size);
		for (int i = 0; i < (int)(a->len / 2); ++i) {
			builtin__vmemcpy(tmp_value, ((u8*)(a->data)) + (u64)(((u64)(i)) * ((u64)(a->element_size))), a->element_size);
			builtin__vmemcpy(((u8*)(a->data)) + (u64)(((u64)(i)) * ((u64)(a->element_size))), ((u8*)(a->data)) + (u64)(((u64)((int)((int)(a->len - 1) - i))) * ((u64)(a->element_size))), a->element_size);
			builtin__vmemcpy(((u8*)(a->data)) + (u64)(((u64)((int)((int)(a->len - 1) - i))) * ((u64)(a->element_size))), tmp_value, a->element_size);
		}
		builtin___v_free(tmp_value);
	}
}
array builtin__array_reverse(array a) {
	if (a.len < 2) {
		return a;
	}
	array arr = ((array){.data = (voidptr)builtin__vcalloc((u64)(((u64)(a.cap)) * ((u64)(a.element_size)))),.offset = 0,.len = a.len,.cap = a.cap,.flags = 0,.element_size = a.element_size,});
	for (int i = 0; i < a.len; ++i) {
		builtin__array_set_unsafe(&arr, i, builtin__array_get_unsafe(a, (int)((int)(a.len - 1) - i)));
	}
	return arr;
}
void builtin__array_free(array* a) {
	if (builtin__ArrayFlags_has(&a->flags, ArrayFlags__nofree)) {
		return;
	}
	u8* mblock_ptr = ((u8*)((u64)(((u64)(a->data)) - ((u64)(a->offset)))));
	if (mblock_ptr != ((void*)0)) {
		builtin___v_free(mblock_ptr);
	}
	{ // Unsafe block
		a->data = ((void*)0);
		a->offset = 0;
		a->len = 0;
		a->cap = 0;
	}
}
array builtin__array_filter(array a, bool (*predicate)(voidptr ));
bool builtin__array_any(array a, bool (*predicate)(voidptr ));
int builtin__array_count(array a, bool (*predicate)(voidptr ));
bool builtin__array_all(array a, bool (*predicate)(voidptr ));
array builtin__array_map(array a, voidptr (*callback)(voidptr ));
void builtin__array_sort(array* a, int (*callback)(voidptr , voidptr ));
array builtin__array_sorted(array* a, int (*callback)(voidptr , voidptr ));
void builtin__array_sort_with_compare(array* a, int (*callback)(voidptr , voidptr )) {
	#if defined(_VFREESTANDING)
	{
	}
	#else
	{
		builtin__vqsort(a->data, ((usize)(a->len)), ((usize)(a->element_size)), (voidptr)callback);
	}
	#endif
}
array builtin__array_sorted_with_compare(array* a, int (*callback)(voidptr , voidptr )) {
	#if defined(_VFREESTANDING)
	{
	}
	#else
	{
		array r = builtin__array_clone(a);
		builtin__vqsort(r.data, ((usize)(r.len)), ((usize)(r.element_size)), (voidptr)callback);
		return r;
	}
	#endif
	return ((array){.data = 0,.offset = 0,.len = 0,.cap = 0,.flags = 0,.element_size = 0,});
}
bool builtin__array_contains(array a, voidptr value);
int builtin__array_index(array a, voidptr value);
int builtin__array_last_index(array a, voidptr value);
void Array_string_free(Array_string* a) {
	for (int _t1 = 0; _t1 < a->len; ++_t1) {
		string* s = ((string*)a->data) + _t1;
		builtin__string_free(s);
	}
	builtin__array_free((((array*)(a))));
}
string Array_string_str(Array_string a) {
	int sb_len = 4;
	if (a.len > 0) {
		sb_len += ((string*)a.data)[0].len;
		sb_len *= a.len;
	}
	sb_len += 2;
	strings__Builder sb = strings__new_builder(sb_len);
	strings__Builder_write_u8(&sb, '[');
	for (int i = 0; i < a.len; ++i) {
		string val = ((string*)a.data)[i];
		strings__Builder_write_u8(&sb, '\'');
		strings__Builder_write_string(&sb, val);
		strings__Builder_write_u8(&sb, '\'');
		if (i < (int)(a.len - 1)) {
			strings__Builder_write_string(&sb, _S(", "));
		}
	}
	strings__Builder_write_u8(&sb, ']');
	string res = strings__Builder_str(&sb);
	strings__Builder_free(&sb);
	return res;
}
string Array_u8_hex(Array_u8 b) {
	if (b.len == 0) {
		return _S("");
	}
	return builtin__data_to_hex_string(((u8*)(b.data)), b.len);
}
int builtin__copy(Array_u8* dst, Array_u8 src) {
	int min = (dst->len < src.len ? (dst->len) : (src.len));
	if (min > 0) {
		builtin__vmemmove(((u8*)(dst->data)), src.data, min);
	}
	return min;
}
void builtin__array_grow_cap(array* a, int amount) {
	i64 new_cap = (i64)(((i64)(amount)) + ((i64)(a->cap)));
	if (new_cap > _const_max_int) {
		builtin__panic_n(_S("array.grow_cap: max_int will be exceeded by new cap:"), new_cap);
		VUNREACHABLE();
	}
	builtin__array_ensure_cap(a, ((int)(new_cap)));
}
void builtin__array_grow_len(array* a, int amount) {
	i64 new_len = (i64)(((i64)(amount)) + ((i64)(a->len)));
	if (new_len > _const_max_int) {
		builtin__panic_n(_S("array.grow_len: max_int will be exceeded by new len:"), new_len);
		VUNREACHABLE();
	}
	builtin__array_ensure_cap(a, ((int)(new_len)));
	a->len = ((int)(new_len));
}
Array_voidptr builtin__array_pointers(array a) {
	Array_voidptr res = builtin____new_array_with_default(0, 0, sizeof(voidptr), 0);
	for (int i = 0; i < a.len; ++i) {
		builtin__array_push((array*)&res, _MOV((voidptr[]){ builtin__array_get_unsafe(a, i) }));
	}
	return res;
}
Array_u8 builtin__voidptr_vbytes(voidptr data, int len) {
	array res = ((array){.data = data,.offset = 0,.len = len,.cap = len,.flags = 0,.element_size = 1,});
	return res;
}
Array_u8 builtin__u8_vbytes(u8* data, int len) {
	return builtin__voidptr_vbytes(((voidptr)(data)), len);
}
void builtin__u8_free(u8* data) {
	builtin___v_free(data);
}
inline VV_LOC void builtin__panic_on_negative_len(int len) {
	if (len < 0) {
		builtin__panic_n(_S("negative .len:"), len);
		VUNREACHABLE();
	}
}
inline VV_LOC void builtin__panic_on_negative_cap(int cap) {
	if (cap < 0) {
		builtin__panic_n(_S("negative .cap:"), cap);
		VUNREACHABLE();
	}
}
VV_LOC array builtin____new_array_noscan(int mylen, int cap, int elm_size) {
	return builtin____new_array(mylen, cap, elm_size);
}
VV_LOC array builtin____new_array_with_default_noscan(int mylen, int cap, int elm_size, voidptr val) {
	return builtin____new_array_with_default(mylen, cap, elm_size, val);
}
VV_LOC array builtin____new_array_with_multi_default_noscan(int mylen, int cap, int elm_size, voidptr val) {
	return builtin____new_array_with_multi_default(mylen, cap, elm_size, val);
}
VV_LOC array builtin____new_array_with_array_default_noscan(int mylen, int cap, int elm_size, array val, int depth) {
	return builtin____new_array_with_array_default(mylen, cap, elm_size, val, depth);
}
VV_LOC void builtin__array_prepend_noscan(array* a, voidptr val) {
	builtin__array_prepend(a, val);
}
VV_LOC void builtin__array_push_noscan(array* a, voidptr val) {
	builtin__array_push(a, val);
}
VV_LOC void builtin__array_push_many_noscan(array* a, voidptr val, int size) {
	builtin__array_push_many(a, val, size);
}
void builtin__print_backtrace(void) {
	#if !defined(CUSTOM_DEFINE_no_backtrace)
	{
		#if defined(_VFREESTANDING)
		{
		}
		#elif defined(_VNATIVE)
		{
		}
		#elif defined(__TINYC__)
		{
		}
		#elif defined(CUSTOM_DEFINE_use_libbacktrace)
		{
		}
		#else
		{
			builtin__print_backtrace_skipping_top_frames(2);
		}
		#endif
	}
	#endif
}
bool builtin__print_backtrace_skipping_top_frames(int xskipframes) {
	#if defined(CUSTOM_DEFINE_no_backtrace)
	{
	}
	#else
	{
		int skipframes = (int)(xskipframes + 2);
		#if defined(__APPLE__) || defined(__FreeBSD__) || defined(__OpenBSD__) || defined(__NetBSD__)
		{
			return builtin__print_backtrace_skipping_top_frames_bsd(skipframes);
		}
		#elif defined(__linux__)
		{
		}
		#else
		{
		}
		#endif
	}
	#endif
	return false;
}
VV_LOC bool builtin__print_backtrace_skipping_top_frames_bsd(int skipframes) {
	#if defined(CUSTOM_DEFINE_no_backtrace)
	{
	}
	#else
	{
		#if defined(__APPLE__) || defined(__FreeBSD__) || defined(__NetBSD__)
		{
			Array_fixed_voidptr_100 buffer = {0};
			i32 nr_ptrs = backtrace(&buffer[0], 100);
			if (nr_ptrs < 2) {
				builtin__eprintln(_S("C.backtrace returned less than 2 frames"));
				return false;
			}
			backtrace_symbols_fd(&buffer[skipframes], (int)(nr_ptrs - skipframes), 2);
		}
		#endif
		return true;
	}
	#endif
	return 0;
}
VNORETURN void builtin___v_exit(int code) {
	exit(code);
	VUNREACHABLE();
	while(1);
}
_result_void builtin__at_exit(void (*cb)(void)) {
	#if defined(_VFREESTANDING)
	{
	}
	#else
	{
		i32 res = atexit((voidptr)cb);
		if (res != 0) {
			return (_result_void){ .is_error=true, .err=builtin__error_with_code(_S("at_exit failed"), res), .data={E_STRUCT} };
		}
	}
	#endif
	return (_result_void){0};
}
VV_LOC void builtin__v_segmentation_fault_handler(i32 signal_number) {
	#if defined(_VFREESTANDING)
	{
	}
	#else
	{
		fprintf(stderr, "signal %d: segmentation fault\n", signal_number);
	}
	#endif
	#if defined(CUSTOM_DEFINE_use_libbacktrace)
	{
	}
	#else
	{
		builtin__print_backtrace();
	}
	#endif
	builtin___v_exit((i32)(128 + signal_number));
	VUNREACHABLE();
}
inline VV_LOC int builtin__v_fixed_index(int i, int len) {
	#if !defined(CUSTOM_DEFINE_no_bounds_checking)
	{
		if (i < 0 || i >= len) {
			builtin___v_panic(builtin__string__plus(builtin__string__plus(builtin__string__plus(builtin__string__plus(_S("fixed array index out of range (index: "), builtin__i64_str(((i64)(i)))), _S(", len: ")), builtin__i64_str(((i64)(len)))), _S(")")));
			VUNREACHABLE();
		}
	}
	#endif
	return i;
}
Array_string builtin__arguments(void) {
	u8** argv = ((u8**)(g_main_argv));
	Array_string res = builtin____new_array_with_default(0, g_main_argc, sizeof(string), 0);
	for (int i = 0; i < g_main_argc; ++i) {
		#if defined(_WIN32)
		{
		}
		#else
		{
			builtin__array_push((array*)&res, _MOV((string[]){ builtin__tos_clone(argv[i]) }));
		}
		#endif
	}
	return res;
}
string builtin__vcurrent_hash(void) {
	return _S("6fa4008");
}
u64 builtin__v_getpid(void) {
	#if defined(CUSTOM_DEFINE_no_getpid)
	{
	}
	#elif defined(_WIN32)
	{
	}
	#else
	{
		return ((u64)(getpid()));
	}
	#endif
	return 0;
}
u64 builtin__v_gettid(void) {
	#if defined(CUSTOM_DEFINE_no_gettid)
	{
	}
	#elif defined(_WIN32)
	{
	}
	#elif defined(__linux__) && !defined(CUSTOM_DEFINE_musl)
	{
	}
	#elif defined(__VTHREADS__)
	{
		return ((u64)(pthread_self()));
	}
	#else
	{
	}
	#endif
	return 0;
}
inline bool builtin__isnil(voidptr v) {
	return v == 0;
}
VV_LOC void builtin__builtin_init(void) {
}
VNORETURN void builtin__panic_lasterr(string base) {
	builtin___v_panic(builtin__string__plus(base, _S(" unknown")));
	VUNREACHABLE();
	while(1);
}
void builtin__gc_check_leaks(void) {
}
bool builtin__gc_is_enabled(void) {
	return false;
}
void builtin__gc_enable(void) {
}
void builtin__gc_disable(void) {
}
void builtin__gc_collect(void) {
}
void builtin__gc_get_warn_proc(void) {
}
void builtin__gc_set_warn_proc(void (*cb)(char* msg, usize arg)) {
}
inline int builtin__vstrlen(u8* s) {
	return strlen(((char*)(s)));
}
inline int builtin__vstrlen_char(char* s) {
	return strlen(s);
}
inline voidptr builtin__vmemcpy(voidptr dest, const voidptr const_src, isize n) {
	if (n == 0) {
		return dest;
	}
	{ // Unsafe block
		return memcpy(dest, const_src, n);
	}
	return 0;
}
inline voidptr builtin__vmemmove(voidptr dest, const voidptr const_src, isize n) {
	if (n == 0) {
		return dest;
	}
	{ // Unsafe block
		return memmove(dest, const_src, n);
	}
	return 0;
}
inline int builtin__vmemcmp(const voidptr const_s1, const voidptr const_s2, isize n) {
	if (n == 0) {
		return 0;
	}
	{ // Unsafe block
		return memcmp(const_s1, const_s2, n);
	}
	return 0;
}
inline voidptr builtin__vmemset(voidptr s, int c, isize n) {
	if (n == 0) {
		return s;
	}
	{ // Unsafe block
		return memset(s, c, n);
	}
	return 0;
}
inline VV_LOC void builtin__vqsort(voidptr base, usize nmemb, usize size, int (*sort_cb)(const voidptr const_a, const voidptr const_b)) {
	if (nmemb == 0) {
		return;
	}
	qsort(base, nmemb, size, ((voidptr)(sort_cb)));
}
void builtin__chan_close(chan ch) {
}
ChanState builtin__chan_try_pop(chan ch, voidptr obj) {
	return ChanState__success;
}
ChanState builtin__chan_try_push(chan ch, voidptr obj) {
	return ChanState__success;
}
VV_LOC void builtin___result_ok(voidptr data, _result* res, int size) {
	{ // Unsafe block
		*res = ((_result){.is_error = 0,.err = _const_none__,});
		builtin__vmemcpy(((u8*)(&res->err)) + sizeof(IError), data, size);
	}
}
string builtin__IError_str(IError err) {
	return ((err._typ == _IError_None___index)? (_S("none")) : (err._typ == _IError_Error_index)? (builtin__Error_msg(*(err._Error))) : (err._typ == _IError_MessageError_index)? (builtin__MessageError_str((*(err._MessageError)))) : (builtin__str_intp(3, _MOV((StrIntpData[]){{_SLIT0, 0xfe10, {.d_s = builtin__charptr_vstring_literal(v_typeof_interface_IError( (err)._typ ))}}, {_S(": "), 0xfe10, {.d_s = IError_name_table[err._typ]._method_msg(err._object)}}, {_SLIT0, 0, { .d_c = 0 }}}))));
}
string builtin__Error_msg(Error err) {
	return _S("");
}
int builtin__Error_code(Error err) {
	return 0;
}
string builtin__MessageError_str(MessageError err) {
	if (err.code > 0) {
		return builtin__str_intp(3, _MOV((StrIntpData[]){{_SLIT0, 0xfe10, {.d_s = err.msg}}, {_S("; code: "), 0xfe07, {.d_i32 = err.code}}, {_SLIT0, 0, { .d_c = 0 }}}));
	}
	return err.msg;
}
string builtin__MessageError_msg(MessageError err) {
	return err.msg;
}
int builtin__MessageError_code(MessageError err) {
	return err.code;
}
void builtin__MessageError_free(MessageError* err) {
	builtin__string_free(&err->msg);
}
inline IError builtin___v_error(string message) {
	;
	return I_MessageError_to_Interface_IError(((MessageError*)builtin__memdup(&(MessageError){.msg = message,.code = 0,}, sizeof(MessageError))));
}
inline IError builtin__error_with_code(string message, int code) {
	;
	return I_MessageError_to_Interface_IError(((MessageError*)builtin__memdup(&(MessageError){.msg = message,.code = code,}, sizeof(MessageError))));
}
VV_LOC void builtin___option_none(voidptr data, _option* option, int size) {
	{ // Unsafe block
		*option = ((_option){.state = 2,.err = _const_none__,});
		builtin__vmemcpy(((u8*)(&option->err)) + sizeof(IError), data, size);
	}
}
VV_LOC void builtin___option_ok(voidptr data, _option* option, int size) {
	{ // Unsafe block
		*option = ((_option){.state = 0,.err = _const_none__,});
		builtin__vmemcpy(((u8*)(&option->err)) + sizeof(IError), data, size);
	}
}
VV_LOC void builtin___option_clone(_option* current, _option* option, int size) {
	{ // Unsafe block
		*option = ((_option){.state = current->state,.err = current->err,});
		builtin__vmemcpy(((u8*)(&option->err)) + sizeof(IError), ((u8*)(&current->err)) + sizeof(IError), size);
	}
}
VV_LOC string builtin__None___str(None__ _d1) {
	return _S("none");
}
string builtin__none_str(none _d1) {
	return _S("none");
}
int builtin__input_character(void) {
	int ch = 0;
	#if defined(_VFREESTANDING)
	{
	}
	#elif defined(__vinix__)
	{
	}
	#else
	{
		ch = getchar();
		if (ch == EOF) {
			return -1;
		}
	}
	#endif
	return ch;
}
int builtin__print_character(u8 ch) {
	#if defined(__ANDROID__) && !defined(__TERMUX__)
	{
	}
	#elif defined(_VFREESTANDING)
	{
	}
	#elif defined(__vinix__)
	{
	}
	#else
	{
		i32 x = putchar(ch);
		if (x == EOF) {
			return -1;
		}
	}
	#endif
	return ch;
}
#if !defined(CUSTOM_DEFINE_nofloat)
#endif
#if !defined(_VNATIVE)
#endif
inline string builtin__f64_str(f64 x) {
	{ // Unsafe block
		strconv__Float64u f = ((strconv__Float64u){.f = x,});
		if (f.u == _const_strconv__double_minus_zero) {
			return _S("-0.0");
		}
		if (f.u == _const_strconv__double_plus_zero) {
			return _S("0.0");
		}
	}
	f64 abs_x = builtin__f64_abs(x);
	if (abs_x >= ((f64)(0.0001)) && abs_x < ((f64)(1.0e6))) {
		return strconv__f64_to_str_l(x);
	} else {
		return strconv__ftoa_64(x);
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
inline string builtin__f64_strg(f64 x) {
	if (x == 0) {
		return _S("0.0");
	}
	f64 abs_x = builtin__f64_abs(x);
	if (abs_x >= ((f64)(0.0001)) && abs_x < ((f64)(1.0e6))) {
		return strconv__f64_to_str_l_with_dot(x);
	} else {
		return strconv__ftoa_64(x);
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
inline string builtin__float_literal_str(float_literal d) {
	return builtin__f64_str(((f64)(d)));
}
inline string builtin__f64_strsci(f64 x, int digit_num) {
	int n_digit = digit_num;
	if (n_digit < 1) {
		n_digit = 1;
	} else if (n_digit > 17) {
		n_digit = 17;
	}
	return strconv__f64_to_str(x, n_digit);
}
inline string builtin__f64_strlong(f64 x) {
	return strconv__f64_to_str_l(x);
}
inline string builtin__f32_str(f32 x) {
	{ // Unsafe block
		strconv__Float32u f = ((strconv__Float32u){.f = x,});
		if (f.u == _const_strconv__single_minus_zero) {
			return _S("-0.0");
		}
		if (f.u == _const_strconv__single_plus_zero) {
			return _S("0.0");
		}
	}
	f32 abs_x = builtin__f32_abs(x);
	if (abs_x >= ((f32)(0.0001)) && abs_x < ((f32)(1.0e6))) {
		return strconv__f32_to_str_l(x);
	} else {
		return strconv__ftoa_32(x);
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
inline string builtin__f32_strg(f32 x) {
	if (x == 0) {
		return _S("0.0");
	}
	f32 abs_x = builtin__f32_abs(x);
	if (abs_x >= ((f32)(0.0001)) && abs_x < ((f32)(1.0e6))) {
		return strconv__f32_to_str_l_with_dot(x);
	} else {
		return strconv__ftoa_32(x);
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
inline string builtin__f32_strsci(f32 x, int digit_num) {
	int n_digit = digit_num;
	if (n_digit < 1) {
		n_digit = 1;
	} else if (n_digit > 8) {
		n_digit = 8;
	}
	return strconv__f32_to_str(x, n_digit);
}
inline string builtin__f32_strlong(f32 x) {
	return strconv__f32_to_str_l(x);
}
inline f32 builtin__f32_abs(f32 a) {
	return (a < 0 ? (-a) : (a));
}
inline f64 builtin__f64_abs(f64 a) {
	return (a < 0 ? (-a) : (a));
}
inline f32 builtin__f32_min(f32 a, f32 b) {
	return (a < b ? (a) : (b));
}
inline f32 builtin__f32_max(f32 a, f32 b) {
	return (a > b ? (a) : (b));
}
inline f64 builtin__f64_min(f64 a, f64 b) {
	return (a < b ? (a) : (b));
}
inline f64 builtin__f64_max(f64 a, f64 b) {
	return (a > b ? (a) : (b));
}
inline bool builtin__f32_eq_epsilon(f32 a, f32 b) {
	f32 hi = builtin__f32_max(builtin__f32_abs(a), builtin__f32_abs(b));
	f32 delta = builtin__f32_abs((f32)(a - b));
	#if defined(_VNATIVE)
	{
	}
	#else
	{
		if (hi > ((f32)(1.0))) {
			return delta <= (f32)(hi * ((f32)(4 * ((f32)(FLT_EPSILON)))));
		} else {
			return (f32)(((f32)(1 / ((f32)(4 * ((f32)(FLT_EPSILON)))))) * delta) <= hi;
		}
	}
	#endif
	return 0;
}
inline bool builtin__f64_eq_epsilon(f64 a, f64 b) {
	f64 hi = builtin__f64_max(builtin__f64_abs(a), builtin__f64_abs(b));
	f64 delta = builtin__f64_abs((f64)(a - b));
	#if defined(_VNATIVE)
	{
	}
	#else
	{
		if (hi > ((f64)(1.0))) {
			return delta <= (f64)(hi * ((f64)(4 * ((f64)(DBL_EPSILON)))));
		} else {
			return (f64)(((f64)(1 / ((f64)(4 * ((f64)(DBL_EPSILON)))))) * delta) <= hi;
		}
	}
	#endif
	return 0;
}
_option_rune builtin__input_rune(void) {
	int x = builtin__input_character();
	if (x <= 0) {
		return (_option_rune){ .state=2, .err=_const_none__, .data={E_STRUCT} };
	}
	int char_len = builtin__utf8_char_len(((u8)(x)));
	if (char_len == 1) {
		_option_rune _t2;
		builtin___option_ok(&(rune[]) { x }, (_option*)(&_t2), sizeof(rune));
		 
		return _t2;
	}
	u8 b = ((u8)(x));
	b = (b << char_len);
	rune res = ((rune)(b));
	int shift = (int)(6 - char_len);
	for (int i = 1; i < char_len; i++) {
		rune c = ((rune)(builtin__input_character()));
		res = (((rune)(res)) << shift);
		res |= (c & 63);
		shift = 6;
	}
	_option_rune _t3;
	builtin___option_ok(&(rune[]) { res }, (_option*)(&_t3), sizeof(rune));
	 
	return _t3;
}
_option_rune builtin__InputRuneIterator_next(InputRuneIterator* self) {
	return builtin__input_rune();
}
InputRuneIterator builtin__input_rune_iterator(void) {
	return ((InputRuneIterator){E_STRUCT});
}
string builtin__ptr_str(voidptr ptr) {
	string buf1 = builtin__u64_to_hex_no_leading_zeros(((u64)(ptr)), 16);
	return buf1;
}
string builtin__isize_str(isize x) {
	return builtin__i64_str(((i64)(x)));
}
string builtin__usize_str(usize x) {
	return builtin__u64_str(((u64)(x)));
}
string builtin__char_str(char* cptr) {
	return builtin__u64_hex(((u64)(cptr)));
}
inline VV_LOC string builtin__int_str_l(int nn, int max) {
	{ // Unsafe block
		i64 n = ((i64)(nn));
		int d = 0;
		if (n == 0) {
			return _S("0");
		}
		#if defined(CUSTOM_DEFINE_new_int) && defined(TARGET_IS_64BIT)
		{
		}
		#else
		{
			if (n == _const_min_i32) {
				return _S("-2147483648");
			}
		}
		#endif
		bool is_neg = false;
		if (n < 0) {
			n = -n;
			is_neg = true;
		}
		int index = max;
		u8* buf = builtin__malloc_noscan((int)(max + 1));
		buf[index] = 0;
		index--;
		for (;;) {
			if (!(n > 0)) break;
			int n1 = ((int)((i64)(n / 100)));
			d = ((int)((((u32)((int)(((int)(n)) - ((int)(n1 * 100))))) << 1)));
			n = n1;
			buf[index] = _const_digit_pairs.str[d];
			index--;
			d++;
			buf[index] = _const_digit_pairs.str[d];
			index--;
		}
		index++;
		if (d < 20) {
			index++;
		}
		if (is_neg) {
			index--;
			buf[index] = '-';
		}
		int diff = (int)(max - index);
		builtin__vmemmove(buf, ((voidptr)(buf + index)), (int)(diff + 1));
		return builtin__tos(buf, diff);
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
string builtin__i8_str(i8 n) {
	return builtin__int_str_l(((int)(n)), 4);
}
string builtin__i16_str(i16 n) {
	return builtin__int_str_l(((int)(n)), 6);
}
string builtin__u16_str(u16 n) {
	return builtin__int_str_l(((int)(n)), 6);
}
string builtin__i32_str(i32 n) {
	return builtin__int_str_l(((int)(n)), 11);
}
string builtin__int_hex_full(int nn) {
	return builtin__u64_to_hex(((u64)(nn)), 8);
}
string builtin__int_str(int n) {
	#if defined(CUSTOM_DEFINE_new_int)
	{
	}
	#else
	{
		return builtin__int_str_l(n, 11);
	}
	#endif
	return (string){.str=(byteptr)"", .is_lit=1};
}
inline string builtin__u32_str(u32 nn) {
	{ // Unsafe block
		u32 n = nn;
		u32 d = ((u32)(0));
		if (n == 0) {
			return _S("0");
		}
		int max = 10;
		u8* buf = builtin__malloc_noscan((int)(max + 1));
		int index = max;
		buf[index] = 0;
		index--;
		for (;;) {
			if (!(n > 0)) break;
			u32 n1 = (u32)(n / ((u32)(100)));
			d = ((((u32)(n - ((u32)(n1 * ((u32)(100)))))) << ((u32)(1))));
			n = n1;
			buf[index] = _const_digit_pairs.str[ d];
			index--;
			d++;
			buf[index] = _const_digit_pairs.str[ d];
			index--;
		}
		index++;
		if (d < ((u32)(20))) {
			index++;
		}
		int diff = (int)(max - index);
		builtin__vmemmove(buf, ((voidptr)(buf + index)), (int)(diff + 1));
		return builtin__tos(buf, diff);
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
inline string builtin__int_literal_str(int_literal n) {
	return builtin__impl_i64_to_string(n);
}
inline string builtin__i64_str(i64 nn) {
	return builtin__impl_i64_to_string(nn);
}
VV_LOC string builtin__impl_i64_to_string(i64 nn) {
	{ // Unsafe block
		i64 n = nn;
		i64 d = ((i64)(0));
		if (n == 0) {
			return _S("0");
		} else if (n == _const_min_i64) {
			return _S("-9223372036854775808");
		}
		int max = 20;
		u8* buf = builtin__malloc_noscan((int)(max + 1));
		bool is_neg = false;
		if (n < 0) {
			n = -n;
			is_neg = true;
		}
		int index = max;
		buf[index] = 0;
		index--;
		for (;;) {
			if (!(n > 0)) break;
			i64 n1 = (i64)(n / ((i64)(100)));
			d = ((((u32)((i64)(n - ((i64)(n1 * ((i64)(100))))))) << ((i64)(1))));
			n = n1;
			buf[index] = _const_digit_pairs.str[ d];
			index--;
			d++;
			buf[index] = _const_digit_pairs.str[ d];
			index--;
		}
		index++;
		if (d < ((i64)(20))) {
			index++;
		}
		if (is_neg) {
			index--;
			buf[index] = '-';
		}
		int diff = (int)(max - index);
		builtin__vmemmove(buf, ((voidptr)(buf + index)), (int)(diff + 1));
		return builtin__tos(buf, diff);
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
inline string builtin__u64_str(u64 nn) {
	{ // Unsafe block
		u64 n = nn;
		u64 d = ((u64)(0));
		if (n == 0) {
			return _S("0");
		}
		int max = 20;
		u8* buf = builtin__malloc_noscan((int)(max + 1));
		int index = max;
		buf[index] = 0;
		index--;
		for (;;) {
			if (!(n > 0)) break;
			u64 n1 = (u64)(n / 100);
			d = ((((u64)(n - ((u64)(n1 * 100)))) << 1));
			n = n1;
			buf[index] = _const_digit_pairs.str[ d];
			index--;
			d++;
			buf[index] = _const_digit_pairs.str[ d];
			index--;
		}
		index++;
		if (d < 20) {
			index++;
		}
		int diff = (int)(max - index);
		builtin__vmemmove(buf, ((voidptr)(buf + index)), (int)(diff + 1));
		return builtin__tos(buf, diff);
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
string builtin__bool_str(bool b) {
	if (b) {
		return _S("true");
	}
	return _S("false");
}
inline VV_LOC string builtin__u64_to_hex(u64 nn, u8 len) {
	u64 n = nn;
	Array_fixed_u8_17 buf = {0};
	buf[len] = 0;
	int i = 0;
	for (i = (u8)(len - 1); i >= 0; i--) {
		u8 d = ((u8)((n & 0xF)));
		buf[i] = (d < 10 ? ((rune)(d + '0')) : ((u8)(d + 87)));
		n = (n >> 4);
	}
	return builtin__tos(builtin__memdup(&buf[0], (u8)(len + 1)), len);
}
inline VV_LOC string builtin__u64_to_hex_no_leading_zeros(u64 nn, u8 len) {
	u64 n = nn;
	Array_fixed_u8_17 buf = {0};
	buf[len] = 0;
	int i = 0;
	for (i = (u8)(len - 1); i >= 0; i--) {
		u8 d = ((u8)((n & 0xF)));
		buf[i] = (d < 10 ? ((rune)(d + '0')) : ((u8)(d + 87)));
		n = (n >> 4);
		if (n == 0) {
			break;
		}
	}
	int res_len = (int)(len - i);
	return builtin__tos(builtin__memdup(&buf[i], (int)(res_len + 1)), res_len);
}
string builtin__u8_hex(u8 nn) {
	if (nn == 0) {
		return _S("00");
	}
	return builtin__u64_to_hex(nn, 2);
}
string builtin__char_hex(char c) {
	return builtin__u8_hex(((u8)(c)));
}
string builtin__rune_hex(rune r) {
	return builtin__u32_hex(((u32)(r)));
}
string builtin__i8_hex(i8 nn) {
	if (nn == 0) {
		return _S("00");
	}
	return builtin__u64_to_hex(((u64)(nn)), 2);
}
string builtin__u16_hex(u16 nn) {
	if (nn == 0) {
		return _S("0");
	}
	return builtin__u64_to_hex_no_leading_zeros(nn, 4);
}
string builtin__i16_hex(i16 nn) {
	return builtin__u16_hex(((u16)(nn)));
}
string builtin__u32_hex(u32 nn) {
	if (nn == 0) {
		return _S("0");
	}
	return builtin__u64_to_hex_no_leading_zeros(nn, 8);
}
string builtin__int_hex(int nn) {
	return builtin__u32_hex(((u32)(nn)));
}
string builtin__int_hex2(int n) {
	return builtin__string__plus(_S("0x"), builtin__int_hex(n));
}
string builtin__u64_hex(u64 nn) {
	if (nn == 0) {
		return _S("0");
	}
	return builtin__u64_to_hex_no_leading_zeros(nn, 16);
}
string builtin__i64_hex(i64 nn) {
	return builtin__u64_hex(((u64)(nn)));
}
string builtin__int_literal_hex(int_literal nn) {
	return builtin__u64_hex(((u64)(nn)));
}
string builtin__voidptr_str(voidptr nn) {
	return builtin__string__plus(_S("0x"), builtin__u64_hex(((u64)(nn))));
}
string builtin__byteptr_str(byteptr nn) {
	return builtin__string__plus(_S("0x"), builtin__u64_hex(((u64)(nn))));
}
string builtin__charptr_str(charptr nn) {
	return builtin__string__plus(_S("0x"), builtin__u64_hex(((u64)(nn))));
}
string builtin__u8_hex_full(u8 nn) {
	return builtin__u64_to_hex(((u64)(nn)), 2);
}
string builtin__i8_hex_full(i8 nn) {
	return builtin__u64_to_hex(((u64)(nn)), 2);
}
string builtin__u16_hex_full(u16 nn) {
	return builtin__u64_to_hex(((u64)(nn)), 4);
}
string builtin__i16_hex_full(i16 nn) {
	return builtin__u64_to_hex(((u64)(nn)), 4);
}
string builtin__u32_hex_full(u32 nn) {
	return builtin__u64_to_hex(((u64)(nn)), 8);
}
string builtin__i64_hex_full(i64 nn) {
	return builtin__u64_to_hex(((u64)(nn)), 16);
}
string builtin__voidptr_hex_full(voidptr nn) {
	return builtin__u64_to_hex(((u64)(nn)), 16);
}
string builtin__int_literal_hex_full(int_literal nn) {
	return builtin__u64_to_hex(((u64)(nn)), 16);
}
string builtin__u64_hex_full(u64 nn) {
	return builtin__u64_to_hex(nn, 16);
}
string builtin__u8_str(u8 b) {
	return builtin__int_str_l(((int)(b)), 4);
}
string builtin__u8_ascii_str(u8 b) {
	string str = ((string){.str = builtin__malloc_noscan(2), .len = 1});
	{ // Unsafe block
		str.str[0] = b;
		str.str[1] = 0;
	}
	return str;
}
string builtin__u8_str_escaped(u8 b) {
	string _t1 = (string){.str=(byteptr)"", .is_lit=1};
	
	if (b == (0)) {
		_t1 = _S("`\\0`");
	}
	else if (b == (7)) {
		_t1 = _S("`\\a`");
	}
	else if (b == (8)) {
		_t1 = _S("`\\b`");
	}
	else if (b == (9)) {
		_t1 = _S("`\\t`");
	}
	else if (b == (10)) {
		_t1 = _S("`\\n`");
	}
	else if (b == (11)) {
		_t1 = _S("`\\v`");
	}
	else if (b == (12)) {
		_t1 = _S("`\\f`");
	}
	else if (b == (13)) {
		_t1 = _S("`\\r`");
	}
	else if (b == (27)) {
		_t1 = _S("`\\e`");
	}
	else if ((b >= 32 && b <= 126)) {
		_t1 = builtin__u8_ascii_str(b);
	}
	else {
		string xx = builtin__u8_hex(b);
		string yy = builtin__string__plus(_S("0x"), xx);
		builtin__string_free(&xx);
		_t1 = yy;
	}string str = _t1;
	return str;
}
inline bool builtin__u8_is_capital(u8 c) {
	return c >= 'A' && c <= 'Z';
}
string Array_u8_bytestr(Array_u8 b) {
	{ // Unsafe block
		u8* buf = builtin__malloc_noscan((int)(b.len + 1));
		builtin__vmemcpy(buf, b.data, b.len);
		buf[b.len] = 0;
		return builtin__tos(buf, b.len);
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
_result_rune Array_u8_byterune(Array_u8 b) {
	_result_rune _t1 = Array_u8_utf8_to_utf32(b);
	if (_t1.is_error) {
		_result_rune _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 	rune r = (*(rune*)_t1.data);
	_result_rune _t3;
	builtin___result_ok(&(rune[]) { ((rune)(r)) }, (_result*)(&_t3), sizeof(rune));
	 
	return _t3;
}
string builtin__u8_repeat(u8 b, int count) {
	if (count <= 0) {
		return _S("");
	} else if (count == 1) {
		return builtin__u8_ascii_str(b);
	}
	u8* bytes = builtin__malloc_noscan((int)(count + 1));
	{ // Unsafe block
		builtin__vmemset(bytes, b, count);
		bytes[count] = 0;
	}
	return builtin__u8_vstring_with_len(bytes, count);
}
inline int builtin__int_min(int a, int b) {
	return (a < b ? (a) : (b));
}
inline int builtin__int_max(int a, int b) {
	return (a > b ? (a) : (b));
}
inline VV_LOC bool builtin__fast_string_eq(string a, string b) {
	if (a.len != b.len) {
		return false;
	}
	{ // Unsafe block
		return memcmp(a.str, b.str, b.len) == 0;
	}
	return 0;
}
VV_LOC u64 builtin__map_hash_string(voidptr pkey) {
	string key = *((string*)(pkey));
	#if defined(_VNATIVE)
	{
	}
	#else
	{
		return wyhash(key.str, ((u64)(key.len)), 0, ((u64*)(((voidptr)(_wyp)))));
	}
	#endif
	return 0;
}
VV_LOC u64 builtin__map_hash_int_1(voidptr pkey) {
	return wyhash64(*((u8*)(pkey)), 0);
}
VV_LOC u64 builtin__map_hash_int_2(voidptr pkey) {
	return wyhash64(*((u16*)(pkey)), 0);
}
VV_LOC u64 builtin__map_hash_int_4(voidptr pkey) {
	return wyhash64(*((u32*)(pkey)), 0);
}
VV_LOC u64 builtin__map_hash_int_8(voidptr pkey) {
	return wyhash64(*((u64*)(pkey)), 0);
}
VV_LOC voidptr builtin__map_enum_fn(int kind, int esize) {
	if (!(kind == 1 || kind == 2 || kind == 3)) {
		builtin___v_panic(_S("map_enum_fn: invalid kind"));
		VUNREACHABLE();
	}
	if (esize > 8 || esize < 0) {
		builtin___v_panic(_S("map_enum_fn: invalid esize"));
		VUNREACHABLE();
	}
	if (kind == 1) {
		if (esize > 4) {
			return ((voidptr)(builtin__map_hash_int_8));
		}
		if (esize > 2) {
			return ((voidptr)(builtin__map_hash_int_4));
		}
		if (esize > 1) {
			return ((voidptr)(builtin__map_hash_int_2));
		}
		if (esize > 0) {
			return ((voidptr)(builtin__map_hash_int_1));
		}
	}
	if (kind == 2) {
		if (esize > 4) {
			return ((voidptr)(builtin__map_eq_int_8));
		}
		if (esize > 2) {
			return ((voidptr)(builtin__map_eq_int_4));
		}
		if (esize > 1) {
			return ((voidptr)(builtin__map_eq_int_2));
		}
		if (esize > 0) {
			return ((voidptr)(builtin__map_eq_int_1));
		}
	}
	if (kind == 3) {
		if (esize > 4) {
			return ((voidptr)(builtin__map_clone_int_8));
		}
		if (esize > 2) {
			return ((voidptr)(builtin__map_clone_int_4));
		}
		if (esize > 1) {
			return ((voidptr)(builtin__map_clone_int_2));
		}
		if (esize > 0) {
			return ((voidptr)(builtin__map_clone_int_1));
		}
	}
	return ((void*)0);
}
VV_LOC void builtin__DenseArray_zeros_to_end(DenseArray* d) {
	u8* tmp_value = builtin___v_malloc(d->value_bytes);
	u8* tmp_key = builtin___v_malloc(d->key_bytes);
	int count = 0;
	for (int i = 0; i < d->len; ++i) {
		if (builtin__DenseArray_has_index(d, i)) {
			{ // Unsafe block
				if (count != i) {
					memcpy(tmp_key, builtin__DenseArray_key(d, count), d->key_bytes);
					memcpy(builtin__DenseArray_key(d, count), builtin__DenseArray_key(d, i), d->key_bytes);
					memcpy(builtin__DenseArray_key(d, i), tmp_key, d->key_bytes);
					memcpy(tmp_value, builtin__DenseArray_value(d, count), d->value_bytes);
					memcpy(builtin__DenseArray_value(d, count), builtin__DenseArray_value(d, i), d->value_bytes);
					memcpy(builtin__DenseArray_value(d, i), tmp_value, d->value_bytes);
				}
			}
			count++;
		}
	}
	{ // Unsafe block
		builtin___v_free(tmp_value);
		builtin___v_free(tmp_key);
		d->deletes = 0;
		builtin___v_free(d->all_deleted);
	}
	d->len = count;
	int old_cap = d->cap;
	d->cap = (count < 8 ? (8) : (count));
	{ // Unsafe block
		d->values = builtin__realloc_data(d->values, (int)(d->value_bytes * old_cap), (int)(d->value_bytes * d->cap));
		d->keys = builtin__realloc_data(d->keys, (int)(d->key_bytes * old_cap), (int)(d->key_bytes * d->cap));
	}
}
inline VV_LOC DenseArray builtin__new_dense_array(int key_bytes, int value_bytes) {
	int cap = 8;
	return ((DenseArray){
		.key_bytes = key_bytes,
		.value_bytes = value_bytes,
		.cap = cap,
		.len = 0,
		.deletes = 0,
		.all_deleted = ((void*)0),
		.keys = builtin___v_malloc(builtin____at_least_one((u64)(((u64)(cap)) * ((u64)(key_bytes))))),
		.values = builtin___v_malloc(builtin____at_least_one((u64)(((u64)(cap)) * ((u64)(value_bytes))))),
	});
}
inline VV_LOC voidptr builtin__DenseArray_key(DenseArray* d, int i) {
	return ((voidptr)(d->keys + (int)(i * d->key_bytes)));
}
inline VV_LOC voidptr builtin__DenseArray_value(DenseArray* d, int i) {
	return ((voidptr)(d->values + (int)(i * d->value_bytes)));
}
inline VV_LOC bool builtin__DenseArray_has_index(DenseArray* d, int i) {
	return d->deletes == 0 || d->all_deleted[i] == 0;
}
inline VV_LOC int builtin__DenseArray_expand(DenseArray* d) {
	int old_cap = d->cap;
	int old_key_size = (int)(d->key_bytes * old_cap);
	int old_value_size = (int)(d->value_bytes * old_cap);
	if (d->cap == d->len) {
		d->cap += (d->cap >> 3);
		{ // Unsafe block
			d->keys = builtin__realloc_data(d->keys, old_key_size, (int)(d->key_bytes * d->cap));
			d->values = builtin__realloc_data(d->values, old_value_size, (int)(d->value_bytes * d->cap));
			if (d->deletes != 0) {
				d->all_deleted = builtin__realloc_data(d->all_deleted, old_cap, d->cap);
				builtin__vmemset(((voidptr)(d->all_deleted + d->len)), 0, (int)(d->cap - d->len));
			}
		}
	}
	int push_index = d->len;
	{ // Unsafe block
		if (d->deletes != 0) {
			d->all_deleted[push_index] = 0;
		}
	}
	d->len++;
	return push_index;
}
inline VV_LOC bool builtin__map_eq_string(voidptr a, voidptr b) {
	return builtin__fast_string_eq(*((string*)(a)), *((string*)(b)));
}
inline VV_LOC bool builtin__map_eq_int_1(voidptr a, voidptr b) {
	return *((u8*)(a)) == *((u8*)(b));
}
inline VV_LOC bool builtin__map_eq_int_2(voidptr a, voidptr b) {
	return *((u16*)(a)) == *((u16*)(b));
}
inline VV_LOC bool builtin__map_eq_int_4(voidptr a, voidptr b) {
	return *((u32*)(a)) == *((u32*)(b));
}
inline VV_LOC bool builtin__map_eq_int_8(voidptr a, voidptr b) {
	return *((u64*)(a)) == *((u64*)(b));
}
inline VV_LOC void builtin__map_clone_string(voidptr dest, voidptr pkey) {
	{ // Unsafe block
		string s = *((string*)(pkey));
		string cloned = builtin__string_clone(s);
		memcpy(dest, ((voidptr)(&cloned)), sizeof(string));
	}
}
inline VV_LOC void builtin__map_clone_int_1(voidptr dest, voidptr pkey) {
	{ // Unsafe block
		*((u8*)(dest)) = *((u8*)(pkey));
	}
}
inline VV_LOC void builtin__map_clone_int_2(voidptr dest, voidptr pkey) {
	{ // Unsafe block
		*((u16*)(dest)) = *((u16*)(pkey));
	}
}
inline VV_LOC void builtin__map_clone_int_4(voidptr dest, voidptr pkey) {
	{ // Unsafe block
		*((u32*)(dest)) = *((u32*)(pkey));
	}
}
inline VV_LOC void builtin__map_clone_int_8(voidptr dest, voidptr pkey) {
	{ // Unsafe block
		*((u64*)(dest)) = *((u64*)(pkey));
	}
}
inline VV_LOC void builtin__map_free_string(voidptr pkey) {
	builtin__string_free(ADDR(string, (*((string*)(pkey)))));
}
inline VV_LOC void builtin__map_free_nop(voidptr _d1) {
}
VV_LOC map builtin__new_map(int key_bytes, int value_bytes, u64 (*hash_fn)(voidptr ), bool (*key_eq_fn)(voidptr , voidptr ), void (*clone_fn)(voidptr , voidptr ), void (*free_fn)(voidptr )) {
	int metasize = ((int)((u32)(sizeof(u32) * ((int_literal)(_const_init_capicity + _const_extra_metas_inc)))));
	bool has_string_keys = key_bytes > ((int)(sizeof(voidptr)));
	return ((map){
		.key_bytes = key_bytes,
		.value_bytes = value_bytes,
		.even_index = _const_init_even_index,
		.cached_hashbits = _const_max_cached_hashbits,
		.shift = _const_init_log_capicity,
		.key_values = builtin__new_dense_array(key_bytes, value_bytes),
		.metas = ((u32*)(builtin__vcalloc_noscan(metasize))),
		.extra_metas = _const_extra_metas_inc,
		.has_string_keys = has_string_keys,
		.hash_fn = (voidptr)hash_fn,
		.key_eq_fn = (voidptr)key_eq_fn,
		.clone_fn = (voidptr)clone_fn,
		.free_fn = (voidptr)free_fn,
		.len = 0,
	});
}
VV_LOC map builtin__new_map_init(u64 (*hash_fn)(voidptr ), bool (*key_eq_fn)(voidptr , voidptr ), void (*clone_fn)(voidptr , voidptr ), void (*free_fn)(voidptr ), int n, int key_bytes, int value_bytes, voidptr keys, voidptr values) {
	map out = builtin__new_map(key_bytes, value_bytes, (voidptr)hash_fn, (voidptr)key_eq_fn, (voidptr)clone_fn, (voidptr)free_fn);
	u8* pkey = ((u8*)(keys));
	u8* pval = ((u8*)(values));
	for (int _t1 = 0; _t1 < n; ++_t1) {
		{ // Unsafe block
			builtin__map_set(&out, pkey, pval);
			pkey = pkey + key_bytes;
			pval = pval + value_bytes;
		}
	}
	return out;
}
map builtin__map_move(map* m) {
	map r = *m;
	builtin__vmemset(m, 0, ((int)(sizeof(map))));
	return r;
}
void builtin__map_clear(map* m) {
	{ // Unsafe block
		if (m->key_values.all_deleted != 0) {
			builtin___v_free(m->key_values.all_deleted);
			m->key_values.all_deleted = ((void*)0);
		}
		builtin__vmemset(m->key_values.keys, 0, (int)(m->key_values.key_bytes * m->key_values.cap));
		builtin__vmemset(m->metas, 0, (u32)(sizeof(u32) * ((u32)((u32)(m->even_index + 2) + m->extra_metas))));
	}
	m->key_values.len = 0;
	m->key_values.deletes = 0;
	m->even_index = _const_init_even_index;
	m->cached_hashbits = _const_max_cached_hashbits;
	m->shift = _const_init_log_capicity;
	m->len = 0;
}
inline VV_LOC multi_return_u32_u32 builtin__map_key_to_index(map* m, voidptr pkey) {
	u64 hash = m->hash_fn(pkey);
	u64 index = (hash & m->even_index);
	u64 meta = (((((hash >> m->shift)) & _const_hash_mask)) | _const_probe_inc);
	return (multi_return_u32_u32){.arg0=((u32)(index)), .arg1=((u32)(meta))};
}
inline VV_LOC multi_return_u32_u32 builtin__map_meta_less(map* m, u32 _index, u32 _metas) {
	u32 index = _index;
	u32 meta = _metas;
	for (;;) {
		if (!(meta < m->metas[index])) break;
		index += 2;
		meta += _const_probe_inc;
	}
	return (multi_return_u32_u32){.arg0=index, .arg1=meta};
}
inline VV_LOC void builtin__map_meta_greater(map* m, u32 _index, u32 _metas, u32 kvi) {
	u32 meta = _metas;
	u32 index = _index;
	u32 kv_index = kvi;
	for (;;) {
		if (!(m->metas[index] != 0)) break;
		if (meta > m->metas[index]) {
			{ // Unsafe block
				u32 tmp_meta = m->metas[index];
				m->metas[index] = meta;
				meta = tmp_meta;
				u32 tmp_index = m->metas[(u32)(index + 1)];
				m->metas[(u32)(index + 1)] = kv_index;
				kv_index = tmp_index;
			}
		}
		index += 2;
		meta += _const_probe_inc;
	}
	{ // Unsafe block
		m->metas[index] = meta;
		m->metas[(u32)(index + 1)] = kv_index;
	}
	u32 probe_count = (u32)(((meta >> _const_hashbits)) - 1);
	builtin__map_ensure_extra_metas(m, probe_count);
}
inline VV_LOC void builtin__map_ensure_extra_metas(map* m, u32 probe_count) {
	if (((probe_count << 1)) == m->extra_metas) {
		u32 size_of_u32 = sizeof(u32);
		u32 old_mem_size = ((u32)((u32)(m->even_index + 2) + m->extra_metas));
		m->extra_metas += _const_extra_metas_inc;
		u32 mem_size = ((u32)((u32)(m->even_index + 2) + m->extra_metas));
		{ // Unsafe block
			u8* x = builtin__realloc_data(((u8*)(m->metas)), ((int)((u32)(size_of_u32 * old_mem_size))), ((int)((u32)(size_of_u32 * mem_size))));
			m->metas = ((u32*)(x));
			builtin__vmemset(m->metas + mem_size - _const_extra_metas_inc, 0, ((int)((u32)(sizeof(u32) * _const_extra_metas_inc))));
		}
		if (probe_count == 252) {
			builtin___v_panic(_S("Probe overflow"));
			VUNREACHABLE();
		}
	}
}
VV_LOC void builtin__map_set(map* m, voidptr key, voidptr value) {
	f32 load_factor = (f32)(((f32)((((u32)(m->len)) << 1))) / ((f32)(m->even_index)));
	if (load_factor > ((f32)(_const_max_load_factor))) {
		builtin__map_expand(m);
	}
	multi_return_u32_u32 mr_12485 = builtin__map_key_to_index(m, key);
	u32 index = mr_12485.arg0;
	u32 meta = mr_12485.arg1;
	multi_return_u32_u32 mr_12521 = builtin__map_meta_less(m, index, meta);
	index = mr_12521.arg0;
	meta = mr_12521.arg1;
	for (;;) {
		if (!(meta == m->metas[index])) break;
		int kv_index = ((int)(m->metas[(u32)(index + 1)]));
		voidptr pkey = builtin__DenseArray_key(&m->key_values, kv_index);
		if (m->key_eq_fn(key, pkey)) {
			{ // Unsafe block
				voidptr pval = builtin__DenseArray_value(&m->key_values, kv_index);
				builtin__vmemcpy(pval, value, m->value_bytes);
			}
			return;
		}
		index += 2;
		meta += _const_probe_inc;
	}
	int kv_index = builtin__DenseArray_expand(&m->key_values);
	{ // Unsafe block
		voidptr pkey = builtin__DenseArray_key(&m->key_values, kv_index);
		voidptr pvalue = builtin__DenseArray_value(&m->key_values, kv_index);
		m->clone_fn(pkey, key);
		builtin__vmemcpy(((u8*)(pvalue)), value, m->value_bytes);
	}
	builtin__map_meta_greater(m, index, meta, ((u32)(kv_index)));
	m->len++;
}
VV_LOC void builtin__map_expand(map* m) {
	u32 old_cap = m->even_index;
	m->even_index = (u32)(((((u32)(m->even_index + 2)) << 1)) - 2);
	if (m->cached_hashbits == 0) {
		m->shift += _const_max_cached_hashbits;
		m->cached_hashbits = _const_max_cached_hashbits;
		builtin__map_rehash(m);
	} else {
		builtin__map_cached_rehash(m, old_cap);
		m->cached_hashbits--;
	}
}
VV_LOC void builtin__map_rehash(map* m) {
	u32 meta_bytes = (u32)(sizeof(u32) * ((u32)((u32)(m->even_index + 2) + m->extra_metas)));
	builtin__map_reserve(m, meta_bytes);
}
void builtin__map_reserve(map* m, u32 meta_bytes) {
	{ // Unsafe block
		u8* x = builtin__v_realloc(((u8*)(m->metas)), ((int)(meta_bytes)));
		m->metas = ((u32*)(x));
		builtin__vmemset(m->metas, 0, ((int)(meta_bytes)));
	}
	for (int i = 0; i < m->key_values.len; i++) {
		if (!builtin__DenseArray_has_index(&m->key_values, i)) {
			continue;
		}
		voidptr pkey = builtin__DenseArray_key(&m->key_values, i);
		multi_return_u32_u32 mr_14282 = builtin__map_key_to_index(m, pkey);
		u32 index = mr_14282.arg0;
		u32 meta = mr_14282.arg1;
		multi_return_u32_u32 mr_14320 = builtin__map_meta_less(m, index, meta);
		index = mr_14320.arg0;
		meta = mr_14320.arg1;
		builtin__map_meta_greater(m, index, meta, ((u32)(i)));
	}
}
VV_LOC void builtin__map_cached_rehash(map* m, u32 old_cap) {
	u32* old_metas = m->metas;
	int metasize = ((int)((u32)(sizeof(u32) * ((u32)((u32)(m->even_index + 2) + m->extra_metas)))));
	m->metas = ((u32*)(builtin__vcalloc(metasize)));
	u32 old_extra_metas = m->extra_metas;
	for (u32 i = ((u32)(0)); i <= (u32)(old_cap + old_extra_metas); i += 2) {
		if (old_metas[i] == 0) {
			continue;
		}
		u32 old_meta = old_metas[i];
		u32 old_probe_count = (((u32)(((old_meta >> _const_hashbits)) - 1)) << 1);
		u32 old_index = (((u32)(i - old_probe_count)) & ((m->even_index >> 1)));
		u32 index = (((old_index | ((old_meta << m->shift)))) & m->even_index);
		u32 meta = (((old_meta & _const_hash_mask)) | _const_probe_inc);
		multi_return_u32_u32 mr_15122 = builtin__map_meta_less(m, index, meta);
		index = mr_15122.arg0;
		meta = mr_15122.arg1;
		u32 kv_index = old_metas[(u32)(i + 1)];
		builtin__map_meta_greater(m, index, meta, kv_index);
	}
	builtin___v_free(old_metas);
}
VV_LOC voidptr builtin__map_get_and_set(map* m, voidptr key, voidptr zero) {
	for (;;) {
		multi_return_u32_u32 mr_15570 = builtin__map_key_to_index(m, key);
		u32 index = mr_15570.arg0;
		u32 meta = mr_15570.arg1;
		for (;;) {
			if (meta == m->metas[index]) {
				int kv_index = ((int)(m->metas[(u32)(index + 1)]));
				voidptr pkey = builtin__DenseArray_key(&m->key_values, kv_index);
				if (m->key_eq_fn(key, pkey)) {
					voidptr pval = builtin__DenseArray_value(&m->key_values, kv_index);
					return ((u8*)(pval));
				}
			}
			index += 2;
			meta += _const_probe_inc;
			if (meta > m->metas[index]) {
				break;
			}
		}
		builtin__map_set(m, key, zero);
	}
	return ((void*)0);
}
VV_LOC voidptr builtin__map_get(map* m, voidptr key, voidptr zero) {
	if (m->len == 0) {
		return zero;
	}
	multi_return_u32_u32 mr_16331 = builtin__map_key_to_index(m, key);
	u32 index = mr_16331.arg0;
	u32 meta = mr_16331.arg1;
	for (;;) {
		if (meta == m->metas[index]) {
			int kv_index = ((int)(m->metas[(u32)(index + 1)]));
			voidptr pkey = builtin__DenseArray_key(&m->key_values, kv_index);
			if (m->key_eq_fn(key, pkey)) {
				voidptr pval = builtin__DenseArray_value(&m->key_values, kv_index);
				return ((u8*)(pval));
			}
		}
		index += 2;
		meta += _const_probe_inc;
		if (meta > m->metas[index]) {
			break;
		}
	}
	return zero;
}
VV_LOC voidptr builtin__map_get_check(map* m, voidptr key) {
	if (m->len == 0) {
		return 0;
	}
	multi_return_u32_u32 mr_17027 = builtin__map_key_to_index(m, key);
	u32 index = mr_17027.arg0;
	u32 meta = mr_17027.arg1;
	for (;;) {
		if (meta == m->metas[index]) {
			int kv_index = ((int)(m->metas[(u32)(index + 1)]));
			voidptr pkey = builtin__DenseArray_key(&m->key_values, kv_index);
			if (m->key_eq_fn(key, pkey)) {
				voidptr pval = builtin__DenseArray_value(&m->key_values, kv_index);
				return ((u8*)(pval));
			}
		}
		index += 2;
		meta += _const_probe_inc;
		if (meta > m->metas[index]) {
			break;
		}
	}
	return 0;
}
VV_LOC bool builtin__map_exists(map* m, voidptr key) {
	if (m->len == 0) {
		return false;
	}
	multi_return_u32_u32 mr_17572 = builtin__map_key_to_index(m, key);
	u32 index = mr_17572.arg0;
	u32 meta = mr_17572.arg1;
	for (;;) {
		if (meta == m->metas[index]) {
			int kv_index = ((int)(m->metas[(u32)(index + 1)]));
			voidptr pkey = builtin__DenseArray_key(&m->key_values, kv_index);
			if (m->key_eq_fn(key, pkey)) {
				return true;
			}
		}
		index += 2;
		meta += _const_probe_inc;
		if (meta > m->metas[index]) {
			break;
		}
	}
	return false;
}
inline VV_LOC void builtin__DenseArray_delete(DenseArray* d, int i) {
	if (d->deletes == 0) {
		d->all_deleted = builtin__vcalloc(d->cap);
	}
	d->deletes++;
	{ // Unsafe block
		d->all_deleted[i] = 1;
	}
}
void builtin__map_delete(map* m, voidptr key) {
	multi_return_u32_u32 mr_18210 = builtin__map_key_to_index(m, key);
	u32 index = mr_18210.arg0;
	u32 meta = mr_18210.arg1;
	multi_return_u32_u32 mr_18246 = builtin__map_meta_less(m, index, meta);
	index = mr_18246.arg0;
	meta = mr_18246.arg1;
	for (;;) {
		if (!(meta == m->metas[index])) break;
		int kv_index = ((int)(m->metas[(u32)(index + 1)]));
		voidptr pkey = builtin__DenseArray_key(&m->key_values, kv_index);
		if (m->key_eq_fn(key, pkey)) {
			for (;;) {
				if (!(((m->metas[(u32)(index + 2)] >> _const_hashbits)) > 1)) break;
				{ // Unsafe block
					m->metas[index] = (u32)(m->metas[(u32)(index + 2)] - _const_probe_inc);
					m->metas[(u32)(index + 1)] = m->metas[(u32)(index + 3)];
				}
				index += 2;
			}
			m->len--;
			builtin__DenseArray_delete(&m->key_values, kv_index);
			{ // Unsafe block
				m->metas[index] = 0;
				m->free_fn(pkey);
				builtin__vmemset(pkey, 0, m->key_bytes);
			}
			if (m->key_values.len <= 32) {
				return;
			}
			if (_us32_ge(m->key_values.deletes,((m->key_values.len >> 1)))) {
				builtin__DenseArray_zeros_to_end(&m->key_values);
				builtin__map_rehash(m);
			}
			return;
		}
		index += 2;
		meta += _const_probe_inc;
	}
}
array builtin__map_keys(map* m) {
	array keys = builtin____new_array(m->len, 0, m->key_bytes);
	u8* item = ((u8*)(keys.data));
	if (m->key_values.deletes == 0) {
		for (int i = 0; i < m->key_values.len; i++) {
			{ // Unsafe block
				voidptr pkey = builtin__DenseArray_key(&m->key_values, i);
				m->clone_fn(item, pkey);
				item = item + m->key_bytes;
			}
		}
		return keys;
	}
	for (int i = 0; i < m->key_values.len; i++) {
		if (!builtin__DenseArray_has_index(&m->key_values, i)) {
			continue;
		}
		{ // Unsafe block
			voidptr pkey = builtin__DenseArray_key(&m->key_values, i);
			m->clone_fn(item, pkey);
			item = item + m->key_bytes;
		}
	}
	return keys;
}
array builtin__map_values(map* m) {
	array values = builtin____new_array(m->len, 0, m->value_bytes);
	u8* item = ((u8*)(values.data));
	if (m->key_values.deletes == 0) {
		builtin__vmemcpy(item, m->key_values.values, (int)(m->value_bytes * m->key_values.len));
		return values;
	}
	for (int i = 0; i < m->key_values.len; i++) {
		if (!builtin__DenseArray_has_index(&m->key_values, i)) {
			continue;
		}
		{ // Unsafe block
			voidptr pvalue = builtin__DenseArray_value(&m->key_values, i);
			builtin__vmemcpy(item, pvalue, m->value_bytes);
			item = item + m->value_bytes;
		}
	}
	return values;
}
VV_LOC DenseArray builtin__DenseArray_clone(DenseArray* d) {
	DenseArray res = ((DenseArray){
		.key_bytes = d->key_bytes,
		.value_bytes = d->value_bytes,
		.cap = d->cap,
		.len = d->len,
		.deletes = d->deletes,
		.all_deleted = ((void*)0),
		.keys = ((void*)0),
		.values = ((void*)0),
	});
	{ // Unsafe block
		if (d->deletes != 0) {
			res.all_deleted = builtin__memdup(d->all_deleted, d->cap);
		}
		res.keys = builtin__memdup(d->keys, (int)(d->cap * d->key_bytes));
		res.values = builtin__memdup(d->values, (int)(d->cap * d->value_bytes));
	}
	return res;
}
map builtin__map_clone(map* m) {
	int metasize = ((int)((u32)(sizeof(u32) * ((u32)((u32)(m->even_index + 2) + m->extra_metas)))));
	map res = ((map){
		.key_bytes = m->key_bytes,
		.value_bytes = m->value_bytes,
		.even_index = m->even_index,
		.cached_hashbits = m->cached_hashbits,
		.shift = m->shift,
		.key_values = builtin__DenseArray_clone(&m->key_values),
		.metas = ((u32*)(builtin__malloc_noscan(metasize))),
		.extra_metas = m->extra_metas,
		.has_string_keys = m->has_string_keys,
		.hash_fn = (voidptr)m->hash_fn,
		.key_eq_fn = (voidptr)m->key_eq_fn,
		.clone_fn = (voidptr)m->clone_fn,
		.free_fn = (voidptr)m->free_fn,
		.len = m->len,
	});
	builtin__vmemcpy(res.metas, m->metas, metasize);
	if (!m->has_string_keys) {
		return res;
	}
	for (int i = 0; i < m->key_values.len; ++i) {
		if (!builtin__DenseArray_has_index(&m->key_values, i)) {
			continue;
		}
		m->clone_fn(builtin__DenseArray_key(&res.key_values, i), builtin__DenseArray_key(&m->key_values, i));
	}
	return res;
}
void builtin__map_free(map* m) {
	builtin___v_free(m->metas);
	{ // Unsafe block
		m->metas = ((void*)0);
	}
	if (m->key_values.deletes == 0) {
		for (int i = 0; i < m->key_values.len; i++) {
			{ // Unsafe block
				voidptr pkey = builtin__DenseArray_key(&m->key_values, i);
				m->free_fn(pkey);
				builtin__vmemset(pkey, 0, m->key_bytes);
			}
		}
	} else {
		for (int i = 0; i < m->key_values.len; i++) {
			if (!builtin__DenseArray_has_index(&m->key_values, i)) {
				continue;
			}
			{ // Unsafe block
				voidptr pkey = builtin__DenseArray_key(&m->key_values, i);
				m->free_fn(pkey);
				builtin__vmemset(pkey, 0, m->key_bytes);
			}
		}
	}
	{ // Unsafe block
		if (m->key_values.all_deleted != ((void*)0)) {
			builtin___v_free(m->key_values.all_deleted);
			m->key_values.all_deleted = ((void*)0);
		}
		if (m->key_values.keys != ((void*)0)) {
			builtin___v_free(m->key_values.keys);
			m->key_values.keys = ((void*)0);
		}
		if (m->key_values.values != ((void*)0)) {
			builtin___v_free(m->key_values.values);
			m->key_values.values = ((void*)0);
		}
		m->hash_fn = (voidptr)((void*)0);
		m->key_eq_fn = (voidptr)((void*)0);
		m->clone_fn = (voidptr)((void*)0);
		m->free_fn = (voidptr)((void*)0);
	}
}
void builtin__VAssertMetaInfo_free(VAssertMetaInfo* ami) {
	{ // Unsafe block
		builtin__string_free(&ami->fpath);
		builtin__string_free(&ami->fn_name);
		builtin__string_free(&ami->src);
		builtin__string_free(&ami->op);
		builtin__string_free(&ami->llabel);
		builtin__string_free(&ami->rlabel);
		builtin__string_free(&ami->lvalue);
		builtin__string_free(&ami->rvalue);
		builtin__string_free(&ami->message);
	}
}
void builtin__IError_free(IError* ie) {
	{ // Unsafe block
		IError* cie = ((IError*)(ie));
		builtin___v_free(cie->_object);
	}
}
VNORETURN void builtin__panic_option_not_set(string s) {
	builtin___v_panic(builtin__string__plus(builtin__string__plus(_S("option not set ("), s), _S(")")));
	VUNREACHABLE();
	while(1);
}
VNORETURN void builtin__panic_result_not_set(string s) {
	builtin___v_panic(builtin__string__plus(builtin__string__plus(_S("result not set ("), s), _S(")")));
	VUNREACHABLE();
	while(1);
}
VNORETURN void builtin___v_panic(string s) {
	#if defined(_VFREESTANDING)
	{
	}
	#else
	{
		builtin__flush_stdout();
		builtin__eprint(_S("V panic: "));
		builtin__eprintln(s);
		builtin__eprint(_S(" v hash: "));
		builtin__eprintln(builtin__vcurrent_hash());
		#if !defined(__vinix__) && !defined(_VNATIVE)
		{
			builtin__eprint(_S("    pid: "));
			;
			fprintf(stderr, "%p\n", ((voidptr)(builtin__v_getpid())));
			builtin__eprint(_S("    tid: "));
			;
			fprintf(stderr, "%p\n", ((voidptr)(builtin__v_gettid())));
		}
		#endif
		builtin__flush_stdout();
		#if defined(_VNATIVE)
		{
		}
		#elif defined(CUSTOM_DEFINE_exit_after_panic_message)
		{
		}
		#elif defined(CUSTOM_DEFINE_no_backtrace)
		{
		}
		#else
		{
			#if defined(CUSTOM_DEFINE_use_libbacktrace)
			{
			}
			#else
			{
				builtin__print_backtrace_skipping_top_frames(1);
			}
			#endif
			exit(1);
			VUNREACHABLE();
		}
		#endif
	}
	#endif
	exit(1);
	VUNREACHABLE();
	while(1);
}
string builtin__c_error_number_str(int errnum) {
	string err_msg = _S("");
	#if defined(_VFREESTANDING)
	{
	}
	#else
	{
		#if !defined(__vinix__)
		{
			char* c_msg = strerror(errnum);
			err_msg = ((string){.str = ((u8*)(c_msg)), .len = strlen(c_msg), .is_lit = 1});
		}
		#endif
	}
	#endif
	return err_msg;
}
VNORETURN void builtin__panic_n(string s, i64 number1) {
	builtin___v_panic(builtin__string__plus(s, builtin__impl_i64_to_string(number1)));
	VUNREACHABLE();
	while(1);
}
VNORETURN void builtin__panic_n2(string s, i64 number1, i64 number2) {
	builtin___v_panic(builtin__string__plus(builtin__string__plus(builtin__string__plus(s, builtin__impl_i64_to_string(number1)), _S(", ")), builtin__impl_i64_to_string(number2)));
	VUNREACHABLE();
	while(1);
}
VNORETURN VV_LOC void builtin__panic_n3(string s, i64 number1, i64 number2, i64 number3) {
	builtin___v_panic(builtin__string__plus(builtin__string__plus(builtin__string__plus(builtin__string__plus(builtin__string__plus(s, builtin__impl_i64_to_string(number1)), _S(", ")), builtin__impl_i64_to_string(number2)), _S(", ")), builtin__impl_i64_to_string(number3)));
	VUNREACHABLE();
	while(1);
}
VNORETURN void builtin__panic_error_number(string basestr, int errnum) {
	builtin___v_panic(builtin__string__plus(basestr, builtin__c_error_number_str(errnum)));
	VUNREACHABLE();
	while(1);
}
void builtin__eprintln(string s) {
	if (s.str == 0) {
		builtin__eprintln(_S("eprintln(NIL)"));
		return;
	}
	#if defined(_VFREESTANDING)
	{
	}
	#elif defined(__TARGET_IOS__)
	{
	}
	#else
	{
		builtin__flush_stdout();
		builtin__flush_stderr();
		builtin___writeln_to_fd(2, s);
		builtin__flush_stderr();
	}
	#endif
}
void builtin__eprint(string s) {
	if (s.str == 0) {
		builtin__eprint(_S("eprint(NIL)"));
		return;
	}
	#if defined(_VFREESTANDING)
	{
	}
	#elif defined(__TARGET_IOS__)
	{
	}
	#else
	{
		builtin__flush_stdout();
		builtin__flush_stderr();
		builtin___write_buf_to_fd(2, s.str, s.len);
		builtin__flush_stderr();
	}
	#endif
}
void builtin__flush_stdout(void) {
	#if defined(_VFREESTANDING)
	{
	}
	#elif defined(_VNATIVE)
	{
	}
	#else
	{
		fflush(stdout);
	}
	#endif
}
void builtin__flush_stderr(void) {
	#if defined(_VFREESTANDING)
	{
	}
	#elif defined(_VNATIVE)
	{
	}
	#else
	{
		fflush(stderr);
	}
	#endif
}
void builtin__unbuffer_stdout(void) {
	#if defined(_VFREESTANDING)
	{
	}
	#else
	{
		setbuf(stdout, 0);
	}
	#endif
}
void builtin__print(string s) {
	#if defined(__ANDROID__) && !defined(__TERMUX__)
	{
	}
	#elif defined(__TARGET_IOS__)
	{
	}
	#elif defined(_VFREESTANDING)
	{
	}
	#else
	{
		builtin___write_buf_to_fd(1, s.str, s.len);
	}
	#endif
}
void builtin__println(string s) {
	if (s.str == 0) {
		builtin__println(_S("println(NIL)"));
		return;
	}
	#if defined(__ANDROID__) && !defined(__TERMUX__)
	{
	}
	#elif defined(__TARGET_IOS__)
	{
	}
	#elif defined(_VFREESTANDING)
	{
	}
	#else
	{
		builtin___writeln_to_fd(1, s);
	}
	#endif
}
VV_LOC void builtin___writeln_to_fd(int fd, string s) {
	#if defined(CUSTOM_DEFINE_builtin_writeln_should_write_at_once)
	{
	}
	#else
	{
		u8 lf = ((u8)('\n'));
		builtin___write_buf_to_fd(fd, s.str, s.len);
		builtin___write_buf_to_fd(fd, &lf, 1);
	}
	#endif
}
VV_LOC void builtin___write_buf_to_fd(int fd, u8* buf, int buf_len) {
	if (buf_len <= 0) {
		return;
	}
	u8* ptr = buf;
	isize remaining_bytes = ((isize)(buf_len));
	isize x = ((isize)(0));
	#if defined(_VFREESTANDING) || defined(__vinix__) || defined(CUSTOM_DEFINE_builtin_write_buf_to_fd_should_use_c_write)
	{
	}
	#else
	{
		voidptr stream = ((voidptr)(stdout));
		if (fd == 2) {
			stream = ((voidptr)(stderr));
		}
		{ // Unsafe block
			for (;;) {
				if (!(remaining_bytes > 0)) break;
				x = ((isize)(fwrite(ptr, 1, remaining_bytes, stream)));
				ptr += x;
				remaining_bytes -= x;
			}
		}
	}
	#endif
}
string builtin__reuse_data_as_string(Array_u8 buffer) {
	return ((string){.str = buffer.data, .len = buffer.len, .is_lit = 1});
}
Array_u8 builtin__reuse_string_as_data(string s) {
	array res = ((array){.data = (voidptr)s.str,.offset = 0,.len = s.len,.cap = 0,.flags = ((ArrayFlags__nogrow | ArrayFlags__noshrink) | ArrayFlags__nofree),.element_size = 1,});
	return res;
}
string builtin__rune_str(rune c) {
	return builtin__utf32_to_str(((u32)(c)));
}
string Array_rune_string(Array_rune ra) {
	strings__Builder sb = strings__new_builder(ra.len);
	strings__Builder_write_runes(&sb, ra);
	string res = strings__Builder_str(&sb);
	strings__Builder_free(&sb);
	return res;
}
string builtin__rune_repeat(rune c, int count) {
	if (count <= 0) {
		return _S("");
	} else if (count == 1) {
		return builtin__rune_str(c);
	}
	Array_fixed_u8_5 buffer = {0};
	string res = builtin__utf32_to_str_no_malloc(((u32)(c)), &buffer[0]);
	return builtin__string_repeat(res, count);
}
Array_u8 builtin__rune_bytes(rune c) {
	Array_u8 res = builtin____new_array_with_default(0, 5, sizeof(u8), 0);
	u8* buf = ((u8*)(res.data));
	res.len = builtin__utf32_decode_to_buffer(((u32)(c)), buf);
	return res;
}
int builtin__rune_length_in_bytes(rune c) {
	u32 code = ((u32)(c));
	if (code <= 0x7F) {
		return 1;
	} else if (code <= 0x7FF) {
		return 2;
	} else if (0xD800 <= code && code <= 0xDFFF) {
		return -1;
	} else if (code <= 0xFFFF) {
		return 3;
	} else if (code <= 0x10FFFF) {
		return 4;
	}
	return -1;
}
rune builtin__rune_to_upper(rune c) {
	if (c < 0x80) {
		if (c >= 'a' && c <= 'z') {
			return (rune)(c - 32);
		}
		return c;
	}
	return builtin__rune_map_to(c, MapMode__to_upper);
}
rune builtin__rune_to_lower(rune c) {
	if (c < 0x80) {
		if (c >= 'A' && c <= 'Z') {
			return (rune)(c + 32);
		}
		return c;
	}
	return builtin__rune_map_to(c, MapMode__to_lower);
}
rune builtin__rune_to_title(rune c) {
	if (c < 0x80) {
		if (c >= 'a' && c <= 'z') {
			return (rune)(c - 32);
		}
		return c;
	}
	return builtin__rune_map_to(c, MapMode__to_title);
}
VV_LOC rune builtin__rune_map_to(rune c, MapMode mode) {
	int start = 0;
	int end = (int)(1264 / _const_rune_maps_columns_in_row);
	for (;;) {
		if (!(start < end)) break;
		int middle = (int)(((int)(start + end)) / 2);
		i32* cur_map = &_const_rune_maps[(int)(middle * _const_rune_maps_columns_in_row)];
		if (c >= ((u32)(*cur_map)) && c <= ((u32)(*(cur_map + 1)))) {
			i32 offset = ((mode == MapMode__to_upper || mode == MapMode__to_title) ? (*(cur_map + 2)) : (*(cur_map + 3)));
			if (offset == _const_rune_maps_ul) {
				rune cnt = (rune)(((rune)(c - *cur_map)) % 2);
				if (mode == MapMode__to_lower) {
					return (rune)((rune)(c + 1) - cnt);
				}
				return (rune)(c - cnt);
			} else if (offset == _const_rune_maps_utl) {
				rune cnt = (rune)(((rune)(c - *cur_map)) % 3);
				if (mode == MapMode__to_upper) {
					return (rune)(c - cnt);
				} else if (mode == MapMode__to_lower) {
					return (rune)((rune)(c + 2) - cnt);
				}
				return (rune)((rune)(c + 1) - cnt);
			}
			return (rune)(c + offset);
		}
		if (c < ((u32)(*cur_map))) {
			end = middle;
		} else {
			start = (int)(middle + 1);
		}
	}
	return c;
}
VV_LOC int builtin__mapnode_find_key(mapnode* n, string k) {
	int idx = 0;
	for (;;) {
		if (!(idx < n->len && builtin__string__lt(n->keys[builtin__v_fixed_index(idx, 11)], k))) break;
		idx++;
	}
	return idx;
}
VV_LOC bool builtin__mapnode_remove_key(mapnode* n, string k) {
	int idx = builtin__mapnode_find_key(n, k);
	if (idx < n->len && builtin__string__eq(n->keys[builtin__v_fixed_index(idx, 11)], k)) {
		if (n->children == ((void*)0)) {
			builtin__mapnode_remove_from_leaf(n, idx);
		} else {
			builtin__mapnode_remove_from_non_leaf(n, idx);
		}
		return true;
	} else {
		if (n->children == ((void*)0)) {
			return false;
		}
		bool flag = (idx == n->len ? (true) : (false));
		if (((mapnode*)(n->children[idx]))->len < _const_degree) {
			builtin__mapnode_fill(n, idx);
		}
		mapnode* node = ((mapnode*)(((void*)0)));
		if (flag && idx > n->len) {
			node = ((mapnode*)(n->children[(int)(idx - 1)]));
		} else {
			node = ((mapnode*)(n->children[idx]));
		}
		return builtin__mapnode_remove_key(node, k);
	}
	return 0;
}
VV_LOC void builtin__mapnode_remove_from_leaf(mapnode* n, int idx) {
	for (int i = (int)(idx + 1); i < n->len; i++) {
		n->keys[builtin__v_fixed_index((int)(i - 1), 11)] = n->keys[builtin__v_fixed_index(i, 11)];
		n->values[builtin__v_fixed_index((int)(i - 1), 11)] = n->values[builtin__v_fixed_index(i, 11)];
	}
	n->len--;
}
VV_LOC void builtin__mapnode_remove_from_non_leaf(mapnode* n, int idx) {
	string k = n->keys[builtin__v_fixed_index(idx, 11)];
	if (((mapnode*)(n->children[idx]))->len >= _const_degree) {
		mapnode* current = ((mapnode*)(n->children[idx]));
		for (;;) {
			if (!(current->children != ((void*)0))) break;
			current = ((mapnode*)(current->children[current->len]));
		}
		string predecessor = current->keys[builtin__v_fixed_index((int)(current->len - 1), 11)];
		n->keys[builtin__v_fixed_index(idx, 11)] = predecessor;
		n->values[builtin__v_fixed_index(idx, 11)] = current->values[builtin__v_fixed_index((int)(current->len - 1), 11)];
		mapnode* node = ((mapnode*)(n->children[idx]));
		builtin__mapnode_remove_key(node, predecessor);
	} else if (((mapnode*)(n->children[(int)(idx + 1)]))->len >= _const_degree) {
		mapnode* current = ((mapnode*)(n->children[(int)(idx + 1)]));
		for (;;) {
			if (!(current->children != ((void*)0))) break;
			current = ((mapnode*)(current->children[0]));
		}
		string successor = current->keys[0];
		n->keys[builtin__v_fixed_index(idx, 11)] = successor;
		n->values[builtin__v_fixed_index(idx, 11)] = current->values[0];
		mapnode* node = ((mapnode*)(n->children[(int)(idx + 1)]));
		builtin__mapnode_remove_key(node, successor);
	} else {
		builtin__mapnode_merge(n, idx);
		mapnode* node = ((mapnode*)(n->children[idx]));
		builtin__mapnode_remove_key(node, k);
	}
}
VV_LOC void builtin__mapnode_fill(mapnode* n, int idx) {
	if (idx != 0 && ((mapnode*)(n->children[(int)(idx - 1)]))->len >= _const_degree) {
		builtin__mapnode_borrow_from_prev(n, idx);
	} else if (idx != n->len && ((mapnode*)(n->children[(int)(idx + 1)]))->len >= _const_degree) {
		builtin__mapnode_borrow_from_next(n, idx);
	} else if (idx != n->len) {
		builtin__mapnode_merge(n, idx);
	} else {
		builtin__mapnode_merge(n, (int)(idx - 1));
	}
}
VV_LOC void builtin__mapnode_borrow_from_prev(mapnode* n, int idx) {
	mapnode* child = ((mapnode*)(n->children[idx]));
	mapnode* sibling = ((mapnode*)(n->children[(int)(idx - 1)]));
	for (int i = (int)(child->len - 1); i >= 0; i--) {
		child->keys[builtin__v_fixed_index((int)(i + 1), 11)] = child->keys[builtin__v_fixed_index(i, 11)];
		child->values[builtin__v_fixed_index((int)(i + 1), 11)] = child->values[builtin__v_fixed_index(i, 11)];
	}
	if (child->children != ((void*)0)) {
		for (int i = child->len; i >= 0; i--) {
			{ // Unsafe block
				child->children[(int)(i + 1)] = child->children[i];
			}
		}
	}
	child->keys[0] = n->keys[builtin__v_fixed_index((int)(idx - 1), 11)];
	child->values[0] = n->values[builtin__v_fixed_index((int)(idx - 1), 11)];
	if (child->children != ((void*)0)) {
		{ // Unsafe block
			child->children[0] = sibling->children[sibling->len];
		}
	}
	n->keys[builtin__v_fixed_index((int)(idx - 1), 11)] = sibling->keys[builtin__v_fixed_index((int)(sibling->len - 1), 11)];
	n->values[builtin__v_fixed_index((int)(idx - 1), 11)] = sibling->values[builtin__v_fixed_index((int)(sibling->len - 1), 11)];
	child->len++;
	sibling->len--;
}
VV_LOC void builtin__mapnode_borrow_from_next(mapnode* n, int idx) {
	mapnode* child = ((mapnode*)(n->children[idx]));
	mapnode* sibling = ((mapnode*)(n->children[(int)(idx + 1)]));
	child->keys[builtin__v_fixed_index(child->len, 11)] = n->keys[builtin__v_fixed_index(idx, 11)];
	child->values[builtin__v_fixed_index(child->len, 11)] = n->values[builtin__v_fixed_index(idx, 11)];
	if (child->children != ((void*)0)) {
		{ // Unsafe block
			child->children[(int)(child->len + 1)] = sibling->children[0];
		}
	}
	n->keys[builtin__v_fixed_index(idx, 11)] = sibling->keys[0];
	n->values[builtin__v_fixed_index(idx, 11)] = sibling->values[0];
	for (int i = 1; i < sibling->len; i++) {
		sibling->keys[builtin__v_fixed_index((int)(i - 1), 11)] = sibling->keys[builtin__v_fixed_index(i, 11)];
		sibling->values[builtin__v_fixed_index((int)(i - 1), 11)] = sibling->values[builtin__v_fixed_index(i, 11)];
	}
	if (sibling->children != ((void*)0)) {
		for (int i = 1; i <= sibling->len; i++) {
			{ // Unsafe block
				sibling->children[(int)(i - 1)] = sibling->children[i];
			}
		}
	}
	child->len++;
	sibling->len--;
}
VV_LOC void builtin__mapnode_merge(mapnode* n, int idx) {
	mapnode* child = ((mapnode*)(n->children[idx]));
	mapnode* sibling = ((mapnode*)(n->children[(int)(idx + 1)]));
	child->keys[builtin__v_fixed_index(_const_mid_index, 11)] = n->keys[builtin__v_fixed_index(idx, 11)];
	child->values[builtin__v_fixed_index(_const_mid_index, 11)] = n->values[builtin__v_fixed_index(idx, 11)];
	for (int i = 0; i < sibling->len; ++i) {
		child->keys[builtin__v_fixed_index((int_literal)(i + _const_degree), 11)] = sibling->keys[builtin__v_fixed_index(i, 11)];
		child->values[builtin__v_fixed_index((int_literal)(i + _const_degree), 11)] = sibling->values[builtin__v_fixed_index(i, 11)];
	}
	if (child->children != ((void*)0)) {
		for (int i = 0; i <= sibling->len; i++) {
			{ // Unsafe block
				child->children[(int)(i + _const_degree)] = sibling->children[i];
			}
		}
	}
	for (int i = (int)(idx + 1); i < n->len; i++) {
		n->keys[builtin__v_fixed_index((int)(i - 1), 11)] = n->keys[builtin__v_fixed_index(i, 11)];
		n->values[builtin__v_fixed_index((int)(i - 1), 11)] = n->values[builtin__v_fixed_index(i, 11)];
	}
	for (int i = (int)(idx + 2); i <= n->len; i++) {
		{ // Unsafe block
			n->children[(int)(i - 1)] = n->children[i];
		}
	}
	child->len += (int)(sibling->len + 1);
	n->len--;
}
void builtin__SortedMap_delete(SortedMap* m, string key) {
	if (m->root->len == 0) {
		return;
	}
	bool removed = builtin__mapnode_remove_key(m->root, key);
	if (removed) {
		m->len--;
	}
	if (m->root->len == 0) {
		if (m->root->children == ((void*)0)) {
			return;
		} else {
			m->root = ((mapnode*)(m->root->children[0]));
		}
	}
}
VV_LOC int builtin__mapnode_subkeys(mapnode* n, Array_string* keys, int at) {
	int position = at;
	if (n->children != ((void*)0)) {
		for (int i = 0; i < n->len; ++i) {
			mapnode* child = ((mapnode*)(n->children[i]));
			position += builtin__mapnode_subkeys(child, keys, position);
			builtin__array_set(keys, position, &(string[]) { n->keys[builtin__v_fixed_index(i, 11)] });
			position++;
		}
		mapnode* child = ((mapnode*)(n->children[n->len]));
		position += builtin__mapnode_subkeys(child, keys, position);
	} else {
		for (int i = 0; i < n->len; ++i) {
			builtin__array_set(keys, (int)(position + i), &(string[]) { n->keys[builtin__v_fixed_index(i, 11)] });
		}
		position += n->len;
	}
	return (int)(position - at);
}
Array_string builtin__SortedMap_keys(SortedMap* m) {
	Array_string keys = builtin____new_array_with_default(m->len, 0, sizeof(string), &(string[]){_S("")});
	if (m->root == ((void*)0) || m->root->len == 0) {
		return keys;
	}
	builtin__mapnode_subkeys(m->root, &keys, 0);
	return keys;
}
VV_LOC void builtin__mapnode_free(mapnode* n) {
}
void builtin__SortedMap_free(SortedMap* m) {
	if (m->root == ((void*)0)) {
		return;
	}
	builtin__mapnode_free(m->root);
}
Array_rune builtin__string_runes(string s) {
	Array_rune runes = builtin____new_array_with_default(0, s.len, sizeof(rune), 0);
	for (int i = 0; i < s.len; i++) {
		int char_len = builtin__utf8_char_len(s.str[i]);
		if (char_len > 1) {
			int end = ((int)(s.len - 1) >= (int)(i + char_len) ? ((int)(i + char_len)) : (s.len));
			string r = builtin__string_substr(s, i, end);
			builtin__array_push((array*)&runes, _MOV((rune[]){ builtin__string_utf32_code(r) }));
			i += (int)(char_len - 1);
		} else {
			builtin__array_push((array*)&runes, _MOV((rune[]){ s.str[i] }));
		}
	}
	return runes;
}
string builtin__cstring_to_vstring(const char* const_s) {
	return builtin__string_clone(builtin__tos2(((u8*)(const_s))));
}
string builtin__tos_clone(const u8* const_s) {
	return builtin__string_clone(builtin__tos2(((u8*)(const_s))));
}
string builtin__tos(u8* s, int len) {
	if (s == 0) {
		builtin___v_panic(_S("tos(): nil string"));
		VUNREACHABLE();
	}
	return ((string){.str = s, .len = len});
}
string builtin__tos2(u8* s) {
	if (s == 0) {
		builtin___v_panic(_S("tos2: nil string"));
		VUNREACHABLE();
	}
	return ((string){.str = s, .len = builtin__vstrlen(s)});
}
string builtin__tos3(char* s) {
	if (s == 0) {
		builtin___v_panic(_S("tos3: nil string"));
		VUNREACHABLE();
	}
	return ((string){.str = ((u8*)(s)), .len = builtin__vstrlen_char(s)});
}
string builtin__tos4(u8* s) {
	if (s == 0) {
		return _S("");
	}
	return ((string){.str = s, .len = builtin__vstrlen(s)});
}
string builtin__tos5(char* s) {
	if (s == 0) {
		return _S("");
	}
	return ((string){.str = ((u8*)(s)), .len = builtin__vstrlen_char(s)});
}
string builtin__u8_vstring(u8* bp) {
	return ((string){.str = bp, .len = builtin__vstrlen(bp)});
}
string builtin__u8_vstring_with_len(u8* bp, int len) {
	return ((string){.str = bp, .len = len, .is_lit = 0});
}
string builtin__char_vstring(char* cp) {
	return ((string){.str = ((u8*)(cp)), .len = builtin__vstrlen_char(cp), .is_lit = 0});
}
string builtin__char_vstring_with_len(char* cp, int len) {
	return ((string){.str = ((u8*)(cp)), .len = len, .is_lit = 0});
}
string builtin__u8_vstring_literal(u8* bp) {
	return ((string){.str = bp, .len = builtin__vstrlen(bp), .is_lit = 1});
}
string builtin__u8_vstring_literal_with_len(u8* bp, int len) {
	return ((string){.str = bp, .len = len, .is_lit = 1});
}
string builtin__char_vstring_literal(char* cp) {
	return ((string){.str = ((u8*)(cp)), .len = builtin__vstrlen_char(cp), .is_lit = 1});
}
string builtin__char_vstring_literal_with_len(char* cp, int len) {
	return ((string){.str = ((u8*)(cp)), .len = len, .is_lit = 1});
}
int builtin__string_len_utf8(string s) {
	int l = 0;
	int i = 0;
	for (;;) {
		if (!(i < s.len)) break;
		l++;
		i += (int_literal)(((((0xe5000000U >> ((((s.str[i] >> 3)) & 0x1e)))) & 3)) + 1);
	}
	return l;
}
bool builtin__string_is_pure_ascii(string s) {
	for (int i = 0; i < s.len; ++i) {
		if (s.str[ i] >= 0x80) {
			return false;
		}
	}
	return true;
}
string builtin__string_clone(string a) {
	if (a.len <= 0) {
		return _S("");
	}
	string b = ((string){.str = builtin__malloc_noscan((int)(a.len + 1)), .len = a.len});
	{ // Unsafe block
		builtin__vmemcpy(b.str, a.str, a.len);
		b.str[a.len] = 0;
	}
	return b;
}
string builtin__string_replace_once(string s, string rep, string with) {
	int idx = builtin__string_index_(s, rep);
	if (idx == -1) {
		return builtin__string_clone(s);
	}
	return builtin__string_plus_two(builtin__string_substr_unsafe(s, 0, idx), with, builtin__string_substr_unsafe(s, (int)(idx + rep.len), s.len));
}
string builtin__string_replace(string s, string rep, string with) {
	if (s.len == 0 || rep.len == 0 || rep.len > s.len) {
		return builtin__string_clone(s);
	}
	if (!builtin__string_contains(s, rep)) {
		return builtin__string_clone(s);
	}
	int pidxs_len = 0;
	int pidxs_cap = (int)(s.len / rep.len);
	Array_fixed_int_10 stack_idxs = {0};
	int* pidxs = &stack_idxs[0];
	if (pidxs_cap > _const_replace_stack_buffer_size) {
		pidxs = ((int*)(builtin___v_malloc((int)(((int)(sizeof(int))) * pidxs_cap))));
	}
	int idx = 0;
	for (;;) {
		idx = builtin__string_index_after_(s, rep, idx);
		if (idx == -1) {
			break;
		}
		{ // Unsafe block
			pidxs[pidxs_len] = idx;
			pidxs_len++;
		}
		idx += rep.len;
	}
	if (pidxs_len == 0) {
		string _t3 = builtin__string_clone(s);
			{ // defer begin
				if (pidxs_cap > _const_replace_stack_buffer_size) {
					builtin___v_free(pidxs);
				}
			} // defer end
		return _t3;
	}
	int new_len = (int)(s.len + (int)(pidxs_len * ((int)(with.len - rep.len))));
	u8* b = builtin__malloc_noscan((int)(new_len + 1));
	int b_i = 0;
	int s_idx = 0;
	for (int j = 0; j < pidxs_len; ++j) {
		int rep_pos = pidxs[j];
		int before_len = (int)(rep_pos - s_idx);
		builtin__vmemcpy(&b[b_i], &s.str[s_idx], before_len);
		b_i += before_len;
		s_idx = (int)(rep_pos + rep.len);
		builtin__vmemcpy(&b[b_i], &with.str[0], with.len);
		b_i += with.len;
	}
	if (s_idx < s.len) {
		builtin__vmemcpy(&b[b_i], &s.str[s_idx], (int)(s.len - s_idx));
	}
	{ // Unsafe block
		b[new_len] = 0;
		string _t4 = builtin__tos(b, new_len);
			{ // defer begin
				if (pidxs_cap > _const_replace_stack_buffer_size) {
					builtin___v_free(pidxs);
				}
			} // defer end
		return _t4;
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
string builtin__string_replace_each(string s, Array_string vals) {
	if (s.len == 0 || vals.len == 0) {
		return builtin__string_clone(s);
	}
	if ((int)(vals.len % 2) != 0) {
		builtin__eprintln(_S("string.replace_each(): odd number of strings"));
		return builtin__string_clone(s);
	}
	int new_len = s.len;
	Array_RepIndex idxs = builtin____new_array_with_default(0, 6, sizeof(RepIndex), 0);
	int idx = 0;
	string s_ = builtin__string_clone(s);
	for (int rep_i = 0; rep_i < vals.len; rep_i += 2) {
		string rep = ((string*)vals.data)[rep_i];
		string with = ((string*)vals.data)[(int)(rep_i + 1)];
		for (;;) {
			idx = builtin__string_index_after_(s_, rep, idx);
			if (idx == -1) {
				break;
			}
			for (int i = 0; i < rep.len; ++i) {
				{ // Unsafe block
					s_.str[(int)(idx + i)] = 0;
				}
			}
			builtin__array_push((array*)&idxs, _MOV((RepIndex[]){ ((RepIndex){.idx = idx,.val_idx = rep_i,}) }));
			idx += rep.len;
			new_len += (int)(with.len - rep.len);
		}
	}
	if (idxs.len == 0) {
		string _t4 = builtin__string_clone(s);
			{ // defer begin
				builtin__array_free(&idxs);
			} // defer end
		return _t4;
	}
	if (idxs.len > 0) { qsort(idxs.data, idxs.len, idxs.element_size, (voidptr)compare_11835712493692648452_RepIndex_by_idx); }
	;
	u8* buf = builtin__malloc_noscan((int)(new_len + 1));
	int idx_pos = 0;
	RepIndex cur_idx = ((RepIndex*)idxs.data)[idx_pos];
	int buf_i = 0;
	for (int i = 0; i < s.len; i++) {
		if (i == cur_idx.idx) {
			string rep = ((string*)vals.data)[cur_idx.val_idx];
			string with = ((string*)vals.data)[(int)(cur_idx.val_idx + 1)];
			for (int j = 0; j < with.len; ++j) {
				{ // Unsafe block
					buf[buf_i] = with.str[ j];
				}
				buf_i++;
			}
			i += (int)(rep.len - 1);
			idx_pos++;
			if (idx_pos < idxs.len) {
				cur_idx = ((RepIndex*)idxs.data)[idx_pos];
			}
		} else {
			{ // Unsafe block
				buf[buf_i] = s.str[i];
			}
			buf_i++;
		}
	}
	{ // Unsafe block
		buf[new_len] = 0;
		string _t5 = builtin__tos(buf, new_len);
			{ // defer begin
				builtin__array_free(&idxs);
			} // defer end
		return _t5;
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
string builtin__string_replace_char(string s, u8 rep, u8 with, int repeat) {
	#if !defined(CUSTOM_DEFINE_no_bounds_checking)
	{
		if (repeat <= 0) {
			builtin___v_panic(_S("string.replace_char(): tab length too short"));
			VUNREACHABLE();
		}
	}
	#endif
	if (s.len == 0) {
		return builtin__string_clone(s);
	}
	Array_int idxs = builtin____new_array_with_default(0, (s.len >> 2), sizeof(int), 0);
	for (int i = 0; i < s.len; ++i) {
		u8 ch = s.str[i];
		if (ch == rep) {
			builtin__array_push((array*)&idxs, _MOV((int[]){ i }));
		}
	}
	if (idxs.len == 0) {
		string _t4 = builtin__string_clone(s);
			{ // defer begin
				builtin__array_free(&idxs);
			} // defer end
		return _t4;
	}
	int new_len = (int)(s.len + (int)(idxs.len * ((int)(repeat - 1))));
	u8* b = builtin__malloc_noscan((int)(new_len + 1));
	int b_i = 0;
	int s_idx = 0;
	for (int _t5 = 0; _t5 < idxs.len; ++_t5) {
		int rep_pos = ((int*)idxs.data)[_t5];
		for (int i = s_idx; i < rep_pos; ++i) {
			{ // Unsafe block
				b[b_i] = s.str[ i];
			}
			b_i++;
		}
		s_idx = (int)(rep_pos + 1);
		for (int _t6 = 0; _t6 < repeat; ++_t6) {
			{ // Unsafe block
				b[b_i] = with;
			}
			b_i++;
		}
	}
	if (s_idx < s.len) {
		for (int i = s_idx; i < s.len; ++i) {
			{ // Unsafe block
				b[b_i] = s.str[ i];
			}
			b_i++;
		}
	}
	{ // Unsafe block
		b[new_len] = 0;
		string _t7 = builtin__tos(b, new_len);
			{ // defer begin
				builtin__array_free(&idxs);
			} // defer end
		return _t7;
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
inline string builtin__string_normalize_tabs(string s, int tab_len) {
	return builtin__string_replace_char(s, '\t', ' ', tab_len);
}
string builtin__string_expand_tabs(string s, int tab_len) {
	if (tab_len <= 0) {
		return builtin__string_clone(s);
	}
	strings__Builder output = strings__new_builder(s.len);
	int column = 0;
	RunesIterator _t2 = builtin__string_runes_iterator(s);
	while (1) {
		_option_rune _t3 = builtin__RunesIterator_next(&_t2);
		if (_t3.state != 0) break;
		rune r = *(rune*)_t3.data;

		if (r == ('\t')) {
			int spaces = (int)(tab_len - ((int)(column % tab_len)));
			strings__Builder_write_string(&output, builtin__string_repeat(_S(" "), spaces));
			column += spaces;
		}
		else if (r == ('\n') || r == ('\r')) {
			strings__Builder_write_rune(&output, r);
			column = 0;
		}
		else {
			strings__Builder_write_rune(&output, r);
			column++;
		}
	}
	return strings__Builder_str(&output);
}
inline bool builtin__string_bool(string s) {
	return _SLIT_EQ(s.str, s.len, "true") || _SLIT_EQ(s.str, s.len, "t");
}
inline i8 builtin__string_i8(string s) {
	_result_i64 _t2 = strconv__common_parse_int(s, 0, 8, false, false);
	if (_t2.is_error) {
		*(i64*) _t2.data = 0;
	}
	
 	return ((i8)((*(i64*)_t2.data)));
}
inline i16 builtin__string_i16(string s) {
	_result_i64 _t2 = strconv__common_parse_int(s, 0, 16, false, false);
	if (_t2.is_error) {
		*(i64*) _t2.data = 0;
	}
	
 	return ((i16)((*(i64*)_t2.data)));
}
inline i32 builtin__string_i32(string s) {
	_result_i64 _t2 = strconv__common_parse_int(s, 0, 32, false, false);
	if (_t2.is_error) {
		*(i64*) _t2.data = 0;
	}
	
 	return ((i32)((*(i64*)_t2.data)));
}
inline int builtin__string_int(string s) {
	_result_i64 _t2 = strconv__common_parse_int(s, 0, 32, false, false);
	if (_t2.is_error) {
		*(i64*) _t2.data = 0;
	}
	
 	return ((int)((*(i64*)_t2.data)));
}
inline i64 builtin__string_i64(string s) {
	_result_i64 _t2 = strconv__common_parse_int(s, 0, 64, false, false);
	if (_t2.is_error) {
		*(i64*) _t2.data = 0;
	}
	
 	return (*(i64*)_t2.data);
}
inline f32 builtin__string_f32(string s) {
	_result_f64 _t2 = strconv__atof64(s, ((strconv__AtoF64Param){.allow_extra_chars = true,}));
	if (_t2.is_error) {
		*(f64*) _t2.data = 0;
	}
	
 	return ((f32)((*(f64*)_t2.data)));
}
inline f64 builtin__string_f64(string s) {
	_result_f64 _t2 = strconv__atof64(s, ((strconv__AtoF64Param){.allow_extra_chars = true,}));
	if (_t2.is_error) {
		*(f64*) _t2.data = 0;
	}
	
 	return (*(f64*)_t2.data);
}
Array_u8 builtin__string_u8_array(string s) {
	string tmps = builtin__string_replace(s, _S("_"), _S(""));
	if (tmps.len == 0) {
		return builtin____new_array_with_default(0, 0, sizeof(u8), 0);
	}
	tmps = builtin__string_to_lower_ascii(tmps);
	if (builtin__string_starts_with(tmps, _S("0x"))) {
		tmps = builtin__string_substr(tmps, 2, 2147483647);
		if (tmps.len == 0) {
			return builtin____new_array_with_default(0, 0, sizeof(u8), 0);
		}
		if (!builtin__string_contains_only(tmps, _S("0123456789abcdef"))) {
			return builtin____new_array_with_default(0, 0, sizeof(u8), 0);
		}
		if ((int)(tmps.len % 2) == 1) {
			tmps = builtin__string__plus(_S("0"), tmps);
		}
		Array_u8 ret = builtin____new_array_with_default((int)(tmps.len / 2), 0, sizeof(u8), 0);
		for (int i = 0; i < ret.len; ++i) {
			_result_u64 _t4 = builtin__string_parse_uint(builtin__string_substr(tmps, (int_literal)(2 * i), (int_literal)((int_literal)(2 * i) + 2)), 16, 8);
			if (_t4.is_error) {
				*(u64*) _t4.data = 0;
			}
			
 			builtin__array_set(&ret, i, &(u8[]) { ((u8)((*(u64*)_t4.data))) });
		}
		return ret;
	} else if (builtin__string_starts_with(tmps, _S("0b"))) {
		tmps = builtin__string_substr(tmps, 2, 2147483647);
		if (tmps.len == 0) {
			return builtin____new_array_with_default(0, 0, sizeof(u8), 0);
		}
		if (!builtin__string_contains_only(tmps, _S("01"))) {
			return builtin____new_array_with_default(0, 0, sizeof(u8), 0);
		}
		if ((int)(tmps.len % 8) != 0) {
			tmps = builtin__string__plus(builtin__string_repeat(_S("0"), (int)(8 - (int)(tmps.len % 8))), tmps);
		}
		Array_u8 ret = builtin____new_array_with_default((int)(tmps.len / 8), 0, sizeof(u8), 0);
		for (int i = 0; i < ret.len; ++i) {
			_result_u64 _t8 = builtin__string_parse_uint(builtin__string_substr(tmps, (int_literal)(8 * i), (int_literal)((int_literal)(8 * i) + 8)), 2, 8);
			if (_t8.is_error) {
				*(u64*) _t8.data = 0;
			}
			
 			builtin__array_set(&ret, i, &(u8[]) { ((u8)((*(u64*)_t8.data))) });
		}
		return ret;
	}
	return builtin____new_array_with_default(0, 0, sizeof(u8), 0);
}
inline u8 builtin__string_u8(string s) {
	_result_u64 _t2 = strconv__common_parse_uint(s, 0, 8, false, false);
	if (_t2.is_error) {
		*(u64*) _t2.data = 0;
	}
	
 	return ((u8)((*(u64*)_t2.data)));
}
inline u16 builtin__string_u16(string s) {
	_result_u64 _t2 = strconv__common_parse_uint(s, 0, 16, false, false);
	if (_t2.is_error) {
		*(u64*) _t2.data = 0;
	}
	
 	return ((u16)((*(u64*)_t2.data)));
}
inline u32 builtin__string_u32(string s) {
	_result_u64 _t2 = strconv__common_parse_uint(s, 0, 32, false, false);
	if (_t2.is_error) {
		*(u64*) _t2.data = 0;
	}
	
 	return ((u32)((*(u64*)_t2.data)));
}
inline u64 builtin__string_u64(string s) {
	_result_u64 _t2 = strconv__common_parse_uint(s, 0, 64, false, false);
	if (_t2.is_error) {
		*(u64*) _t2.data = 0;
	}
	
 	return (*(u64*)_t2.data);
}
inline _result_u64 builtin__string_parse_uint(string s, int _base, int _bit_size) {
	return strconv__parse_uint(s, _base, _bit_size);
}
inline _result_i64 builtin__string_parse_int(string s, int _base, int _bit_size) {
	return strconv__parse_int(s, _base, _bit_size);
}
VV_LOC bool builtin__string__eq(string s, string a) {
	if (s.str == 0) {
		builtin___v_panic(_S("string.eq(): nil string"));
		VUNREACHABLE();
	}
	if (s.len != a.len) {
		return false;
	}
	{ // Unsafe block
		return builtin__vmemcmp(s.str, a.str, a.len) == 0;
	}
	return 0;
}
int builtin__string_compare(string s, string a) {
	int min_len = (s.len < a.len ? (s.len) : (a.len));
	for (int i = 0; i < min_len; ++i) {
		if (s.str[ i] < a.str[ i]) {
			return -1;
		}
		if (s.str[ i] > a.str[ i]) {
			return 1;
		}
	}
	if (s.len < a.len) {
		return -1;
	}
	if (s.len > a.len) {
		return 1;
	}
	return 0;
}
VV_LOC bool builtin__string__lt(string s, string a) {
	for (int i = 0; i < s.len; ++i) {
		if (i >= a.len || s.str[ i] > a.str[ i]) {
			return false;
		} else if (s.str[ i] < a.str[ i]) {
			return true;
		}
	}
	if (s.len < a.len) {
		return true;
	}
	return false;
}
VV_LOC string builtin__string__plus(string s, string a) {
	int new_len = (int)(a.len + s.len);
	string res = ((string){.str = builtin__malloc_noscan((int)(new_len + 1)), .len = new_len});
	{ // Unsafe block
		builtin__vmemcpy(res.str, s.str, s.len);
		builtin__vmemcpy(res.str + s.len, a.str, a.len);
	}
	{ // Unsafe block
		res.str[new_len] = 0;
	}
	return res;
}
VV_LOC string builtin__string_plus_two(string s, string a, string b) {
	int new_len = (int)((int)(a.len + b.len) + s.len);
	string res = ((string){.str = builtin__malloc_noscan((int)(new_len + 1)), .len = new_len});
	{ // Unsafe block
		builtin__vmemcpy(res.str, s.str, s.len);
		builtin__vmemcpy(res.str + s.len, a.str, a.len);
		builtin__vmemcpy(res.str + s.len + a.len, b.str, b.len);
	}
	{ // Unsafe block
		res.str[new_len] = 0;
	}
	return res;
}
Array_string builtin__string_split_any(string s, string delim) {
	Array_string res = builtin____new_array_with_default(0, 0, sizeof(string), 0);
	builtin__ArrayFlags_set(&res.flags, ArrayFlags__noslices);
	int i = 0;
	if (s.len > 0) {
		if (delim.len <= 0) {
			Array_string _t1 = builtin__string_split(s, _S(""));
				{ // defer begin
					builtin__ArrayFlags_clear(&res.flags, ArrayFlags__noslices);
				} // defer end
			return _t1;
		}
		for (int index = 0; index < s.len; ++index) {
			u8 ch = s.str[index];
			for (int _t2 = 0; _t2 < delim.len; ++_t2) {
				u8 delim_ch = delim.str[_t2];
				if (ch == delim_ch) {
					builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_substr(s, i, index) }));
					i = (int)(index + 1);
					break;
				}
			}
		}
		if (i < s.len) {
			builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_substr(s, i, 2147483647) }));
		}
	}
	Array_string _t5 = res;
		{ // defer begin
			builtin__ArrayFlags_clear(&res.flags, ArrayFlags__noslices);
		} // defer end
	return _t5;
}
Array_string builtin__string_rsplit_any(string s, string delim) {
	Array_string res = builtin____new_array_with_default(0, 0, sizeof(string), 0);
	builtin__ArrayFlags_set(&res.flags, ArrayFlags__noslices);
	int i = (int)(s.len - 1);
	if (s.len > 0) {
		if (delim.len <= 0) {
			Array_string _t1 = builtin__string_rsplit(s, _S(""));
				{ // defer begin
					builtin__ArrayFlags_clear(&res.flags, ArrayFlags__noslices);
				} // defer end
			return _t1;
		}
		int rbound = s.len;
		for (;;) {
			if (!(i >= 0)) break;
			for (int _t2 = 0; _t2 < delim.len; ++_t2) {
				u8 delim_ch = delim.str[_t2];
				if (s.str[ i] == delim_ch) {
					builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_substr(s, (int)(i + 1), rbound) }));
					rbound = i;
					break;
				}
			}
			i--;
		}
		if (rbound > 0) {
			builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_substr(s, 0, rbound) }));
		}
	}
	Array_string _t5 = res;
		{ // defer begin
			builtin__ArrayFlags_clear(&res.flags, ArrayFlags__noslices);
		} // defer end
	return _t5;
}
inline Array_string builtin__string_split(string s, string delim) {
	return builtin__string_split_nth(s, delim, 0);
}
inline Array_string builtin__string_rsplit(string s, string delim) {
	return builtin__string_rsplit_nth(s, delim, 0);
}
_option_multi_return_string_string builtin__string_split_once(string s, string delim) {
	Array_string result = builtin__string_split_nth(s, delim, 2);
	if (result.len != 2) {
		_option_multi_return_string_string _t1 = (_option_multi_return_string_string){ .state=2, .err=_const_none__, .data={E_STRUCT} };
		return _t1;
	}
	_option_multi_return_string_string _t2;
	builtin___option_ok(&(multi_return_string_string[]) { (multi_return_string_string){.arg0=(*(string*)builtin__array_get(result, 0)), .arg1=(*(string*)builtin__array_get(result, 1))} }, (_option*)(&_t2), sizeof(multi_return_string_string));
	return _t2;
}
_option_multi_return_string_string builtin__string_rsplit_once(string s, string delim) {
	Array_string result = builtin__string_rsplit_nth(s, delim, 2);
	if (result.len != 2) {
		_option_multi_return_string_string _t1 = (_option_multi_return_string_string){ .state=2, .err=_const_none__, .data={E_STRUCT} };
		return _t1;
	}
	_option_multi_return_string_string _t2;
	builtin___option_ok(&(multi_return_string_string[]) { (multi_return_string_string){.arg0=(*(string*)builtin__array_get(result, 1)), .arg1=(*(string*)builtin__array_get(result, 0))} }, (_option*)(&_t2), sizeof(multi_return_string_string));
	return _t2;
}
Array_string builtin__string_split_n(string s, string delim, int n) {
	return builtin__string_split_nth(s, delim, n);
}
Array_string builtin__string_split_nth(string s, string delim, int nth) {
	Array_string res = builtin____new_array_with_default(0, 0, sizeof(string), 0);
	builtin__ArrayFlags_set(&res.flags, ArrayFlags__noslices);
	switch (delim.len) {
		case 0: {
			for (int i = 0; i < s.len; ++i) {
				u8 ch = s.str[i];
				if (nth > 0 && res.len == (int)(nth - 1)) {
					builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_substr(s, i, 2147483647) }));
					break;
				}
				builtin__array_push((array*)&res, _MOV((string[]){ builtin__u8_ascii_str(ch) }));
			}
			break;
		}
		case 1: {
			u8 delim_byte = delim.str[ 0];
			int start = 0;
			for (int i = 0; i < s.len; ++i) {
				u8 ch = s.str[i];
				if (ch == delim_byte) {
					if (nth > 0 && res.len == (int)(nth - 1)) {
						break;
					}
					builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_substr(s, start, i) }));
					start = (int)(i + 1);
				}
			}
			if (nth < 1 || res.len < nth) {
				builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_substr(s, start, 2147483647) }));
			}
			break;
		}
		default: {
			{
				int start = 0;
				for (int i = 0; (int)(i + delim.len) <= s.len; ) {
					if (builtin__string__eq(builtin__string_substr_unsafe(s, i, (int)(i + delim.len)), delim)) {
						if (nth > 0 && res.len == (int)(nth - 1)) {
							break;
						}
						builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_substr(s, start, i) }));
						i += delim.len;
						start = i;
					} else {
						i++;
					}
				}
				if (nth < 1 || res.len < nth) {
					builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_substr(s, start, 2147483647) }));
				}
				break;
			}
		}
	}
	
	Array_string _t7 = res;
		{ // defer begin
			builtin__ArrayFlags_clear(&res.flags, ArrayFlags__noslices);
		} // defer end
	return _t7;
}
Array_string builtin__string_rsplit_nth(string s, string delim, int nth) {
	Array_string res = builtin____new_array_with_default(0, 0, sizeof(string), 0);
	builtin__ArrayFlags_set(&res.flags, ArrayFlags__noslices);
	switch (delim.len) {
		case 0: {
			for (int i = (int)(s.len - 1); i >= 0; i--) {
				if (nth > 0 && res.len == (int)(nth - 1)) {
					builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_substr(s, 0, (int)(i + 1)) }));
					break;
				}
				builtin__array_push((array*)&res, _MOV((string[]){ builtin__u8_ascii_str(s.str[ i]) }));
			}
			break;
		}
		case 1: {
			u8 delim_byte = delim.str[ 0];
			int rbound = s.len;
			for (int i = (int)(s.len - 1); i >= 0; i--) {
				if (s.str[ i] == delim_byte) {
					if (nth > 0 && res.len == (int)(nth - 1)) {
						break;
					}
					builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_substr(s, (int)(i + 1), rbound) }));
					rbound = i;
				}
			}
			if (nth < 1 || res.len < nth) {
				builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_substr(s, 0, rbound) }));
			}
			break;
		}
		default: {
			{
				int rbound = s.len;
				for (int i = (int)(s.len - 1); i >= 0; i--) {
					bool is_delim = (int)(i - delim.len) >= 0 && builtin__string__eq(builtin__string_substr(s, (int)(i - delim.len), i), delim);
					if (is_delim) {
						if (nth > 0 && res.len == (int)(nth - 1)) {
							break;
						}
						builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_substr(s, i, rbound) }));
						i -= delim.len;
						rbound = i;
					}
				}
				if (nth < 1 || res.len < nth) {
					builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_substr(s, 0, rbound) }));
				}
				break;
			}
		}
	}
	
	Array_string _t7 = res;
		{ // defer begin
			builtin__ArrayFlags_clear(&res.flags, ArrayFlags__noslices);
		} // defer end
	return _t7;
}
Array_string builtin__string_split_into_lines(string s) {
	Array_string res = builtin____new_array_with_default(0, 0, sizeof(string), 0);
	if (s.len == 0) {
		return res;
	}
	builtin__ArrayFlags_set(&res.flags, ArrayFlags__noslices);
	rune cr = '\r';
	rune lf = '\n';
	int line_start = 0;
	for (int i = 0; i < s.len; i++) {
		if (line_start <= i) {
			if (s.str[ i] == lf) {
				builtin__array_push((array*)&res, _MOV((string[]){ (line_start == i ? (_S("")) : (builtin__string_substr(s, line_start, i))) }));
				line_start = (int)(i + 1);
			} else if (s.str[ i] == cr) {
				builtin__array_push((array*)&res, _MOV((string[]){ (line_start == i ? (_S("")) : (builtin__string_substr(s, line_start, i))) }));
				if (((int)(i + 1)) < s.len && s.str[ (int)(i + 1)] == lf) {
					line_start = (int)(i + 2);
				} else {
					line_start = (int)(i + 1);
				}
			}
		}
	}
	if (line_start < s.len) {
		builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_substr(s, line_start, 2147483647) }));
	}
	Array_string _t5 = res;
		{ // defer begin
			builtin__ArrayFlags_clear(&res.flags, ArrayFlags__noslices);
		} // defer end
	return _t5;
}
Array_string builtin__string_split_by_space(string s) {
	Array_string res = builtin____new_array_with_default(0, 0, sizeof(string), 0);
	builtin__ArrayFlags_set(&res.flags, ArrayFlags__noslices);
	Array_string _t1 = builtin__string_split_any(s, _S(" \n\t\v\f\r"));
	for (int _t2 = 0; _t2 < _t1.len; ++_t2) {
		string word = ((string*)_t1.data)[_t2];
		if ((word).len != 0) {
			builtin__array_push((array*)&res, _MOV((string[]){ word }));
		}
	}
	Array_string _t4 = res;
		{ // defer begin
			builtin__ArrayFlags_clear(&res.flags, ArrayFlags__noslices);
		} // defer end
	return _t4;
}
string builtin__string_substr(string s, int start, int _end) {
	int end = (_end == _const_max_i64 || _end == _const_max_i32 ? (s.len) : (_end));
	#if !defined(CUSTOM_DEFINE_no_bounds_checking)
	{
		if (start > end || start > s.len || end > s.len || start < 0 || end < 0) {
			builtin___v_panic(builtin__string__plus(builtin__string__plus(builtin__string__plus(builtin__string__plus(builtin__string__plus(builtin__string__plus(builtin__string__plus(_S("substr("), builtin__impl_i64_to_string(start)), _S(", ")), builtin__impl_i64_to_string(end)), _S(") out of bounds (len=")), builtin__impl_i64_to_string(s.len)), _S(") s=")), s));
			VUNREACHABLE();
		}
	}
	#endif
	int len = (int)(end - start);
	if (len == s.len) {
		return builtin__string_clone(s);
	}
	string res = ((string){.str = builtin__malloc_noscan((int)(len + 1)), .len = len});
	{ // Unsafe block
		builtin__vmemcpy(res.str, s.str + start, len);
		res.str[len] = 0;
	}
	return res;
}
string builtin__string_substr_unsafe(string s, int start, int _end) {
	int end = (_end == 2147483647 ? (s.len) : (_end));
	int len = (int)(end - start);
	if (len == s.len) {
		return s;
	}
	return ((string){.str = s.str + start, .len = len});
}
_result_string builtin__string_substr_with_check(string s, int start, int _end) {
	int end = (_end == _const_max_i64 || _end == _const_max_i32 ? (s.len) : (_end));
	if (start > end || start > s.len || end > s.len || start < 0 || end < 0) {
		return (_result_string){ .is_error=true, .err=builtin___v_error(builtin__string__plus(builtin__string__plus(builtin__string__plus(builtin__string__plus(builtin__string__plus(builtin__string__plus(_S("substr("), builtin__impl_i64_to_string(start)), _S(", ")), builtin__impl_i64_to_string(end)), _S(") out of bounds (len=")), builtin__impl_i64_to_string(s.len)), _S(")"))), .data={E_STRUCT} };
	}
	int len = (int)(end - start);
	if (len == s.len) {
		_result_string _t2;
		builtin___result_ok(&(string[]) { builtin__string_clone(s) }, (_result*)(&_t2), sizeof(string));
		 
		return _t2;
	}
	string res = ((string){.str = builtin__malloc_noscan((int)(len + 1)), .len = len});
	{ // Unsafe block
		builtin__vmemcpy(res.str, s.str + start, len);
		res.str[len] = 0;
	}
	_result_string _t3;
	builtin___result_ok(&(string[]) { res }, (_result*)(&_t3), sizeof(string));
	 
	return _t3;
}
string builtin__string_substr_ni(string s, int _start, int _end) {
	int start = _start;
	int end = (_end == _const_max_i64 || _end == _const_max_i32 ? (s.len) : (_end));
	if (start < 0) {
		start = (int)(s.len + start);
		if (start < 0) {
			start = 0;
		}
	}
	if (end < 0) {
		end = (int)(s.len + end);
		if (end < 0) {
			end = 0;
		}
	}
	if (end >= s.len) {
		end = s.len;
	}
	if (start > s.len || end < start) {
		return _S("");
	}
	int len = (int)(end - start);
	string res = ((string){.str = builtin__malloc_noscan((int)(len + 1)), .len = len});
	{ // Unsafe block
		builtin__vmemcpy(res.str, s.str + start, len);
		res.str[len] = 0;
	}
	return res;
}
int builtin__string_index_(string s, string p) {
	if (p.len > s.len || p.len == 0) {
		return -1;
	}
	if (p.len > 2) {
		return builtin__string_index_kmp(s, p);
	}
	int i = 0;
	for (;;) {
		if (!(i < s.len)) break;
		int j = 0;
		for (;;) {
			if (!(j < p.len && s.str[(int)(i + j)] == p.str[j])) break;
			j++;
		}
		if (j == p.len) {
			return i;
		}
		i++;
	}
	return -1;
}
_option_int builtin__string_index(string s, string p) {
	int idx = builtin__string_index_(s, p);
	if (idx == -1) {
		return (_option_int){ .state=2, .err=_const_none__, .data={E_STRUCT} };
	}
	_option_int _t2;
	builtin___option_ok(&(int[]) { idx }, (_option*)(&_t2), sizeof(int));
	 
	return _t2;
}
inline _option_int builtin__string_last_index(string s, string needle) {
	int idx = builtin__string_index_last_(s, needle);
	if (idx == -1) {
		return (_option_int){ .state=2, .err=_const_none__, .data={E_STRUCT} };
	}
	_option_int _t2;
	builtin___option_ok(&(int[]) { idx }, (_option*)(&_t2), sizeof(int));
	 
	return _t2;
}
VV_LOC int builtin__string_index_kmp(string s, string p) {
	if (p.len > s.len) {
		return -1;
	}
	Array_fixed_int_20 stack_prefixes = {0};
	int* p_prefixes = &stack_prefixes[0];
	if (p.len > _const_kmp_stack_buffer_size) {
		p_prefixes = ((int*)(builtin__vcalloc((int)(p.len * ((int)(sizeof(int)))))));
	}
	int j = 0;
	for (int i = 1; i < p.len; i++) {
		for (;;) {
			if (!(p.str[j] != p.str[i] && j > 0)) break;
			j = p_prefixes[(int)(j - 1)];
		}
		if (p.str[j] == p.str[i]) {
			j++;
		}
		{ // Unsafe block
			p_prefixes[i] = j;
		}
	}
	j = 0;
	for (int i = 0; i < s.len; ++i) {
		for (;;) {
			if (!(p.str[j] != s.str[i] && j > 0)) break;
			j = p_prefixes[(int)(j - 1)];
		}
		if (p.str[j] == s.str[i]) {
			j++;
		}
		if (j == p.len) {
			int _t2 = (int)((int)(i - p.len) + 1);
				{ // defer begin
					if (p.len > _const_kmp_stack_buffer_size) {
						builtin___v_free(p_prefixes);
					}
				} // defer end
			return _t2;
		}
	}
	int _t3 = -1;
		{ // defer begin
			if (p.len > _const_kmp_stack_buffer_size) {
				builtin___v_free(p_prefixes);
			}
		} // defer end
	return _t3;
}
int builtin__string_index_any(string s, string chars) {
	for (int i = 0; i < s.len; ++i) {
		u8 ss = s.str[i];
		for (int _t1 = 0; _t1 < chars.len; ++_t1) {
			u8 c = chars.str[_t1];
			if (c == ss) {
				return i;
			}
		}
	}
	return -1;
}
VV_LOC int builtin__string_index_last_(string s, string p) {
	if (p.len > s.len || p.len == 0) {
		return -1;
	}
	int i = (int)(s.len - p.len);
	for (;;) {
		if (!(i >= 0)) break;
		int j = 0;
		for (;;) {
			if (!(j < p.len && s.str[(int)(i + j)] == p.str[j])) break;
			j++;
		}
		if (j == p.len) {
			return i;
		}
		i--;
	}
	return -1;
}
_option_int builtin__string_index_after(string s, string p, int start) {
	if (p.len > s.len) {
		return (_option_int){ .state=2, .err=_const_none__, .data={E_STRUCT} };
	}
	int strt = start;
	if (start < 0) {
		strt = 0;
	}
	if (start >= s.len) {
		return (_option_int){ .state=2, .err=_const_none__, .data={E_STRUCT} };
	}
	int i = strt;
	for (;;) {
		if (!(i < s.len)) break;
		int j = 0;
		int ii = i;
		for (;;) {
			if (!(j < p.len && s.str[ii] == p.str[j])) break;
			j++;
			ii++;
		}
		if (j == p.len) {
			_option_int _t3;
			builtin___option_ok(&(int[]) { i }, (_option*)(&_t3), sizeof(int));
			 
			return _t3;
		}
		i++;
	}
	return (_option_int){ .state=2, .err=_const_none__, .data={E_STRUCT} };
}
int builtin__string_index_after_(string s, string p, int start) {
	if (p.len > s.len) {
		return -1;
	}
	int strt = start;
	if (start < 0) {
		strt = 0;
	}
	if (start >= s.len) {
		return -1;
	}
	int i = strt;
	for (;;) {
		if (!(i < s.len)) break;
		int j = 0;
		int ii = i;
		for (;;) {
			if (!(j < p.len && s.str[ii] == p.str[j])) break;
			j++;
			ii++;
		}
		if (j == p.len) {
			return i;
		}
		i++;
	}
	return -1;
}
int builtin__string_index_u8(string s, u8 c) {
	for (int i = 0; i < s.len; ++i) {
		u8 b = s.str[i];
		if (b == c) {
			return i;
		}
	}
	return -1;
}
inline int builtin__string_last_index_u8(string s, u8 c) {
	for (int i = (int)(s.len - 1); i >= 0; i--) {
		if (s.str[ i] == c) {
			return i;
		}
	}
	return -1;
}
int builtin__string_count(string s, string substr) {
	if (s.len == 0 || substr.len == 0) {
		return 0;
	}
	if (substr.len > s.len) {
		return 0;
	}
	int n = 0;
	if (substr.len == 1) {
		u8 target = substr.str[ 0];
		for (int _t3 = 0; _t3 < s.len; ++_t3) {
			u8 letter = s.str[_t3];
			if (letter == target) {
				n++;
			}
		}
		return n;
	}
	int i = 0;
	for (;;) {
		i = builtin__string_index_after_(s, substr, i);
		if (i == -1) {
			return n;
		}
		i += substr.len;
		n++;
	}
	return 0;
}
bool builtin__string_contains_u8(string s, u8 x) {
	for (int _t1 = 0; _t1 < s.len; ++_t1) {
		u8 c = s.str[_t1];
		if (x == c) {
			return true;
		}
	}
	return false;
}
bool builtin__string_contains(string s, string substr) {
	if (substr.len == 0) {
		return true;
	}
	if (substr.len == 1) {
		return builtin__string_contains_u8(s, substr.str[0]);
	}
	return builtin__string_index_(s, substr) != -1;
}
bool builtin__string_contains_any(string s, string chars) {
	for (int _t1 = 0; _t1 < chars.len; ++_t1) {
		u8 c = chars.str[_t1];
		if (builtin__string_contains_u8(s, c)) {
			return true;
		}
	}
	return false;
}
bool builtin__string_contains_only(string s, string chars) {
	if (chars.len == 0) {
		return false;
	}
	for (int _t2 = 0; _t2 < s.len; ++_t2) {
		u8 ch = s.str[_t2];
		int res = 0;
		for (int i = 0; i < chars.len && res == 0; i++) {
			res += (int[]){(ch == chars.str[i])?1:0}[0];
		}
		if (res == 0) {
			return false;
		}
	}
	return true;
}
bool builtin__string_contains_any_substr(string s, Array_string substrs) {
	if (substrs.len == 0) {
		return true;
	}
	for (int _t2 = 0; _t2 < substrs.len; ++_t2) {
		string sub = ((string*)substrs.data)[_t2];
		if (builtin__string_contains(s, sub)) {
			return true;
		}
	}
	return false;
}
bool builtin__string_starts_with(string s, string p) {
	if (p.len > s.len) {
		return false;
	} else if (builtin__vmemcmp(s.str, p.str, p.len) == 0) {
		return true;
	}
	return false;
}
bool builtin__string_ends_with(string s, string p) {
	if (p.len > s.len) {
		return false;
	} else if (builtin__vmemcmp(s.str + s.len - p.len, p.str, p.len) == 0) {
		return true;
	}
	return false;
}
string builtin__string_to_lower_ascii(string s) {
	{ // Unsafe block
		u8* b = builtin__malloc_noscan((int)(s.len + 1));
		for (int i = 0; i < s.len; ++i) {
			if (s.str[i] >= 'A' && s.str[i] <= 'Z') {
				b[i] = (u8)(s.str[i] + 32);
			} else {
				b[i] = s.str[i];
			}
		}
		b[s.len] = 0;
		return builtin__tos(b, s.len);
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
string builtin__string_to_lower(string s) {
	if (builtin__string_is_pure_ascii(s)) {
		return builtin__string_to_lower_ascii(s);
	}
	Array_rune runes = builtin__string_runes(s);
	for (int i = 0; i < runes.len; ++i) {
		((rune*)runes.data)[i] = builtin__rune_to_lower(((rune*)runes.data)[i]);
	}
	return Array_rune_string(runes);
}
bool builtin__string_is_lower(string s) {
	if ((s).len == 0 || builtin__u8_is_digit(s.str[ 0])) {
		return false;
	}
	for (int i = 0; i < s.len; ++i) {
		if (s.str[ i] >= 'A' && s.str[ i] <= 'Z') {
			return false;
		}
	}
	return true;
}
string builtin__string_to_upper_ascii(string s) {
	{ // Unsafe block
		u8* b = builtin__malloc_noscan((int)(s.len + 1));
		for (int i = 0; i < s.len; ++i) {
			if (s.str[i] >= 'a' && s.str[i] <= 'z') {
				b[i] = (u8)(s.str[i] - 32);
			} else {
				b[i] = s.str[i];
			}
		}
		b[s.len] = 0;
		return builtin__tos(b, s.len);
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
string builtin__string_to_upper(string s) {
	if (builtin__string_is_pure_ascii(s)) {
		return builtin__string_to_upper_ascii(s);
	}
	Array_rune runes = builtin__string_runes(s);
	for (int i = 0; i < runes.len; ++i) {
		((rune*)runes.data)[i] = builtin__rune_to_upper(((rune*)runes.data)[i]);
	}
	return Array_rune_string(runes);
}
bool builtin__string_is_upper(string s) {
	if ((s).len == 0 || builtin__u8_is_digit(s.str[ 0])) {
		return false;
	}
	for (int i = 0; i < s.len; ++i) {
		if (s.str[ i] >= 'a' && s.str[ i] <= 'z') {
			return false;
		}
	}
	return true;
}
string builtin__string_capitalize(string s) {
	if (s.len == 0) {
		return _S("");
	}
	if (s.len == 1) {
		return builtin__string_to_upper(builtin__u8_ascii_str(s.str[ 0]));
	}
	Array_rune r = builtin__string_runes(s);
	string letter = builtin__rune_str(((rune*)r.data)[0]);
	string uletter = builtin__string_to_upper(letter);
	Array_rune rrest = builtin__array_slice(r, 1, 2147483647);
	string srest = Array_rune_string(rrest);
	string res = builtin__string__plus(uletter, srest);
	return res;
}
string builtin__string_uncapitalize(string s) {
	if (s.len == 0) {
		return _S("");
	}
	if (s.len == 1) {
		return builtin__string_to_lower(builtin__u8_ascii_str(s.str[ 0]));
	}
	Array_rune r = builtin__string_runes(s);
	string letter = builtin__rune_str(((rune*)r.data)[0]);
	string lletter = builtin__string_to_lower(letter);
	Array_rune rrest = builtin__array_slice(r, 1, 2147483647);
	string srest = Array_rune_string(rrest);
	string res = builtin__string__plus(lletter, srest);
	return res;
}
bool builtin__string_is_capital(string s) {
	if (s.len == 0 || !(s.str[ 0] >= 'A' && s.str[ 0] <= 'Z')) {
		return false;
	}
	for (int i = 1; i < s.len; ++i) {
		if (s.str[ i] >= 'A' && s.str[ i] <= 'Z') {
			return false;
		}
	}
	return true;
}
bool builtin__string_starts_with_capital(string s) {
	if (s.len == 0 || !builtin__u8_is_capital(s.str[ 0])) {
		return false;
	}
	return true;
}
string builtin__string_title(string s) {
	Array_string words = builtin__string_split(s, _S(" "));
	Array_string tit = builtin____new_array_with_default(0, 0, sizeof(string), 0);
	for (int _t1 = 0; _t1 < words.len; ++_t1) {
		string word = ((string*)words.data)[_t1];
		builtin__array_push((array*)&tit, _MOV((string[]){ builtin__string_capitalize(word) }));
	}
	string title = Array_string_join(tit, _S(" "));
	return title;
}
bool builtin__string_is_title(string s) {
	Array_string words = builtin__string_split(s, _S(" "));
	for (int _t1 = 0; _t1 < words.len; ++_t1) {
		string word = ((string*)words.data)[_t1];
		if (!builtin__string_is_capital(word)) {
			return false;
		}
	}
	return true;
}
string builtin__string_find_between(string s, string start, string end) {
	int start_pos = builtin__string_index_(s, start);
	if (start_pos == -1) {
		return _S("");
	}
	string val = builtin__string_substr(s, (int)(start_pos + start.len), 2147483647);
	int end_pos = builtin__string_index_(val, end);
	if (end_pos == -1) {
		return _S("");
	}
	return builtin__string_substr(val, 0, end_pos);
}
inline string builtin__string_trim_space(string s) {
	return builtin__string_trim(s, _S(" \n\t\v\f\r"));
}
inline string builtin__string_trim_space_left(string s) {
	return builtin__string_trim_left(s, _S(" \n\t\v\f\r"));
}
inline string builtin__string_trim_space_right(string s) {
	return builtin__string_trim_right(s, _S(" \n\t\v\f\r"));
}
string builtin__string_trim(string s, string cutset) {
	if ((s).len == 0 || (cutset).len == 0) {
		return builtin__string_clone(s);
	}
	if (builtin__string_is_pure_ascii(cutset)) {
		return builtin__string_trim_chars(s, cutset, TrimMode__trim_both);
	} else {
		return builtin__string_trim_runes(s, cutset, TrimMode__trim_both);
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
multi_return_int_int builtin__string_trim_indexes(string s, string cutset) {
	int pos_left = 0;
	int pos_right = (int)(s.len - 1);
	bool cs_match = true;
	for (;;) {
		if (!(pos_left <= s.len && pos_right >= -1 && cs_match)) break;
		cs_match = false;
		for (int _t1 = 0; _t1 < cutset.len; ++_t1) {
			u8 cs = cutset.str[_t1];
			if (s.str[ pos_left] == cs) {
				pos_left++;
				cs_match = true;
				break;
			}
		}
		for (int _t2 = 0; _t2 < cutset.len; ++_t2) {
			u8 cs = cutset.str[_t2];
			if (s.str[ pos_right] == cs) {
				pos_right--;
				cs_match = true;
				break;
			}
		}
		if (pos_left > pos_right) {
			return (multi_return_int_int){.arg0=0, .arg1=0};
		}
	}
	return (multi_return_int_int){.arg0=pos_left, .arg1=(int)(pos_right + 1)};
}
VV_LOC string builtin__string_trim_chars(string s, string cutset, TrimMode mode) {
	int pos_left = 0;
	int pos_right = (int)(s.len - 1);
	bool cs_match = true;
	for (;;) {
		if (!(pos_left <= s.len && pos_right >= -1 && cs_match)) break;
		cs_match = false;
		if (mode == TrimMode__trim_left || mode == TrimMode__trim_both) {
			for (int _t1 = 0; _t1 < cutset.len; ++_t1) {
				u8 cs = cutset.str[_t1];
				if (s.str[ pos_left] == cs) {
					pos_left++;
					cs_match = true;
					break;
				}
			}
		}
		if (mode == TrimMode__trim_right || mode == TrimMode__trim_both) {
			for (int _t2 = 0; _t2 < cutset.len; ++_t2) {
				u8 cs = cutset.str[_t2];
				if (s.str[ pos_right] == cs) {
					pos_right--;
					cs_match = true;
					break;
				}
			}
		}
		if (pos_left > pos_right) {
			return _S("");
		}
	}
	return builtin__string_substr(s, pos_left, (int)(pos_right + 1));
}
VV_LOC string builtin__string_trim_runes(string s, string cutset, TrimMode mode) {
	Array_rune s_runes = builtin__string_runes(s);
	int pos_left = 0;
	int pos_right = (int)(s_runes.len - 1);
	bool cs_match = true;
	for (;;) {
		if (!(pos_left <= s_runes.len && pos_right >= -1 && cs_match)) break;
		cs_match = false;
		if (mode == TrimMode__trim_left || mode == TrimMode__trim_both) {
			RunesIterator _t1 = builtin__string_runes_iterator(cutset);
			while (1) {
				_option_rune _t2 = builtin__RunesIterator_next(&_t1);
				if (_t2.state != 0) break;
				rune cs = *(rune*)_t2.data;
				if (((rune*)s_runes.data)[pos_left] == cs) {
					pos_left++;
					cs_match = true;
					break;
				}
			}
		}
		if (mode == TrimMode__trim_right || mode == TrimMode__trim_both) {
			RunesIterator _t3 = builtin__string_runes_iterator(cutset);
			while (1) {
				_option_rune _t4 = builtin__RunesIterator_next(&_t3);
				if (_t4.state != 0) break;
				rune cs = *(rune*)_t4.data;
				if (((rune*)s_runes.data)[pos_right] == cs) {
					pos_right--;
					cs_match = true;
					break;
				}
			}
		}
		if (pos_left > pos_right) {
			return _S("");
		}
	}
	return Array_rune_string(builtin__array_slice(s_runes, pos_left, (int)(pos_right + 1)));
}
string builtin__string_trim_left(string s, string cutset) {
	if ((s).len == 0 || (cutset).len == 0) {
		return builtin__string_clone(s);
	}
	if (builtin__string_is_pure_ascii(cutset)) {
		return builtin__string_trim_chars(s, cutset, TrimMode__trim_left);
	} else {
		return builtin__string_trim_runes(s, cutset, TrimMode__trim_left);
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
string builtin__string_trim_right(string s, string cutset) {
	if (s.len < 1 || cutset.len < 1) {
		return builtin__string_clone(s);
	}
	if (builtin__string_is_pure_ascii(cutset)) {
		return builtin__string_trim_chars(s, cutset, TrimMode__trim_right);
	} else {
		return builtin__string_trim_runes(s, cutset, TrimMode__trim_right);
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
string builtin__string_trim_string_left(string s, string str) {
	if (builtin__string_starts_with(s, str)) {
		return builtin__string_substr(s, str.len, 2147483647);
	}
	return builtin__string_clone(s);
}
string builtin__string_trim_string_right(string s, string str) {
	if (builtin__string_ends_with(s, str)) {
		return builtin__string_substr(s, 0, (int)(s.len - str.len));
	}
	return builtin__string_clone(s);
}
int builtin__compare_strings(string* a, string* b) {
	bool _t2 = true;
	return ((_t2 == (builtin__string__lt(*a, *b)))? (-1) : (_t2 == (builtin__string__lt(*b, *a)))? (1) : (0));
}
VV_LOC int builtin__compare_strings_by_len(string* a, string* b) {
	bool _t2 = true;
	return ((_t2 == (a->len < b->len))? (-1) : (_t2 == (a->len > b->len))? (1) : (0));
}
VV_LOC int builtin__compare_lower_strings(string* a, string* b) {
	string aa = builtin__string_to_lower(*a);
	string bb = builtin__string_to_lower(*b);
	return builtin__compare_strings(&aa, &bb);
}
inline void Array_string_sort_ignore_case(Array_string* s) {
	builtin__array_sort_with_compare(s, ((voidptr)(builtin__compare_lower_strings)));
}
inline void Array_string_sort_by_len(Array_string* s) {
	builtin__array_sort_with_compare(s, ((voidptr)(builtin__compare_strings_by_len)));
}
inline string builtin__string_str(string s) {
	return builtin__string_clone(s);
}
VV_LOC u8 builtin__string_at(string s, int idx) {
	#if !defined(CUSTOM_DEFINE_no_bounds_checking)
	{
		if (idx < 0 || idx >= s.len) {
			builtin__panic_n2(_S("string index out of range(idx,s.len):"), idx, s.len);
			VUNREACHABLE();
		}
	}
	#endif
	return s.str[idx];
}
bool builtin__string_is_oct(string str) {
	int i = 0;
	if (str.len == 0) {
		return false;
	}
	if (str.str[ i] == '0') {
		i++;
	} else if (str.str[ i] == '-' || str.str[ i] == '+') {
		i++;
		if (i < str.len && str.str[ i] == '0') {
			i++;
		} else {
			return false;
		}
	} else {
		return false;
	}
	if (i < str.len && str.str[ i] == 'o') {
		i++;
	} else {
		return false;
	}
	if (i == str.len) {
		return false;
	}
	for (;;) {
		if (!(i < str.len)) break;
		if (str.str[ i] < '0' || str.str[ i] > '7') {
			return false;
		}
		i++;
	}
	return true;
}
bool builtin__string_is_bin(string str) {
	int i = 0;
	if (str.len == 0) {
		return false;
	}
	if (str.str[ i] == '0') {
		i++;
	} else if (str.str[ i] == '-' || str.str[ i] == '+') {
		i++;
		if (i < str.len && str.str[ i] == '0') {
			i++;
		} else {
			return false;
		}
	} else {
		return false;
	}
	if (i < str.len && str.str[ i] == 'b') {
		i++;
	} else {
		return false;
	}
	if (i == str.len) {
		return false;
	}
	for (;;) {
		if (!(i < str.len)) break;
		if (str.str[ i] < '0' || str.str[ i] > '1') {
			return false;
		}
		i++;
	}
	return true;
}
bool builtin__string_is_hex(string str) {
	int i = 0;
	if (str.len == 0) {
		return false;
	}
	if (str.str[ i] == '0') {
		i++;
	} else if (str.str[ i] == '-' || str.str[ i] == '+') {
		i++;
		if (i < str.len && str.str[ i] == '0') {
			i++;
		} else {
			return false;
		}
	} else {
		return false;
	}
	if (i < str.len && str.str[ i] == 'x') {
		i++;
	} else {
		return false;
	}
	if (i == str.len) {
		return false;
	}
	for (;;) {
		if (!(i < str.len)) break;
		if ((str.str[ i] < '0' || str.str[ i] > '9') && ((str.str[ i] < 'a' || str.str[ i] > 'f') && (str.str[ i] < 'A' || str.str[ i] > 'F'))) {
			return false;
		}
		i++;
	}
	return true;
}
bool builtin__string_is_int(string str) {
	int i = 0;
	if (str.len == 0) {
		return false;
	}
	if ((str.str[ i] != '-' && str.str[ i] != '+') && (!builtin__u8_is_digit(str.str[ i]))) {
		return false;
	} else {
		i++;
	}
	if (i == str.len && (!builtin__u8_is_digit(str.str[ (int)(i - 1)]))) {
		return false;
	}
	for (;;) {
		if (!(i < str.len)) break;
		if (str.str[ i] < '0' || str.str[ i] > '9') {
			return false;
		}
		i++;
	}
	return true;
}
inline bool builtin__u8_is_space(u8 c) {
	return c == 32 || (c > 8 && c < 14) || c == 0x85 || c == 0xa0;
}
inline bool builtin__u8_is_digit(u8 c) {
	return c >= '0' && c <= '9';
}
inline bool builtin__u8_is_hex_digit(u8 c) {
	return builtin__u8_is_digit(c) || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F');
}
inline bool builtin__u8_is_oct_digit(u8 c) {
	return c >= '0' && c <= '7';
}
inline bool builtin__u8_is_bin_digit(u8 c) {
	return c == '0' || c == '1';
}
inline bool builtin__u8_is_letter(u8 c) {
	return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
}
inline bool builtin__u8_is_alnum(u8 c) {
	return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9');
}
void builtin__string_free(string* s) {
	if (s->is_lit == -98761234) {
		u8* double_free_msg = ((u8*)("double string.free() detected\n"));
		int double_free_msg_len = builtin__vstrlen(double_free_msg);
		#if defined(_VFREESTANDING)
		{
		}
		#else
		{
			builtin___write_buf_to_fd(1, double_free_msg, double_free_msg_len);
		}
		#endif
		return;
	}
	if (s->is_lit == 1 || s->str == 0) {
		return;
	}
	{ // Unsafe block
		builtin___v_free(s->str);
		s->str = ((void*)0);
	}
	s->is_lit = -98761234;
}
string builtin__string_before(string s, string sub) {
	int pos = builtin__string_index_(s, sub);
	if (pos == -1) {
		return builtin__string_clone(s);
	}
	return builtin__string_substr(s, 0, pos);
}
string builtin__string_all_before(string s, string sub) {
	int pos = builtin__string_index_(s, sub);
	if (pos == -1) {
		return builtin__string_clone(s);
	}
	return builtin__string_substr(s, 0, pos);
}
string builtin__string_all_before_last(string s, string sub) {
	int pos = builtin__string_index_last_(s, sub);
	if (pos == -1) {
		return builtin__string_clone(s);
	}
	return builtin__string_substr(s, 0, pos);
}
string builtin__string_all_after(string s, string sub) {
	int pos = builtin__string_index_(s, sub);
	if (pos == -1) {
		return builtin__string_clone(s);
	}
	return builtin__string_substr(s, (int)(pos + sub.len), 2147483647);
}
string builtin__string_all_after_last(string s, string sub) {
	int pos = builtin__string_index_last_(s, sub);
	if (pos == -1) {
		return builtin__string_clone(s);
	}
	return builtin__string_substr(s, (int)(pos + sub.len), 2147483647);
}
string builtin__string_all_after_first(string s, string sub) {
	int pos = builtin__string_index_(s, sub);
	if (pos == -1) {
		return builtin__string_clone(s);
	}
	return builtin__string_substr(s, (int)(pos + sub.len), 2147483647);
}
inline string builtin__string_after(string s, string sub) {
	return builtin__string_all_after_last(s, sub);
}
string builtin__string_after_char(string s, u8 sub) {
	int pos = -1;
	for (int i = 0; i < s.len; ++i) {
		u8 c = s.str[i];
		if (c == sub) {
			pos = i;
			break;
		}
	}
	if (pos == -1) {
		return builtin__string_clone(s);
	}
	return builtin__string_substr(s, (int)(pos + 1), 2147483647);
}
string Array_string_join(Array_string a, string sep) {
	if (a.len == 0) {
		return _S("");
	}
	int len = 0;
	for (int _t2 = 0; _t2 < a.len; ++_t2) {
		string val = ((string*)a.data)[_t2];
		len += (int)(val.len + sep.len);
	}
	len -= sep.len;
	string res = ((string){.str = builtin__malloc_noscan((int)(len + 1)), .len = len});
	int idx = 0;
	for (int i = 0; i < a.len; ++i) {
		string val = ((string*)a.data)[i];
		{ // Unsafe block
			builtin__vmemcpy(((voidptr)(res.str + idx)), val.str, val.len);
			idx += val.len;
		}
		if (i != (int)(a.len - 1)) {
			{ // Unsafe block
				builtin__vmemcpy(((voidptr)(res.str + idx)), sep.str, sep.len);
				idx += sep.len;
			}
		}
	}
	{ // Unsafe block
		res.str[res.len] = 0;
	}
	return res;
}
inline string Array_string_join_lines(Array_string s) {
	return Array_string_join(s, _S("\n"));
}
string builtin__string_reverse(string s) {
	if (s.len == 0 || s.len == 1) {
		return builtin__string_clone(s);
	}
	string res = ((string){.str = builtin__malloc_noscan((int)(s.len + 1)), .len = s.len});
	for (int i = (int)(s.len - 1); i >= 0; i--) {
		{ // Unsafe block
			res.str[(int)((int)(s.len - i) - 1)] = s.str[ i];
		}
	}
	{ // Unsafe block
		res.str[res.len] = 0;
	}
	return res;
}
string builtin__string_limit(string s, int max) {
	Array_rune u = builtin__string_runes(s);
	if (u.len <= max) {
		return builtin__string_clone(s);
	}
	return Array_rune_string(builtin__array_slice(u, 0, max));
}
int builtin__string_hash(string s) {
	u32 h = ((u32)(0));
	if (h == 0 && s.len > 0) {
		for (int _t1 = 0; _t1 < s.len; ++_t1) {
			u8 c = s.str[_t1];
			h = (u32)((u32)(h * 31) + ((u32)(c)));
		}
	}
	return ((int)(h));
}
Array_u8 builtin__string_bytes(string s) {
	if (s.len == 0) {
		return builtin____new_array_with_default(0, 0, sizeof(u8), 0);
	}
	Array_u8 buf = builtin____new_array_with_default(s.len, 0, sizeof(u8), 0);
	builtin__vmemcpy(buf.data, s.str, s.len);
	return buf;
}
string builtin__string_repeat(string s, int count) {
	if (count <= 0) {
		return _S("");
	} else if (count == 1) {
		return builtin__string_clone(s);
	}
	u8* ret = builtin__malloc_noscan((int)((int)(s.len * count) + 1));
	for (int i = 0; i < count; ++i) {
		builtin__vmemcpy(ret + (int)(i * s.len), s.str, s.len);
	}
	int new_len = (int)(s.len * count);
	{ // Unsafe block
		ret[new_len] = 0;
	}
	return builtin__u8_vstring_with_len(ret, new_len);
}
Array_string builtin__string_fields(string s) {
	Array_string res = builtin____new_array_with_default(0, 0, sizeof(string), 0);
	builtin__ArrayFlags_set(&res.flags, ArrayFlags__noslices);
	int word_start = 0;
	int word_len = 0;
	bool is_in_word = false;
	bool is_space = false;
	for (int i = 0; i < s.len; ++i) {
		u8 c = s.str[i];
		is_space = (c == 32 || c == 9 || c == 10);
		if (!is_space) {
			word_len++;
		}
		if (!is_in_word && !is_space) {
			word_start = i;
			is_in_word = true;
			continue;
		}
		if (is_space && is_in_word) {
			builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_substr(s, word_start, (int)(word_start + word_len)) }));
			is_in_word = false;
			word_len = 0;
			word_start = 0;
			continue;
		}
	}
	if (is_in_word && word_len > 0) {
		builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_substr(s, word_start, s.len) }));
	}
	Array_string _t3 = res;
		{ // defer begin
			builtin__ArrayFlags_clear(&res.flags, ArrayFlags__noslices);
		} // defer end
	return _t3;
}
inline string builtin__string_strip_margin(string s) {
	return builtin__string_strip_margin_custom(s, '|');
}
string builtin__string_strip_margin_custom(string s, u8 del) {
	u8 sep = del;
	if (builtin__u8_is_space(sep)) {
		builtin__println(_S("Warning: `strip_margin` cannot use white-space as a delimiter"));
		builtin__println(_S("    Defaulting to `|`"));
		sep = '|';
	}
	u8* ret = builtin__malloc_noscan((int)(s.len + 1));
	int count = 0;
	for (int i = 0; i < s.len; i++) {
		if (s.str[ i] == 10 || s.str[ i] == 13) {
			{ // Unsafe block
				ret[count] = s.str[ i];
			}
			count++;
			if (s.str[ i] == 13 && i < (int)(s.len - 1) && s.str[ (int)(i + 1)] == 10) {
				{ // Unsafe block
					ret[count] = s.str[ (int)(i + 1)];
				}
				count++;
				i++;
			}
			for (;;) {
				if (!(s.str[ i] != sep)) break;
				i++;
				if (i >= s.len) {
					break;
				}
			}
		} else {
			{ // Unsafe block
				ret[count] = s.str[ i];
			}
			count++;
		}
	}
	{ // Unsafe block
		ret[count] = 0;
		return builtin__u8_vstring_with_len(ret, count);
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
string builtin__string_trim_indent(string s) {
	Array_string lines = builtin__string_split_into_lines(s);
	int min_common_indent = ((int)(_const_max_int));
	for (int _t1 = 0; _t1 < lines.len; ++_t1) {
		string line = ((string*)lines.data)[_t1];
		if (builtin__string_is_blank(line)) {
			continue;
		}
		int line_indent = builtin__string_indent_width(line);
		if (line_indent < min_common_indent) {
			min_common_indent = line_indent;
		}
	}
	if (lines.len > 0 && builtin__string_is_blank((*(string*)builtin__array_first(lines)))) {
		lines = builtin__array_slice(lines, 1, 2147483647);
	}
	if (lines.len > 0 && builtin__string_is_blank((*(string*)builtin__array_last(lines)))) {
		lines = builtin__array_slice(lines, 0, (int)(lines.len - 1));
	}
	Array_string trimmed_lines = builtin____new_array_with_default(0, lines.len, sizeof(string), 0);
	for (int _t2 = 0; _t2 < lines.len; ++_t2) {
		string line = ((string*)lines.data)[_t2];
		if (builtin__string_is_blank(line)) {
			builtin__array_push((array*)&trimmed_lines, _MOV((string[]){ line }));
			continue;
		}
		builtin__array_push((array*)&trimmed_lines, _MOV((string[]){ builtin__string_substr(line, min_common_indent, 2147483647) }));
	}
	return Array_string_join(trimmed_lines, _S("\n"));
}
int builtin__string_indent_width(string s) {
	for (int i = 0; i < s.len; ++i) {
		u8 c = s.str[i];
		if (!builtin__u8_is_space(c)) {
			return i;
		}
	}
	return 0;
}
bool builtin__string_is_blank(string s) {
	if (s.len == 0) {
		return true;
	}
	for (int _t2 = 0; _t2 < s.len; ++_t2) {
		u8 c = s.str[_t2];
		if (!builtin__u8_is_space(c)) {
			return false;
		}
	}
	return true;
}
bool builtin__string_match_glob(string name, string pattern) {
	int px = 0;
	int nx = 0;
	int next_px = 0;
	int next_nx = 0;
	int plen = pattern.len;
	int nlen = name.len;
	for (;;) {
		if (!(px < plen || nx < nlen)) break;
		if (px < plen) {
			u8 c = pattern.str[ px];

			if (c == ('?')) {
				if (nx < nlen) {
					px++;
					nx++;
					continue;
				}
			}
			else if (c == ('*')) {
				next_px = px;
				next_nx = (int)(nx + 1);
				px++;
				continue;
			}
			else if (c == ('[')) {
				if (nx < nlen) {
					u8 wanted_c = name.str[ nx];
					int bstart = px;
					bool is_inverted = false;
					bool inner_match = false;
					int inner_idx = (int)(bstart + 1);
					int inner_c = 0;
					if (inner_idx < plen) {
						inner_c = pattern.str[ inner_idx];
						if (inner_c == '^') {
							is_inverted = true;
							inner_idx++;
						}
					}
					for (; inner_idx < plen; inner_idx++) {
						inner_c = pattern.str[ inner_idx];
						if (inner_c == ']') {
							break;
						}
						if (inner_c == wanted_c) {
							inner_match = true;
							for (;;) {
								if (!(px < plen && pattern.str[ px] != ']')) break;
								px++;
							}
							break;
						}
					}
					if (is_inverted) {
						if (inner_match) {
							return false;
						} else {
							px = inner_idx;
						}
					}
				}
				px++;
				nx++;
				continue;
			}
			else {
				if (nx < nlen && name.str[ nx] == c) {
					px++;
					nx++;
					continue;
				}
			}
		}
		if (0 < next_nx && next_nx <= nlen) {
			px = next_px;
			nx = next_nx;
			continue;
		}
		return false;
	}
	return true;
}
inline bool builtin__string_is_ascii(string s) {
	for (int i = 0; i < s.len; i++) {
		if (s.str[ i] < ((u8)(' ')) || s.str[ i] > ((u8)('~'))) {
			return false;
		}
	}
	return true;
}
bool builtin__string_is_identifier(string s) {
	if (s.len == 0) {
		return false;
	}
	if (!(builtin__u8_is_letter(s.str[ 0]) || s.str[ 0] == '_')) {
		return false;
	}
	for (int i = 1; i < s.len; i++) {
		u8 c = s.str[ i];
		if (!(builtin__u8_is_letter(c) || builtin__u8_is_digit(c) || c == '_')) {
			return false;
		}
	}
	return true;
}
string builtin__string_camel_to_snake(string s) {
	if (s.len == 0) {
		return _S("");
	}
	if (s.len == 1) {
		return builtin__string_to_lower_ascii(s);
	}
	u8* b = builtin__malloc_noscan((int)((int)(2 * s.len) + 1));
	int pos = 2;
	bool prev_is_upper = false;
	bool prev_inserted_boundary = false;
	{ // Unsafe block
		if (builtin__u8_is_capital(s.str[ 0])) {
			b[0] = (u8)(s.str[ 0] + 32);
			u8 _t3; /* if prepend */
			if (builtin__u8_is_capital(s.str[ 1])) {
				prev_is_upper = true;
				_t3 = (u8)(s.str[ 1] + 32);
				goto _t4;
			};
			{
				_t3 = s.str[ 1];
			}
	_t4: {};
						b[1] = _t3;
		} else {
			b[0] = s.str[ 0];
			if (builtin__u8_is_capital(s.str[ 1])) {
				prev_is_upper = true;
				if (s.str[ 0] != '_' && s.len > 2 && !builtin__u8_is_capital(s.str[ 2])) {
					b[1] = '_';
					b[2] = (u8)(s.str[ 1] + 32);
					pos = 3;
				} else {
					b[1] = (u8)(s.str[ 1] + 32);
				}
			} else {
				b[1] = s.str[ 1];
			}
		}
	}
	for (int i = 2; i < s.len; i++) {
		bool has_boundary_before_upper = false;
		u8 c = s.str[ i];
		bool c_is_upper = builtin__u8_is_capital(c);
		bool c_is_number = builtin__u8_is_digit(c);
		bool next_is_lower = (int)(i + 1) < s.len && builtin__u8_is_letter(s.str[ (int)(i + 1)]) && !builtin__u8_is_capital(s.str[ (int)(i + 1)]);
		bool next2_is_lower = (int)(i + 2) < s.len && builtin__u8_is_letter(s.str[ (int)(i + 2)]) && !builtin__u8_is_capital(s.str[ (int)(i + 2)]);
		bool skip_digit = c_is_number && prev_is_upper && !next_is_lower && next2_is_lower;
		if (c_is_upper && prev_is_upper && i >= 2 && builtin__u8_is_capital(s.str[ (int)(i - 2)]) && next_is_lower && c != '_') {
			{ // Unsafe block
				if (b[(int)(pos - 1)] != '_') {
					b[pos] = '_';
					pos++;
				}
			}
			has_boundary_before_upper = true;
		}
		if (((c_is_upper && !prev_is_upper) || (!c_is_upper && prev_is_upper && builtin__u8_is_capital(s.str[ (int)(i - 2)]) && !prev_inserted_boundary && !skip_digit)) && c != '_') {
			{ // Unsafe block
				if (b[(int)(pos - 1)] != '_') {
					b[pos] = '_';
					pos++;
				}
			}
		}
		u8 lower_c = (c_is_upper ? ((u8)(c + 32)) : (c));
		{ // Unsafe block
			b[pos] = lower_c;
		}
		prev_is_upper = c_is_upper;
		prev_inserted_boundary = has_boundary_before_upper;
		pos++;
	}
	{ // Unsafe block
		b[pos] = 0;
	}
	return builtin__tos(b, pos);
}
string builtin__string_snake_to_camel(string s) {
	if (s.len == 0) {
		return _S("");
	}
	if (s.len == 1) {
		return s;
	}
	bool need_upper = true;
	rune upper_c = '_';
	u8* b = builtin__malloc_noscan((int)(s.len + 1));
	int i = 0;
	for (int _t3 = 0; _t3 < s.len; ++_t3) {
		u8 c = s.str[_t3];
		upper_c = (c >= 'a' && c <= 'z' ? ((u8)(c - 32)) : (c));
		if (c == '_') {
			need_upper = true;
		} else if (need_upper) {
			{ // Unsafe block
				b[i] = upper_c;
			}
			i++;
			need_upper = false;
		} else {
			{ // Unsafe block
				b[i] = c;
			}
			i++;
		}
	}
	{ // Unsafe block
		b[i] = 0;
	}
	return builtin__tos(b, i);
}
string builtin__string_wrap(string s, WrapConfig config) {
	if (config.width <= 0) {
		return _S("");
	}
	Array_string words = builtin__string_fields(s);
	if (words.len == 0) {
		return _S("");
	}
	strings__Builder sb = strings__new_builder(s.len);
	strings__Builder_write_string(&sb, (*(string*)builtin__array_get(words, 0)));
	int space_left = (int)(config.width - (*(string*)builtin__array_get(words, 0)).len);
	for (int i = 1; i < words.len; ++i) {
		string word = (*(string*)builtin__array_get(words, i));
		if ((int)(word.len + 1) > space_left) {
			strings__Builder_write_string(&sb, config.end);
			strings__Builder_write_string(&sb, word);
			space_left = (int)(config.width - word.len);
		} else {
			strings__Builder_write_string(&sb, _S(" "));
			strings__Builder_write_string(&sb, word);
			space_left -= (int)(1 + word.len);
		}
	}
	return strings__Builder_str(&sb);
}
string builtin__string_hex(string s) {
	if ((s).len == 0) {
		return _S("");
	}
	return builtin__data_to_hex_string(((u8*)(s.str)), s.len);
}
VV_LOC string builtin__data_to_hex_string(u8* data, int len) {
	u8* hex = builtin__malloc_noscan((u64)((u64)(((u64)(len)) * 2) + 1));
	int dst = 0;
	for (int c = 0; c < len; ++c) {
		u8 b = data[c];
		u8 n0 = (b >> 4);
		u8 n1 = (b & 0xF);
		hex[dst] = (n0 < 10 ? ((rune)(n0 + '0')) : ((rune)(n0 + 'W')));
		hex[(int)(dst + 1)] = (n1 < 10 ? ((rune)(n1 + '0')) : ((rune)(n1 + 'W')));
		dst += 2;
	}
	hex[dst] = 0;
	return builtin__tos(hex, dst);
}
RunesIterator builtin__string_runes_iterator(string s) {
	return ((RunesIterator){.s = s,.i = 0,});
}
_option_rune builtin__RunesIterator_next(RunesIterator* ri) {
	if (ri->i >= ri->s.len) {
		return (_option_rune){ .state=2, .err=_const_none__, .data={E_STRUCT} };
	}
	int char_len = builtin__utf8_char_len(ri->s.str[ri->i]);
	if (char_len == 1) {
		u8 res = ri->s.str[ri->i];
		ri->i++;
		_option_rune _t2;
		builtin___option_ok(&(rune[]) { res }, (_option*)(&_t2), sizeof(rune));
		 
		return _t2;
	}
	u8* start = ((u8*)(&ri->s.str[ri->i]));
	int len = ((int)(ri->s.len - 1) >= (int)(ri->i + char_len) ? (char_len) : ((int)(ri->s.len - ri->i)));
	ri->i += char_len;
	if (char_len > 4) {
		_option_rune _t3;
		builtin___option_ok(&(rune[]) { 0 }, (_option*)(&_t3), sizeof(rune));
		 
		return _t3;
	}
	_option_rune _t4;
	builtin___option_ok(&(rune[]) { ((rune)(builtin__impl_utf8_to_utf32(start, len))) }, (_option*)(&_t4), sizeof(rune));
	 
	return _t4;
}
Array_u8 builtin__byteptr_vbytes(byteptr data, int len) {
	return builtin__voidptr_vbytes(((voidptr)(data)), len);
}
string builtin__byteptr_vstring(byteptr bp) {
	return ((string){.str = bp, .len = builtin__vstrlen(bp)});
}
string builtin__byteptr_vstring_with_len(byteptr bp, int len) {
	return ((string){.str = bp, .len = len, .is_lit = 0});
}
string builtin__charptr_vstring(charptr cp) {
	return ((string){.str = ((byteptr)(cp)), .len = builtin__vstrlen_char(cp), .is_lit = 0});
}
string builtin__charptr_vstring_with_len(charptr cp, int len) {
	return ((string){.str = ((byteptr)(cp)), .len = len, .is_lit = 0});
}
string builtin__byteptr_vstring_literal(byteptr bp) {
	return ((string){.str = bp, .len = builtin__vstrlen(bp), .is_lit = 1});
}
string builtin__byteptr_vstring_literal_with_len(byteptr bp, int len) {
	return ((string){.str = bp, .len = len, .is_lit = 1});
}
string builtin__charptr_vstring_literal(charptr cp) {
	return ((string){.str = ((byteptr)(cp)), .len = builtin__vstrlen_char(cp), .is_lit = 1});
}
string builtin__charptr_vstring_literal_with_len(charptr cp, int len) {
	return ((string){.str = ((byteptr)(cp)), .len = len, .is_lit = 1});
}
string builtin__StrIntpType_str(StrIntpType x) {
	string _t2 = (string){.str=(byteptr)"", .is_lit=1};
	switch (x) {
		case StrIntpType__si_no_str: {
			_t2 = _S("no_str");
			break;
		}
		case StrIntpType__si_c: {
			_t2 = _S("c");
			break;
		}
		case StrIntpType__si_u8: {
			_t2 = _S("u8");
			break;
		}
		case StrIntpType__si_i8: {
			_t2 = _S("i8");
			break;
		}
		case StrIntpType__si_u16: {
			_t2 = _S("u16");
			break;
		}
		case StrIntpType__si_i16: {
			_t2 = _S("i16");
			break;
		}
		case StrIntpType__si_u32: {
			_t2 = _S("u32");
			break;
		}
		case StrIntpType__si_i32: {
			_t2 = _S("i32");
			break;
		}
		case StrIntpType__si_u64: {
			_t2 = _S("u64");
			break;
		}
		case StrIntpType__si_i64: {
			_t2 = _S("i64");
			break;
		}
		case StrIntpType__si_f32: {
			_t2 = _S("f32");
			break;
		}
		case StrIntpType__si_f64: {
			_t2 = _S("f64");
			break;
		}
		case StrIntpType__si_g32: {
			_t2 = _S("f32");
			break;
		}
		case StrIntpType__si_g64: {
			_t2 = _S("f64");
			break;
		}
		case StrIntpType__si_e32: {
			_t2 = _S("f32");
			break;
		}
		case StrIntpType__si_e64: {
			_t2 = _S("f64");
			break;
		}
		case StrIntpType__si_s: {
			_t2 = _S("s");
			break;
		}
		case StrIntpType__si_p: {
			_t2 = _S("p");
			break;
		}
		case StrIntpType__si_r: {
			_t2 = _S("r");
			break;
		}
		case StrIntpType__si_vp: {
			_t2 = _S("vp");
			break;
		}
	}
	return _t2;
}
inline VV_LOC f32 builtin__fabs32(f32 x) {
	return (x < 0 ? (-x) : (x));
}
inline VV_LOC f64 builtin__fabs64(f64 x) {
	return (x < 0 ? (-x) : (x));
}
inline VV_LOC u64 builtin__abs64(i64 x) {
	return (x < 0 ? (((u64)(-x))) : (((u64)(x))));
}
u64 builtin__get_str_intp_u64_format(StrIntpType fmt_type, int in_width, int in_precision, bool in_tail_zeros, bool in_sign, u8 in_pad_ch, int in_base, bool in_upper_case) {
	u64 width = (in_width != 0 ? (builtin__abs64(in_width)) : (((u64)(0))));
	u64 align = (in_width > 0 ? (((u64)(32))) : (((u64)(0))));
	u64 upper_case = (in_upper_case ? (((u64)(128))) : (((u64)(0))));
	u64 sign = (in_sign ? (((u64)(256))) : (((u64)(0))));
	u64 precision = (in_precision != 987698 ? (((((u64)((in_precision & 0x7F))) << 9))) : ((((u64)(0x7F)) << 9)));
	u32 tail_zeros = (in_tail_zeros ? ((((u32)(1)) << 16)) : (((u32)(0))));
	u64 base = ((u64)((((u32)((in_base & 0xf))) << 27)));
	u64 res = ((u64)(((((((((((((u64)(fmt_type)) & 0x1F)) | align) | upper_case) | sign) | precision) | tail_zeros) | ((((u64)((width & 0x3FF))) << 17))) | base) | ((((u64)(in_pad_ch)) << 31)))));
	return res;
}
u32 builtin__get_str_intp_u32_format(StrIntpType fmt_type, int in_width, int in_precision, bool in_tail_zeros, bool in_sign, u8 in_pad_ch, int in_base, bool in_upper_case) {
	u64 width = (in_width != 0 ? (builtin__abs64(in_width)) : (((u32)(0))));
	u32 align = (in_width > 0 ? (((u32)(32))) : (((u32)(0))));
	u32 upper_case = (in_upper_case ? (((u32)(128))) : (((u32)(0))));
	u32 sign = (in_sign ? (((u32)(256))) : (((u32)(0))));
	u32 precision = (in_precision != 987698 ? (((((u32)((in_precision & 0x7F))) << 9))) : ((((u32)(0x7F)) << 9)));
	u32 tail_zeros = (in_tail_zeros ? ((((u32)(1)) << 16)) : (((u32)(0))));
	u32 base = ((u32)((((u32)((in_base & 0xf))) << 27)));
	u32 res = ((u32)(((((((((((((u32)(fmt_type)) & 0x1F)) | align) | upper_case) | sign) | precision) | tail_zeros) | ((((u32)((width & 0x3FF))) << 17))) | base) | ((((u32)((in_pad_ch & 1))) << 31)))));
	return res;
}
VV_LOC void builtin__StrIntpData_process_str_intp_data(StrIntpData* data, strings__Builder* sb) {
	u32 x = data->fmt;
	StrIntpType typ = ((StrIntpType)((x & 0x1F)));
	int align = ((int)((((x >> 5)) & 0x01)));
	bool upper_case = ((((x >> 7)) & 0x01)) > 0;
	int sign = ((int)((((x >> 8)) & 0x01)));
	int precision = ((int)((((x >> 9)) & 0x7F)));
	bool tail_zeros = ((((x >> 16)) & 0x01)) > 0;
	int width = ((int)(((i16)((((x >> 17)) & 0x3FF)))));
	int base = (((int)((x >> 27))) & 0xF);
	u8 fmt_pad_ch = ((u8)((((x >> 31)) & 0xFF)));
	if (typ == StrIntpType__si_no_str) {
		return;
	}
	if (base > 0) {
		base += 2;
	}
	u8 pad_ch = ((u8)(' '));
	if (fmt_pad_ch > 0) {
		pad_ch = '0';
	}
	int len0_set = (width > 0 ? (width) : (-1));
	int len1_set = (precision == 0x7F ? (-1) : (precision));
	bool sign_set = sign == 1;
	strconv__BF_param bf = ((strconv__BF_param){
		.pad_ch = pad_ch,
		.len0 = len0_set,
		.len1 = len1_set,
		.positive = true,
		.sign_flag = sign_set,
		.align = strconv__Align_text__left,
		.rm_tail_zero = tail_zeros,
	});
	if (fmt_pad_ch == 0 || pad_ch == '0') {
		switch (align) {
			case 0: {
				bf.align = strconv__Align_text__left;
				break;
			}
			case 1: {
				bf.align = strconv__Align_text__right;
				break;
			}
			default: {
				{
					bf.align = strconv__Align_text__left;
					break;
				}
			}
		}
		
	} else {
		bf.align = strconv__Align_text__right;
	}
	{ // Unsafe block
		if (typ == StrIntpType__si_s) {
			if (upper_case) {
				string s = builtin__string_to_upper(data->d.d_s);
				if (width == 0) {
					strings__Builder_write_string(sb, s);
				} else {
					strconv__format_str_sb(s, bf, sb);
				}
				builtin__string_free(&s);
			} else {
				if (width == 0) {
					strings__Builder_write_string(sb, data->d.d_s);
				} else {
					strconv__format_str_sb(data->d.d_s, bf, sb);
				}
			}
			return;
		}
		if (typ == StrIntpType__si_r) {
			if (width > 0) {
				if (upper_case) {
					string s = builtin__string_to_upper(data->d.d_s);
					for (int _t1 = 1; _t1 < ((int)(1 + ((width > 0 ? (width) : (0))))); ++_t1) {
						strings__Builder_write_string(sb, s);
					}
					builtin__string_free(&s);
				} else {
					for (int _t2 = 1; _t2 < ((int)(1 + ((width > 0 ? (width) : (0))))); ++_t2) {
						strings__Builder_write_string(sb, data->d.d_s);
					}
				}
			}
			return;
		}
		if (typ == StrIntpType__si_i8 || typ == StrIntpType__si_i16 || typ == StrIntpType__si_i32 || typ == StrIntpType__si_i64) {
			i64 d = data->d.d_i64;
			if (typ == StrIntpType__si_i8) {
				d = ((i64)(data->d.d_i8));
			} else if (typ == StrIntpType__si_i16) {
				d = ((i64)(data->d.d_i16));
			} else if (typ == StrIntpType__si_i32) {
				d = ((i64)(data->d.d_i32));
			}
			if (base == 0) {
				if (width == 0) {
					string d_str = builtin__i64_str(d);
					strings__Builder_write_string(sb, d_str);
					builtin__string_free(&d_str);
					return;
				}
				if (d < 0) {
					bf.positive = false;
				}
				strconv__format_dec_sb(builtin__abs64(d), bf, sb);
			} else {
				if (base == 3) {
					base = 2;
				}
				i64 absd = d;
				bool write_minus = false;
				if (d < 0 && pad_ch != ' ') {
					absd = -d;
					write_minus = true;
				}
				string hx = strconv__format_int(absd, base);
				if (upper_case) {
					string tmp = hx;
					hx = builtin__string_to_upper(hx);
					builtin__string_free(&tmp);
				}
				if (write_minus) {
					strings__Builder_write_u8(sb, '-');
					bf.len0--;
				}
				if (width == 0) {
					strings__Builder_write_string(sb, hx);
				} else {
					strconv__format_str_sb(hx, bf, sb);
				}
				builtin__string_free(&hx);
			}
			return;
		}
		if (typ == StrIntpType__si_u8 || typ == StrIntpType__si_u16 || typ == StrIntpType__si_u32 || typ == StrIntpType__si_u64) {
			u64 d = data->d.d_u64;
			if (typ == StrIntpType__si_u8) {
				d = ((u64)(data->d.d_u8));
			} else if (typ == StrIntpType__si_u16) {
				d = ((u64)(data->d.d_u16));
			} else if (typ == StrIntpType__si_u32) {
				d = ((u64)(data->d.d_u32));
			}
			if (base == 0) {
				if (width == 0) {
					string d_str = builtin__u64_str(d);
					strings__Builder_write_string(sb, d_str);
					builtin__string_free(&d_str);
					return;
				}
				strconv__format_dec_sb(d, bf, sb);
			} else {
				if (base == 3) {
					base = 2;
				}
				string hx = strconv__format_uint(d, base);
				if (upper_case) {
					string tmp = hx;
					hx = builtin__string_to_upper(hx);
					builtin__string_free(&tmp);
				}
				if (width == 0) {
					strings__Builder_write_string(sb, hx);
				} else {
					strconv__format_str_sb(hx, bf, sb);
				}
				builtin__string_free(&hx);
			}
			return;
		}
		if (typ == StrIntpType__si_p) {
			u64 d = data->d.d_u64;
			base = 16;
			if (base == 0) {
				if (width == 0) {
					string d_str = builtin__u64_str(d);
					strings__Builder_write_string(sb, d_str);
					builtin__string_free(&d_str);
					return;
				}
				strconv__format_dec_sb(d, bf, sb);
			} else {
				string hx = strconv__format_uint(d, base);
				if (upper_case) {
					string tmp = hx;
					hx = builtin__string_to_upper(hx);
					builtin__string_free(&tmp);
				}
				if (width == 0) {
					strings__Builder_write_string(sb, hx);
				} else {
					strconv__format_str_sb(hx, bf, sb);
				}
				builtin__string_free(&hx);
			}
			return;
		}
		bool use_default_str = false;
		if (width == 0 && precision == 0x7F) {
			bf.len1 = 3;
			use_default_str = true;
		}
		if (bf.len1 < 0) {
			bf.len1 = 3;
		}
		switch (typ) {
			case StrIntpType__si_f32: {
				#if !defined(CUSTOM_DEFINE_nofloat)
				{
					if (use_default_str) {
						string f = builtin__f32_str(data->d.d_f32);
						if (upper_case) {
							string tmp = f;
							f = builtin__string_to_upper(f);
							builtin__string_free(&tmp);
						}
						strings__Builder_write_string(sb, f);
						builtin__string_free(&f);
					} else {
						if (data->d.d_f32 < 0) {
							bf.positive = false;
						}
						string f = strconv__format_fl(data->d.d_f32, bf);
						if (upper_case) {
							string tmp = f;
							f = builtin__string_to_upper(f);
							builtin__string_free(&tmp);
						}
						strings__Builder_write_string(sb, f);
						builtin__string_free(&f);
					}
				}
				#endif
				break;
			}
			case StrIntpType__si_f64: {
				#if !defined(CUSTOM_DEFINE_nofloat)
				{
					if (use_default_str) {
						string f = builtin__f64_str(data->d.d_f64);
						if (upper_case) {
							string tmp = f;
							f = builtin__string_to_upper(f);
							builtin__string_free(&tmp);
						}
						strings__Builder_write_string(sb, f);
						builtin__string_free(&f);
					} else {
						if (data->d.d_f64 < 0) {
							bf.positive = false;
						}
						strconv__Float64u f_union = ((strconv__Float64u){.f = data->d.d_f64,});
						if (f_union.u == _const_strconv__double_minus_zero) {
							bf.positive = false;
						}
						string f = strconv__format_fl(data->d.d_f64, bf);
						if (upper_case) {
							string tmp = f;
							f = builtin__string_to_upper(f);
							builtin__string_free(&tmp);
						}
						strings__Builder_write_string(sb, f);
						builtin__string_free(&f);
					}
				}
				#endif
				break;
			}
			case StrIntpType__si_g32: {
				if (use_default_str) {
					#if !defined(CUSTOM_DEFINE_nofloat)
					{
						string f = builtin__f32_strg(data->d.d_f32);
						if (upper_case) {
							string tmp = f;
							f = builtin__string_to_upper(f);
							builtin__string_free(&tmp);
						}
						strings__Builder_write_string(sb, f);
						builtin__string_free(&f);
					}
					#endif
				} else {
					if (data->d.d_f32 == _const_strconv__single_plus_zero) {
						string tmp_str = _S("0");
						strconv__format_str_sb(tmp_str, bf, sb);
						builtin__string_free(&tmp_str);
						return;
					}
					if (data->d.d_f32 == _const_strconv__single_minus_zero) {
						string tmp_str = _S("-0");
						strconv__format_str_sb(tmp_str, bf, sb);
						builtin__string_free(&tmp_str);
						return;
					}
					if (data->d.d_f32 == _const_strconv__single_plus_infinity) {
						string tmp_str = _S("+inf");
						if (upper_case) {
							tmp_str = _S("+INF");
						}
						strconv__format_str_sb(tmp_str, bf, sb);
						builtin__string_free(&tmp_str);
					}
					if (data->d.d_f32 == _const_strconv__single_minus_infinity) {
						string tmp_str = _S("-inf");
						if (upper_case) {
							tmp_str = _S("-INF");
						}
						strconv__format_str_sb(tmp_str, bf, sb);
						builtin__string_free(&tmp_str);
					}
					if (data->d.d_f32 < 0) {
						bf.positive = false;
					}
					f32 d = builtin__fabs32(data->d.d_f32);
					if (d < ((f32)(999999.0)) && d >= ((f32)(0.00001))) {
						string f = strconv__format_fl(data->d.d_f32, bf);
						if (upper_case) {
							string tmp = f;
							f = builtin__string_to_upper(f);
							builtin__string_free(&tmp);
						}
						strings__Builder_write_string(sb, f);
						builtin__string_free(&f);
						return;
					}
					bf.len1--;
					string f = strconv__format_es(data->d.d_f32, bf);
					if (upper_case) {
						string tmp = f;
						f = builtin__string_to_upper(f);
						builtin__string_free(&tmp);
					}
					strings__Builder_write_string(sb, f);
					builtin__string_free(&f);
				}
				break;
			}
			case StrIntpType__si_g64: {
				if (use_default_str) {
					#if !defined(CUSTOM_DEFINE_nofloat)
					{
						string f = builtin__f64_strg(data->d.d_f64);
						if (upper_case) {
							string tmp = f;
							f = builtin__string_to_upper(f);
							builtin__string_free(&tmp);
						}
						strings__Builder_write_string(sb, f);
						builtin__string_free(&f);
					}
					#endif
				} else {
					if (data->d.d_f64 == _const_strconv__double_plus_zero) {
						string tmp_str = _S("0");
						strconv__format_str_sb(tmp_str, bf, sb);
						builtin__string_free(&tmp_str);
						return;
					}
					if (data->d.d_f64 == _const_strconv__double_minus_zero) {
						string tmp_str = _S("-0");
						strconv__format_str_sb(tmp_str, bf, sb);
						builtin__string_free(&tmp_str);
						return;
					}
					if (data->d.d_f64 == _const_strconv__double_plus_infinity) {
						string tmp_str = _S("+inf");
						if (upper_case) {
							tmp_str = _S("+INF");
						}
						strconv__format_str_sb(tmp_str, bf, sb);
						builtin__string_free(&tmp_str);
					}
					if (data->d.d_f64 == _const_strconv__double_minus_infinity) {
						string tmp_str = _S("-inf");
						if (upper_case) {
							tmp_str = _S("-INF");
						}
						strconv__format_str_sb(tmp_str, bf, sb);
						builtin__string_free(&tmp_str);
					}
					if (data->d.d_f64 < 0) {
						bf.positive = false;
					}
					f64 d = builtin__fabs64(data->d.d_f64);
					if (d < ((f64)(999999.0)) && d >= ((f64)(0.00001))) {
						string f = strconv__format_fl(data->d.d_f64, bf);
						if (upper_case) {
							string tmp = f;
							f = builtin__string_to_upper(f);
							builtin__string_free(&tmp);
						}
						strings__Builder_write_string(sb, f);
						builtin__string_free(&f);
						return;
					}
					bf.len1--;
					string f = strconv__format_es(data->d.d_f64, bf);
					if (upper_case) {
						string tmp = f;
						f = builtin__string_to_upper(f);
						builtin__string_free(&tmp);
					}
					strings__Builder_write_string(sb, f);
					builtin__string_free(&f);
				}
				break;
			}
			case StrIntpType__si_e32: {
				#if !defined(CUSTOM_DEFINE_nofloat)
				{
					if (use_default_str) {
						string f = builtin__f32_str(data->d.d_f32);
						if (upper_case) {
							string tmp = f;
							f = builtin__string_to_upper(f);
							builtin__string_free(&tmp);
						}
						strings__Builder_write_string(sb, f);
						builtin__string_free(&f);
					} else {
						if (data->d.d_f32 < 0) {
							bf.positive = false;
						}
						string f = strconv__format_es(data->d.d_f32, bf);
						if (upper_case) {
							string tmp = f;
							f = builtin__string_to_upper(f);
							builtin__string_free(&tmp);
						}
						strings__Builder_write_string(sb, f);
						builtin__string_free(&f);
					}
				}
				#endif
				break;
			}
			case StrIntpType__si_e64: {
				#if !defined(CUSTOM_DEFINE_nofloat)
				{
					if (use_default_str) {
						string f = builtin__f64_str(data->d.d_f64);
						if (upper_case) {
							string tmp = f;
							f = builtin__string_to_upper(f);
							builtin__string_free(&tmp);
						}
						strings__Builder_write_string(sb, f);
						builtin__string_free(&f);
					} else {
						if (data->d.d_f64 < 0) {
							bf.positive = false;
						}
						string f = strconv__format_es(data->d.d_f64, bf);
						if (upper_case) {
							string tmp = f;
							f = builtin__string_to_upper(f);
							builtin__string_free(&tmp);
						}
						strings__Builder_write_string(sb, f);
						builtin__string_free(&f);
					}
				}
				#endif
				break;
			}
			case StrIntpType__si_c: {
				string ss = builtin__utf32_to_str(data->d.d_c);
				strings__Builder_write_string(sb, ss);
				builtin__string_free(&ss);
				break;
			}
			case StrIntpType__si_vp: {
				string ss = builtin__u64_hex(((u64)(data->d.d_vp)));
				strings__Builder_write_string(sb, ss);
				builtin__string_free(&ss);
				break;
			}
			case StrIntpType__si_no_str:
			case StrIntpType__si_u8:
			case StrIntpType__si_i8:
			case StrIntpType__si_u16:
			case StrIntpType__si_i16:
			case StrIntpType__si_u32:
			case StrIntpType__si_i32:
			case StrIntpType__si_u64:
			case StrIntpType__si_i64:
			case StrIntpType__si_s:
			case StrIntpType__si_p:
			case StrIntpType__si_r:
			default: {
				{
					strings__Builder_write_string(sb, _S("***ERROR!***"));
					break;
				}
			}
		}
		
	}
}
string builtin__str_intp(int data_len, StrIntpData* input_base) {
	strings__Builder res = strings__new_builder(64);
	for (int i = 0; i < data_len; i++) {
		StrIntpData* data = &input_base[i];
		if (data->str.len != 0) {
			strings__Builder_write_string(&res, data->str);
		}
		if (data->fmt != 0) {
			builtin__StrIntpData_process_str_intp_data(data, (voidptr)&res);
		}
	}
	string ret = strings__Builder_str(&res);
	strings__Builder_free(&res);
	return ret;
}
inline string builtin__str_intp_sq(string in_str) {
	return builtin__str_intp(3, _MOV((StrIntpData[]){{_S("builtin__str_intp(2, _MOV((StrIntpData[]){{_S(\"\'\"), "), 0xfe10, {.d_s = _const_si_s_code}}, {_S(", {.d_s = "), 0xfe10, {.d_s = in_str}}, {_S("}},{_S(\"\'\"), 0, {.d_c = 0 }}}))"), 0, { .d_c = 0 }}}));
}
inline string builtin__str_intp_rune(string in_str) {
	return builtin__str_intp(3, _MOV((StrIntpData[]){{_S("builtin__str_intp(2, _MOV((StrIntpData[]){{_S(\"`\"), "), 0xfe10, {.d_s = _const_si_s_code}}, {_S(", {.d_s = "), 0xfe10, {.d_s = in_str}}, {_S("}},{_S(\"`\"), 0, {.d_c = 0 }}}))"), 0, { .d_c = 0 }}}));
}
inline string builtin__str_intp_g32(string in_str) {
	return builtin__str_intp(3, _MOV((StrIntpData[]){{_S("builtin__str_intp(1, _MOV((StrIntpData[]){{_SLIT0, "), 0xfe10, {.d_s = _const_si_g32_code}}, {_S(", {.d_f32 = "), 0xfe10, {.d_s = in_str}}, {_S(" }}}))"), 0, { .d_c = 0 }}}));
}
inline string builtin__str_intp_g64(string in_str) {
	return builtin__str_intp(3, _MOV((StrIntpData[]){{_S("builtin__str_intp(1, _MOV((StrIntpData[]){{_SLIT0, "), 0xfe10, {.d_s = _const_si_g64_code}}, {_S(", {.d_f64 = "), 0xfe10, {.d_s = in_str}}, {_S(" }}}))"), 0, { .d_c = 0 }}}));
}
string builtin__str_intp_sub(string base_str, string in_str) {
	_option_int _t1 = builtin__string_index(base_str, _S("%%"));
	if (_t1.state != 0) {
		builtin__eprintln(_S("No string interpolation %% parameters"));
		builtin___v_exit(1);
		VUNREACHABLE();
	;
	}
	
 	int index = (*(int*)_t1.data);
	{ // Unsafe block
		string st_str = builtin__string_substr(base_str, 0, index);
		if ((int)(index + 2) < base_str.len) {
			string en_str = builtin__string_substr(base_str, (int)(index + 2), 2147483647);
			string res_str = builtin__str_intp(5, _MOV((StrIntpData[]){{_S("builtin__str_intp(2, _MOV((StrIntpData[]){{_S(\""), 0xfe10, {.d_s = st_str}}, {_S("\"), "), 0xfe10, {.d_s = _const_si_s_code}}, {_S(", {.d_s = "), 0xfe10, {.d_s = in_str}}, {_S(" }},{_S(\""), 0xfe10, {.d_s = en_str}}, {_S("\"), 0, {.d_c = 0}}}))"), 0, { .d_c = 0 }}}));
			builtin__string_free(&st_str);
			builtin__string_free(&en_str);
			return res_str;
		}
		string res2_str = builtin__str_intp(4, _MOV((StrIntpData[]){{_S("builtin__str_intp(1, _MOV((StrIntpData[]){{_S(\""), 0xfe10, {.d_s = st_str}}, {_S("\"), "), 0xfe10, {.d_s = _const_si_s_code}}, {_S(", {.d_s = "), 0xfe10, {.d_s = in_str}}, {_S(" }}}))"), 0, { .d_c = 0 }}}));
		builtin__string_free(&st_str);
		return res2_str;
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
u16* builtin__string_to_wide(string _str, ToWideConfig param) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		Array_rune srunes = builtin__string_runes(_str);
		{ // Unsafe block
			u16* result = ((u16*)(builtin__vcalloc_noscan((int)(((int)(srunes.len + 1)) * 2))));
			for (int i = 0; i < srunes.len; ++i) {
				rune r = ((rune*)srunes.data)[i];
				result[i] = ((u16)(r));
			}
			result[srunes.len] = 0;
			return result;
		}
	}
	#endif
	return 0;
}
string builtin__string_from_wide(u16* _wstr) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		int i = 0;
		for (;;) {
			if (!(_wstr[i] != 0)) break;
			i++;
		}
		return builtin__string_from_wide2(_wstr, i);
	}
	#endif
	return (string){.str=(byteptr)"", .is_lit=1};
}
string builtin__string_from_wide2(u16* _wstr, int len) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		strings__Builder sb = strings__new_builder(len);
		for (int i = 0; i < len; i++) {
			rune u = ((rune)(_wstr[i]));
			strings__Builder_write_rune(&sb, u);
		}
		string res = strings__Builder_str(&sb);
		strings__Builder_free(&sb);
		return res;
	}
	#endif
	return (string){.str=(byteptr)"", .is_lit=1};
}
Array_u8 builtin__wide_to_ansi(u16* _wstr) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		string s = builtin__string_from_wide(_wstr);
		Array_u8 str_to = builtin____new_array_with_default((int)(s.len + 1), 0, sizeof(u8), 0);
		builtin__vmemcpy(str_to.data, s.str, s.len);
		return str_to;
	}
	#endif
	return builtin____new_array_with_default(0, 0, sizeof(u8), 0);
}
int builtin__utf8_char_len(u8 b) {
	return (int_literal)(((((0xe5000000U >> ((((b >> 3)) & 0x1e)))) & 3)) + 1);
}
string builtin__utf32_to_str(u32 code) {
	{ // Unsafe block
		u8* buffer = builtin__malloc_noscan(5);
		string res = builtin__utf32_to_str_no_malloc(code, buffer);
		if (res.len == 0) {
			builtin___v_free(buffer);
		}
		return res;
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
string builtin__utf32_to_str_no_malloc(u32 code, u8* buf) {
	{ // Unsafe block
		int len = builtin__utf32_decode_to_buffer(code, buf);
		if (len == 0) {
			return _S("");
		}
		buf[len] = 0;
		return builtin__tos(buf, len);
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
int builtin__utf32_decode_to_buffer(u32 code, u8* buf) {
	{ // Unsafe block
		int icode = ((int)(code));
		u8* buffer = ((u8*)(buf));
		if (icode <= 127) {
			buffer[0] = ((u8)(icode));
			return 1;
		} else if (icode <= 2047) {
			buffer[0] = (192 | ((u8)((icode >> 6))));
			buffer[1] = (128 | ((u8)((icode & 63))));
			return 2;
		} else if (icode <= 65535) {
			buffer[0] = (224 | ((u8)((icode >> 12))));
			buffer[1] = (128 | ((((u8)((icode >> 6))) & 63)));
			buffer[2] = (128 | ((u8)((icode & 63))));
			return 3;
		} else if (icode <= 1114111) {
			buffer[0] = (240 | ((u8)((icode >> 18))));
			buffer[1] = (128 | ((((u8)((icode >> 12))) & 63)));
			buffer[2] = (128 | ((((u8)((icode >> 6))) & 63)));
			buffer[3] = (128 | ((u8)((icode & 63))));
			return 4;
		}
	}
	return 0;
}
int builtin__string_utf32_code(string _rune) {
	if (_rune.len > 4) {
		return 0;
	}
	return ((int)(builtin__impl_utf8_to_utf32(((u8*)(_rune.str)), _rune.len)));
}
_result_rune Array_u8_utf8_to_utf32(Array_u8 _bytes) {
	if (_bytes.len > 4) {
		return (_result_rune){ .is_error=true, .err=builtin___v_error(_S("attempted to decode too many bytes, utf-8 is limited to four bytes maximum")), .data={E_STRUCT} };
	}
	_result_rune _t2;
	builtin___result_ok(&(rune[]) { builtin__impl_utf8_to_utf32(((u8*)(_bytes.data)), _bytes.len) }, (_result*)(&_t2), sizeof(rune));
	 
	return _t2;
}
VV_LOC rune builtin__impl_utf8_to_utf32(u8* _bytes, int _bytes_len) {
	if (_bytes_len == 0 || _bytes_len > 4) {
		return 0;
	}
	if (_bytes_len == 1) {
		return ((rune)(_bytes[0]));
	}
	switch (_bytes_len) {
		case 2: {
			rune b0 = ((rune)(_bytes[0]));
			rune b1 = ((rune)(_bytes[1]));
			return (((((b0 & 0x1F)) << 6)) | ((b1 & 0x3F)));
		}
		case 3: {
			rune b0 = ((rune)(_bytes[0]));
			rune b1 = ((rune)(_bytes[1]));
			rune b2 = ((rune)(_bytes[2]));
			return ((((((b0 & 0x0F)) << 12)) | ((((b1 & 0x3F)) << 6))) | ((b2 & 0x3F)));
		}
		case 4: {
			rune b0 = ((rune)(_bytes[0]));
			rune b1 = ((rune)(_bytes[1]));
			rune b2 = ((rune)(_bytes[2]));
			rune b3 = ((rune)(_bytes[3]));
			return (((((((b0 & 0x07)) << 18)) | ((((b1 & 0x3F)) << 12))) | ((((b2 & 0x3F)) << 6))) | ((b3 & 0x3F)));
		}
		default: {
			{
				return 0;
			}
		}
	}
	
	return 0;
}
int builtin__utf8_str_visible_length(string s) {
	int l = 0;
	int ul = 1;
	for (int i = 0; i < s.len; i += ul) {
		u8 c = s.str[i];
		ul = (int_literal)(((((0xe5000000U >> ((((s.str[i] >> 3)) & 0x1e)))) & 3)) + 1);
		if ((int)(i + ul) > s.len) {
			return l;
		}
		l++;
		if (ul == 1) {
			continue;
		}

		if (ul == (2)) {
			u64 r = ((u64)((((((u16)(c)) << 8)) | s.str[(int)(i + 1)])));
			if (r >= 0xcc80 && r < 0xcdb0) {
				l--;
			}
		}
		else if (ul == (3)) {
			u64 r = ((u64)((((((u32)(c)) << 16)) | (((((u32)(s.str[(int)(i + 1)])) << 8)) | s.str[(int)(i + 2)]))));
			if ((r >= 0xe1aab0 && r <= 0xe1ac7f) || (r >= 0xe1b780 && r <= 0xe1b87f) || (r >= 0xe28390 && r <= 0xe2847f) || (r >= 0xefb8a0 && r <= 0xefb8af)) {
				l--;
			} else if ((r >= 0xe18480 && r <= 0xe1859f) || (r >= 0xe2ba80 && r <= 0xe2bf95) || (r >= 0xe38080 && r <= 0xe4b77f) || (r >= 0xe4b880 && r <= 0xea807f) || (r >= 0xeaa5a0 && r <= 0xeaa79f) || (r >= 0xeab080 && r <= 0xed9eaf) || (r >= 0xefa480 && r <= 0xefac7f) || (r >= 0xefb8b8 && r <= 0xefb9af)) {
				l++;
			}
		}
		else if (ul == (4)) {
			u64 r = ((u64)((((((u32)(c)) << 24)) | ((((((u32)(s.str[(int)(i + 1)])) << 16)) | ((((u32)(s.str[(int)(i + 2)])) << 8))) | s.str[(int)(i + 3)]))));
			if ((r >= 0xf09f8880U && r <= 0xf09f8a8fU) || (r >= 0xf09f8c80U && r <= 0xf09f9c90U) || (r >= 0xf09fa490U && r <= 0xf09fa7afU) || (r >= 0xf0a08080U && r <= 0xf180807fU)) {
				l++;
			}
		}
		else {
		}
	}
	return l;
}
Array_u8 builtin__string_to_ansi_not_null_terminated(string _str) {
	u16* wstr = builtin__string_to_wide(_str, ((ToWideConfig){.from_ansi = 0,}));
	Array_u8 ansi = builtin__wide_to_ansi(wstr);
	if (ansi.len > 0) {
		ansi.len--;
	}
	return ansi;
}
inline bool builtin__ArrayFlags_is_empty(ArrayFlags* e) {
	return ((int)(*e)) == 0;
}
inline bool builtin__ArrayFlags_has(ArrayFlags* e, ArrayFlags flag_) {
	return ((((int)(*e)) & (((int)(flag_))))) != 0;
}
inline bool builtin__ArrayFlags_all(ArrayFlags* e, ArrayFlags flag_) {
	return ((((int)(*e)) & (((int)(flag_))))) == ((int)(flag_));
}
inline void builtin__ArrayFlags_set(ArrayFlags* e, ArrayFlags flag_) {
	{ // Unsafe block
		*e = ((ArrayFlags)((((int)(*e)) | (((int)(flag_))))));
	}
}
inline void builtin__ArrayFlags_set_all(ArrayFlags* e) {
	{ // Unsafe block
		*e = ((ArrayFlags)(0b1111));
	}
}
inline void builtin__ArrayFlags_clear(ArrayFlags* e, ArrayFlags flag_) {
	{ // Unsafe block
		*e = ((ArrayFlags)((((int)(*e)) & ~(((int)(flag_))))));
	}
}
inline void builtin__ArrayFlags_clear_all(ArrayFlags* e) {
	{ // Unsafe block
		*e = ((ArrayFlags)(0));
	}
}
inline void builtin__ArrayFlags_toggle(ArrayFlags* e, ArrayFlags flag_) {
	{ // Unsafe block
		*e = ((ArrayFlags)((((int)(*e)) ^ (((int)(flag_))))));
	}
}
inline ArrayFlags builtin__ArrayFlags__static__zero(void) {
	return ((ArrayFlags)(0));
}
#if !defined(_WIN32) && !defined(__ANDROID__)
#endif
strings__textscanner__TextScanner strings__textscanner__new(string input) {
	return ((strings__textscanner__TextScanner){.input = input,.ilen = input.len,.pos = 0,});
}
void strings__textscanner__TextScanner_free(strings__textscanner__TextScanner* ss) {
	builtin__string_free(&ss->input);
}
inline int strings__textscanner__TextScanner_remaining(strings__textscanner__TextScanner* ss) {
	return (int)(ss->ilen - ss->pos);
}
inline int strings__textscanner__TextScanner_next(strings__textscanner__TextScanner* ss) {
	if (ss->pos < ss->ilen) {
		int opos = ss->pos;
		ss->pos++;
		return ss->input.str[ opos];
	}
	return -1;
}
inline void strings__textscanner__TextScanner_skip(strings__textscanner__TextScanner* ss) {
	if (ss->pos < ss->ilen) {
		ss->pos++;
	}
}
inline void strings__textscanner__TextScanner_skip_n(strings__textscanner__TextScanner* ss, int n) {
	ss->pos += n;
	if (ss->pos > ss->ilen) {
		ss->pos = ss->ilen;
	}
}
inline int strings__textscanner__TextScanner_peek(strings__textscanner__TextScanner* ss) {
	if (ss->pos < ss->ilen) {
		return ss->input.str[ ss->pos];
	}
	return -1;
}
inline u8 strings__textscanner__TextScanner_peek_u8(strings__textscanner__TextScanner* ss) {
	if (ss->pos < ss->ilen) {
		return ss->input.str[ ss->pos];
	}
	return 0;
}
inline int strings__textscanner__TextScanner_peek_n(strings__textscanner__TextScanner* ss, int n) {
	if ((int)(ss->pos + n) < ss->ilen) {
		return ss->input.str[ (int)(ss->pos + n)];
	}
	return -1;
}
inline u8 strings__textscanner__TextScanner_peek_n_u8(strings__textscanner__TextScanner* ss, int n) {
	if ((int)(ss->pos + n) < ss->ilen) {
		return ss->input.str[ (int)(ss->pos + n)];
	}
	return 0;
}
inline void strings__textscanner__TextScanner_back(strings__textscanner__TextScanner* ss) {
	if (ss->pos > 0) {
		ss->pos--;
	}
}
void strings__textscanner__TextScanner_back_n(strings__textscanner__TextScanner* ss, int n) {
	ss->pos -= n;
	if (ss->pos < 0) {
		ss->pos = 0;
	}
	if (ss->pos > ss->ilen) {
		ss->pos = ss->ilen;
	}
}
inline int strings__textscanner__TextScanner_peek_back(strings__textscanner__TextScanner* ss) {
	return strings__textscanner__TextScanner_peek_back_n(ss, 1);
}
inline int strings__textscanner__TextScanner_peek_back_n(strings__textscanner__TextScanner* ss, int n) {
	int offset = (int)(n + 1);
	if (ss->pos >= offset) {
		return ss->input.str[ (int)(ss->pos - offset)];
	}
	return -1;
}
inline int strings__textscanner__TextScanner_current(strings__textscanner__TextScanner* ss) {
	if (ss->pos > 0) {
		return ss->input.str[ (int)(ss->pos - 1)];
	}
	return -1;
}
void strings__textscanner__TextScanner_reset(strings__textscanner__TextScanner* ss) {
	ss->pos = 0;
}
void strings__textscanner__TextScanner_goto_end(strings__textscanner__TextScanner* ss) {
	ss->pos = ss->ilen;
}
void strings__textscanner__TextScanner_skip_whitespace(strings__textscanner__TextScanner* ss) {
	for (;;) {
		if (!((int)(ss->ilen - ss->pos) > 0 && builtin__u8_is_space(strings__textscanner__TextScanner_peek_u8(ss)))) break;
		strings__textscanner__TextScanner_next(ss);
	}
}
inline term__termios__TcFlag term__termios__flag(int value) {
	return ((usize)(value));
}
inline term__termios__TcFlag term__termios__invert(term__termios__TcFlag value) {
	return ~((usize)(value));
}
inline int term__termios__tcgetattr(int fd, term__termios__Termios* termios_p) {
	{ // Unsafe block
		return tcgetattr(fd, ((struct termios*)(termios_p)));
	}
	return 0;
}
inline int term__termios__tcsetattr(int fd, int optional_actions, term__termios__Termios* termios_p) {
	{ // Unsafe block
		return tcsetattr(fd, optional_actions, ((struct termios*)(termios_p)));
	}
	return 0;
}
inline int term__termios__ioctl(int fd, u64 request, voidptr arg) {
	{ // Unsafe block
		return ioctl(fd, request, arg);
	}
	return 0;
}
int term__termios__set_state(int fd, term__termios__Termios new_state) {
	term__termios__Termios x = new_state;
	return term__termios__tcsetattr(0, TCSANOW, (voidptr)&x);
}
void term__termios__Termios_disable_echo(term__termios__Termios* t) {
	t->c_lflag &= term__termios__invert(((usize)(ECHO)));
}
int vphp__Val_type_id(vphp__Val v) {
	return vphp_get_type(v.raw);
}
bool vphp__Val_is_array(vphp__Val v) {
	return vphp__Val_type_id(v) == ((int)(vphp__PHPType__array));
}
bool vphp__Val_is_string(vphp__Val v) {
	return vphp__Val_type_id(v) == ((int)(vphp__PHPType__string));
}
bool vphp__Val_is_long(vphp__Val v) {
	return vphp__Val_type_id(v) == ((int)(vphp__PHPType__long));
}
bool vphp__Val_is_double(vphp__Val v) {
	return vphp__Val_type_id(v) == ((int)(vphp__PHPType__double));
}
bool vphp__Val_is_bool(vphp__Val v) {
	int tid = vphp__Val_type_id(v);
	return tid == ((int)(vphp__PHPType__false_)) || tid == ((int)(vphp__PHPType__true_));
}
bool vphp__Val_is_null(vphp__Val v) {
	return vphp__Val_type_id(v) == ((int)(vphp__PHPType__null));
}
bool vphp__Val_is_object(vphp__Val v) {
	return vphp__Val_type_id(v) == ((int)(vphp__PHPType__object));
}
vphp__Val vphp__Val_invoke(vphp__Val v, Array_vphp__Val args) {
	if (v.raw == 0) {
		return ((vphp__Val){.raw = 0,});
	}
	{ // Unsafe block
		zval* retval = ((zval*)(builtin___v_malloc(((int)(sizeof(zval))))));
		zval** p_args = ((zval**)(((void*)0)));
		if (args.len > 0) {
			p_args = &(*(vphp__Val*)builtin__array_get(args, 0)).raw;
		}
		int res = vphp_call_callable(v.raw, retval, args.len, p_args);
		if (res == -1) {
			return ((vphp__Val){.raw = 0,});
		}
		return ((vphp__Val){.raw = retval,});
	}
	return (vphp__Val){.raw = 0,};
}
void vphp__Context_return_res(vphp__Context ctx, voidptr ptr, string label) {
	vphp_make_res(ctx.ret, ptr, ((char*)(label.str)));
}
void vphp__Context_return_map(vphp__Context ctx, Map_string_string m) {
	vphp_return_array_start(ctx.ret);
	int _t2 = m.key_values.len;
	for (int _t1 = 0; _t1 < _t2; ++_t1 ) {
		int _t3 = m.key_values.len - _t2;
		_t2 = m.key_values.len;
		if (_t3 < 0) {
			_t1 = -1;
			continue;
		}
		if (!builtin__DenseArray_has_index(&m.key_values, _t1)) {continue;}
		string k = *(string*)builtin__DenseArray_key(&m.key_values, _t1);
		k = builtin__string_clone(k);
		string v = (*(string*)builtin__DenseArray_value(&m.key_values, _t1));
		vphp_array_add_assoc_string(ctx.ret, ((char*)(k.str)), ((char*)(v.str)));
	}
}
void vphp__Context_return_struct_T_main__MotionReport(vphp__Context ctx, main__MotionReport s) {
	vphp_return_array_start(ctx.ret);
	/* $for field in main.MotionReport.fields */ {
			FieldData field = {0};
		/* field 0 : user_name */ {
			field.name = _S("user_name");
			field.attrs = builtin____new_array_with_default(0, 0, sizeof(string), 0);
			field.typ = 21;	// string
			field.unaliased_typ = 21;	// string
			field.is_pub = false;
			field.is_mut = false;
			field.is_embed = false;
			field.is_shared = false;
			field.is_atomic = false;
			field.is_option = false;
			field.is_array = false;
			field.is_map = false;
			field.is_chan = false;
			field.is_struct = false;
			field.is_alias = false;
			field.is_enum = false;
			field.indirections = 0;
			string key = field.name;
			string val = s.user_name;
			#if true
			{
				vphp_array_add_assoc_string(ctx.ret, ((char*)(key.str)), ((char*)(val.str)));
			}
			#elif false
			{
			}
			#elif false || false
			{
			}
			#elif false
			{
			}
			#endif
		}
		/* field 1 : max_hr */ {
			field.name = _S("max_hr");
			field.attrs = builtin____new_array_with_default(0, 0, sizeof(string), 0);
			field.typ = 17;	// f64
			field.unaliased_typ = 17;	// f64
			field.is_pub = false;
			field.is_mut = false;
			field.is_embed = false;
			field.is_shared = false;
			field.is_atomic = false;
			field.is_option = false;
			field.is_array = false;
			field.is_map = false;
			field.is_chan = false;
			field.is_struct = false;
			field.is_alias = false;
			field.is_enum = false;
			field.indirections = 0;
			string key = field.name;
			f64 val = s.max_hr;
			#if false
			{
			}
			#elif true
			{
				vphp_array_add_assoc_double(ctx.ret, ((char*)(key.str)), val);
			}
			#elif false || false
			{
			}
			#elif false
			{
			}
			#endif
		}
		/* field 2 : min_hr */ {
			field.name = _S("min_hr");
			field.attrs = builtin____new_array_with_default(0, 0, sizeof(string), 0);
			field.typ = 17;	// f64
			field.unaliased_typ = 17;	// f64
			field.is_pub = false;
			field.is_mut = false;
			field.is_embed = false;
			field.is_shared = false;
			field.is_atomic = false;
			field.is_option = false;
			field.is_array = false;
			field.is_map = false;
			field.is_chan = false;
			field.is_struct = false;
			field.is_alias = false;
			field.is_enum = false;
			field.indirections = 0;
			string key = field.name;
			f64 val = s.min_hr;
			#if false
			{
			}
			#elif true
			{
				vphp_array_add_assoc_double(ctx.ret, ((char*)(key.str)), val);
			}
			#elif false || false
			{
			}
			#elif false
			{
			}
			#endif
		}
		/* field 3 : avg_hr */ {
			field.name = _S("avg_hr");
			field.attrs = builtin____new_array_with_default(0, 0, sizeof(string), 0);
			field.typ = 17;	// f64
			field.unaliased_typ = 17;	// f64
			field.is_pub = false;
			field.is_mut = false;
			field.is_embed = false;
			field.is_shared = false;
			field.is_atomic = false;
			field.is_option = false;
			field.is_array = false;
			field.is_map = false;
			field.is_chan = false;
			field.is_struct = false;
			field.is_alias = false;
			field.is_enum = false;
			field.indirections = 0;
			string key = field.name;
			f64 val = s.avg_hr;
			#if false
			{
			}
			#elif true
			{
				vphp_array_add_assoc_double(ctx.ret, ((char*)(key.str)), val);
			}
			#elif false || false
			{
			}
			#elif false
			{
			}
			#endif
		}
		/* field 4 : risk_level */ {
			field.name = _S("risk_level");
			field.attrs = builtin____new_array_with_default(0, 0, sizeof(string), 0);
			field.typ = 21;	// string
			field.unaliased_typ = 21;	// string
			field.is_pub = false;
			field.is_mut = false;
			field.is_embed = false;
			field.is_shared = false;
			field.is_atomic = false;
			field.is_option = false;
			field.is_array = false;
			field.is_map = false;
			field.is_chan = false;
			field.is_struct = false;
			field.is_alias = false;
			field.is_enum = false;
			field.indirections = 0;
			string key = field.name;
			string val = s.risk_level;
			#if true
			{
				vphp_array_add_assoc_string(ctx.ret, ((char*)(key.str)), ((char*)(val.str)));
			}
			#elif false
			{
			}
			#elif false || false
			{
			}
			#elif false
			{
			}
			#endif
		}
		/* field 5 : device_mode */ {
			field.name = _S("device_mode");
			field.attrs = builtin____new_array_with_default(0, 0, sizeof(string), 0);
			field.typ = 21;	// string
			field.unaliased_typ = 21;	// string
			field.is_pub = false;
			field.is_mut = false;
			field.is_embed = false;
			field.is_shared = false;
			field.is_atomic = false;
			field.is_option = false;
			field.is_array = false;
			field.is_map = false;
			field.is_chan = false;
			field.is_struct = false;
			field.is_alias = false;
			field.is_enum = false;
			field.indirections = 0;
			string key = field.name;
			string val = s.device_mode;
			#if true
			{
				vphp_array_add_assoc_string(ctx.ret, ((char*)(key.str)), ((char*)(val.str)));
			}
			#elif false
			{
			}
			#elif false || false
			{
			}
			#elif false
			{
			}
			#endif
		}
	}// $for
}
void vphp__Context_return_list_T_main__HeartPoint(vphp__Context ctx, Array_main__HeartPoint list) {
	vphp_return_array_start(ctx.ret);
	if (list.len == 0) {
		return;
	}
	for (int _t1 = 0; _t1 < list.len; ++_t1) {
		main__HeartPoint item = ((main__HeartPoint*)list.data)[_t1];
		zval sub_zv = ((zval){E_STRUCT});
		vphp_return_array_start(&sub_zv);
		/* $for field in main.HeartPoint.fields */ {
				FieldData field = {0};
			/* field 0 : timestamp */ {
				field.name = _S("timestamp");
				field.attrs = builtin____new_array_with_default(0, 0, sizeof(string), 0);
				field.typ = 8;	// int
				field.unaliased_typ = 8;	// int
				field.is_pub = false;
				field.is_mut = false;
				field.is_embed = false;
				field.is_shared = false;
				field.is_atomic = false;
				field.is_option = false;
				field.is_array = false;
				field.is_map = false;
				field.is_chan = false;
				field.is_struct = false;
				field.is_alias = false;
				field.is_enum = false;
				field.indirections = 0;
				string key = field.name;
				int val = item.timestamp;
				#if false
				{
				}
				#elif false
				{
				}
				#elif true || false
				{
					vphp_array_add_assoc_long(&sub_zv, ((char*)(key.str)), ((i64)(val)));
				}
				#elif false
				{
				}
				#endif
			}
			/* field 1 : hr */ {
				field.name = _S("hr");
				field.attrs = builtin____new_array_with_default(0, 0, sizeof(string), 0);
				field.typ = 17;	// f64
				field.unaliased_typ = 17;	// f64
				field.is_pub = false;
				field.is_mut = false;
				field.is_embed = false;
				field.is_shared = false;
				field.is_atomic = false;
				field.is_option = false;
				field.is_array = false;
				field.is_map = false;
				field.is_chan = false;
				field.is_struct = false;
				field.is_alias = false;
				field.is_enum = false;
				field.indirections = 0;
				string key = field.name;
				f64 val = item.hr;
				#if false
				{
				}
				#elif true
				{
					vphp_array_add_assoc_double(&sub_zv, ((char*)(key.str)), val);
				}
				#elif false || false
				{
				}
				#elif false
				{
				}
				#endif
			}
		}// $for
		vphp_array_add_next_zval(ctx.ret, &sub_zv);
	}
}
voidptr vphp__Val_to_res(vphp__Val v) {
	return vphp_fetch_res(v.raw);
}
bool vphp__Val_to_bool(vphp__Val v) {
	return vphp__Val_type_id(v) == ((int)(vphp__PHPType__true_));
}
string vphp__Val_type_name(vphp__Val v) {
	int tid = vphp__Val_type_id(v);
	return ((tid == (((int)(vphp__PHPType__undef))))? (_S("undefined")) : (tid == (((int)(vphp__PHPType__null))))? (_S("null")) : (tid == (((int)(vphp__PHPType__false_))))? (_S("boolean")) : (tid == (((int)(vphp__PHPType__true_))))? (_S("boolean")) : (tid == (((int)(vphp__PHPType__long))))? (_S("integer")) : (tid == (((int)(vphp__PHPType__double))))? (_S("float")) : (tid == (((int)(vphp__PHPType__string))))? (_S("string")) : (tid == (((int)(vphp__PHPType__array))))? (_S("array")) : (tid == (((int)(vphp__PHPType__object))))? (_S("object")) : (_S("unknown")));
}
vphp__Val vphp__Val_call(vphp__Val v, string method, Array_vphp__Val args) {
	if (v.raw == 0 || !vphp__Val_is_object(v)) {
		return ((vphp__Val){.raw = 0,});
	}
	{ // Unsafe block
		zval* retval = ((zval*)(builtin___v_malloc(((int)(sizeof(zval))))));
		zval** p_args = ((zval**)(((void*)0)));
		if (args.len > 0) {
			p_args = &(*(vphp__Val*)builtin__array_get(args, 0)).raw;
		}
		int res = vphp_call_method(v.raw, ((char*)(method.str)), method.len, retval, args.len, p_args);
		if (res == -1) {
			return ((vphp__Val){.raw = 0,});
		}
		return ((vphp__Val){.raw = retval,});
	}
	return (vphp__Val){.raw = 0,};
}
void vphp__init_framework(int module_number) {
	vphp_init_resource_system(module_number);
}
VV_LOC void vphp__vphp_framework_init(int module_number) {
	vphp__init_framework(module_number);
	builtin__println(_S("VPHP Framework initialized."));
}
// export alias: vphp_framework_init -> vphp__vphp_framework_init
void vphp_framework_init(int module_number) {
	return vphp__vphp_framework_init(module_number);
}
vphp__Val vphp__Context_arg_raw(vphp__Context ctx, int index) {
	Array_vphp__Val args = vphp__get_args(ctx.ex);
	if (index >= args.len || index < 0) {
		return ((vphp__Val){.raw = 0,});
	}
	return (*(vphp__Val*)builtin__array_get(args, index));
}
void vphp__Context_return_object(vphp__Context ctx, Map_string_string props) {
	{ // Unsafe block
		vphp_object_init(ctx.ret);
		int _t2 = props.key_values.len;
		for (int _t1 = 0; _t1 < _t2; ++_t1 ) {
			int _t3 = props.key_values.len - _t2;
			_t2 = props.key_values.len;
			if (_t3 < 0) {
				_t1 = -1;
				continue;
			}
			if (!builtin__DenseArray_has_index(&props.key_values, _t1)) {continue;}
			string k = *(string*)builtin__DenseArray_key(&props.key_values, _t1);
			k = builtin__string_clone(k);
			string v = (*(string*)builtin__DenseArray_value(&props.key_values, _t1));
			vphp_update_property_string(ctx.ret, ((char*)(k.str)), k.len, ((char*)(v.str)));
		}
	}
}
_result_vphp__Val vphp__Val_get(vphp__Val v, string key) {
	if (v.raw == 0 || vphp_is_null(v.raw)) {
		return (_result_vphp__Val){ .is_error=true, .err=builtin___v_error(_S("invalid zval or not an array")), .data={E_STRUCT} };
	}
	{ // Unsafe block
		zval* res = vphp_array_get_key(v.raw, ((char*)(key.str)), key.len);
		if (res == 0 || vphp_is_null(res)) {
			return (_result_vphp__Val){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("key \""), 0xfe10, {.d_s = key}}, {_S("\" not found"), 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
		}
		_result_vphp__Val _t3;
		builtin___result_ok(&(vphp__Val[]) { ((vphp__Val){.raw = res,}) }, (_result*)(&_t3), sizeof(vphp__Val));
		 
		return _t3;
	}
	return (_result_vphp__Val){0};
}
void vphp__report_error(int level, string msg) {
	vphp_error(level, ((char*)(msg.str)));
}
string vphp__Val_to_string(vphp__Val v) {
	{ // Unsafe block
		char* p = vphp_get_strval(v.raw);
		int l = vphp_get_strlen(v.raw);
		return builtin__char_vstring_with_len(p, l);
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
void vphp__Val_set_string(vphp__Val v, string s) {
	{ // Unsafe block
		voidptr zs = zend_string_init(((char*)(s.str)), ((usize)(s.len)), 0);
		ZVAL_STR(v.raw, zs);
	}
}
i64 vphp__Val_as_int(vphp__Val v) {
	return vphp_get_lval(v.raw);
}
Array_vphp__Val vphp__get_args(zend_execute_data* ex) {
	int num = ((int)(vphp_get_num_args(ex)));
	Array_vphp__Val res = builtin____new_array_with_default(0, 0, sizeof(vphp__Val), 0);
	for (int i = 1; i < ((int)(num + 1)); ++i) {
		builtin__array_push((array*)&res, _MOV((vphp__Val[]){ ((vphp__Val){.raw = vphp_get_arg_ptr(ex, ((u32)(i))),}) }));
	}
	return res;
}
void vphp__throw_exception(string msg, int code) {
	vphp_throw(((char*)(msg.str)), code);
}
void vphp__Val_set_int(vphp__Val v, i64 val) {
	vphp_set_lval(v.raw, val);
}
void vphp__Context_return_int(vphp__Context ctx, i64 val) {
	{ // Unsafe block
		vphp__Val out = ((vphp__Val){.raw = ctx.ret,});
		vphp__Val_set_int(out, val);
	}
}
void vphp__Context_return_string(vphp__Context ctx, string val) {
	{ // Unsafe block
		vphp__Val out = ((vphp__Val){.raw = ctx.ret,});
		vphp__Val_set_string(out, val);
	}
}
void vphp__Context_return_map_f64(vphp__Context ctx, Map_string_f64 m) {
	vphp_return_array_start(ctx.ret);
	int _t2 = m.key_values.len;
	for (int _t1 = 0; _t1 < _t2; ++_t1 ) {
		int _t3 = m.key_values.len - _t2;
		_t2 = m.key_values.len;
		if (_t3 < 0) {
			_t1 = -1;
			continue;
		}
		if (!builtin__DenseArray_has_index(&m.key_values, _t1)) {continue;}
		string k = *(string*)builtin__DenseArray_key(&m.key_values, _t1);
		k = builtin__string_clone(k);
		f64 v = (*(f64*)builtin__DenseArray_value(&m.key_values, _t1));
		vphp_array_add_assoc_double(ctx.ret, ((char*)(k.str)), v);
	}
}
void vphp__Context_return_map_int(vphp__Context ctx, Map_string_int m) {
	vphp_return_array_start(ctx.ret);
	int _t2 = m.key_values.len;
	for (int _t1 = 0; _t1 < _t2; ++_t1 ) {
		int _t3 = m.key_values.len - _t2;
		_t2 = m.key_values.len;
		if (_t3 < 0) {
			_t1 = -1;
			continue;
		}
		if (!builtin__DenseArray_has_index(&m.key_values, _t1)) {continue;}
		string k = *(string*)builtin__DenseArray_key(&m.key_values, _t1);
		k = builtin__string_clone(k);
		int v = (*(int*)builtin__DenseArray_value(&m.key_values, _t1));
		vphp_array_add_assoc_long(ctx.ret, ((char*)(k.str)), ((i64)(v)));
	}
}
int vphp__Context_num_args(vphp__Context ctx) {
	return ((int)(vphp_get_num_args(ctx.ex)));
}
string vphp__Context_arg_T_string(vphp__Context ctx, int index) {
	Array_vphp__Val args = vphp__get_args(ctx.ex);
	if (index >= args.len) {
		return (string){.str=(byteptr)"", .is_lit=1};
	}
	vphp__Val val = (*(vphp__Val*)builtin__array_get(args, index));
	zval* raw_zval = val.raw;
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if true
	{
		int len = 0;
		voidptr ptr = ((voidptr)(vphp_get_string_ptr(val.raw, &len)));
		return (ptr != 0 ? (builtin__char_vstring_with_len((((char*)(ptr))), len)) : (_S("")));
	}
	#endif
	return (string){.str=(byteptr)"", .is_lit=1};
}
i64 vphp__Context_arg_T_i64(vphp__Context ctx, int index) {
	Array_vphp__Val args = vphp__get_args(ctx.ex);
	if (index >= args.len) {
		return 0;
	}
	vphp__Val val = (*(vphp__Val*)builtin__array_get(args, index));
	zval* raw_zval = val.raw;
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if true
	{
		if (!vphp__Val_is_long(val) && !vphp__Val_is_double(val)) {
			vphp_throw(((char*)(builtin__str_intp(3, _MOV((StrIntpData[]){{_S("Argument "), 0xfe07, {.d_i32 = index}}, {_S(": expected integer, got "), 0xfe10, {.d_s = vphp__Val_type_name(val)}}, {_SLIT0, 0, { .d_c = 0 }}})).str)), 0);
			return 0;
		}
		return ((i64)(vphp_get_int(val.raw)));
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	return 0;
}
Array_string vphp__Context_arg_T_Array_string(vphp__Context ctx, int index) {
	Array_vphp__Val args = vphp__get_args(ctx.ex);
	if (index >= args.len) {
		return builtin____new_array_with_default(0, 0, sizeof(string), 0);
	}
	vphp__Val val = (*(vphp__Val*)builtin__array_get(args, index));
	zval* raw_zval = val.raw;
	#if true
	{
		if (!vphp__Val_is_array(val)) {
			vphp_throw(((char*)(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("Expected array at index "), 0xfe07, {.d_i32 = index}}, {_SLIT0, 0, { .d_c = 0 }}})).str)), 0);
			return builtin____new_array_with_default(0, 0, sizeof(string), 0);
		}
		int count = vphp_array_count(raw_zval);
		Array_string res = builtin____new_array_with_default(0, count, sizeof(string), 0);
		for (int i = 0; i < count; ++i) {
			zval* item_zval = vphp_array_get_index(raw_zval, ((u32)(i)));
			if (item_zval != 0) {
				#if true
				{
					int len = 0;
					voidptr ptr = ((voidptr)(vphp_get_string_ptr(item_zval, &len)));
					if (ptr != 0) {
						builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_clone(builtin__char_vstring_with_len((((char*)(ptr))), len)) }));
					} else {
						builtin__array_push((array*)&res, _MOV((string[]){ _S("") }));
					}
				}
				#elif false
				{
				}
				#elif false
				{
				}
				#elif false
				{
				}
				#endif
			}
		}
		return res;
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	return builtin____new_array_with_default(0, 0, sizeof(string), 0);
}
Map_string_string vphp__Context_arg_T_Map_string_string(vphp__Context ctx, int index) {
	Array_vphp__Val args = vphp__get_args(ctx.ex);
	if (index >= args.len) {
		return builtin__new_map(sizeof(string), sizeof(string), &builtin__map_hash_string, &builtin__map_eq_string, &builtin__map_clone_string, &builtin__map_free_string)
		;
	}
	vphp__Val val = (*(vphp__Val*)builtin__array_get(args, index));
	zval* raw_zval = val.raw;
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if true
	{
		vphp__MapContext m_ctx = ((vphp__MapContext){.m = builtin__new_map(sizeof(string), sizeof(string), &builtin__map_hash_string, &builtin__map_eq_string, &builtin__map_clone_string, &builtin__map_free_string)
		,});
		vphp_array_each(raw_zval, &m_ctx, ((voidptr)(vphp__map_callback)));
		return builtin__map_clone(&m_ctx.m);
	}
	#endif
	#if false
	{
	}
	#endif
	return builtin__new_map(sizeof(string), sizeof(string), &builtin__map_hash_string, &builtin__map_eq_string, &builtin__map_clone_string, &builtin__map_free_string)
	;
}
Array_f64 vphp__Context_arg_T_Array_f64(vphp__Context ctx, int index) {
	Array_vphp__Val args = vphp__get_args(ctx.ex);
	if (index >= args.len) {
		return builtin____new_array_with_default(0, 0, sizeof(f64), 0);
	}
	vphp__Val val = (*(vphp__Val*)builtin__array_get(args, index));
	zval* raw_zval = val.raw;
	#if true
	{
		if (!vphp__Val_is_array(val)) {
			vphp_throw(((char*)(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("Expected array at index "), 0xfe07, {.d_i32 = index}}, {_SLIT0, 0, { .d_c = 0 }}})).str)), 0);
			return builtin____new_array_with_default(0, 0, sizeof(f64), 0);
		}
		int count = vphp_array_count(raw_zval);
		Array_f64 res = builtin____new_array_with_default(0, count, sizeof(f64), 0);
		for (int i = 0; i < count; ++i) {
			zval* item_zval = vphp_array_get_index(raw_zval, ((u32)(i)));
			if (item_zval != 0) {
				#if false
				{
				}
				#elif true
				{
					builtin__array_push((array*)&res, _MOV((f64[]){ vphp_get_double(item_zval) }));
				}
				#elif false
				{
				}
				#elif false
				{
				}
				#endif
			}
		}
		return res;
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	return builtin____new_array_with_default(0, 0, sizeof(f64), 0);
}
int vphp__Context_arg_T_int(vphp__Context ctx, int index) {
	Array_vphp__Val args = vphp__get_args(ctx.ex);
	if (index >= args.len) {
		return 0;
	}
	vphp__Val val = (*(vphp__Val*)builtin__array_get(args, index));
	zval* raw_zval = val.raw;
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if true
	{
		if (!vphp__Val_is_long(val) && !vphp__Val_is_double(val)) {
			vphp_throw(((char*)(builtin__str_intp(3, _MOV((StrIntpData[]){{_S("Argument "), 0xfe07, {.d_i32 = index}}, {_S(": expected integer, got "), 0xfe10, {.d_s = vphp__Val_type_name(val)}}, {_SLIT0, 0, { .d_c = 0 }}})).str)), 0);
			return 0;
		}
		return ((int)(vphp_get_int(val.raw)));
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	return 0;
}
bool vphp__Context_arg_T_bool(vphp__Context ctx, int index) {
	Array_vphp__Val args = vphp__get_args(ctx.ex);
	if (index >= args.len) {
		return 0;
	}
	vphp__Val val = (*(vphp__Val*)builtin__array_get(args, index));
	zval* raw_zval = val.raw;
	#if false
	{
	}
	#endif
	#if true
	{
		if (!vphp__Val_is_bool(val)) {
			vphp_throw(((char*)(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("Argument "), 0xfe07, {.d_i32 = index}}, {_S(" must be a boolean"), 0, { .d_c = 0 }}})).str)), 0);
			return false;
		}
		return vphp__Val_to_bool(val);
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	#if false
	{
	}
	#endif
	return 0;
}
void vphp__return_val_T_i64(vphp__Context ctx, i64 val) {
	{ // Unsafe block
		vphp__Val out = ((vphp__Val){.raw = ctx.ret,});
		#if true
		{
			vphp__Val_set_int(out, val);
		}
		#elif false
		{
		}
		#endif
	}
}
void vphp__return_val_T_string(vphp__Context ctx, string val) {
	{ // Unsafe block
		vphp__Val out = ((vphp__Val){.raw = ctx.ret,});
		#if false
		{
		}
		#elif true
		{
			vphp__Val_set_string(out, val);
		}
		#endif
	}
}
vphp__Context vphp__new_context(zend_execute_data* ex, zval* ret) {
	return ((vphp__Context){.ex = ex,.ret = ret,});
}
VV_LOC void vphp__map_callback(voidptr p_ctx, char* key, zval* val) {
	vphp__MapContext* ctx = ((vphp__MapContext*)(p_ctx));
	string v_key = builtin__char_vstring(key);
	string v_val = vphp__Val_to_string(((vphp__Val){.raw = val,}));
	builtin__map_set(&ctx->m, &(string[]){v_key}, &(string[]) { v_val });
}
vphp__Val vphp__call_php(string name, Array_vphp__Val args) {
	{ // Unsafe block
		zval retval = ((zval){E_STRUCT});
		zval** p_args = ((zval**)(((void*)0)));
		if (args.len > 0) {
			p_args = &(*(vphp__Val*)builtin__array_get(args, 0)).raw;
		}
		vphp_call_php_func(((char*)(name.str)), name.len, &retval, args.len, p_args);
		return ((vphp__Val){.raw = &retval,});
	}
	return (vphp__Val){.raw = 0,};
}
bool vphp__Context_has_exception(vphp__Context ctx) {
	return vphp_has_exception();
}
vphp__Val vphp__Val_get_prop(vphp__Val v, string name) {
	if (!vphp__Val_is_object(v)) {
		return ((vphp__Val){.raw = 0,});
	}
	zval* res = vphp_read_property(v.raw, ((char*)(name.str)), name.len);
	return ((vphp__Val){.raw = res,});
}
string vphp__Val_get_prop_string(vphp__Val v, string name) {
	vphp__Val prop = vphp__Val_get_prop(v, name);
	if (prop.raw == 0 || vphp__Val_is_null(prop)) {
		return _S("");
	}
	return vphp__Val_to_string(prop);
}
int vphp__Val_get_prop_int(vphp__Val v, string name) {
	vphp__Val prop = vphp__Val_get_prop(v, name);
	if (prop.raw == 0) {
		return 0;
	}
	return ((int)(vphp_get_int(prop.raw)));
}
VV_LOC vphp__TaskRegistry* vphp__get_registry(void) {
	{ // Unsafe block
		if (g_registry == 0) {
			g_registry = ((vphp__TaskRegistry*)builtin__memdup(&(vphp__TaskRegistry){.tasks = builtin__new_map(sizeof(string), sizeof(vphp__TaskCreator), &builtin__map_hash_string, &builtin__map_eq_string, &builtin__map_clone_string, &builtin__map_free_string)
			,}, sizeof(vphp__TaskRegistry)));
		}
		return g_registry;
	}
	return 0;
}
void vphp__ITask__static__register(string name, vphp__ITask (*creator)(void)) {
	vphp__TaskRegistry* r = vphp__get_registry();
	builtin__map_set(&r->tasks, &(string[]){name}, &(voidptr[]) { (voidptr)creator });
}
_option_anon_fn___vphp__ITask vphp__ITask__static__get_creator(string name) {
	vphp__TaskRegistry* r = vphp__get_registry();
	if (_IN_MAP(ADDR(string, name), ADDR(map, r->tasks))) {
		_option_anon_fn___vphp__ITask _t1;
		builtin___option_ok(&(vphp__TaskCreator[]) { (vphp__ITask (*) ())(*(voidptr*)builtin__map_get(ADDR(map, r->tasks), &(string[]){name}, &(voidptr[]){ 0 })) }, (_option*)(&_t1), sizeof(vphp__TaskCreator));
		 
		return _t1;
	}
	return (_option_anon_fn___vphp__ITask){ .state=2, .err=_const_none__, .data={E_STRUCT} };
}
VV_LOC void vphp__framework_v_spawn(zend_execute_data* ex, zval* retval) {
	vphp__Context ctx = vphp__new_context(ex, retval);
	string task_name = vphp__Context_arg_T_string(ctx, 0);
	_option_anon_fn___vphp__ITask _t1 = vphp__ITask__static__get_creator(task_name);
	if (_t1.state != 0) {
		vphp__throw_exception(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("Task "), 0xfe10, {.d_s = task_name}}, {_S(" not registered"), 0, { .d_c = 0 }}})), 0);
		return;
	}
	
 	vphp__ITask (*creator) (void) = (*(vphp__TaskCreator*)_t1.data);
	vphp__ITask task_inst = creator();
	// start go
	thread_arg_vphp__ITask_run *arg__t2 = (thread_arg_vphp__ITask_run *) builtin___v_malloc(sizeof(thread_arg_vphp__ITask_run));
	arg__t2->arg0 = task_inst;
	pthread_t thread__t2;
	pthread_attr_t thread__t2_attributes;
	pthread_attr_init(&thread__t2_attributes);
	pthread_attr_setstacksize(&thread__t2_attributes, 8388608); // fn: run
	int _t2_thr_res = pthread_create(&thread__t2, &thread__t2_attributes, (void*)vphp__ITask_run_thread_wrapper, arg__t2);
	if (_t2_thr_res) builtin__panic_error_number(builtin__tos3("`go vphp__ITask_run()`: "), _t2_thr_res);
	// end go
	__v_thread_Array_f64 t = /*spawn (thread) */
thread__t2;
	{ // Unsafe block
		vphp__AsyncResult* res = ((vphp__AsyncResult*)(builtin___v_malloc(((int)(sizeof(vphp__AsyncResult))))));
		res->handle = t;
		vphp__Context_return_res(ctx, res, _S("v_task"));
	}
}
// export alias: v_spawn -> vphp__framework_v_spawn
void v_spawn(zend_execute_data* ex, zval* retval) {
	return vphp__framework_v_spawn(ex, retval);
}
VV_LOC void vphp__framework_v_wait(zend_execute_data* ex, zval* retval) {
	vphp__Context ctx = vphp__new_context(ex, retval);
	vphp__Val res_val = vphp__Context_arg_raw(ctx, 0);
	{ // Unsafe block
		voidptr ptr = vphp__Val_to_res(res_val);
		if (ptr == ((void*)0)) {
			return;
		}
		vphp__AsyncResult* task = ((vphp__AsyncResult*)(ptr));
		Array_f64 results = __v_thread_Array_f64_wait(task->handle);
		vphp_return_array_start(retval);
		for (int _t1 = 0; _t1 < results.len; ++_t1) {
			f64 r = ((f64*)results.data)[_t1];
			vphp_array_push_double(retval, ((f64)(r)));
		}
	}
}
// export alias: v_wait -> vphp__framework_v_wait
void v_wait(zend_execute_data* ex, zval* retval) {
	return vphp__framework_v_wait(ex, retval);
}
Array_string os__args_after(string cut_word) {
	if (_const_os__args.len == 0) {
		return builtin____new_array_with_default(0, 0, sizeof(string), 0);
	}
	Array_string cargs = builtin____new_array_with_default(0, 0, sizeof(string), 0);
	if (!(Array_string_contains(_const_os__args, cut_word))) {
		cargs = builtin__array_clone_to_depth(&_const_os__args, 1);
	} else {
		bool found = false;
		builtin__array_push((array*)&cargs, _MOV((string[]){ (*(string*)builtin__array_get(_const_os__args, 0)) }));
		Array_string _t3 = builtin__array_slice(_const_os__args, 1, 2147483647);
		for (int _t4 = 0; _t4 < _t3.len; ++_t4) {
			string a = ((string*)_t3.data)[_t4];
			if (builtin__string__eq(a, cut_word)) {
				found = true;
				continue;
			}
			if (!found) {
				continue;
			}
			builtin__array_push((array*)&cargs, _MOV((string[]){ builtin__string_clone(a) }));
		}
	}
	return cargs;
}
Array_string os__args_before(string cut_word) {
	if (_const_os__args.len == 0) {
		return builtin____new_array_with_default(0, 0, sizeof(string), 0);
	}
	Array_string cargs = builtin____new_array_with_default(0, 0, sizeof(string), 0);
	if (!(Array_string_contains(_const_os__args, cut_word))) {
		cargs = builtin__array_clone_to_depth(&_const_os__args, 1);
	} else {
		builtin__array_push((array*)&cargs, _MOV((string[]){ (*(string*)builtin__array_get(_const_os__args, 0)) }));
		Array_string _t3 = builtin__array_slice(_const_os__args, 1, 2147483647);
		for (int _t4 = 0; _t4 < _t3.len; ++_t4) {
			string a = ((string*)_t3.data)[_t4];
			if (builtin__string__eq(a, cut_word)) {
				break;
			}
			builtin__array_push((array*)&cargs, _MOV((string[]){ builtin__string_clone(a) }));
		}
	}
	return cargs;
}
_result_os__Command os__start_new_command(string cmd) {
	os__Command res = ((os__Command){.f = 0,.eof = 0,.exit_code = 0,.path = cmd,.redirect_stdout = 0,});
	_result_void _t1 = os__Command_start(&res);
	if (_t1.is_error) {
		_result_os__Command _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 ;
	_result_os__Command _t3;
	builtin___result_ok(&(os__Command[]) { res }, (_result*)(&_t3), sizeof(os__Command));
	 
	return _t3;
}
_result_void os__Command_start(os__Command* c) {
	string pcmd = builtin__string__plus(c->path, _S(" 2>&1"));
	c->f = os__vpopen(pcmd);
	if (builtin__isnil(c->f)) {
		_result_void _t1 = (_result_void){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("exec(\""), 0xfe10, {.d_s = c->path}}, {_S("\") failed"), 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
			{ // defer begin
				builtin__string_free(&pcmd);
			} // defer end
		return _t1;
	}
		{ // defer begin
			builtin__string_free(&pcmd);
		} // defer end
	return (_result_void){0};
}
string os__Command_read_line(os__Command* c) {
	Array_fixed_u8_4096 buf = {0};
	strings__Builder res = strings__new_builder(1024);
	{ // Unsafe block
		u8* bufbp = &buf[0];
		for (;;) {
			if (!(fgets(((char*)(bufbp)), 4096, c->f) != 0)) break;
			int len = builtin__vstrlen(bufbp);
			for (int i = 0; i < len; ++i) {
				if (bufbp[i] == '\n') {
					strings__Builder_write_ptr(&res, bufbp, i);
					string final = strings__Builder_str(&res);
					string _t1 = final;
						{ // defer begin
							strings__Builder_free(&res);
						} // defer end
					return _t1;
				}
			}
			strings__Builder_write_ptr(&res, bufbp, len);
		}
	}
	c->eof = true;
	string final = strings__Builder_str(&res);
	string _t2 = final;
		{ // defer begin
			strings__Builder_free(&res);
		} // defer end
	return _t2;
}
_result_void os__Command_close(os__Command* c) {
	c->exit_code = os__vpclose(c->f);
	c->f = ((void*)0);
	if (c->exit_code == 127) {
		return (_result_void){ .is_error=true, .err=builtin__error_with_code(_S("error"), 127), .data={E_STRUCT} };
	}
	return (_result_void){0};
}
bool os__debugger_present(void) {
	{
		int pid = os__fork();
		if (pid == 0) {
			int ppid = os__getppid();
			if (ptrace(PT_TRACE_ME, ppid, ((void*)0), 0) == 0) {
				waitpid(ppid, 0, 0);
				ptrace(PT_DETACH, ppid, 0, 0);
				builtin___v_exit(0);
				VUNREACHABLE();
			} else {
				builtin___v_exit(1);
				VUNREACHABLE();
			}
		} else {
			int status = 0;
			waitpid(pid, &status, 0);
			if (WEXITSTATUS(status) == 0) {
				return false;
			} else {
				return true;
			}
		}
	}
	return false;
}
string os__getenv(string key) {
	_option_string _t2 = os__getenv_opt(key);
	if (_t2.state != 0) {
		*(string*) _t2.data = _S("");
	}
	
 	return (*(string*)_t2.data);
}
_option_string os__getenv_opt(string key) {
	{ // Unsafe block
		#if defined(_WIN32)
		{
		}
		#else
		{
			char* s = getenv(((char*)(key.str)));
			if (s == ((void*)0)) {
				return (_option_string){ .state=2, .err=_const_none__, .data={E_STRUCT} };
			}
			_option_string _t3;
			builtin___option_ok(&(string[]) { builtin__cstring_to_vstring(s) }, (_option*)(&_t3), sizeof(string));
			 
			return _t3;
		}
		#endif
	}
	return (_option_string){.state=2, .err=_const_none__, .data={E_STRUCT}};
}
int os__setenv(string name, string value, bool overwrite) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		{ // Unsafe block
			return setenv(((char*)(name.str)), ((char*)(value.str)), overwrite);
		}
	}
	#endif
	return 0;
}
int os__unsetenv(string name) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		return unsetenv(((char*)(name.str)));
	}
	#endif
	return 0;
}
Map_string_string os__environ(void) {
	Map_string_string res = builtin__new_map(sizeof(string), sizeof(string), &builtin__map_hash_string, &builtin__map_eq_string, &builtin__map_clone_string, &builtin__map_free_string)
	;
	#if defined(_WIN32)
	{
	}
	#else
	{
		char** start = ((char**)(((voidptr)(environ))));
		int i = 0;
		for (;;) {
			char* x = start[i];
			if (x == 0) {
				break;
			}
			string eline = builtin__cstring_to_vstring(x);
			int eq_index = builtin__string_index_u8(eline, '=');
			if (eq_index > 0) {
				builtin__map_set(&res, &(string[]){builtin__string_substr(eline, 0, eq_index)}, &(string[]) { builtin__string_substr(eline, (int)(eq_index + 1), 2147483647) });
			}
			i++;
		}
	}
	#endif
	return res;
}
#if !defined(_WIN32)
#endif
int os__fd_close(int fd) {
	if (fd == -1) {
		return 0;
	}
	return close(fd);
}
void os__fd_write(int fd, string s) {
	if (fd == -1) {
		return;
	}
	u8* sp = s.str;
	int remaining = s.len;
	for (;;) {
		if (!(remaining > 0)) break;
		int written = ((int)(write(fd, sp, remaining)));
		if (written < 0) {
			return;
		}
		remaining = (int)(remaining - written);
		sp = ((voidptr)((usize)(((usize)(sp)) + ((usize)(written)))));
	}
}
Array_string os__fd_slurp(int fd) {
	Array_string res = builtin____new_array_with_default(0, 0, sizeof(string), 0);
	if (fd == -1) {
		return res;
	}
	for (;;) {
		multi_return_string_int mr_905 = os__fd_read(fd, 4096);
		string s = mr_905.arg0;
		int b = mr_905.arg1;
		if (b <= 0) {
			break;
		}
		builtin__array_push((array*)&res, _MOV((string[]){ builtin__string_clone(s) }));
	}
	return res;
}
multi_return_string_int os__fd_read(int fd, int maxbytes) {
	if (fd == -1) {
		return (multi_return_string_int){.arg0=_S(""), .arg1=0};
	}
	{ // Unsafe block
		u8* buf = builtin__malloc_noscan((int)(maxbytes + 1));
		int nbytes = ((int)(read(fd, buf, maxbytes)));
		if (nbytes < 0) {
			builtin___v_free(buf);
			return (multi_return_string_int){.arg0=_S(""), .arg1=nbytes};
		}
		buf[nbytes] = 0;
		return (multi_return_string_int){.arg0=builtin__tos(buf, nbytes), .arg1=nbytes};
	}
	return (multi_return_string_int){0};
}
bool os__fd_is_pending(int fd) {
	fd_set read_set = ((fd_set){E_STRUCT});
	FD_ZERO(&read_set);
	FD_SET(fd, &read_set);
	struct timeval ts = ((struct timeval){.tv_sec = 0,.tv_usec = 0,});
	i32 res = select((int)(fd + 1), &read_set, NULL, NULL, &ts);
	if (res > 0) {
		if (FD_ISSET(fd, &read_set) != 0) {
			return true;
		}
	}
	return false;
}
VV_LOC string os__NotExpected_msg(os__NotExpected err) {
	return err.cause;
}
VV_LOC int os__NotExpected_code(os__NotExpected err) {
	return err.code;
}
VV_LOC string os__fix_windows_path(string path) {
	string p = path;
	return p;
}
__NOINLINE _result_os__File os__open_file(string path, string mode, Array_int options) {
	int flags = 0;
	bool seek_to_end = false;
	for (int _t1 = 0; _t1 < mode.len; ++_t1) {
		u8 m = mode.str[_t1];

		if (m == ('w')) {
			flags |= ((_const_os__o_create | _const_os__o_trunc) | _const_os__o_wronly);
		}
		else if (m == ('a')) {
			flags |= ((_const_os__o_create | _const_os__o_append) | _const_os__o_wronly);
			seek_to_end = true;
		}
		else if (m == ('r')) {
			flags |= _const_os__o_rdonly;
		}
		else if (m == ('b')) {
			flags |= _const_os__o_binary;
		}
		else if (m == ('s')) {
			flags |= _const_os__o_sync;
		}
		else if (m == ('n')) {
			flags |= _const_os__o_nonblock;
		}
		else if (m == ('c')) {
			flags |= _const_os__o_noctty;
		}
		else if (m == ('+')) {
			flags &= ~_const_os__o_wronly;
			flags |= _const_os__o_rdwr;
		}
		else {
		}
	}
	if (_SLIT_EQ(mode.str, mode.len, "r+")) {
		flags = _const_os__o_rdwr;
	}
	int permission = 0666;
	if (options.len > 0) {
		permission = (*(int*)builtin__array_get(options, 0));
	}
	string p = os__fix_windows_path(path);
	i32 _t2;
	#if defined(_WIN32)
	#else
		_t2 = open(((char*)(p.str)), flags, permission);
		;
	#endif
		i32 fd = _t2;
	if (fd == -1) {
		return (_result_os__File){ .is_error=true, .err=builtin___v_error(os__posix_get_error_msg(errno)), .data={E_STRUCT} };
	}
	FILE* cfile = fdopen(fd, ((char*)(mode.str)));
	if (builtin__isnil(cfile)) {
		return (_result_os__File){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("Failed to open or create file \""), 0xfe10, {.d_s = path}}, {_S("\""), 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
	}
	os__File res = ((os__File){.cfile = (voidptr)cfile,.fd = fd,.is_opened = true,});
	if (seek_to_end) {
		_result_void _t5 = os__File_seek(&res, 0, os__SeekMode__end);
		(void)_t5;
 ;
	}
	_result_os__File _t6;
	builtin___result_ok(&(os__File[]) { res }, (_result*)(&_t6), sizeof(os__File));
	 
	return _t6;
}
_result_os__File os__open(string path) {
	_result_FILE_ptr _t1 = os__vfopen(path, _S("rb"));
	if (_t1.is_error) {
		_result_os__File _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 	FILE* cfile = (*(FILE**)_t1.data);
	int fd = os__fileno(cfile);
	_result_os__File _t3;
	builtin___result_ok(&(os__File[]) { ((os__File){.cfile = (voidptr)cfile,.fd = fd,.is_opened = true,}) }, (_result*)(&_t3), sizeof(os__File));
	 
	return _t3;
}
__NOINLINE _result_os__File os__create(string path) {
	_result_FILE_ptr _t1 = os__vfopen(path, _S("wb"));
	if (_t1.is_error) {
		_result_os__File _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 	FILE* cfile = (*(FILE**)_t1.data);
	int fd = os__fileno(cfile);
	_result_os__File _t3;
	builtin___result_ok(&(os__File[]) { ((os__File){.cfile = (voidptr)cfile,.fd = fd,.is_opened = true,}) }, (_result*)(&_t3), sizeof(os__File));
	 
	return _t3;
}
os__File os__stdin(void) {
	return ((os__File){.cfile = ((voidptr)(stdin)),.fd = 0,.is_opened = true,});
}
os__File os__stdout(void) {
	return ((os__File){.cfile = ((voidptr)(stdout)),.fd = 1,.is_opened = true,});
}
os__File os__stderr(void) {
	return ((os__File){.cfile = ((voidptr)(stderr)),.fd = 2,.is_opened = true,});
}
bool os__File_eof(os__File* f) {
	FILE* cfile = ((FILE*)(f->cfile));
	return feof(cfile) != 0;
}
_result_void os__File_reopen(os__File* f, string path, string mode) {
	string p = os__fix_windows_path(path);
	FILE* cfile = ((FILE*)(((void*)0)));
	#if defined(_WIN32)
	{
	}
	#else
	{
		cfile = freopen(((char*)(p.str)), ((char*)(mode.str)), f->cfile);
	}
	#endif
	if (builtin__isnil(cfile)) {
		return (_result_void){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("Failed to reopen file \""), 0xfe10, {.d_s = path}}, {_S("\""), 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
	}
	f->cfile = cfile;
	return (_result_void){0};
}
_result_int os__File_read(os__File* f, Array_u8* buf) {
	if (!f->is_opened) {
		return (_result_int){ .is_error=true, .err=os__error_file_not_opened(), .data={E_STRUCT} };
	}
	if (buf->len == 0) {
		return (_result_int){ .is_error=true, .err=I_os__Eof_to_Interface_IError(((os__Eof*)builtin__memdup(&(os__Eof){.Error = ((Error){E_STRUCT}),}, sizeof(os__Eof)))), .data={E_STRUCT} };
	}
	int nbytes = ((int)(fread(buf->data, 1, buf->len, ((FILE*)(f->cfile)))));
	if (nbytes <= 0) {
		if (feof(((FILE*)(f->cfile))) != 0) {
			return (_result_int){ .is_error=true, .err=I_os__Eof_to_Interface_IError(((os__Eof*)builtin__memdup(&(os__Eof){.Error = ((Error){E_STRUCT}),}, sizeof(os__Eof)))), .data={E_STRUCT} };
		}
		if (ferror(((FILE*)(f->cfile))) != 0) {
			return (_result_int){ .is_error=true, .err=I_os__NotExpected_to_Interface_IError(((os__NotExpected*)builtin__memdup(&(os__NotExpected){.cause = _S("unexpected error from fread"),.code = -1,}, sizeof(os__NotExpected)))), .data={E_STRUCT} };
		}
	}
	_result_int _t5;
	builtin___result_ok(&(int[]) { nbytes }, (_result*)(&_t5), sizeof(int));
	 
	return _t5;
}
_result_int os__File_write(os__File* f, Array_u8 buf) {
	if (!f->is_opened) {
		return (_result_int){ .is_error=true, .err=os__error_file_not_opened(), .data={E_STRUCT} };
	}
	int written = ((int)(fwrite(buf.data, 1, buf.len, f->cfile)));
	if (written == 0 && buf.len != 0) {
		return (_result_int){ .is_error=true, .err=builtin___v_error(_S("0 bytes written")), .data={E_STRUCT} };
	}
	_result_int _t3;
	builtin___result_ok(&(int[]) { written }, (_result*)(&_t3), sizeof(int));
	 
	return _t3;
}
_result_int os__File_writeln(os__File* f, string s) {
	if (!f->is_opened) {
		return (_result_int){ .is_error=true, .err=os__error_file_not_opened(), .data={E_STRUCT} };
	}
	_result_int _t2 = os__File_write_string(f, s);
	if (_t2.is_error) {
		_result_int _t3 = {0};
		_t3.is_error = true;
		_t3.err = _t2.err;
		return _t3;
	}
	
 	int written = (*(int*)_t2.data);
	i32 x = fputs("\n", f->cfile);
	if (x < 0) {
		return (_result_int){ .is_error=true, .err=builtin___v_error(_S("could not add newline")), .data={E_STRUCT} };
	}
	_result_int _t5;
	builtin___result_ok(&(int[]) { (int)(written + 1) }, (_result*)(&_t5), sizeof(int));
	 
	return _t5;
}
_result_int os__File_write_string(os__File* f, string s) {
		_result_void _t1 = os__File_write_full_buffer(f, s.str, ((usize)(s.len)));
	if (_t1.is_error) {
		_result_int _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 ;
	_result_int _t3;
	builtin___result_ok(&(int[]) { s.len }, (_result*)(&_t3), sizeof(int));
	 
	return _t3;
}
_result_int os__File_write_to(os__File* f, u64 pos, Array_u8 buf) {
	if (!f->is_opened) {
		return (_result_int){ .is_error=true, .err=os__error_file_not_opened(), .data={E_STRUCT} };
	}
	_result_void _t2 = os__File_seek(f, pos, os__SeekMode__start);
	(void)_t2;
 ;
	int res = ((int)(fwrite(buf.data, 1, buf.len, f->cfile)));
	if (res == 0 && buf.len != 0) {
		return (_result_int){ .is_error=true, .err=builtin___v_error(_S("0 bytes written")), .data={E_STRUCT} };
	}
	_result_void _t4 = os__File_seek(f, 0, os__SeekMode__end);
	(void)_t4;
 ;
	_result_int _t5;
	builtin___result_ok(&(int[]) { res }, (_result*)(&_t5), sizeof(int));
	 
	return _t5;
}
int os__File_write_ptr(os__File* f, voidptr data, int size) {
	return ((int)(fwrite(data, 1, size, f->cfile)));
}
_result_void os__File_write_full_buffer(os__File* f, voidptr buffer, usize buffer_len) {
	if (buffer_len <= ((usize)(0))) {
		return (_result_void){0};
	}
	if (!f->is_opened) {
		return (_result_void){ .is_error=true, .err=os__error_file_not_opened(), .data={E_STRUCT} };
	}
	u8* ptr = ((u8*)(buffer));
	i64 remaining_bytes = ((i64)(buffer_len));
	for (;;) {
		if (!(remaining_bytes > 0)) break;
		{ // Unsafe block
			errno = 0;
			i64 x = ((i64)(fwrite(ptr, 1, remaining_bytes, f->cfile)));
			int cerror = ((int)(errno));
			ptr += x;
			remaining_bytes -= x;
			if (cerror != 0) {
				if (cerror == EINTR) {
					continue;
				}
				if (((i64)(x)) != ((i64)(buffer_len))) {
					return (_result_void){ .is_error=true, .err=builtin___v_error(os__posix_get_error_msg(cerror)), .data={E_STRUCT} };
				}
			}
			if (x <= 0) {
				return (_result_void){ .is_error=true, .err=builtin___v_error(_S("C.fwrite returned 0")), .data={E_STRUCT} };
			}
		}
	}
	return (_result_void){0};
}
int os__File_write_ptr_at(os__File* f, voidptr data, int size, u64 pos) {
	_result_void _t1 = os__File_seek(f, pos, os__SeekMode__start);
	(void)_t1;
 ;
	int res = ((int)(fwrite(data, 1, size, f->cfile)));
	_result_void _t2 = os__File_seek(f, 0, os__SeekMode__end);
	(void)_t2;
 ;
	return res;
}
VV_LOC _result_int os__fread(voidptr ptr, int item_size, int items, FILE* stream) {
	int nbytes = ((int)(fread(ptr, item_size, items, stream)));
	if (nbytes <= 0) {
		if (feof(stream) != 0) {
			return (_result_int){ .is_error=true, .err=I_os__Eof_to_Interface_IError(((os__Eof*)builtin__memdup(&(os__Eof){.Error = ((Error){E_STRUCT}),}, sizeof(os__Eof)))), .data={E_STRUCT} };
		}
		if (ferror(stream) != 0) {
			return (_result_int){ .is_error=true, .err=builtin___v_error(_S("file read error")), .data={E_STRUCT} };
		}
	}
	_result_int _t3;
	builtin___result_ok(&(int[]) { nbytes }, (_result*)(&_t3), sizeof(int));
	 
	return _t3;
}
Array_u8 os__File_read_bytes(os__File* f, int size) {
	return os__File_read_bytes_at(f, size, 0);
}
Array_u8 os__File_read_bytes_at(os__File* f, int size, u64 pos) {
	Array_u8 arr = builtin____new_array_with_default(size, 0, sizeof(u8), 0);
	_result_int _t1 = os__File_read_bytes_into(f, pos, &arr);
	if (_t1.is_error) {
		return builtin____new_array_with_default(0, 0, sizeof(u8), 0);
	}
	
 	int nreadbytes = (*(int*)_t1.data);
	return builtin__array_slice(arr, 0, nreadbytes);
}
_result_int os__File_read_bytes_with_newline(os__File* f, Array_u8* buf) {
	if (!f->is_opened) {
		return (_result_int){ .is_error=true, .err=os__error_file_not_opened(), .data={E_STRUCT} };
	}
	if (buf->len == 0) {
		return (_result_int){ .is_error=true, .err=builtin___v_error(builtin__string__plus(_S("read_bytes_with_newline"), _S(": `buf.len` == 0"))), .data={E_STRUCT} };
	}
	int newline = 10;
	int c = 0;
	int buf_ptr = 0;
	int nbytes = 0;
	FILE* stream = ((FILE*)(f->cfile));
	for (;;) {
		if (!((buf_ptr < buf->len))) break;
		c = getc(stream);

		if (c == (EOF)) {
			if (feof(stream) != 0) {
				_result_int _t3;
				builtin___result_ok(&(int[]) { nbytes }, (_result*)(&_t3), sizeof(int));
				 
				return _t3;
			}
			if (ferror(stream) != 0) {
				return (_result_int){ .is_error=true, .err=builtin___v_error(_S("file read error")), .data={E_STRUCT} };
			}
		}
		else if (c == (newline)) {
			builtin__array_set(buf, buf_ptr, &(u8[]) { ((u8)(c)) });
			nbytes++;
			_result_int _t5;
			builtin___result_ok(&(int[]) { nbytes }, (_result*)(&_t5), sizeof(int));
			 
			return _t5;
		}
		else {
			builtin__array_set(buf, buf_ptr, &(u8[]) { ((u8)(c)) });
			buf_ptr++;
			nbytes++;
		}
	}
	_result_int _t6;
	builtin___result_ok(&(int[]) { nbytes }, (_result*)(&_t6), sizeof(int));
	 
	return _t6;
}
_result_int os__File_read_bytes_into(os__File* f, u64 pos, Array_u8* buf) {
	if (!f->is_opened) {
		return (_result_int){ .is_error=true, .err=os__error_file_not_opened(), .data={E_STRUCT} };
	}
	if (buf->len == 0) {
		return (_result_int){ .is_error=true, .err=builtin___v_error(builtin__string__plus(_S("read_bytes_into"), _S(": `buf.len` == 0"))), .data={E_STRUCT} };
	}
		_result_void _t3 = os__File_seek(f, pos, os__SeekMode__start);
	(void)_t3;
 ;
	_result_int _t4 = os__fread(buf->data, 1, buf->len, f->cfile);
	if (_t4.is_error) {
		_result_int _t5 = {0};
		_t5.is_error = true;
		_t5.err = _t4.err;
		return _t5;
	}
	
 	int nbytes = (*(int*)_t4.data);
	_result_int _t6;
	builtin___result_ok(&(int[]) { nbytes }, (_result*)(&_t6), sizeof(int));
	 
	return _t6;
}
_result_int os__File_read_from(os__File* f, u64 pos, Array_u8* buf) {
	if (!f->is_opened) {
		return (_result_int){ .is_error=true, .err=os__error_file_not_opened(), .data={E_STRUCT} };
	}
	if (buf->len == 0) {
		_result_int _t2;
		builtin___result_ok(&(int[]) { 0 }, (_result*)(&_t2), sizeof(int));
		 
		return _t2;
	}
		_result_void _t3 = os__File_seek(f, pos, os__SeekMode__start);
	(void)_t3;
 ;
	_result_int _t4 = os__fread(buf->data, 1, buf->len, f->cfile);
	if (_t4.is_error) {
		_result_int _t5 = {0};
		_t5.is_error = true;
		_t5.err = _t4.err;
		return _t5;
	}
	
 	int nbytes = (*(int*)_t4.data);
	_result_int _t6;
	builtin___result_ok(&(int[]) { nbytes }, (_result*)(&_t6), sizeof(int));
	 
	return _t6;
}
_result_int os__File_read_into_ptr(os__File* f, u8* ptr, int max_size) {
	if (!f->is_opened) {
		return (_result_int){ .is_error=true, .err=os__error_file_not_opened(), .data={E_STRUCT} };
	}
	return os__fread(ptr, 1, max_size, f->cfile);
}
void os__File_flush(os__File* f) {
	if (!f->is_opened) {
		return;
	}
	fflush(f->cfile);
}
string os__FileNotOpenedError_msg(os__FileNotOpenedError err) {
	return _S("os: file not opened");
}
string os__SizeOfTypeIs0Error_msg(os__SizeOfTypeIs0Error err) {
	return _S("os: size of type is 0");
}
VV_LOC IError os__error_file_not_opened(void) {
	return I_os__FileNotOpenedError_to_Interface_IError(((os__FileNotOpenedError*)builtin__memdup(&(os__FileNotOpenedError){.Error = ((Error){E_STRUCT}),}, sizeof(os__FileNotOpenedError))));
}
_result_void os__File_seek(os__File* f, i64 pos, os__SeekMode mode) {
	if (!f->is_opened) {
		return (_result_void){ .is_error=true, .err=os__error_file_not_opened(), .data={E_STRUCT} };
	}
	int whence = ((int)(mode));
	int res = 0;
	#if defined(TARGET_IS_64BIT)
	{
		#if defined(_WIN32)
		{
		}
		#else
		{
			res = fseeko(f->cfile, pos, whence);
		}
		#endif
	}
	#endif
	if (res == -1) {
		return (_result_void){ .is_error=true, .err=builtin___v_error(os__posix_get_error_msg(errno)), .data={E_STRUCT} };
	}
	return (_result_void){0};
}
_result_i64 os__File_tell(os__File* f) {
	if (!f->is_opened) {
		return (_result_i64){ .is_error=true, .err=os__error_file_not_opened(), .data={E_STRUCT} };
	}
	i64 pos = ((i64)(0));
	int ret = 0;
	#if defined(_WIN32)
	{
	}
	#else
	{
		pos = ((i64)(ftell(f->cfile)));
	}
	#endif
	if (ret == -1 || pos == -1) {
		return (_result_i64){ .is_error=true, .err=builtin___v_error(os__posix_get_error_msg(errno)), .data={E_STRUCT} };
	}
	_result_i64 _t4;
	builtin___result_ok(&(i64[]) { pos }, (_result*)(&_t4), sizeof(i64));
	 
	return _t4;
}
int os__File_setvbuf(os__File* f, char* buffer, os__FileBufferMode mode, usize size) {
	return setvbuf(f->cfile, buffer, ((int)(mode)), size);
}
int os__File_set_buffer(os__File* f, Array_u8* buffer, os__FileBufferMode mode) {
	return os__File_setvbuf(f, ((char*)(buffer->data)), mode, ((usize)(buffer->len)));
}
void os__File_set_line_buffered(os__File* f) {
	os__File_setvbuf(f, ((char*)(((void*)0))), os__FileBufferMode__line_buffered, ((usize)(0)));
}
void os__File_set_unbuffered(os__File* f) {
	os__File_setvbuf(f, ((char*)(((void*)0))), os__FileBufferMode__not_buffered, ((usize)(0)));
}
_result_void os__File_write_u8(os__File* f, u8 b) {
	errno = 0;
	_result_void _t1 = os__check_fwrite(fwrite(((voidptr)(&b)), 1, 1, f->cfile));
	if (_t1.is_error) {
		_result_void _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 ;
	return (_result_void){0};
}
_result_u8 os__File_read_u8(os__File* f) {
	u8 res = ((u8)(0));
	errno = 0;
	_result_void _t1 = os__check_fread(fread(((voidptr)(&res)), 1, 1, f->cfile));
	if (_t1.is_error) {
		_result_u8 _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 ;
	_result_u8 _t3;
	builtin___result_ok(&(u8[]) { res }, (_result*)(&_t3), sizeof(u8));
	 
	return _t3;
}
VV_LOC _result_void os__check_cf(usize x, string label) {
	if (errno != 0) {
		return (_result_void){ .is_error=true, .err=builtin___v_error(os__posix_get_error_msg(errno)), .data={E_STRUCT} };
	}
	if (x == 0) {
		return (_result_void){ .is_error=true, .err=builtin___v_error(label), .data={E_STRUCT} };
	}
	return (_result_void){0};
}
VV_LOC _result_void os__check_fwrite(usize x) {
	_result_void _t1 = os__check_cf(x, _S("fwrite"));
	if (_t1.is_error) {
		_result_void _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 ;
	return (_result_void){0};
}
VV_LOC _result_void os__check_fread(usize x) {
	_result_void _t1 = os__check_cf(x, _S("fread"));
	if (_t1.is_error) {
		_result_void _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 ;
	return (_result_void){0};
}
bool os__is_abs_path(string path) {
	if ((path).len == 0) {
		return false;
	}
	return builtin__string_at(path, 0) == _const_os__fslash;
}
string os__abs_path(string path) {
	string wd = os__getwd();
	if ((path).len == 0) {
		return wd;
	}
	string npath = os__norm_path(path);
	if (_SLIT_EQ(npath.str, npath.len, ".")) {
		return wd;
	}
	if (!os__is_abs_path(npath)) {
		strings__Builder sb = strings__new_builder(npath.len);
		strings__Builder_write_string(&sb, wd);
		strings__Builder_write_string(&sb, _const_os__path_separator);
		strings__Builder_write_string(&sb, npath);
		return os__norm_path(strings__Builder_str(&sb));
	}
	return npath;
}
string os__norm_path(string path) {
	if ((path).len == 0) {
		return _const_os__dot_str;
	}
	bool rooted = os__is_abs_path(path);
	int volume_len = os__win_volume_len(path);
	string volume = builtin__string_substr(path, 0, volume_len);
	if (volume_len != 0 && builtin__string_contains(volume, _const_os__fslash_str)) {
		volume = builtin__string_replace(volume, _const_os__fslash_str, _const_os__path_separator);
	}
	string cpath = os__clean_path(builtin__string_substr(path, volume_len, 2147483647));
	if ((cpath).len == 0 && volume_len == 0) {
		return _const_os__dot_str;
	}
	Array_string spath = builtin__string_split(cpath, _const_os__path_separator);
	if (!(Array_string_contains(spath, _S("..")))) {
		return (volume_len != 0 ? (builtin__string__plus(volume, cpath)) : (cpath));
	}
	int spath_len = spath.len;
	strings__Builder sb = strings__new_builder(cpath.len);
	if (rooted) {
		strings__Builder_write_string(&sb, _const_os__path_separator);
	}
	Array_string new_path = builtin____new_array_with_default(0, spath_len, sizeof(string), 0);
	int backlink_count = 0;
	for (int i = (int)(spath_len - 1); i >= 0; i--) {
		string part = ((string*)spath.data)[i];
		if ((part).len == 0) {
			continue;
		}
		if (_SLIT_EQ(part.str, part.len, "..")) {
			backlink_count++;
			continue;
		}
		if (backlink_count != 0) {
			backlink_count--;
			continue;
		}
		builtin__array_prepend(&new_path, &(string[]){part});
	}
	if (backlink_count != 0 && !rooted) {
		for (int i = 0; i < backlink_count; ++i) {
			strings__Builder_write_string(&sb, _const_os__dot_dot);
			if (new_path.len == 0 && i == (int)(backlink_count - 1)) {
				break;
			}
			strings__Builder_write_string(&sb, _const_os__path_separator);
		}
	}
	strings__Builder_write_string(&sb, Array_string_join(new_path, _const_os__path_separator));
	string res = strings__Builder_str(&sb);
	if (res.len == 0) {
		if (volume_len != 0) {
			return volume;
		}
		if (!rooted) {
			return _const_os__dot_str;
		}
		return _const_os__path_separator;
	}
	if (volume_len != 0) {
		return builtin__string__plus(volume, res);
	}
	return res;
}
_result_string os__existing_path(string path) {
	IError err = builtin___v_error(_S("path does not exist"));
	if ((path).len == 0) {
		return (_result_string){ .is_error=true, .err=err, .data={E_STRUCT} };
	}
	if (os__exists(path)) {
		_result_string _t2;
		builtin___result_ok(&(string[]) { path }, (_result*)(&_t2), sizeof(string));
		 
		return _t2;
	}
	int volume_len = 0;
	if (volume_len > 0 && os__is_slash(builtin__string_at(path, (int)(volume_len - 1)))) {
		volume_len++;
	}
	strings__textscanner__TextScanner sc = strings__textscanner__new(builtin__string_substr(path, volume_len, 2147483647));
	string recent_path = builtin__string_substr(path, 0, volume_len);
	for (;;) {
		if (!(strings__textscanner__TextScanner_next(&sc) != -1)) break;
		u8 curr = ((u8)(strings__textscanner__TextScanner_current(&sc)));
		int peek = strings__textscanner__TextScanner_peek(&sc);
		int back = strings__textscanner__TextScanner_peek_back(&sc);
		if (os__is_curr_dir_ref(back, curr, peek)) {
			continue;
		}
		int range = (int)((int)(sc.ilen - strings__textscanner__TextScanner_remaining(&sc)) + volume_len);
		if (os__is_slash(curr) && !os__is_slash(((u8)(peek)))) {
			recent_path = builtin__string_substr(path, 0, range);
			continue;
		}
		if (!os__is_slash(curr) && (peek == -1 || os__is_slash(((u8)(peek))))) {
			string curr_path = builtin__string_substr(path, 0, range);
			if (os__exists(curr_path)) {
				recent_path = curr_path;
				continue;
			}
			if ((recent_path).len == 0) {
				break;
			}
			_result_string _t3;
			builtin___result_ok(&(string[]) { recent_path }, (_result*)(&_t3), sizeof(string));
			 
			return _t3;
		}
	}
	return (_result_string){ .is_error=true, .err=err, .data={E_STRUCT} };
}
VV_LOC string os__clean_path(string path) {
	if ((path).len == 0) {
		return _const_os__empty_str;
	}
	strings__Builder sb = strings__new_builder(path.len);
	strings__textscanner__TextScanner sc = strings__textscanner__new(path);
	for (;;) {
		if (!(strings__textscanner__TextScanner_next(&sc) != -1)) break;
		u8 curr = ((u8)(strings__textscanner__TextScanner_current(&sc)));
		int back = strings__textscanner__TextScanner_peek_back(&sc);
		int peek = strings__textscanner__TextScanner_peek(&sc);
		if (back != -1 && os__is_slash(((u8)(back))) && os__is_slash(curr)) {
			continue;
		}
		if (os__is_curr_dir_ref(back, curr, peek)) {
			if (peek != -1 && os__is_slash(((u8)(peek)))) {
				strings__textscanner__TextScanner_skip_n(&sc, 1);
			}
			continue;
		}
		strings__Builder_write_u8(&sb, ((u8)(strings__textscanner__TextScanner_current(&sc))));
	}
	string res = strings__Builder_str(&sb);
	if (res.len > 1 && os__is_slash(builtin__string_at(res, (int)(res.len - 1)))) {
		return builtin__string_substr(res, 0, (int)(res.len - 1));
	}
	return res;
}
string os__to_slash(string path) {
	string _t2;
	#if defined(_WIN32)
	#else
		_t2 = path;
		;
	#endif
		return _t2;
}
string os__from_slash(string path) {
	string _t2;
	#if defined(_WIN32)
	#else
		_t2 = path;
		;
	#endif
		return _t2;
}
VV_LOC int os__win_volume_len(string path) {
	#if !defined(_WIN32)
	{
		return 0;
	}
	#endif
	int plen = path.len;
	if (plen < 2) {
		return 0;
	}
	if (os__has_drive_letter(path)) {
		return 2;
	}
	if (plen >= 5 && os__starts_w_slash_slash(path) && !os__is_slash(builtin__string_at(path, 2))) {
		for (int i = 3; i < plen; i++) {
			if (os__is_slash(builtin__string_at(path, i))) {
				if ((int)(i + 1) >= plen || os__is_slash(builtin__string_at(path, (int)(i + 1)))) {
					break;
				}
				i++;
				for (; i < plen; i++) {
					if (os__is_slash(builtin__string_at(path, i))) {
						return i;
					}
				}
				return i;
			}
		}
	}
	return 0;
}
VV_LOC bool os__is_slash(u8 b) {
	return b == _const_os__fslash;
}
VV_LOC bool os__has_drive_letter(string path) {
	return path.len >= 2 && builtin__u8_is_letter(builtin__string_at(path, 0)) && builtin__string_at(path, 1) == ':';
}
VV_LOC bool os__starts_w_slash_slash(string path) {
	return path.len >= 2 && os__is_slash(builtin__string_at(path, 0)) && os__is_slash(builtin__string_at(path, 1));
}
VV_LOC bool os__is_curr_dir_ref(int byte_one, int byte_two, int byte_three) {
	if (((u8)(byte_two)) != _const_os__dot) {
		return false;
	}
	return (byte_one < 0 || os__is_slash(((u8)(byte_one)))) && (byte_three < 0 || os__is_slash(((u8)(byte_three))));
}
u32 os__FilePermission_bitmask(os__FilePermission p) {
	u32 mask = ((u32)(0));
	if (p.read) {
		mask |= 4;
	}
	if (p.write) {
		mask |= 2;
	}
	if (p.execute) {
		mask |= 1;
	}
	return mask;
}
u32 os__FileMode_bitmask(os__FileMode m) {
	return (((os__FilePermission_bitmask(m.owner) << 6) | (os__FilePermission_bitmask(m.group) << 3)) | os__FilePermission_bitmask(m.others));
}
os__FileInfo os__inode(string path) {
	_result_os__Stat _t1 = os__lstat(path);
	if (_t1.is_error) {
		*(os__Stat*) _t1.data = ((os__Stat){.dev = 0,.inode = 0,.mode = 0,.nlink = 0,.uid = 0,.gid = 0,.rdev = 0,.size = 0,.atime = 0,.mtime = 0,.ctime = 0,});
	}
	
 	os__Stat attr = (*(os__Stat*)_t1.data);
	os__FileMode fm = os__Stat_get_mode(attr);
	return ((os__FileInfo){
		.FileMode = ((os__FileMode){.typ = fm.typ,.owner = fm.owner,.group = fm.group,.others = fm.others,}),
		.size = attr.size,
		.mtime = attr.mtime,
	});
}
_result_Array_u8 os__read_bytes(string path) {
	_result_FILE_ptr _t1 = os__vfopen(path, _S("rb"));
	if (_t1.is_error) {
		_result_Array_u8 _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 	FILE* fp = (*(FILE**)_t1.data);
	_result_int _t3 = os__find_cfile_size(fp);
	if (_t3.is_error) {
		{ // defer begin
			fclose(fp);
		} // defer end
		_result_Array_u8 _t4 = {0};
		_t4.is_error = true;
		_t4.err = _t3.err;
		return _t4;
	}
	
 	int fsize = (*(int*)_t3.data);
	if (fsize == 0) {
		_result_strings__Builder _t5 = os__slurp_file_in_builder(fp);
		if (_t5.is_error) {
			{ // defer begin
				fclose(fp);
			} // defer end
			_result_Array_u8 _t6 = {0};
			_t6.is_error = true;
			_t6.err = _t5.err;
			return _t6;
		}
		
 		strings__Builder sb = (*(strings__Builder*)_t5.data);
		_result_Array_u8 _t7;
		builtin___result_ok(&(Array_u8[]) { strings__Builder_reuse_as_plain_u8_array(&sb) }, (_result*)(&_t7), sizeof(Array_u8));
		 
			{ // defer begin
				fclose(fp);
			} // defer end
		return _t7;
	}
	Array_u8 res = builtin____new_array_with_default(fsize, 0, sizeof(u8), 0);
	int nr_read_elements = ((int)(fread(res.data, 1, fsize, fp)));
	if (nr_read_elements == 0 && fsize > 0) {
		_result_Array_u8 _t8 = (_result_Array_u8){ .is_error=true, .err=builtin___v_error(_S("fread failed")), .data={E_STRUCT} };
			{ // defer begin
				fclose(fp);
			} // defer end
		return _t8;
	}
	builtin__array_trim(&res, nr_read_elements);
	_result_Array_u8 _t9;
	builtin___result_ok(&(Array_u8[]) { res }, (_result*)(&_t9), sizeof(Array_u8));
	 
		{ // defer begin
			fclose(fp);
		} // defer end
	return _t9;
}
_result_void os__write_bytes(string path, Array_u8 bytes) {
	_result_void _t1 = os__write_file_array(path, bytes);
	if (_t1.is_error) {
		_result_void _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 ;
	return (_result_void){0};
}
VV_LOC _result_int os__find_cfile_size(FILE* fp) {
	i32 cseek = fseek(fp, 0, SEEK_END);
	isize raw_fsize = ftell(fp);
	if (raw_fsize != 0 && cseek != 0) {
		return (_result_int){ .is_error=true, .err=builtin___v_error(_S("fseek failed")), .data={E_STRUCT} };
	}
	if (cseek != 0 && raw_fsize < 0) {
		return (_result_int){ .is_error=true, .err=builtin___v_error(_S("ftell failed")), .data={E_STRUCT} };
	}
	int len = ((int)(raw_fsize));
	if (((i64)(len)) < raw_fsize) {
		return (_result_int){ .is_error=true, .err=builtin___v_error(builtin__str_intp(3, _MOV((StrIntpData[]){{_S("int("), 0xfe09, {.d_i64 = raw_fsize}}, {_S(") cast results in "), 0xfe07, {.d_i32 = len}}, {_SLIT0, 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
	}
	rewind(fp);
	_result_int _t4;
	builtin___result_ok(&(int[]) { len }, (_result*)(&_t4), sizeof(int));
	 
	return _t4;
}
VV_LOC _result_strings__Builder os__slurp_file_in_builder(FILE* fp) {
	Array_fixed_u8_4096 buf = {0};
	strings__Builder sb = strings__new_builder(_const_os__buf_size);
	for (;;) {
		_result_int _t1 = os__fread(&buf[0], 1, _const_os__buf_size, fp);
		if (_t1.is_error) {
			IError err = _t1.err;
			if ((err)._typ == _IError_os__Eof_index) {
				break;
			}
			strings__Builder_free(&sb);
			return (_result_strings__Builder){ .is_error=true, .err=err, .data={E_STRUCT} };
		}
		
 		int read_bytes = (*(int*)_t1.data);
		strings__Builder_write_ptr(&sb, &buf[0], read_bytes);
	}
	_result_strings__Builder _t3;
	builtin___result_ok(&(strings__Builder[]) { sb }, (_result*)(&_t3), sizeof(strings__Builder));
	 
	return _t3;
}
_result_string os__read_file(string path) {
	string mode = _S("rb");
	_result_FILE_ptr _t1 = os__vfopen(path, mode);
	if (_t1.is_error) {
		_result_string _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 	FILE* fp = (*(FILE**)_t1.data);
	_result_int _t3 = os__find_cfile_size(fp);
	if (_t3.is_error) {
		{ // defer begin
			fclose(fp);
		} // defer end
		_result_string _t4 = {0};
		_t4.is_error = true;
		_t4.err = _t3.err;
		return _t4;
	}
	
 	int allocate = (*(int*)_t3.data);
	if (allocate == 0) {
		_result_strings__Builder _t5 = os__slurp_file_in_builder(fp);
		if (_t5.is_error) {
			{ // defer begin
				fclose(fp);
			} // defer end
			_result_string _t6 = {0};
			_t6.is_error = true;
			_t6.err = _t5.err;
			return _t6;
		}
		
 		strings__Builder sb = (*(strings__Builder*)_t5.data);
		string res = strings__Builder_str(&sb);
		strings__Builder_free(&sb);
		_result_string _t7;
		builtin___result_ok(&(string[]) { res }, (_result*)(&_t7), sizeof(string));
		 
			{ // defer begin
				fclose(fp);
			} // defer end
		return _t7;
	}
	{ // Unsafe block
		u8* str = builtin__malloc_noscan((int)(allocate + 1));
		int nelements = ((int)(fread(str, 1, allocate, fp)));
		int is_eof = ((int)(feof(fp)));
		int is_error = ((int)(ferror(fp)));
		if (is_eof == 0 && is_error != 0) {
			builtin___v_free(str);
			_result_string _t8 = (_result_string){ .is_error=true, .err=builtin___v_error(_S("fread failed")), .data={E_STRUCT} };
				{ // defer begin
					fclose(fp);
				} // defer end
			return _t8;
		}
		str[nelements] = 0;
		if (nelements == 0) {
			_result_string _t9;
			builtin___result_ok(&(string[]) { builtin__u8_vstring(str) }, (_result*)(&_t9), sizeof(string));
			 
				{ // defer begin
					fclose(fp);
				} // defer end
			return _t9;
		}
		_result_string _t10;
		builtin___result_ok(&(string[]) { builtin__u8_vstring_with_len(str, nelements) }, (_result*)(&_t10), sizeof(string));
		 
			{ // defer begin
				fclose(fp);
			} // defer end
		return _t10;
	}
	return (_result_string){0};
}
_result_void os__truncate(string path, u64 len) {
	i32 _t1;
	#if defined(_WIN32)
	#else
		_t1 = open(((char*)(path.str)), (_const_os__o_wronly | _const_os__o_trunc), 0);
		;
	#endif
		i32 fp = _t1;
	if (fp < 0) {
		return (_result_void){ .is_error=true, .err=os__error_posix(((os__SystemError){.msg = (string){.str=(byteptr)"", .is_lit=1},.code = _const_os__error_code_not_set,})), .data={E_STRUCT} };
	}
	#if defined(_WIN32)
	{
	}
	#else
	{
		if (ftruncate(fp, len) != 0) {
			_result_void _t4 = (_result_void){ .is_error=true, .err=os__error_posix(((os__SystemError){.msg = (string){.str=(byteptr)"", .is_lit=1},.code = _const_os__error_code_not_set,})), .data={E_STRUCT} };
				{ // defer begin
					close(fp);
				} // defer end
			return _t4;
		}
	}
	#endif
		{ // defer begin
			close(fp);
		} // defer end
	return (_result_void){0};
}
u64 os__file_size(string path) {
	_result_os__Stat _t1 = os__stat(path);
	if (_t1.is_error) {
		builtin__eprintln(builtin__string__plus(_S("os.file_size() Cannot determine file-size: "), os__posix_get_error_msg(errno)));
		return 0;
	}
	
 	os__Stat attr = (*(os__Stat*)_t1.data);
	return attr.size;
}
_result_void os__rename_dir(string src, string dst) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		i32 ret = rename(((char*)(src.str)), ((char*)(dst.str)));
		if (ret != 0) {
			return (_result_void){ .is_error=true, .err=builtin__error_with_code(builtin__str_intp(3, _MOV((StrIntpData[]){{_S("failed to rename "), 0xfe10, {.d_s = src}}, {_S(" to "), 0xfe10, {.d_s = dst}}, {_SLIT0, 0, { .d_c = 0 }}})), ret), .data={E_STRUCT} };
		}
	}
	#endif
	return (_result_void){0};
}
_result_void os__rename(string src, string dst) {
	string rdst = dst;
	if (os__is_dir(rdst)) {
		rdst = os__join_path_single(builtin__string_trim_right(rdst, _const_os__path_separator), os__file_name(builtin__string_trim_right(src, _const_os__path_separator)));
	}
	#if defined(_WIN32)
	{
	}
	#else
	{
		i32 ret = rename(((char*)(src.str)), ((char*)(rdst.str)));
		if (ret != 0) {
			return (_result_void){ .is_error=true, .err=builtin__error_with_code(builtin__str_intp(3, _MOV((StrIntpData[]){{_S("failed to rename "), 0xfe10, {.d_s = src}}, {_S(" to "), 0xfe10, {.d_s = dst}}, {_SLIT0, 0, { .d_c = 0 }}})), ret), .data={E_STRUCT} };
		}
	}
	#endif
	return (_result_void){0};
}
_result_void os__cp(string src, string dst, os__CopyParams config) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		string w_dst = dst;
		if (os__is_dir(dst)) {
			w_dst = os__join_path_single(w_dst, os__file_name(src));
		}
		i32 fp_from = open(((char*)(src.str)), O_RDONLY, 0);
		if (fp_from < 0) {
			return (_result_void){ .is_error=true, .err=builtin__error_with_code(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("cp: failed to open "), 0xfe10, {.d_s = src}}, {_S(" for reading"), 0, { .d_c = 0 }}})), ((int)(fp_from))), .data={E_STRUCT} };
		}
		int mode_flags = (S_IWUSR | S_IRUSR);
		int open_flags = ((O_WRONLY | O_CREAT) | O_TRUNC);
		if (config.fail_if_exists) {
			open_flags |= O_EXCL;
		}
		i32 fp_to = open(((char*)(w_dst.str)), open_flags, mode_flags);
		if (fp_to < 0) {
			close(fp_from);
			return (_result_void){ .is_error=true, .err=builtin__error_with_code(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("cp: failed to open "), 0xfe10, {.d_s = w_dst}}, {_S(" for writing"), 0, { .d_c = 0 }}})), ((int)(fp_to))), .data={E_STRUCT} };
		}
		Array_fixed_u8_1024 buf = {0};
		int count = ((int)(0));
		for (;;) {
			count = ((int)(read(fp_from, &buf[0], sizeof(Array_fixed_u8_1024))));
			if (count == 0) {
				break;
			}
			if (write(fp_to, &buf[0], count) < 0) {
				close(fp_to);
				close(fp_from);
				return (_result_void){ .is_error=true, .err=builtin__error_with_code(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("cp: failed to write to "), 0xfe10, {.d_s = w_dst}}, {_SLIT0, 0, { .d_c = 0 }}})), ((int)(-1))), .data={E_STRUCT} };
			}
		}
		_result_os__Stat _t5 = os__stat(src);
		if (_t5.is_error) {
			_result_void _t6 = {0};
			_t6.is_error = true;
			_t6.err = _t5.err;
			return _t6;
		}
		
 		os__Stat from_attr = (*(os__Stat*)_t5.data);
		if (chmod(((char*)(w_dst.str)), from_attr.mode) < 0) {
			close(fp_to);
			close(fp_from);
			return (_result_void){ .is_error=true, .err=builtin__error_with_code(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("failed to set permissions for "), 0xfe10, {.d_s = w_dst}}, {_SLIT0, 0, { .d_c = 0 }}})), ((int)(-1))), .data={E_STRUCT} };
		}
		close(fp_to);
		close(fp_from);
	}
	#endif
	return (_result_void){0};
}
_result_FILE_ptr os__vfopen(string path, string mode) {
	if ((path).len == 0) {
		return (_result_FILE_ptr){ .is_error=true, .err=builtin___v_error(_S("vfopen called with \"\"")), .data={E_STRUCT} };
	}
	voidptr fp = ((void*)0);
	#if defined(_WIN32)
	{
	}
	#else
	{
		fp = fopen(((char*)(path.str)), ((char*)(mode.str)));
	}
	#endif
	if (builtin__isnil(((voidptr)(fp)))) {
		return (_result_FILE_ptr){ .is_error=true, .err=os__error_posix(((os__SystemError){.msg = builtin__str_intp(2, _MOV((StrIntpData[]){{_S("failed to open file \""), 0xfe10, {.d_s = path}}, {_S("\""), 0, { .d_c = 0 }}})),.code = _const_os__error_code_not_set,})), .data={E_STRUCT} };
	} else {
		_result_FILE_ptr _t4;
		builtin___result_ok(&(FILE*[]) { fp }, (_result*)(&_t4), sizeof(FILE*));
		 
		return _t4;
	}
	return (_result_FILE_ptr){0};
}
int os__fileno(voidptr cfile) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		FILE* cfile_casted = ((FILE*)(((void*)0)));
		cfile_casted = cfile;
		return fileno(cfile_casted);
	}
	#endif
	return 0;
}
VV_LOC voidptr os__vpopen(string path) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		u8* cpath = path.str;
		return popen(((char*)(cpath)), "r");
	}
	#endif
	return 0;
}
VV_LOC multi_return_int_bool os__posix_wait4_to_exit_status(int waitret) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		int ret = 0;
		bool is_signaled = true;
		if (WIFEXITED(waitret)) {
			ret = WEXITSTATUS(waitret);
			is_signaled = false;
		} else if (WIFSIGNALED(waitret)) {
			ret = WTERMSIG(waitret);
			is_signaled = true;
		}
		return (multi_return_int_bool){.arg0=ret, .arg1=is_signaled};
	}
	#endif
	return (multi_return_int_bool){0};
}
string os__posix_get_error_msg(int code) {
	char* ptr_text = strerror(code);
	if (ptr_text == 0) {
		return _S("");
	}
	return builtin__tos3(ptr_text);
}
VV_LOC int os__vpclose(voidptr f) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		multi_return_int_bool mr_10526 = os__posix_wait4_to_exit_status(pclose(f));
		int ret = mr_10526.arg0;
		return ret;
	}
	#endif
	return 0;
}
int os__system(string cmd) {
	int ret = 0;
	#if defined(_WIN32)
	{
	}
	#else
	{
		#if defined(__TARGET_IOS__)
		{
		}
		#else
		{
			{ // Unsafe block
				ret = system(((char*)(cmd.str)));
			}
		}
		#endif
	}
	#endif
	if (ret == -1) {
		os__print_c_errno();
	}
	#if !defined(_WIN32)
	{
		multi_return_int_bool mr_11570 = os__posix_wait4_to_exit_status(ret);
		int pret = mr_11570.arg0;
		bool is_signaled = mr_11570.arg1;
		ret = pret;
		if (is_signaled) {
			builtin__eprintln(builtin__string__plus(builtin__string__plus(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("Terminated by signal "), 0x4fe27, {.d_i32 = pret}}, {_S(" ("), 0, { .d_c = 0 }}})), os__sigint_to_signal_name(pret)), _S(")")));
			ret = (int)(pret + 128);
		}
	}
	#endif
	return ret;
}
bool os__exists(string path) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		return access(((char*)(path.str)), _const_os__f_ok) != -1;
	}
	#endif
	return 0;
}
bool os__is_executable(string path) {
	return access(((char*)(path.str)), _const_os__x_ok) != -1;
}
bool os__is_writable(string path) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		return access(((char*)(path.str)), _const_os__w_ok) != -1;
	}
	#endif
	return 0;
}
bool os__is_readable(string path) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		return access(((char*)(path.str)), _const_os__r_ok) != -1;
	}
	#endif
	return 0;
}
_result_void os__rm(string path) {
	int rc = 0;
	#if defined(_WIN32)
	{
	}
	#else
	{
		rc = remove(((char*)(path.str)));
	}
	#endif
	if (rc == -1) {
		return (_result_void){ .is_error=true, .err=os__error_posix(((os__SystemError){.msg = builtin__string__plus(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("Failed to remove \""), 0xfe10, {.d_s = path}}, {_S("\": "), 0, { .d_c = 0 }}})), os__posix_get_error_msg(errno)),.code = _const_os__error_code_not_set,})), .data={E_STRUCT} };
	}
	return (_result_void){0};
}
_result_void os__rmdir(string path) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		i32 rc = rmdir(((char*)(path.str)));
		if (rc == -1) {
			return (_result_void){ .is_error=true, .err=os__error_posix(((os__SystemError){.msg = (string){.str=(byteptr)"", .is_lit=1},.code = _const_os__error_code_not_set,})), .data={E_STRUCT} };
		}
	}
	#endif
	return (_result_void){0};
}
VV_LOC void os__print_c_errno(void) {
	int e = errno;
	string se = builtin__tos_clone(((u8*)(strerror(e))));
	builtin__eprintln(builtin__str_intp(3, _MOV((StrIntpData[]){{_S("errno="), 0xfe07, {.d_i32 = e}}, {_S(" err="), 0xfe10, {.d_s = se}}, {_SLIT0, 0, { .d_c = 0 }}})));
}
string os__get_raw_line(void) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		usize max = ((usize)(0));
		u8* buf = ((u8*)(((void*)0)));
		string str = _S("");
		i32 nr_chars = getline(((voidptr)(&buf)), &max, stdin);
		#if defined(__OpenBSD__)
		{
		}
		#else
		{
			str = builtin__tos(buf, (nr_chars < 0 ? (0) : (nr_chars)));
		}
		#endif
		string ret = builtin__string_clone(str);
		#if !defined(_VAUTOFREE)
		{
			{ // Unsafe block
				if (nr_chars > 0 && buf != 0) {
					free(buf);
				}
			}
		}
		#endif
		return ret;
	}
	#endif
	return (string){.str=(byteptr)"", .is_lit=1};
}
Array_u8 os__get_raw_stdin(void) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		usize max = ((usize)(0));
		u8* buf = ((u8*)(((void*)0)));
		i32 nr_chars = getline(((voidptr)(&buf)), &max, stdin);
		return ((array){.data = ((voidptr)(buf)),.offset = 0,.len = (nr_chars < 0 ? (0) : (nr_chars)),.cap = ((int)(max)),.flags = 0,.element_size = 1,});
	}
	#endif
	return builtin____new_array(0, 0, sizeof(u8));
}
string os__executable(void) {
	Array_fixed_u8_4096 result = {0};
	{
		char* self_path = ((char*)(_dyld_get_image_name(((u32)(0)))));
		if (self_path == NULL) {
			return os__executable_fallback();
		}
		return builtin__cstring_to_vstring(self_path);
	}
	return os__executable_fallback();
}
_result_void os__chdir(string path) {
	i32 _t1;
	#if defined(_WIN32)
	#else
		_t1 = chdir(((char*)(path.str)));
		;
	#endif
		i32 ret = _t1;
	if (ret == -1) {
		return (_result_void){ .is_error=true, .err=os__error_posix(((os__SystemError){.msg = (string){.str=(byteptr)"", .is_lit=1},.code = _const_os__error_code_not_set,})), .data={E_STRUCT} };
	}
	return (_result_void){0};
}
string os__getwd(void) {
	{ // Unsafe block
		#if defined(_WIN32)
		{
		}
		#else
		{
			char* cwd_ptr = getcwd(0, 4096);
			if (cwd_ptr == 0) {
				return _S("");
			}
			string res = builtin__tos_clone(((byteptr)(cwd_ptr)));
			free(cwd_ptr);
			return res;
		}
		#endif
	}
	return (string){.str=(byteptr)"", .is_lit=1};
}
string os__real_path(string fpath) {
	Array_fixed_u8_4096 fullpath = {0};
	string res = _S("");
	#if defined(_WIN32)
	{
	}
	#else
	{
		char* ret = ((char*)(realpath(((char*)(fpath.str)), ((char*)(&fullpath[0])))));
		if (ret == 0) {
			builtin__string_free(&res);
			return builtin__string_clone(fpath);
		}
		builtin__string_free(&res);
		res = builtin__tos_clone(&fullpath[0]);
	}
	#endif
	os__normalize_drive_letter(res);
	return res;
}
VV_LOC void os__normalize_drive_letter(string path) {
	#if !defined(_WIN32)
	{
		return;
	}
	#endif
	if (path.len > 2 && path.str[ 0] >= 'a' && path.str[ 0] <= 'z' && path.str[ 1] == ':' && path.str[ 2] == _const_os__path_separator.str[ 0]) {
		{ // Unsafe block
			u8* x = &path.str[0];
			*x = (u8)(*x - 32);
		}
	}
}
int os__fork(void) {
	int pid = -1;
	#if !defined(_WIN32)
	{
		pid = fork();
	}
	#endif
	return pid;
}
int os__wait(void) {
	int pid = -1;
	#if !defined(_WIN32)
	{
		#if !defined(CUSTOM_DEFINE_emscripten)
		{
			pid = wait(0);
		}
		#endif
	}
	#endif
	return pid;
}
i64 os__file_last_mod_unix(string path) {
	_result_os__Stat _t1;
	if (_t1 = os__stat(path), !_t1.is_error) {
		os__Stat attr = *(os__Stat*)_t1.data;
		return attr.mtime;
	}
	return 0;
}
void os__flush(void) {
	fflush(stdout);
}
_result_void os__chmod(string path, int mode) {
	if (chmod(((char*)(path.str)), mode) != 0) {
		return (_result_void){ .is_error=true, .err=os__error_posix(((os__SystemError){.msg = builtin__string__plus(_S("chmod failed: "), os__posix_get_error_msg(errno)),.code = _const_os__error_code_not_set,})), .data={E_STRUCT} };
	}
	return (_result_void){0};
}
_result_void os__chown(string path, int owner, int group) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		if (chown(((char*)(path.str)), owner, group) != 0) {
			return (_result_void){ .is_error=true, .err=os__error_posix(((os__SystemError){.msg = (string){.str=(byteptr)"", .is_lit=1},.code = _const_os__error_code_not_set,})), .data={E_STRUCT} };
		}
	}
	#endif
	return (_result_void){0};
}
_result_os__File os__open_append(string path) {
	os__File file = ((os__File){.cfile = 0,.fd = 0,.is_opened = 0,});
	#if defined(_WIN32)
	{
	}
	#else
	{
		u8* cpath = path.str;
		file = ((os__File){.cfile = (voidptr)fopen(((char*)(cpath)), "ab"),.fd = 0,.is_opened = 0,});
	}
	#endif
	if (builtin__isnil(file.cfile)) {
		return (_result_os__File){ .is_error=true, .err=os__error_posix(((os__SystemError){.msg = builtin__str_intp(2, _MOV((StrIntpData[]){{_S("failed to create(append) file \""), 0xfe10, {.d_s = path}}, {_S("\""), 0, { .d_c = 0 }}})),.code = _const_os__error_code_not_set,})), .data={E_STRUCT} };
	}
	file.is_opened = true;
	_result_os__File _t3;
	builtin___result_ok(&(os__File[]) { file }, (_result*)(&_t3), sizeof(os__File));
	 
	return _t3;
}
_result_void os__execvp(string cmdpath, Array_string cmdargs) {
	Array_char_ptr cargs = builtin____new_array_with_default(0, 0, sizeof(char*), 0);
	builtin__array_push((array*)&cargs, _MOV((char*[]){ ((char*)(cmdpath.str)) }));
	for (int i = 0; i < cmdargs.len; ++i) {
		builtin__array_push((array*)&cargs, _MOV((char*[]){ ((char*)((*(string*)builtin__array_get(cmdargs, i)).str)) }));
	}
	builtin__array_push((array*)&cargs, _MOV((char*[]){ ((char*)(((void*)0))) }));
	int res = ((int)(0));
	#if defined(_WIN32)
	{
	}
	#else
	{
		res = execvp(((char*)(cmdpath.str)), cargs.data);
	}
	#endif
	if (res == -1) {
		return (_result_void){ .is_error=true, .err=os__error_posix(((os__SystemError){.msg = (string){.str=(byteptr)"", .is_lit=1},.code = _const_os__error_code_not_set,})), .data={E_STRUCT} };
	}
	builtin___v_exit(res);
	VUNREACHABLE();
	return (_result_void){0};
}
_result_void os__execve(string cmdpath, Array_string cmdargs, Array_string envs) {
	Array_char_ptr cargv = builtin____new_array_with_default(0, 0, sizeof(char*), 0);
	Array_char_ptr cenvs = builtin____new_array_with_default(0, 0, sizeof(char*), 0);
	builtin__array_push((array*)&cargv, _MOV((char*[]){ ((char*)(cmdpath.str)) }));
	for (int i = 0; i < cmdargs.len; ++i) {
		builtin__array_push((array*)&cargv, _MOV((char*[]){ ((char*)((*(string*)builtin__array_get(cmdargs, i)).str)) }));
	}
	for (int i = 0; i < envs.len; ++i) {
		builtin__array_push((array*)&cenvs, _MOV((char*[]){ ((char*)((*(string*)builtin__array_get(envs, i)).str)) }));
	}
	builtin__array_push((array*)&cargv, _MOV((char*[]){ ((char*)(((void*)0))) }));
	builtin__array_push((array*)&cenvs, _MOV((char*[]){ ((char*)(((void*)0))) }));
	int res = ((int)(0));
	#if defined(_WIN32)
	{
	}
	#else
	{
		res = execve(((char*)(cmdpath.str)), cargv.data, cenvs.data);
	}
	#endif
	if (res == -1) {
		return (_result_void){ .is_error=true, .err=os__error_posix(((os__SystemError){.msg = (string){.str=(byteptr)"", .is_lit=1},.code = _const_os__error_code_not_set,})), .data={E_STRUCT} };
	}
	return (_result_void){0};
}
int os__is_atty(int fd) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		return isatty(fd);
	}
	#endif
	return 0;
}
_result_void os__write_file_array(string path, array buffer) {
	_result_os__File _t1 = os__create(path);
	if (_t1.is_error) {
		_result_void _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 	os__File f = (*(os__File*)_t1.data);
		_result_void _t3 = os__File_write_full_buffer(&f, buffer.data, ((usize)((int)(buffer.len * buffer.element_size))));
	if (_t3.is_error) {
		_result_void _t4 = {0};
		_t4.is_error = true;
		_t4.err = _t3.err;
		return _t4;
	}
	
 ;
	os__File_close(&f);
	return (_result_void){0};
}
_result_Array_string os__glob(Array_string patterns) {
	Array_string matches = builtin____new_array_with_default(0, 0, sizeof(string), 0);
	for (int _t1 = 0; _t1 < patterns.len; ++_t1) {
		string pattern = ((string*)patterns.data)[_t1];
		_result_void _t2 = os__native_glob_pattern(pattern, &matches);
		if (_t2.is_error) {
			_result_Array_string _t3 = {0};
			_t3.is_error = true;
			_t3.err = _t2.err;
			return _t3;
		}
		
 ;
	}
	if (matches.len > 0) { qsort(matches.data, matches.len, matches.element_size, (voidptr)compare_1065768667300548517_string); }
	;
	_result_Array_string _t4;
	builtin___result_ok(&(Array_string[]) { matches }, (_result*)(&_t4), sizeof(Array_string));
	 
	return _t4;
}
IError os__last_error(void) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		int code = errno;
		string msg = os__posix_get_error_msg(code);
		return builtin__error_with_code(msg, code);
	}
	#endif
	return (IError){0};
}
inline IError os__error_posix(os__SystemError e) {
	int code = (e.code == _const_os__error_code_not_set ? (errno) : (e.code));
	string message = ((e.msg).len == 0 ? (os__posix_get_error_msg(code)) : (e.msg));
	return builtin__error_with_code(message, code);
}
inline IError os__error_win32(os__SystemError e) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		builtin___v_panic(_S("Win32 API not available on this platform."));
		VUNREACHABLE();
	}
	#endif
	return (IError){0};
}
void os__Result_free(os__Result* result) {
	builtin__string_free(&result->output);
}
VV_LOC string os__executable_fallback(void) {
	if (_const_os__args.len == 0) {
		return _S("");
	}
	string exepath = (*(string*)builtin__array_get(_const_os__args, 0));
	if (!os__is_abs_path(exepath)) {
		string _t2;
		#if defined(_WIN32)
		#else
			_t2 = _S("\\");
			;
		#endif
				string other_separator = _t2;
		string rexepath = builtin__string_replace(exepath, other_separator, _const_os__path_separator);
		if (builtin__string_contains(rexepath, _const_os__path_separator)) {
			exepath = os__join_path_single(_const_os__wd_at_startup, exepath);
		} else {
			_result_string _t3 = os__find_abs_path_of_executable(exepath);
			if (_t3.is_error) {
				*(string*) _t3.data = _S("");
			}
			
 			string foundpath = (*(string*)_t3.data);
			if ((foundpath).len != 0) {
				exepath = foundpath;
			}
		}
	}
	exepath = os__real_path(exepath);
	return exepath;
}
_result_void os__cp_all(string src, string dst, bool overwrite) {
	string source_path = os__real_path(src);
	string dest_path = os__real_path(dst);
	if (!os__exists(source_path)) {
		return (_result_void){ .is_error=true, .err=builtin___v_error(_S("Source path doesn't exist")), .data={E_STRUCT} };
	}
	if (!os__is_dir(source_path)) {
		string fname = os__file_name(source_path);
		string adjusted_path = (os__is_dir(dest_path) ? (os__join_path_single(dest_path, fname)) : (dest_path));
		if (os__exists(adjusted_path)) {
			if (overwrite) {
				_result_void _t2 = os__rm(adjusted_path);
				if (_t2.is_error) {
					_result_void _t3 = {0};
					_t3.is_error = true;
					_t3.err = _t2.err;
					return _t3;
				}
				
 ;
			} else {
				return (_result_void){ .is_error=true, .err=builtin___v_error(_S("Destination file path already exist")), .data={E_STRUCT} };
			}
		}
		_result_void _t5 = os__cp(source_path, adjusted_path, ((os__CopyParams){.fail_if_exists = 0,}));
		if (_t5.is_error) {
			_result_void _t6 = {0};
			_t6.is_error = true;
			_t6.err = _t5.err;
			return _t6;
		}
		
 ;
		return (_result_void){0};
	}
	if (!os__exists(dest_path)) {
		_result_void _t7 = os__mkdir(dest_path, ((os__MkdirParams){.mode = 0777,}));
		if (_t7.is_error) {
			_result_void _t8 = {0};
			_t8.is_error = true;
			_t8.err = _t7.err;
			return _t8;
		}
		
 ;
	}
	if (!os__is_dir(dest_path)) {
		return (_result_void){ .is_error=true, .err=builtin___v_error(_S("Destination path is not a valid directory")), .data={E_STRUCT} };
	}
	_result_Array_string _t10 = os__ls(source_path);
	if (_t10.is_error) {
		_result_void _t11 = {0};
		_t11.is_error = true;
		_t11.err = _t10.err;
		return _t11;
	}
	
 	Array_string files = (*(Array_string*)_t10.data);
	for (int _t12 = 0; _t12 < files.len; ++_t12) {
		string file = ((string*)files.data)[_t12];
		string sp = os__join_path_single(source_path, file);
		string dp = os__join_path_single(dest_path, file);
		if (os__is_dir(sp)) {
			if (!os__exists(dp)) {
				_result_void _t13 = os__mkdir(dp, ((os__MkdirParams){.mode = 0777,}));
				if (_t13.is_error) {
					_result_void _t14 = {0};
					_t14.is_error = true;
					_t14.err = _t13.err;
					return _t14;
				}
				
 ;
			}
		}
		_result_void _t15 = os__cp_all(sp, dp, overwrite);
		if (_t15.is_error) {
			IError err = _t15.err;
			_result_void _t16 = os__rmdir(dp);
			if (_t16.is_error) {
				IError err = _t16.err;
				return (_result_void){ .is_error=true, .err=err, .data={E_STRUCT} };
			}
			
 ;
			return (_result_void){ .is_error=true, .err=err, .data={E_STRUCT} };
		}
		
 ;
	}
	return (_result_void){0};
}
_result_void os__mv_by_cp(string source, string target, os__MvParams opts) {
	_result_void _t1 = os__cp_all(source, target, opts.overwrite);
	if (_t1.is_error) {
		_result_void _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 ;
	if (os__is_dir(source)) {
		_result_void _t3 = os__rmdir_all(source);
		if (_t3.is_error) {
			_result_void _t4 = {0};
			_t4.is_error = true;
			_t4.err = _t3.err;
			return _t4;
		}
		
 ;
		return (_result_void){0};
	}
	_result_void _t5 = os__rm(source);
	if (_t5.is_error) {
		_result_void _t6 = {0};
		_t6.is_error = true;
		_t6.err = _t5.err;
		return _t6;
	}
	
 ;
	return (_result_void){0};
}
_result_void os__mv(string source, string target, os__MvParams opts) {
	if (!opts.overwrite && os__exists(target)) {
		return (_result_void){ .is_error=true, .err=builtin___v_error(_S("target path already exist")), .data={E_STRUCT} };
	}
	_result_void _t2 = os__rename(source, target);
	if (_t2.is_error) {
		_result_void _t3 = os__mv_by_cp(source, target, opts);
		if (_t3.is_error) {
			_result_void _t4 = {0};
			_t4.is_error = true;
			_t4.err = _t3.err;
			return _t4;
		}
		
 ;
	;
	}
	
 ;
	return (_result_void){0};
}
_result_Array_string os__read_lines(string path) {
	_result_string _t1 = os__read_file(path);
	if (_t1.is_error) {
		_result_Array_string _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 	string buf = (*(string*)_t1.data);
	Array_string res = builtin__string_split_into_lines(buf);
	builtin__string_free(&buf);
	_result_Array_string _t3;
	builtin___result_ok(&(Array_string[]) { res }, (_result*)(&_t3), sizeof(Array_string));
	 
	return _t3;
}
_result_void os__write_lines(string path, Array_string lines) {
	_result_os__File _t1 = os__create(path);
	if (_t1.is_error) {
		_result_void _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 	os__File f = (*(os__File*)_t1.data);
	for (int _t3 = 0; _t3 < lines.len; ++_t3) {
		string line = ((string*)lines.data)[_t3];
		_result_int _t4 = os__File_writeln(&f, line);
		if (_t4.is_error) {
			{ // defer begin
				os__File_close(&f);
			} // defer end
			_result_void _t5 = {0};
			_t5.is_error = true;
			_t5.err = _t4.err;
			return _t5;
		}
		
 ;
	}
		{ // defer begin
			os__File_close(&f);
		} // defer end
	return (_result_void){0};
}
string os__sigint_to_signal_name(int si) {
	switch (si) {
		case 1: {
			return _S("SIGHUP");
		}
		case 2: {
			return _S("SIGINT");
		}
		case 3: {
			return _S("SIGQUIT");
		}
		case 4: {
			return _S("SIGILL");
		}
		case 6: {
			return _S("SIGABRT");
		}
		case 8: {
			return _S("SIGFPE");
		}
		case 9: {
			return _S("SIGKILL");
		}
		case 11: {
			return _S("SIGSEGV");
		}
		case 13: {
			return _S("SIGPIPE");
		}
		case 14: {
			return _S("SIGALRM");
		}
		case 15: {
			return _S("SIGTERM");
		}
		default: {
			{
				break;
			}
		}
	}
	
	return _S("unknown");
}
_result_void os__rmdir_all(string path) {
	string err_msg = _S("");
	int err_code = -1;
	_result_Array_string _t1 = os__ls(path);
	if (_t1.is_error) {
		_result_void _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 	Array_string items = (*(Array_string*)_t1.data);
	for (int _t3 = 0; _t3 < items.len; ++_t3) {
		string item = ((string*)items.data)[_t3];
		string fullpath = os__join_path_single(path, item);
		if (os__is_dir(fullpath) && !os__is_link(fullpath)) {
			_result_void _t4 = os__rmdir_all(fullpath);
			if (_t4.is_error) {
				IError err = _t4.err;
				err_msg = IError_name_table[err._typ]._method_msg(err._object);
				err_code = IError_name_table[err._typ]._method_code(err._object);
			}
			
 ;
		} else {
			_result_void _t5 = os__rm(fullpath);
			if (_t5.is_error) {
				IError err = _t5.err;
				err_msg = IError_name_table[err._typ]._method_msg(err._object);
				err_code = IError_name_table[err._typ]._method_code(err._object);
			}
			
 ;
		}
	}
	_result_void _t6 = os__rmdir(path);
	if (_t6.is_error) {
		IError err = _t6.err;
		err_msg = IError_name_table[err._typ]._method_msg(err._object);
		err_code = IError_name_table[err._typ]._method_code(err._object);
	}
	
 ;
	if ((err_msg).len != 0) {
		return (_result_void){ .is_error=true, .err=builtin__error_with_code(err_msg, err_code), .data={E_STRUCT} };
	}
	return (_result_void){0};
}
bool os__is_dir_empty(string path) {
	_result_Array_string _t1 = os__ls(path);
	if (_t1.is_error) {
		return true;
	}
	
 	Array_string items = (*(Array_string*)_t1.data);
	bool res = items.len == 0;
	Array_string_free(&items);
	return res;
}
string os__file_ext(string opath) {
	if (opath.len < 3) {
		return _S("");
	}
	string path = os__file_name(opath);
	int pos = builtin__string_last_index_u8(path, '.');
	if (pos == -1) {
		return _S("");
	}
	if ((int)(pos + 1) >= path.len || pos == 0) {
		return _S("");
	}
	return builtin__string_substr(path, pos, 2147483647);
}
string os__dir(string path) {
	if ((path).len == 0) {
		return _S(".");
	}
	string detected_path_separator = (builtin__string_contains(path, _S("/")) ? (_S("/")) : (_S("\\")));
	_option_int _t2 = builtin__string_last_index(path, detected_path_separator);
	if (_t2.state != 0) {
		return _S(".");
	}
	
 	int pos = (*(int*)_t2.data);
	if (pos == 0) {
		return detected_path_separator;
	}
	return builtin__string_substr(path, 0, pos);
}
string os__base(string path) {
	if ((path).len == 0) {
		return _S(".");
	}
	string detected_path_separator = (builtin__string_contains(path, _S("/")) ? (_S("/")) : (_S("\\")));
	if (builtin__string__eq(path, detected_path_separator)) {
		return detected_path_separator;
	}
	if (builtin__string_ends_with(path, detected_path_separator)) {
		string path2 = builtin__string_substr(path, 0, (int)(path.len - 1));
		_option_int _t3 = builtin__string_last_index(path2, detected_path_separator);
		if (_t3.state != 0) {
			return builtin__string_clone(path2);
		}
		
 		int pos = (*(int*)_t3.data);
		return builtin__string_substr(path2, (int)(pos + 1), 2147483647);
	}
	_option_int _t6 = builtin__string_last_index(path, detected_path_separator);
	if (_t6.state != 0) {
		return builtin__string_clone(path);
	}
	
 	int pos = (*(int*)_t6.data);
	return builtin__string_substr(path, (int)(pos + 1), 2147483647);
}
string os__file_name(string path) {
	string detected_path_separator = (builtin__string_contains(path, _S("/")) ? (_S("/")) : (_S("\\")));
	return builtin__string_all_after_last(path, detected_path_separator);
}
multi_return_string_string_string os__split_path(string path) {
	if ((path).len == 0) {
		return (multi_return_string_string_string){.arg0=_S("."), .arg1=_S(""), .arg2=_S("")};
	} else if (_SLIT_EQ(path.str, path.len, ".")) {
		return (multi_return_string_string_string){.arg0=_S("."), .arg1=_S(""), .arg2=_S("")};
	} else if (_SLIT_EQ(path.str, path.len, "..")) {
		return (multi_return_string_string_string){.arg0=_S(".."), .arg1=_S(""), .arg2=_S("")};
	}
	string detected_path_separator = (builtin__string_contains(path, _S("/")) ? (_S("/")) : (_S("\\")));
	if (builtin__string__eq(path, detected_path_separator)) {
		return (multi_return_string_string_string){.arg0=detected_path_separator, .arg1=_S(""), .arg2=_S("")};
	}
	if (builtin__string_ends_with(path, detected_path_separator)) {
		return (multi_return_string_string_string){.arg0=builtin__string_substr(path, 0, (int)(path.len - 1)), .arg1=_S(""), .arg2=_S("")};
	}
	string dir = _S(".");
	_option_int _t6 = builtin__string_last_index(path, detected_path_separator);
	if (_t6.state != 0) {
		*(int*) _t6.data = -1;
	}
	
 	int pos = (*(int*)_t6.data);
	if (pos == -1) {
		dir = _S(".");
	} else if (pos == 0) {
		dir = detected_path_separator;
	} else {
		dir = builtin__string_substr(path, 0, pos);
	}
	string file_name = builtin__string_all_after_last(path, detected_path_separator);
	int pos_ext = builtin__string_last_index_u8(file_name, '.');
	if (pos_ext == -1 || pos_ext == 0 || (int)(pos_ext + 1) >= file_name.len) {
		return (multi_return_string_string_string){.arg0=dir, .arg1=file_name, .arg2=_S("")};
	}
	return (multi_return_string_string_string){.arg0=dir, .arg1=builtin__string_substr(file_name, 0, pos_ext), .arg2=builtin__string_substr(file_name, pos_ext, 2147483647)};
}
_option_string os__input_opt(string prompt) {
	builtin__print(prompt);
	os__flush();
	string res = os__get_raw_line();
	if (res.len > 0) {
		_option_string _t1;
		builtin___option_ok(&(string[]) { builtin__string_trim_right(res, _S("\r\n")) }, (_option*)(&_t1), sizeof(string));
		 
		return _t1;
	}
	return (_option_string){ .state=2, .err=_const_none__, .data={E_STRUCT} };
}
string os__input(string prompt) {
	_option_string _t1 = os__input_opt(prompt);
	if (_t1.state != 0) {
		return _S("<EOF>");
	}
	
 	string res = (*(string*)_t1.data);
	return res;
}
string os__get_line(void) {
	string str = os__get_raw_line();
	return builtin__string_trim_right(str, _S("\n"));
}
Array_string os__get_lines(void) {
	string line = _S("");
	Array_string inputstr = builtin____new_array_with_default(0, 0, sizeof(string), 0);
	for (;;) {
		line = os__get_line();
		if (line.len <= 0) {
			break;
		}
		line = builtin__string_trim_space(line);
		builtin__array_push((array*)&inputstr, _MOV((string[]){ builtin__string_clone(line) }));
	}
	return inputstr;
}
string os__get_lines_joined(void) {
	return Array_string_join(os__get_lines(), _S(""));
}
Array_string os__get_raw_lines(void) {
	string line = _S("");
	Array_string lines = builtin____new_array_with_default(0, 0, sizeof(string), 0);
	for (;;) {
		line = os__get_raw_line();
		if (line.len <= 0) {
			break;
		}
		builtin__array_push((array*)&lines, _MOV((string[]){ builtin__string_clone(line) }));
	}
	return lines;
}
string os__get_raw_lines_joined(void) {
	return Array_string_join(os__get_raw_lines(), _S(""));
}
Array_string os__get_trimmed_lines(void) {
	Array_string lines = builtin____new_array_with_default(0, 0, sizeof(string), 0);
	for (;;) {
		string line = os__get_raw_line();
		if (line.len <= 0) {
			break;
		}
		int end = line.len;
		if (end > 0 && builtin__string_at(line, (int)(end - 1)) == '\n') {
			end--;
		}
		if (end > 0 && builtin__string_at(line, (int)(end - 1)) == '\r') {
			end--;
		}
		builtin__array_push((array*)&lines, _MOV((string[]){ builtin__string_substr_ni(line, 0, end) }));
	}
	return lines;
}
string os__user_os(void) {
	{
		return _S("macos");
	}
	if ((os__getenv(_S("TERMUX_VERSION"))).len != 0) {
		return _S("termux");
	}
	return _S("unknown");
}
_result_Array_string os__user_names(void) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		_result_Array_string _t2 = os__read_lines(_S("/etc/passwd"));
		if (_t2.is_error) {
			_result_Array_string _t3 = {0};
			_t3.is_error = true;
			_t3.err = _t2.err;
			return _t3;
		}
		
 		Array_string lines = (*(Array_string*)_t2.data);
		Array_string users = builtin____new_array_with_default(0, lines.len, sizeof(string), 0);
		for (int _t4 = 0; _t4 < lines.len; ++_t4) {
			string line = ((string*)lines.data)[_t4];
			_option_int _t5 = builtin__string_index(line, _S(":"));
			if (_t5.state != 0) {
				*(int*) _t5.data = line.len;
			}
			
 			int end_name = (*(int*)_t5.data);
			builtin__array_push((array*)&users, _MOV((string[]){ builtin__string_substr(line, 0, end_name) }));
		}
		_result_Array_string _t7;
		builtin___result_ok(&(Array_string[]) { users }, (_result*)(&_t7), sizeof(Array_string));
		 
		return _t7;
	}
	#endif
	return (_result_Array_string){0};
}
string os__home_dir(void) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		return os__getenv(_S("HOME"));
	}
	#endif
	return (string){.str=(byteptr)"", .is_lit=1};
}
string os__expand_tilde_to_home(string path) {
	if (_SLIT_EQ(path.str, path.len, "~")) {
		string hdir = os__home_dir();
		return builtin__string_trim_right(hdir, _const_os__path_separator);
	}
	string source = _S("~/");
	if (builtin__string_starts_with(path, source)) {
		string hdir = os__home_dir();
		string trimmed = builtin__string_trim_right(hdir, _const_os__path_separator);
		string final = builtin__string__plus(trimmed, _S("/"));
		string result = builtin__string_replace_once(path, source, final);
		return result;
	}
	return path;
}
_result_void os__write_file(string path, string text) {
	_result_os__File _t1 = os__create(path);
	if (_t1.is_error) {
		_result_void _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 	os__File f = (*(os__File*)_t1.data);
		_result_void _t3 = os__File_write_full_buffer(&f, text.str, ((usize)(text.len)));
	if (_t3.is_error) {
		_result_void _t4 = {0};
		_t4.is_error = true;
		_t4.err = _t3.err;
		return _t4;
	}
	
 ;
	os__File_close(&f);
	return (_result_void){0};
}
string os__ExecutableNotFoundError_msg(os__ExecutableNotFoundError err) {
	return _S("os: failed to find executable");
}
VV_LOC IError os__error_failed_to_find_executable(void) {
	return I_os__ExecutableNotFoundError_to_Interface_IError(((os__ExecutableNotFoundError*)builtin__memdup(&(os__ExecutableNotFoundError){.Error = ((Error){E_STRUCT}),}, sizeof(os__ExecutableNotFoundError))));
}
_result_string os__find_abs_path_of_executable(string exe_name) {
	if ((exe_name).len == 0) {
		return (_result_string){ .is_error=true, .err=builtin___v_error(_S("expected non empty `exe_name`")), .data={E_STRUCT} };
	}
	for (int _t2 = 0; _t2 < _const_os__executable_suffixes.len; ++_t2) {
		string suffix = ((string*)_const_os__executable_suffixes.data)[_t2];
		string fexepath = builtin__string__plus(exe_name, suffix);
		if (os__is_abs_path(fexepath)) {
			_result_string _t3;
			builtin___result_ok(&(string[]) { fexepath }, (_result*)(&_t3), sizeof(string));
			 
			return _t3;
		}
		string res = _S("");
		string path = os__getenv(_S("PATH"));
		Array_string paths = builtin__string_split(path, _const_os__path_delimiter);
		for (int _t4 = 0; _t4 < paths.len; ++_t4) {
			string p = ((string*)paths.data)[_t4];
			string found_abs_path = os__join_path_single(p, fexepath);
			if (os__is_file(found_abs_path) && os__is_executable(found_abs_path)) {
				res = found_abs_path;
				break;
			}
		}
		if (res.len > 0) {
			_result_string _t5;
			builtin___result_ok(&(string[]) { os__abs_path(res) }, (_result*)(&_t5), sizeof(string));
			 
			return _t5;
		}
	}
	return (_result_string){ .is_error=true, .err=os__error_failed_to_find_executable(), .data={E_STRUCT} };
}
bool os__exists_in_system_path(string prog) {
	_result_string _t1 = os__find_abs_path_of_executable(prog);
	if (_t1.is_error) {
		return false;
	}
	
 ;
	return true;
}
bool os__is_file(string path) {
	return os__exists(path) && !os__is_dir(path);
}
string os__join_path(string base, Array_string dirs) {
	strings__Builder sb = strings__new_builder((int)(base.len + (int)(dirs.len * 50)));
	string sbase = builtin__string_trim_right(base, _S("\\/"));
	strings__Builder_write_string(&sb, sbase);
	for (int _t1 = 0; _t1 < dirs.len; ++_t1) {
		string d = ((string*)dirs.data)[_t1];
		if ((d).len != 0) {
			strings__Builder_write_string(&sb, _const_os__path_separator);
			strings__Builder_write_string(&sb, d);
		}
	}
	os__normalize_path_in_builder((voidptr)&sb);
	string res = strings__Builder_str(&sb);
	if ((base).len == 0) {
		res = builtin__string_trim_left(res, _const_os__path_separator);
	}
	string _t2 = res;
		{ // defer begin
			builtin__string_free(&sbase);
		} // defer end
		{ // defer begin
			strings__Builder_free(&sb);
		} // defer end
	return _t2;
}
string os__join_path_single(string base, string elem) {
	strings__Builder sb = strings__new_builder((int)((int)(base.len + elem.len) + 1));
	string sbase = builtin__string_trim_right(base, _S("\\/"));
	strings__Builder_write_string(&sb, sbase);
	if ((elem).len != 0) {
		strings__Builder_write_string(&sb, _const_os__path_separator);
		strings__Builder_write_string(&sb, elem);
	}
	os__normalize_path_in_builder((voidptr)&sb);
	string res = strings__Builder_str(&sb);
	if ((base).len == 0) {
		res = builtin__string_trim_left(res, _const_os__path_separator);
	}
	string _t1 = res;
		{ // defer begin
			builtin__string_free(&sbase);
		} // defer end
		{ // defer begin
			strings__Builder_free(&sb);
		} // defer end
	return _t1;
}
VV_LOC void os__normalize_path_in_builder(strings__Builder* sb) {
	rune fs = '\\';
	rune rs = '/';
	for (int idx = 0; idx < sb->len; ++idx) {
		{ // Unsafe block
			if (((u8*)sb->data)[idx] == fs) {
				((u8*)sb->data)[idx] = rs;
			}
		}
	}
	for (int idx = 0; idx < (int)(sb->len - 3); ++idx) {
		if (((u8*)sb->data)[idx] == rs && ((u8*)sb->data)[(int_literal)(idx + 1)] == '.' && ((u8*)sb->data)[(int_literal)(idx + 2)] == rs) {
			{ // Unsafe block
				for (int j = (int_literal)(idx + 1); j < (int)(sb->len - 2); j++) {
					((u8*)sb->data)[j] = ((u8*)sb->data)[(int)(j + 2)];
				}
				sb->len -= 2;
			}
		}
		if (((u8*)sb->data)[idx] == rs && ((u8*)sb->data)[(int_literal)(idx + 1)] == rs) {
			{ // Unsafe block
				for (int j = (int_literal)(idx + 1); j < (int)(sb->len - 1); j++) {
					((u8*)sb->data)[j] = ((u8*)sb->data)[(int)(j + 1)];
				}
				sb->len -= 1;
			}
		}
	}
}
Array_string os__walk_ext(string path, string ext, os__WalkParams opts) {
	Array_string res = builtin____new_array_with_default(0, 0, sizeof(string), 0);
	os__impl_walk_ext(path, ext, &res, opts);
	return res;
}
VV_LOC void os__impl_walk_ext(string path, string ext, Array_string* out, os__WalkParams opts) {
	if (!os__is_dir(path)) {
		return;
	}
	_result_Array_string _t1 = os__ls(path);
	if (_t1.is_error) {
		return;
	}
	
 	Array_string files = (*(Array_string*)_t1.data);
	string separator = (builtin__string_ends_with(path, _const_os__path_separator) ? (_S("")) : (_const_os__path_separator));
	for (int _t2 = 0; _t2 < files.len; ++_t2) {
		string file = ((string*)files.data)[_t2];
		if (!opts.hidden && builtin__string_starts_with(file, _S("."))) {
			continue;
		}
		string p = builtin__string__plus(builtin__string__plus(path, separator), file);
		if (os__is_dir(p) && !os__is_link(p)) {
			os__impl_walk_ext(p, ext, out, opts);
		} else if (builtin__string_ends_with(file, ext)) {
			builtin__array_push((array*)out, _MOV((string[]){ builtin__string_clone(p) }));
		}
	}
}
void os__walk(string path, void (*f)(string )) {
	if ((path).len == 0) {
		return;
	}
	if (!os__is_dir(path)) {
		return;
	}
	Array_string remaining = builtin____new_array_with_default(0, 1000, sizeof(string), 0);
	string clean_path = builtin__string_trim_right(path, _const_os__path_separator);
	#if defined(_WIN32)
	{
	}
	#else
	{
		builtin__array_push((array*)&remaining, _MOV((string[]){ builtin__string_clone(clean_path) }));
	}
	#endif
	for (;;) {
		if (!(remaining.len > 0)) break;
		string cpath = (*(string*)builtin__array_pop(&remaining));
		os__PathKind pkind = os__kind_of_existing_path(cpath);
		if (pkind.is_link || !pkind.is_dir) {
			f(cpath);
			continue;
		}
		_result_Array_string _t3 = os__ls(cpath);
		if (_t3.is_error) {
			continue;
		}
		
 		Array_string files = (*(Array_string*)_t3.data);
		for (int idx = (int)(files.len - 1); idx >= 0; idx--) {
			builtin__array_push((array*)&remaining, _MOV((string[]){ builtin__string__plus(builtin__string__plus(cpath, _S("/")), (*(string*)builtin__array_get(files, idx))) }));
		}
	}
}
void os__walk_with_context(string path, voidptr context, void (*fcb)(voidptr , string )) {
	if ((path).len == 0) {
		return;
	}
	if (!os__is_dir(path)) {
		return;
	}
	Array_string remaining = builtin____new_array_with_default(0, 1000, sizeof(string), 0);
	string clean_path = builtin__string_trim_right(path, _const_os__path_separator);
	#if defined(_WIN32)
	{
	}
	#else
	{
		builtin__array_push((array*)&remaining, _MOV((string[]){ builtin__string_clone(clean_path) }));
	}
	#endif
	int loops = 0;
	for (;;) {
		if (!(remaining.len > 0)) break;
		loops++;
		string cpath = (*(string*)builtin__array_pop(&remaining));
		if (loops > 1) {
			fcb(context, cpath);
		}
		os__PathKind pkind = os__kind_of_existing_path(cpath);
		if (pkind.is_link || !pkind.is_dir) {
			continue;
		}
		_result_Array_string _t3 = os__ls(cpath);
		if (_t3.is_error) {
			continue;
		}
		
 		Array_string files = (*(Array_string*)_t3.data);
		for (int idx = (int)(files.len - 1); idx >= 0; idx--) {
			builtin__array_push((array*)&remaining, _MOV((string[]){ builtin__string__plus(builtin__string__plus(cpath, _S("/")), (*(string*)builtin__array_get(files, idx))) }));
		}
	}
}
void os__log(string s) {
	builtin__println(builtin__string__plus(_S("os.log: "), s));
}
_result_void os__mkdir_all(string opath, os__MkdirParams params) {
	if (os__exists(opath)) {
		if (os__is_dir(opath)) {
			return (_result_void){0};
		}
		return (_result_void){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("path `"), 0xfe10, {.d_s = opath}}, {_S("` already exists, and is not a folder"), 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
	}
	string _t2;
	#if defined(_WIN32)
	#else
		_t2 = _S("\\");
		;
	#endif
		string other_separator = _t2;
	string path = builtin__string_replace(opath, other_separator, _const_os__path_separator);
	string p = (builtin__string_starts_with(path, _const_os__path_separator) ? (_const_os__path_separator) : (_S("")));
	Array_string path_parts = builtin__string_split(builtin__string_trim_left(path, _const_os__path_separator), _const_os__path_separator);
	for (int _t3 = 0; _t3 < path_parts.len; ++_t3) {
		string subdir = ((string*)path_parts.data)[_t3];
		p = builtin__string__plus(p, builtin__string__plus(subdir, _S("/")));
		if (os__exists(p) && os__is_dir(p)) {
			continue;
		}
		_result_void _t4 = os__mkdir(p, params);
		if (_t4.is_error) {
			IError err = _t4.err;
			return (_result_void){ .is_error=true, .err=builtin___v_error(builtin__str_intp(3, _MOV((StrIntpData[]){{_S("folder: "), 0xfe10, {.d_s = p}}, {_S(", error: "), 0xfe10, {.d_s = builtin__IError_str(err)}}, {_SLIT0, 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
		}
		
 ;
	}
	return (_result_void){0};
}
VV_LOC void os__create_folder_when_it_does_not_exist(string path) {
	if (os__is_dir(path) || os__is_link(path)) {
		return;
	}
	string error_msg = _S("");
	for (int _t1 = 0; _t1 < 10; ++_t1) {
		_result_void _t2 = os__mkdir_all(path, ((os__MkdirParams){.mode = 0700,}));
		if (_t2.is_error) {
			IError err = _t2.err;
			if (os__is_dir(path) || os__is_link(path)) {
				return;
			}
			error_msg = IError_name_table[err._typ]._method_msg(err._object);
			os__sleep_ms(1);
			continue;
		}
		
 ;
		break;
	}
	if (os__is_dir(path) || os__is_link(path)) {
		return;
	}
	builtin___v_panic(error_msg);
	VUNREACHABLE();
}
VV_LOC string os__xdg_home_folder(string ename, string lpath) {
	string xdg_folder = os__getenv(ename);
	string dir = ((xdg_folder).len != 0 ? (xdg_folder) : (os__join_path_single(os__home_dir(), lpath)));
	os__create_folder_when_it_does_not_exist(dir);
	return dir;
}
string os__cache_dir(void) {
	return os__xdg_home_folder(_S("XDG_CACHE_HOME"), _S(".cache"));
}
string os__data_dir(void) {
	return os__xdg_home_folder(_S("XDG_DATA_HOME"), _S(".local/share"));
}
string os__state_dir(void) {
	return os__xdg_home_folder(_S("XDG_STATE_HOME"), _S(".local/state"));
}
string os__local_bin_dir(void) {
	return os__xdg_home_folder(_S("LOCAL_BIN_DIR"), _S(".local/bin"));
}
string os__temp_dir(void) {
	string path = os__getenv(_S("TMPDIR"));
	{
		return _S("/tmp");
	}
	if ((path).len == 0) {
		path = _S("/tmp");
	}
	return path;
}
string os__vtmp_dir(void) {
	string vtmp = os__getenv(_S("VTMP"));
	if (vtmp.len > 0) {
		os__create_folder_when_it_does_not_exist(vtmp);
		return vtmp;
	}
	int uid = os__getuid();
	vtmp = os__join_path_single(os__temp_dir(), builtin__str_intp(2, _MOV((StrIntpData[]){{_S("v_"), 0xfe07, {.d_i32 = uid}}, {_SLIT0, 0, { .d_c = 0 }}})));
	os__create_folder_when_it_does_not_exist(vtmp);
	os__setenv(_S("VTMP"), vtmp, true);
	return vtmp;
}
VV_LOC string os__default_vmodules_path(void) {
	string hdir = os__home_dir();
	string res = os__join_path_single(hdir, _S(".vmodules"));
	return res;
}
string os__vmodules_dir(void) {
	Array_string paths = os__vmodules_paths();
	if (paths.len > 0) {
		return (*(string*)builtin__array_get(paths, 0));
	}
	return os__default_vmodules_path();
}
Array_string os__vmodules_paths(void) {
	string path = os__getenv(_S("VMODULES"));
	if ((path).len == 0) {
		path = os__default_vmodules_path();
	}
	Array_string splitted = builtin__string_split(path, _const_os__path_delimiter);
	Array_string list = builtin____new_array_with_default(0, splitted.len, sizeof(string), 0);
	for (int i = 0; i < splitted.len; ++i) {
		string si = (*(string*)builtin__array_get(splitted, i));
		string trimmed = builtin__string_trim_right(si, _const_os__path_separator);
		builtin__array_push((array*)&list, _MOV((string[]){ builtin__string_clone(trimmed) }));
	}
	Array_string _t2 = list;
		{ // defer begin
		} // defer end
		{ // defer begin
		} // defer end
	return _t2;
}
string os__resource_abs_path(string path) {
	string exe = os__executable();
	string dexe = os__dir(exe);
	string base_path = os__real_path(dexe);
	string vresource = os__getenv(_S("V_RESOURCE_PATH"));
	if (vresource.len != 0) {
		builtin__string_free(&base_path);
		base_path = vresource;
	}
	string fp = os__join_path_single(base_path, path);
	string res = os__real_path(fp);
	{ // Unsafe block
		builtin__string_free(&fp);
		builtin__string_free(&vresource);
		builtin__string_free(&base_path);
		builtin__string_free(&dexe);
		builtin__string_free(&exe);
	}
	return res;
}
os__Result os__execute_or_panic(string cmd) {
	os__Result res = os__execute(cmd);
	if (res.exit_code != 0) {
		builtin__eprintln(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("failed    cmd: "), 0xfe10, {.d_s = cmd}}, {_SLIT0, 0, { .d_c = 0 }}})));
		builtin__eprintln(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("failed   code: "), 0xfe07, {.d_i32 = res.exit_code}}, {_SLIT0, 0, { .d_c = 0 }}})));
		builtin___v_panic(res.output);
		VUNREACHABLE();
	}
	return res;
}
os__Result os__execute_or_exit(string cmd) {
	os__Result res = os__execute(cmd);
	if (res.exit_code != 0) {
		builtin__eprintln(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("failed    cmd: "), 0xfe10, {.d_s = cmd}}, {_SLIT0, 0, { .d_c = 0 }}})));
		builtin__eprintln(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("failed   code: "), 0xfe07, {.d_i32 = res.exit_code}}, {_SLIT0, 0, { .d_c = 0 }}})));
		builtin__eprintln(res.output);
		builtin___v_exit(1);
		VUNREACHABLE();
	}
	return res;
}
_result_os__Result os__execute_opt(string cmd) {
	os__Result res = os__execute(cmd);
	if (res.exit_code != 0) {
		return (_result_os__Result){ .is_error=true, .err=builtin___v_error(res.output), .data={E_STRUCT} };
	}
	_result_os__Result _t2;
	builtin___result_ok(&(os__Result[]) { res }, (_result*)(&_t2), sizeof(os__Result));
	 
	return _t2;
}
string os__quoted_path(string path) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		return builtin__str_intp(2, _MOV((StrIntpData[]){{_S("'"), 0xfe10, {.d_s = path}}, {_S("'"), 0, { .d_c = 0 }}}));
	}
	#endif
	return (string){.str=(byteptr)"", .is_lit=1};
}
_result_string os__config_dir(void) {
	#if defined(_WIN32)
	{
	}
	#elif defined(__APPLE__) || defined(__DARWIN__) || defined(__TARGET_IOS__)
	{
		string home = os__home_dir();
		if ((home).len != 0) {
			_result_string _t2;
			builtin___result_ok(&(string[]) { builtin__string__plus(home, _S("/Library/Application Support")) }, (_result*)(&_t2), sizeof(string));
			 
			return _t2;
		}
	}
	#else
	{
	}
	#endif
	return (_result_string){ .is_error=true, .err=builtin___v_error(_S("Cannot find config directory")), .data={E_STRUCT} };
}
VV_LOC Array_string os__glob_match(string dir, string pattern, string next_pattern, Array_string* matches) {
	Array_string subdirs = builtin____new_array_with_default(0, 0, sizeof(string), 0);
	if (os__is_file(dir)) {
		return subdirs;
	}
	_result_Array_string _t2 = os__ls(dir);
	if (_t2.is_error) {
		return subdirs;
	}
	
 	Array_string files = (*(Array_string*)_t2.data);
	os__GlobMatch mode = os__GlobMatch__exact;
	string pat = pattern;
	if (_SLIT_EQ(pat.str, pat.len, "*")) {
		mode = os__GlobMatch__any;
		if (!builtin__string__eq(next_pattern, pattern) && (next_pattern).len != 0) {
			for (int _t4 = 0; _t4 < files.len; ++_t4) {
				string file = ((string*)files.data)[_t4];
				if (os__is_dir(builtin__str_intp(3, _MOV((StrIntpData[]){{_SLIT0, 0xfe10, {.d_s = dir}}, {_S("/"), 0xfe10, {.d_s = file}}, {_SLIT0, 0, { .d_c = 0 }}})))) {
					builtin__array_push((array*)&subdirs, _MOV((string[]){ builtin__str_intp(3, _MOV((StrIntpData[]){{_SLIT0, 0xfe10, {.d_s = dir}}, {_S("/"), 0xfe10, {.d_s = file}}, {_SLIT0, 0, { .d_c = 0 }}})) }));
				}
			}
			return subdirs;
		}
	}
	if (_SLIT_EQ(pat.str, pat.len, "**")) {
		files = os__walk_ext(dir, _S(""), ((os__WalkParams){.hidden = 0,}));
		pat = next_pattern;
	}
	if (builtin__string_starts_with(pat, _S("*"))) {
		mode = os__GlobMatch__ends_with;
		pat = builtin__string_substr(pat, 1, 2147483647);
	}
	if (builtin__string_ends_with(pat, _S("*"))) {
		mode = (mode == os__GlobMatch__ends_with ? (os__GlobMatch__contains) : (os__GlobMatch__starts_with));
		pat = builtin__string_substr(pat, 0, (int)(pat.len - 1));
	}
	if (builtin__string_contains(pat, _S("*"))) {
		mode = os__GlobMatch__start_and_ends_with;
	}
	for (int _t7 = 0; _t7 < files.len; ++_t7) {
		string file = ((string*)files.data)[_t7];
		string fpath = file;
		string _t8; /* if prepend */
		if (builtin__string_contains(file, _const_os__path_separator)) {
			Array_string pathwalk = builtin__string_split(file, _const_os__path_separator);
			_t8 = (*(string*)builtin__array_get(pathwalk, (int)(pathwalk.len - 1)));
			goto _t9;
		};
		{
			fpath = (_SLIT_EQ(dir.str, dir.len, ".") ? (file) : (builtin__str_intp(3, _MOV((StrIntpData[]){{_SLIT0, 0xfe10, {.d_s = dir}}, {_S("/"), 0xfe10, {.d_s = file}}, {_SLIT0, 0, { .d_c = 0 }}}))));
			_t8 = file;
		}
	_t9: {};
				string f = _t8;
		if ((_SLIT_EQ(f.str, f.len, ".") || _SLIT_EQ(f.str, f.len, "..")) || (f).len == 0) {
			continue;
		}
		bool _t10 = 0;
		
		if (mode == (os__GlobMatch__any)) {
			_t10 = true;
		}
		else if (mode == (os__GlobMatch__exact)) {
			_t10 = builtin__string__eq(f, pat);
		}
		else if (mode == (os__GlobMatch__starts_with)) {
			_t10 = builtin__string_starts_with(f, pat);
		}
		else if (mode == (os__GlobMatch__ends_with)) {
			_t10 = builtin__string_ends_with(f, pat);
		}
		else if (mode == (os__GlobMatch__start_and_ends_with)) {
			Array_string p = builtin__string_split(pat, _S("*"));
			_t10 = builtin__string_starts_with(f, (*(string*)builtin__array_get(p, 0))) && builtin__string_ends_with(f, (*(string*)builtin__array_get(p, 1)));
		}
		else if (mode == (os__GlobMatch__contains)) {
			_t10 = builtin__string_contains(f, pat);
		}bool hit = _t10;
		if (hit) {
			if (os__is_dir(fpath)) {
				builtin__array_push((array*)&subdirs, _MOV((string[]){ builtin__string_clone(fpath) }));
				if (builtin__string__eq(next_pattern, pattern) && (next_pattern).len != 0) {
					builtin__array_push((array*)matches, _MOV((string[]){ builtin__str_intp(3, _MOV((StrIntpData[]){{_SLIT0, 0xfe10, {.d_s = fpath}}, {_SLIT0, 0xfe10, {.d_s = _const_os__path_separator}}, {_SLIT0, 0, { .d_c = 0 }}})) }));
				}
			} else {
				builtin__array_push((array*)matches, _MOV((string[]){ builtin__string_clone(fpath) }));
			}
		}
	}
	return subdirs;
}
VV_LOC _result_void os__native_glob_pattern(string pattern, Array_string* matches) {
	Array_string steps = builtin__string_split(pattern, _const_os__path_separator);
	string cwd = (builtin__string_starts_with(pattern, _const_os__path_separator) ? (_const_os__path_separator) : (_S(".")));
	Array_string subdirs = builtin__new_array_from_c_array(1, 1, sizeof(string), _MOV((string[1]){builtin__string_clone(cwd)}));
	for (int i = 0; i < steps.len; i++) {
		string step = (*(string*)builtin__array_get(steps, i));
		string step2 = ((int)(i + 1) == steps.len ? (step) : ((*(string*)builtin__array_get(steps, (int)(i + 1)))));
		if ((step).len == 0) {
			continue;
		}
		if (os__is_dir(builtin__str_intp(4, _MOV((StrIntpData[]){{_SLIT0, 0xfe10, {.d_s = cwd}}, {_SLIT0, 0xfe10, {.d_s = _const_os__path_separator}}, {_SLIT0, 0xfe10, {.d_s = step}}, {_SLIT0, 0, { .d_c = 0 }}})))) {
			string dd = (_SLIT_EQ(cwd.str, cwd.len, "/") ? (step) : ((_SLIT_EQ(cwd.str, cwd.len, ".") || (cwd).len == 0 ? (step) : ((_SLIT_EQ(step.str, step.len, ".") || _SLIT_EQ(step.str, step.len, "/") ? (cwd) : (builtin__str_intp(3, _MOV((StrIntpData[]){{_SLIT0, 0xfe10, {.d_s = cwd}}, {_S("/"), 0xfe10, {.d_s = step}}, {_SLIT0, 0, { .d_c = 0 }}}))))))));
			if ((int)(i + 1) != steps.len) {
				if (!(Array_string_contains(subdirs, dd))) {
					builtin__array_push((array*)&subdirs, _MOV((string[]){ builtin__string_clone(dd) }));
				}
			}
		}
		Array_string subs = builtin____new_array_with_default(0, 0, sizeof(string), 0);
		for (int _t2 = 0; _t2 < subdirs.len; ++_t2) {
			string sd = ((string*)subdirs.data)[_t2];
			string d = (_SLIT_EQ(cwd.str, cwd.len, "/") ? (sd) : ((_SLIT_EQ(cwd.str, cwd.len, ".") || (cwd).len == 0 ? (sd) : ((_SLIT_EQ(sd.str, sd.len, ".") || _SLIT_EQ(sd.str, sd.len, "/") ? (cwd) : (builtin__str_intp(3, _MOV((StrIntpData[]){{_SLIT0, 0xfe10, {.d_s = cwd}}, {_S("/"), 0xfe10, {.d_s = sd}}, {_SLIT0, 0, { .d_c = 0 }}}))))))));
			_PUSH_MANY(&subs, (os__glob_match(builtin__string_replace(d, _S("//"), _S("/")), step, step2, matches)), _t3, Array_string);
		}
		subdirs = builtin__array_clone_to_depth(&subs, 1);
	}
	return (_result_void){0};
}
_result_void os__utime(string path, int actime, int modtime) {
	struct utimbuf u = ((struct utimbuf){.actime = actime,.modtime = modtime,});
	if (utime(((char*)(path.str)), &u) != 0) {
		return (_result_void){ .is_error=true, .err=builtin__error_with_code(os__posix_get_error_msg(errno), errno), .data={E_STRUCT} };
	}
	return (_result_void){0};
}
os__Uname os__uname(void) {
	os__Uname u = ((os__Uname){.sysname = (string){.str=(byteptr)"", .is_lit=1},.nodename = (string){.str=(byteptr)"", .is_lit=1},.release = (string){.str=(byteptr)"", .is_lit=1},.version = (string){.str=(byteptr)"", .is_lit=1},.machine = (string){.str=(byteptr)"", .is_lit=1},});
	{ // Unsafe block
		struct utsname* d = ((struct utsname*)(builtin__malloc_noscan(((int)(sizeof(struct utsname))))));
		if (uname(d) == 0) {
			u.sysname = builtin__cstring_to_vstring(d->sysname);
			u.nodename = builtin__cstring_to_vstring(d->nodename);
			u.release = builtin__cstring_to_vstring(d->release);
			u.version = builtin__cstring_to_vstring(d->version);
			u.machine = builtin__cstring_to_vstring(d->machine);
		}
		builtin___v_free(d);
	}
	return u;
}
_result_string os__hostname(void) {
	string hstnme = _S("");
	int size = 256;
	char* buf = ((char*)(builtin__malloc_noscan(size)));
	if (gethostname(buf, size) == 0) {
		hstnme = builtin__cstring_to_vstring(buf);
		builtin___v_free(buf);
		_result_string _t1;
		builtin___result_ok(&(string[]) { hstnme }, (_result*)(&_t1), sizeof(string));
		 
		return _t1;
	}
	return (_result_string){ .is_error=true, .err=builtin___v_error(os__posix_get_error_msg(errno)), .data={E_STRUCT} };
}
_result_string os__loginname(void) {
	char* x = getlogin();
	if (!builtin__isnil(x)) {
		_result_string _t1;
		builtin___result_ok(&(string[]) { builtin__cstring_to_vstring(x) }, (_result*)(&_t1), sizeof(string));
		 
		return _t1;
	}
	return (_result_string){ .is_error=true, .err=builtin___v_error(os__posix_get_error_msg(errno)), .data={E_STRUCT} };
}
_result_Array_string os__ls(string path) {
	if ((path).len == 0) {
		return (_result_Array_string){ .is_error=true, .err=builtin___v_error(_S("ls() expects a folder, not an empty string")), .data={E_STRUCT} };
	}
	Array_string res = builtin____new_array_with_default(0, 50, sizeof(string), 0);
	DIR* dir = opendir(((char*)(path.str)));
	if (builtin__isnil(dir)) {
		return (_result_Array_string){ .is_error=true, .err=os__error_posix(((os__SystemError){.msg = builtin__str_intp(2, _MOV((StrIntpData[]){{_S("ls() couldnt open dir \""), 0xfe10, {.d_s = path}}, {_S("\""), 0, { .d_c = 0 }}})),.code = _const_os__error_code_not_set,})), .data={E_STRUCT} };
	}
	struct dirent* ent = ((struct dirent*)(((void*)0)));
	for (;;) {
		ent = readdir(dir);
		if (builtin__isnil(ent)) {
			break;
		}
		{ // Unsafe block
			u8* bptr = ((u8*)(&ent->d_name[0]));
			if (bptr[0] == 0 || (bptr[0] == '.' && bptr[1] == 0) || (bptr[0] == '.' && bptr[1] == '.' && bptr[2] == 0)) {
				continue;
			}
			builtin__array_push((array*)&res, _MOV((string[]){ builtin__tos_clone(bptr) }));
		}
	}
	closedir(dir);
	_result_Array_string _t4;
	builtin___result_ok(&(Array_string[]) { res }, (_result*)(&_t4), sizeof(Array_string));
	 
	return _t4;
}
_result_void os__mkdir(string path, os__MkdirParams params) {
	if (_SLIT_EQ(path.str, path.len, ".")) {
		return (_result_void){0};
	}
	string apath = os__real_path(path);
	i32 r = mkdir(((char*)(apath.str)), params.mode);
	if (r == -1) {
		return (_result_void){ .is_error=true, .err=builtin___v_error(os__posix_get_error_msg(errno)), .data={E_STRUCT} };
	}
	return (_result_void){0};
}
os__Result os__execute(string cmd) {
	string pcmd = builtin__str_intp(2, _MOV((StrIntpData[]){{_S("exec 2>&1;"), 0xfe10, {.d_s = cmd}}, {_SLIT0, 0, { .d_c = 0 }}}));
	voidptr f = os__vpopen(pcmd);
	if (builtin__isnil(f)) {
		os__Result _t1 = ((os__Result){.exit_code = -1,.output = builtin__str_intp(2, _MOV((StrIntpData[]){{_S("exec(\""), 0xfe10, {.d_s = cmd}}, {_S("\") failed"), 0, { .d_c = 0 }}})),});
			{ // defer begin
				builtin__string_free(&pcmd);
			} // defer end
		return _t1;
	}
	int fd = os__fileno(f);
	strings__Builder res = strings__new_builder(1024);
	Array_fixed_u8_4096 buf = {0};
	{ // Unsafe block
		u8* pbuf = &buf[0];
		for (;;) {
			int len = ((int)(read(fd, pbuf, 4096)));
			if (len == 0) {
				break;
			}
			strings__Builder_write_ptr(&res, pbuf, len);
		}
	}
	string soutput = strings__Builder_str(&res);
	int exit_code = os__vpclose(f);
	os__Result _t2 = ((os__Result){.exit_code = exit_code,.output = soutput,});
		{ // defer begin
			strings__Builder_free(&res);
		} // defer end
		{ // defer begin
			builtin__string_free(&pcmd);
		} // defer end
	return _t2;
}
os__Result os__raw_execute(string cmd) {
	return os__execute(cmd);
}
_result_void os__symlink(string target, string link_name) {
	i32 res = symlink(((char*)(target.str)), ((char*)(link_name.str)));
	if (res == 0) {
		return (_result_void){0};
	}
	return (_result_void){ .is_error=true, .err=builtin___v_error(os__posix_get_error_msg(errno)), .data={E_STRUCT} };
}
_result_string os__readlink(string path) {
	Array_fixed_u8_4096 buf = {0};
	i32 res = readlink(((char*)(path.str)), ((char*)(&buf[0])), _const_os__max_path_buffer_size);
	if (res < 0) {
		return (_result_string){ .is_error=true, .err=os__last_error(), .data={E_STRUCT} };
	}
	if (res < _const_os__max_path_buffer_size) {
		_result_string _t2;
		builtin___result_ok(&(string[]) { builtin__string_clone(builtin__u8_vstring_with_len((&buf[0]), res)) }, (_result*)(&_t2), sizeof(string));
		 
		return _t2;
	}
	int size = _const_os__max_path_buffer_size;
	for (;;) {
		size *= 2;
		char* buf2 = ((char*)(builtin__malloc_noscan(size)));
		i32 res2 = readlink(((char*)(path.str)), buf2, size);
		if (res2 < 0) {
			return (_result_string){ .is_error=true, .err=os__last_error(), .data={E_STRUCT} };
		}
		if (res2 < size) {
			_result_string _t4;
			builtin___result_ok(&(string[]) { builtin__tos(((u8*)(&buf2[0])), res2) }, (_result*)(&_t4), sizeof(string));
			 
			return _t4;
		}
		builtin___v_free(buf2);
	}
	return (_result_string){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_SLIT0, 0xfe10, {.d_s = _S("readlink")}}, {_S(" unreachable code"), 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
}
_result_void os__link(string origin, string target) {
	i32 res = link(((char*)(origin.str)), ((char*)(target.str)));
	if (res == 0) {
		return (_result_void){0};
	}
	return (_result_void){ .is_error=true, .err=builtin___v_error(os__posix_get_error_msg(errno)), .data={E_STRUCT} };
}
string os__get_error_msg(int code) {
	return os__posix_get_error_msg(code);
}
void os__File_close(os__File* f) {
	if (!f->is_opened) {
		return;
	}
	f->is_opened = false;
	fflush(f->cfile);
	fclose(f->cfile);
}
_result_void os__ensure_folder_is_writable(string folder) {
	if (!os__exists(folder)) {
		return (_result_void){ .is_error=true, .err=builtin__error_with_code(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("`"), 0xfe10, {.d_s = folder}}, {_S("` does not exist"), 0, { .d_c = 0 }}})), 1), .data={E_STRUCT} };
	}
	if (!os__is_dir(folder)) {
		return (_result_void){ .is_error=true, .err=builtin__error_with_code(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("`"), 0xfe10, {.d_s = folder}}, {_S("` is not a folder"), 0, { .d_c = 0 }}})), 2), .data={E_STRUCT} };
	}
	string tmp_perm_check = os__join_path_single(folder, _S("XXXXXX"));
	{ // Unsafe block
		i32 x = mkstemp(((char*)(tmp_perm_check.str)));
		if (-1 == x) {
			_result_void _t3 = (_result_void){ .is_error=true, .err=builtin__error_with_code(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("folder `"), 0xfe10, {.d_s = folder}}, {_S("` is not writable"), 0, { .d_c = 0 }}})), 3), .data={E_STRUCT} };
				{ // defer begin
					builtin__string_free(&tmp_perm_check);
				} // defer end
			return _t3;
		}
		close(x);
	}
	_result_void _t4 = os__rm(tmp_perm_check);
	if (_t4.is_error) {
		{ // defer begin
			builtin__string_free(&tmp_perm_check);
		} // defer end
		_result_void _t5 = {0};
		_t5.is_error = true;
		_t5.err = _t4.err;
		return _t5;
	}
	
 ;
		{ // defer begin
			builtin__string_free(&tmp_perm_check);
		} // defer end
	return (_result_void){0};
}
inline int os__getpid(void) {
	return getpid();
}
inline int os__getppid(void) {
	return getppid();
}
inline int os__getuid(void) {
	return getuid();
}
inline int os__geteuid(void) {
	return geteuid();
}
inline int os__getgid(void) {
	return getgid();
}
inline int os__getegid(void) {
	return getegid();
}
void os__posix_set_permission_bit(string path_s, u32 mode, bool enable) {
	u32 new_mode = ((u32)(0));
	_result_os__Stat _t1;
	if (_t1 = os__stat(path_s), !_t1.is_error) {
		os__Stat s = *(os__Stat*)_t1.data;
		new_mode = s.mode;
	}

	if (enable == (true)) {
		new_mode |= mode;
	}
	else if (enable == (false)) {
		new_mode &= ((u32)(07777 - mode));
	}
	chmod(((char*)(path_s.str)), ((int)(new_mode)));
}
int os__page_size(void) {
	return ((int)(sysconf(_SC_PAGESIZE)));
}
_result_os__DiskUsage os__disk_usage(string path) {
	string mpath = ((path).len == 0 ? (_S(".")) : (path));
	struct statvfs vfs = ((struct statvfs){.f_bsize = 0,.f_blocks = 0,.f_bfree = 0,.f_bavail = 0,});
	i32 ret = statvfs(((char*)(mpath.str)), &vfs);
	if (ret == -1) {
		_result_os__DiskUsage _t1 = (_result_os__DiskUsage){ .is_error=true, .err=builtin___v_error(_S("cannot get disk usage of path")), .data={E_STRUCT} };
			{ // defer begin
				builtin__string_free(&mpath);
			} // defer end
		return _t1;
	}
	u64 f_bsize = ((u64)(vfs.f_bsize));
	u64 f_blocks = ((u64)(vfs.f_blocks));
	u64 f_bavail = ((u64)(vfs.f_bavail));
	u64 f_bfree = ((u64)(vfs.f_bfree));
	_result_os__DiskUsage _t2;
	builtin___result_ok(&(os__DiskUsage[]) { ((os__DiskUsage){.total = (u64)(f_bsize * f_blocks),.available = (u64)(f_bsize * f_bavail),.used = (u64)(f_bsize * ((u64)(f_blocks - f_bfree))),}) }, (_result*)(&_t2), sizeof(os__DiskUsage));
	 
		{ // defer begin
			builtin__string_free(&mpath);
		} // defer end
	return _t2;
}
_result_string os__input_password(string prompt) {
	if (os__is_atty(1) <= 0 || builtin__string__eq(os__getenv(_S("TERM")), _S("dumb"))) {
		return (_result_string){ .is_error=true, .err=builtin___v_error(_S("Could not obtain password discretely.")), .data={E_STRUCT} };
	}
	term__termios__Termios old_state = ((term__termios__Termios){.c_iflag = 0,.c_oflag = 0,.c_cflag = 0,.c_lflag = 0,.c_cc = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},.c_ispeed = 0,.c_ospeed = 0,});
	if (term__termios__tcgetattr(0, (voidptr)&old_state) != 0) {
		return (_result_string){ .is_error=true, .err=os__last_error(), .data={E_STRUCT} };
	}
	term__termios__Termios new_state = old_state;
	term__termios__Termios_disable_echo(&new_state);
	term__termios__set_state(0, new_state);
	_option_string _t3 = os__input_opt(prompt);
	if (_t3.state != 0) {
		return (_result_string){ .is_error=true, .err=builtin___v_error(_S("Failed to read password")), .data={E_STRUCT} };
	}
	
 	string password = (*(string*)_t3.data);
	term__termios__set_state(0, old_state);
	builtin__println(_S(""));
	_result_string _t5;
	builtin___result_ok(&(string[]) { password }, (_result*)(&_t5), sizeof(string));
	 
	return _t5;
}
int os__fd_dup(int fd) {
	i32 _t2;
	#if defined(_WIN32)
	#else
		_t2 = dup(fd);
		;
	#endif
		return _t2;
}
int os__fd_dup2(int fd1, int fd2) {
	i32 _t2;
	#if defined(_WIN32)
	#else
		_t2 = dup2(fd1, fd2);
		;
	#endif
		return _t2;
}
_result_os__Pipe os__pipe(void) {
	Array_fixed_int_2 fds = {0};
	#if defined(_WIN32)
	{
	}
	#else
	{
		if (pipe(&fds[0]) == -1) {
			return (_result_os__Pipe){ .is_error=true, .err=builtin___v_error(_S("Failed to create pipe")), .data={E_STRUCT} };
		}
	}
	#endif
	_result_os__Pipe _t3;
	builtin___result_ok(&(os__Pipe[]) { ((os__Pipe){.read_fd = fds[0],.write_fd = fds[1],}) }, (_result*)(&_t3), sizeof(os__Pipe));
	 
	return _t3;
}
void os__Pipe_close(os__Pipe* p) {
	if (p->read_fd != -1) {
		os__fd_close(p->read_fd);
		p->read_fd = -1;
	}
	if (p->write_fd != -1) {
		os__fd_close(p->write_fd);
		p->write_fd = -1;
	}
}
_result_int os__Pipe_read(os__Pipe* p, Array_u8* buffer) {
	i32 result = read(p->read_fd, buffer->data, buffer->len);
	if (result == -1) {
		return (_result_int){ .is_error=true, .err=builtin___v_error(_S("Read failed")), .data={E_STRUCT} };
	}
	_result_int _t2;
	builtin___result_ok(&(int[]) { ((int)(result)) }, (_result*)(&_t2), sizeof(int));
	 
	return _t2;
}
_result_int os__Pipe_write(os__Pipe* p, Array_u8 buffer) {
	i32 result = write(p->write_fd, buffer.data, buffer.len);
	if (result == -1) {
		return (_result_int){ .is_error=true, .err=builtin___v_error(_S("Write failed")), .data={E_STRUCT} };
	}
	_result_int _t2;
	builtin___result_ok(&(int[]) { ((int)(result)) }, (_result*)(&_t2), sizeof(int));
	 
	return _t2;
}
_result_int os__Pipe_write_string(os__Pipe* p, string s) {
	i32 result = write(p->write_fd, ((voidptr)(s.str)), s.len);
	if (result == -1) {
		return (_result_int){ .is_error=true, .err=builtin___v_error(_S("Write failed")), .data={E_STRUCT} };
	}
	_result_int _t2;
	builtin___result_ok(&(int[]) { ((int)(result)) }, (_result*)(&_t2), sizeof(int));
	 
	return _t2;
}
Array_string os__Pipe_slurp(os__Pipe* p) {
	os__fd_close(p->write_fd);
	p->write_fd = -1;
	Array_string result = os__fd_slurp(p->read_fd);
	os__fd_close(p->read_fd);
	p->read_fd = -1;
	return result;
}
_result_os__IOCapture os__stdio_capture(void) {
	os__IOCapture c = ((os__IOCapture){.__v_stdout = ((os__Pipe){.read_fd = -1,.write_fd = -1,}),.__v_stderr = ((os__Pipe){.read_fd = -1,.write_fd = -1,}),.original_stdout_fd = -1,.original_stderr_fd = -1,});
	_result_os__Pipe _t1 = os__pipe();
	if (_t1.is_error) {
		_result_os__IOCapture _t2 = {0};
		_t2.is_error = true;
		_t2.err = _t1.err;
		return _t2;
	}
	
 	os__Pipe pipe_stdout = (*(os__Pipe*)_t1.data);
	_result_os__Pipe _t3 = os__pipe();
	if (_t3.is_error) {
		_result_os__IOCapture _t4 = {0};
		_t4.is_error = true;
		_t4.err = _t3.err;
		return _t4;
	}
	
 	os__Pipe pipe_stderr = (*(os__Pipe*)_t3.data);
	c.original_stdout_fd = os__fd_dup(_const_os__fd_stdout);
	c.original_stderr_fd = os__fd_dup(_const_os__fd_stderr);
	if (os__fd_dup2(pipe_stdout.write_fd, _const_os__fd_stdout) == -1) {
		os__Pipe_close(&pipe_stdout);
		os__Pipe_close(&pipe_stderr);
		return (_result_os__IOCapture){ .is_error=true, .err=builtin___v_error(_S("Failed to redirect stdout")), .data={E_STRUCT} };
	}
	if (os__fd_dup2(pipe_stderr.write_fd, _const_os__fd_stderr) == -1) {
		os__fd_dup2(c.original_stdout_fd, _const_os__fd_stdout);
		os__Pipe_close(&pipe_stdout);
		os__Pipe_close(&pipe_stderr);
		return (_result_os__IOCapture){ .is_error=true, .err=builtin___v_error(_S("Failed to redirect stderr")), .data={E_STRUCT} };
	}
	os__fd_close(pipe_stdout.write_fd);
	os__fd_close(pipe_stderr.write_fd);
	pipe_stdout.write_fd = -1;
	pipe_stderr.write_fd = -1;
	c.__v_stdout = pipe_stdout;
	c.__v_stderr = pipe_stderr;
	_result_os__IOCapture _t7;
	builtin___result_ok(&(os__IOCapture[]) { c }, (_result*)(&_t7), sizeof(os__IOCapture));
	 
	return _t7;
}
void os__IOCapture_stop(os__IOCapture* c) {
	if (c->original_stdout_fd != -1) {
		os__fd_dup2(c->original_stdout_fd, _const_os__fd_stdout);
		os__fd_close(c->original_stdout_fd);
		c->original_stdout_fd = -1;
	}
	if (c->original_stderr_fd != -1) {
		os__fd_dup2(c->original_stderr_fd, _const_os__fd_stderr);
		os__fd_close(c->original_stderr_fd);
		c->original_stderr_fd = -1;
	}
}
void os__IOCapture_close(os__IOCapture* c) {
	os__Pipe_close(&c->__v_stdout);
	os__Pipe_close(&c->__v_stderr);
}
multi_return_Array_string_Array_string os__IOCapture_finish(os__IOCapture* c) {
	os__IOCapture_stop(c);
	Array_string stdout_str = os__Pipe_slurp(&c->__v_stdout);
	Array_string stderr_str = os__Pipe_slurp(&c->__v_stderr);
	os__IOCapture_close(c);
	return (multi_return_Array_string_Array_string){.arg0=stdout_str, .arg1=stderr_str};
}
void os__Process_signal_kill(os__Process* p) {
	if (!(p->status == os__ProcessState__running || p->status == os__ProcessState__stopped)) {
		return;
	}
	os__Process__signal_kill(p);
	p->status = os__ProcessState__aborted;
}
void os__Process_signal_term(os__Process* p) {
	if (!(p->status == os__ProcessState__running || p->status == os__ProcessState__stopped)) {
		return;
	}
	os__Process__signal_term(p);
}
void os__Process_signal_pgkill(os__Process* p) {
	if (!(p->status == os__ProcessState__running || p->status == os__ProcessState__stopped)) {
		return;
	}
	os__Process__signal_pgkill(p);
}
void os__Process_signal_stop(os__Process* p) {
	if (p->status != os__ProcessState__running) {
		return;
	}
	os__Process__signal_stop(p);
	p->status = os__ProcessState__stopped;
}
void os__Process_signal_continue(os__Process* p) {
	if (p->status != os__ProcessState__stopped) {
		return;
	}
	os__Process__signal_continue(p);
	p->status = os__ProcessState__running;
}
void os__Process_wait(os__Process* p) {
	if (p->status == os__ProcessState__not_started) {
		os__Process__spawn(p);
	}
	if (!(p->status == os__ProcessState__running || p->status == os__ProcessState__stopped)) {
		return;
	}
	os__Process__wait(p);
}
void os__Process_close(os__Process* p) {
	if (p->status == os__ProcessState__not_started || p->status == os__ProcessState__closed) {
		return;
	}
	p->status = os__ProcessState__closed;
	#if !defined(_WIN32)
	{
		for (int i = 0; i < 3; ++i) {
			if (p->stdio_fd[builtin__v_fixed_index(i, 3)] != 0) {
				os__fd_close(p->stdio_fd[builtin__v_fixed_index(i, 3)]);
			}
		}
	}
	#endif
}
void os__Process_free(os__Process* p) {
	os__Process_close(p);
	{ // Unsafe block
		builtin__string_free(&p->filename);
		builtin__string_free(&p->err);
		Array_string_free(&p->args);
		Array_string_free(&p->env);
	}
}
VV_LOC int os__Process__spawn(os__Process* p) {
	if (!p->env_is_custom) {
		p->env = builtin____new_array_with_default(0, 0, sizeof(string), 0);
		Map_string_string current_environment = os__environ();
		int _t2 = current_environment.key_values.len;
		for (int _t1 = 0; _t1 < _t2; ++_t1 ) {
			int _t3 = current_environment.key_values.len - _t2;
			_t2 = current_environment.key_values.len;
			if (_t3 < 0) {
				_t1 = -1;
				continue;
			}
			if (!builtin__DenseArray_has_index(&current_environment.key_values, _t1)) {continue;}
			string k = *(string*)builtin__DenseArray_key(&current_environment.key_values, _t1);
			k = builtin__string_clone(k);
			string v = (*(string*)builtin__DenseArray_value(&current_environment.key_values, _t1));
			builtin__array_push((array*)&p->env, _MOV((string[]){ builtin__str_intp(3, _MOV((StrIntpData[]){{_SLIT0, 0xfe10, {.d_s = k}}, {_S("="), 0xfe10, {.d_s = v}}, {_SLIT0, 0, { .d_c = 0 }}})) }));
		}
	}
	int pid = 0;
	#if defined(_WIN32)
	{
	}
	#else
	{
		pid = os__Process_unix_spawn_process(p);
	}
	#endif
	p->pid = pid;
	p->status = os__ProcessState__running;
	return 0;
}
bool os__Process_is_alive(os__Process* p) {
	bool res = false;
	if (p->status == os__ProcessState__running || p->status == os__ProcessState__stopped) {
		res = os__Process__is_alive(p);
	}
	return res;
}
void os__Process_set_redirect_stdio(os__Process* p) {
	p->use_stdio_ctl = true;
}
void os__Process_stdin_write(os__Process* p, string s) {
	os__Process__check_redirection_call(p, _S("Process.stdin_write"));
	os__Process__write_to(p, os__ChildProcessPipeKind__stdin, s);
}
string os__Process_stdout_slurp(os__Process* p) {
	os__Process__check_redirection_call(p, _S("Process.stdout_slurp"));
	string res = os__Process__slurp_from(p, os__ChildProcessPipeKind__stdout);
	return res;
}
string os__Process_stderr_slurp(os__Process* p) {
	os__Process__check_redirection_call(p, _S("Process.stderr_slurp"));
	string res = os__Process__slurp_from(p, os__ChildProcessPipeKind__stderr);
	return res;
}
string os__Process_stdout_read(os__Process* p) {
	os__Process__check_redirection_call(p, _S("Process.stdout_read"));
	string res = os__Process__read_from(p, os__ChildProcessPipeKind__stdout);
	return res;
}
string os__Process_stderr_read(os__Process* p) {
	os__Process__check_redirection_call(p, _S("Process.stderr_read"));
	string res = os__Process__read_from(p, os__ChildProcessPipeKind__stderr);
	return res;
}
_option_string os__Process_pipe_read(os__Process* p, os__ChildProcessPipeKind pkind) {
	os__Process__check_redirection_call(p, _S("Process.pipe_read"));
	if (!os__Process__is_pending(p, pkind)) {
		return (_option_string){ .state=2, .err=_const_none__, .data={E_STRUCT} };
	}
	string res = os__Process__read_from(p, pkind);
	_option_string _t2;
	builtin___option_ok(&(string[]) { res }, (_option*)(&_t2), sizeof(string));
	 
	return _t2;
}
bool os__Process_is_pending(os__Process* p, os__ChildProcessPipeKind pkind) {
	os__Process__check_redirection_call(p, _S("Process.is_pending"));
	bool res = os__Process__is_pending(p, pkind);
	return res;
}
VV_LOC string os__Process__read_from(os__Process* p, os__ChildProcessPipeKind pkind) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		multi_return_string_int mr_6450 = os__fd_read(p->stdio_fd[builtin__v_fixed_index(pkind, 3)], 4096);
		string s = mr_6450.arg0;
		return s;
	}
	#endif
	return (string){.str=(byteptr)"", .is_lit=1};
}
VV_LOC string os__Process__slurp_from(os__Process* p, os__ChildProcessPipeKind pkind) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		return Array_string_join(os__fd_slurp(p->stdio_fd[builtin__v_fixed_index(pkind, 3)]), _S(""));
	}
	#endif
	return (string){.str=(byteptr)"", .is_lit=1};
}
VV_LOC void os__Process__write_to(os__Process* p, os__ChildProcessPipeKind pkind, string s) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		os__fd_write(p->stdio_fd[builtin__v_fixed_index(pkind, 3)], s);
	}
	#endif
}
VV_LOC bool os__Process__is_pending(os__Process* p, os__ChildProcessPipeKind pkind) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		return os__fd_is_pending(p->stdio_fd[builtin__v_fixed_index(pkind, 3)]);
	}
	#endif
	return false;
}
VV_LOC void os__Process__check_redirection_call(os__Process* p, string fn_name) {
	if (!p->use_stdio_ctl) {
		builtin___v_panic(builtin__string__plus(_S("Call p.set_redirect_stdio() before calling p."), fn_name));
		VUNREACHABLE();
	}
	if (p->status == os__ProcessState__not_started) {
		builtin___v_panic(builtin__string__plus(builtin__string__plus(_S("Call p."), fn_name), _S("() after you have called p.run()")));
		VUNREACHABLE();
	}
}
VV_LOC void os__Process__signal_stop(os__Process* p) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		os__Process_unix_stop_process(p);
	}
	#endif
}
VV_LOC void os__Process__signal_continue(os__Process* p) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		os__Process_unix_resume_process(p);
	}
	#endif
}
VV_LOC void os__Process__signal_kill(os__Process* p) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		os__Process_unix_kill_process(p);
	}
	#endif
}
VV_LOC void os__Process__signal_term(os__Process* p) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		os__Process_unix_term_process(p);
	}
	#endif
}
VV_LOC void os__Process__signal_pgkill(os__Process* p) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		os__Process_unix_kill_pgroup(p);
	}
	#endif
}
VV_LOC void os__Process__wait(os__Process* p) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		os__Process_unix_wait(p);
	}
	#endif
}
VV_LOC bool os__Process__is_alive(os__Process* p) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		return os__Process_unix_is_alive(p);
	}
	#endif
	return 0;
}
void os__Process_run(os__Process* p) {
	if (p->status != os__ProcessState__not_started) {
		return;
	}
	os__Process__spawn(p);
}
os__Process* os__new_process(string filename) {
	return ((os__Process*)builtin__memdup(&(os__Process){.filename = filename,.pid = 0,.code = -1,.status = os__ProcessState__not_started,.err = (string){.str=(byteptr)"", .is_lit=1},.args = builtin____new_array(0, 0, sizeof(string)),.work_folder = (string){.str=(byteptr)"", .is_lit=1},.env_is_custom = 0,.env = builtin____new_array(0, 0, sizeof(string)),.use_stdio_ctl = 0,.use_pgroup = 0,.stdio_fd = {-1, -1, -1},.wdata = 0,.create_no_window = 0,}, sizeof(os__Process)));
}
void os__Process_set_args(os__Process* p, Array_string pargs) {
	if (p->status != os__ProcessState__not_started) {
		return;
	}
	p->args = pargs;
	return;
}
void os__Process_set_work_folder(os__Process* p, string path) {
	if (p->status != os__ProcessState__not_started) {
		return;
	}
	p->work_folder = os__real_path(path);
	return;
}
void os__Process_set_environment(os__Process* p, Map_string_string envs) {
	if (p->status != os__ProcessState__not_started) {
		return;
	}
	p->env_is_custom = true;
	p->env = builtin____new_array_with_default(0, 0, sizeof(string), 0);
	int _t2 = envs.key_values.len;
	for (int _t1 = 0; _t1 < _t2; ++_t1 ) {
		int _t3 = envs.key_values.len - _t2;
		_t2 = envs.key_values.len;
		if (_t3 < 0) {
			_t1 = -1;
			continue;
		}
		if (!builtin__DenseArray_has_index(&envs.key_values, _t1)) {continue;}
		string k = *(string*)builtin__DenseArray_key(&envs.key_values, _t1);
		k = builtin__string_clone(k);
		string v = (*(string*)builtin__DenseArray_value(&envs.key_values, _t1));
		builtin__array_push((array*)&p->env, _MOV((string[]){ builtin__str_intp(3, _MOV((StrIntpData[]){{_SLIT0, 0xfe10, {.d_s = k}}, {_S("="), 0xfe10, {.d_s = v}}, {_SLIT0, 0, { .d_c = 0 }}})) }));
	}
	return;
}
VV_LOC int os__Process_unix_spawn_process(os__Process* p) {
	Array_fixed_int_6 pipeset = {0};
	if (p->use_stdio_ctl) {
		i32 dont_care = pipe(&pipeset[0]);
		dont_care = pipe(&pipeset[2]);
		dont_care = pipe(&pipeset[4]);
		{i32 _ = dont_care;}
		;
	}
	int pid = os__fork();
	if (pid != 0) {
		if (p->use_stdio_ctl) {
			p->stdio_fd[0] = pipeset[1];
			p->stdio_fd[1] = pipeset[2];
			p->stdio_fd[2] = pipeset[4];
			os__fd_close(pipeset[0]);
			os__fd_close(pipeset[3]);
			os__fd_close(pipeset[5]);
		}
		return pid;
	}
	if (p->use_pgroup) {
		setpgid(0, 0);
	}
	if (p->use_stdio_ctl) {
		os__fd_close(pipeset[1]);
		os__fd_close(pipeset[2]);
		os__fd_close(pipeset[4]);
		dup2(pipeset[0], 0);
		dup2(pipeset[3], 1);
		dup2(pipeset[5], 2);
		os__fd_close(pipeset[0]);
		os__fd_close(pipeset[3]);
		os__fd_close(pipeset[5]);
	}
	if ((p->work_folder).len != 0) {
		if (!os__is_abs_path(p->filename)) {
			p->filename = os__abs_path(p->filename);
		}
		_result_void _t2 = os__chdir(p->work_folder);
		(void)_t2;
 ;
	}
	_result_void _t3 = os__execve(p->filename, p->args, p->env);
	if (_t3.is_error) {
		IError err = _t3.err;
		builtin__eprintln(builtin__IError_str(err));
		builtin___v_exit(1);
		VUNREACHABLE();
	;
	}
	
 ;
	return 0;
}
VV_LOC void os__Process_unix_stop_process(os__Process* p) {
	kill(p->pid, SIGSTOP);
}
VV_LOC void os__Process_unix_resume_process(os__Process* p) {
	kill(p->pid, SIGCONT);
}
VV_LOC void os__Process_unix_term_process(os__Process* p) {
	kill(p->pid, SIGTERM);
}
VV_LOC void os__Process_unix_kill_process(os__Process* p) {
	kill(p->pid, SIGKILL);
}
VV_LOC void os__Process_unix_kill_pgroup(os__Process* p) {
	kill(-p->pid, SIGKILL);
}
VV_LOC void os__Process_unix_wait(os__Process* p) {
	os__Process_impl_check_pid_status(p, false, 0);
}
VV_LOC bool os__Process_unix_is_alive(os__Process* p) {
	return os__Process_impl_check_pid_status(p, true, WNOHANG);
}
VV_LOC bool os__Process_impl_check_pid_status(os__Process* p, bool exit_early_on_ret0, int waitpid_options) {
	int cstatus = 0;
	int ret = -1;
	#if !defined(CUSTOM_DEFINE_emscripten)
	{
		ret = waitpid(p->pid, &cstatus, waitpid_options);
	}
	#endif
	p->code = ret;
	if (ret == -1) {
		p->err = os__posix_get_error_msg(errno);
		return false;
	}
	if (exit_early_on_ret0 && ret == 0) {
		return true;
	}
	multi_return_int_bool mr_3008 = os__posix_wait4_to_exit_status(cstatus);
	int pret = mr_3008.arg0;
	bool is_signaled = mr_3008.arg1;
	if (is_signaled) {
		p->status = os__ProcessState__aborted;
		p->err = builtin__str_intp(3, _MOV((StrIntpData[]){{_S("Terminated by signal "), 0x4fe27, {.d_i32 = pret}}, {_S(" ("), 0xfe10, {.d_s = os__sigint_to_signal_name(pret)}}, {_S(")"), 0, { .d_c = 0 }}}));
		pret += 128;
	} else {
		p->status = os__ProcessState__exited;
	}
	p->code = pret;
	return false;
}
_result_anon_fn_os__signal os__signal_opt(os__Signal signum, void (*handler)(os__Signal )) {
	errno = 0;
	voidptr prev_handler = signal(((int)(signum)), (voidptr)handler);
	if (prev_handler == SIG_ERR) {
		return (_result_anon_fn_os__signal){ .is_error=true, .err=builtin__error_with_code(os__posix_get_error_msg(EINVAL), EINVAL), .data={E_STRUCT} };
	}
	_result_anon_fn_os__signal _t2;
	builtin___result_ok(&(os__SignalHandler[]) { (voidptr)((os__SignalHandler)(prev_handler)) }, (_result*)(&_t2), sizeof(os__SignalHandler));
	 
	return _t2;
}
VV_LOC void os__ignore_signal_handler(os__Signal _signal) {
}
void os__signal_ignore(Array_os__Signal args) {
	if (os__is_main_thread()) {
		#if !defined(_WIN32)
		{
			for (int _t2 = 0; _t2 < args.len; ++_t2) {
				os__Signal arg = ((os__Signal*)args.data)[_t2];
				_result_anon_fn_os__signal _t3 = os__signal_opt(arg, (voidptr)os__ignore_signal_handler);
				(void)_t3;
 ;
			}
		}
		#endif
	} else {
		os__signal_ignore_internal(args);
	}
}
bool os__is_main_thread(void) {
	return g_main_thread_id == ((u64)(pthread_self()));
}
VV_LOC void os__signal_ignore_internal(Array_os__Signal args) {
	u32 mask1 = ((u32)(0));
	sigemptyset(&mask1);
	for (int _t1 = 0; _t1 < args.len; ++_t1) {
		os__Signal arg = ((os__Signal*)args.data)[_t1];
		sigaddset(&mask1, ((int)(arg)));
	}
	sigprocmask(SIG_BLOCK, &mask1, ((void*)0));
}
VV_LOC void os__sleep_ms(i64 ms) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		struct timespec req = ((struct timespec){.tv_sec = (i64)(ms / 1000),.tv_nsec = (i64)(1000000 * ((i64)(ms % 1000))),});
		struct timespec rem = ((struct timespec){.tv_sec = 0,.tv_nsec = 0,});
		for (;;) {
			if (!(nanosleep(&req, &rem) < 0)) break;
			if (errno == EINTR) {
				req = rem;
			} else {
				break;
			}
		}
	}
	#endif
}
_result_void os__open_uri(string uri) {
	string vopen_uri_cmd = os__getenv(_S("VOPEN_URI_CMD"));
	if ((vopen_uri_cmd).len == 0) {
		#if defined(__APPLE__)
		{
			vopen_uri_cmd = _S("open");
		}
		#elif defined(__FreeBSD__) || defined(__OpenBSD__)
		{
		}
		#elif defined(__linux__)
		{
		}
		#endif
	}
	if ((vopen_uri_cmd).len == 0) {
		return (_result_void){ .is_error=true, .err=builtin___v_error(_S("unsupported platform")), .data={E_STRUCT} };
	}
	os__Result result = os__execute(builtin__str_intp(3, _MOV((StrIntpData[]){{_SLIT0, 0xfe10, {.d_s = vopen_uri_cmd}}, {_S(" \""), 0xfe10, {.d_s = uri}}, {_S("\""), 0, { .d_c = 0 }}})));
	if (result.exit_code != 0) {
		return (_result_void){ .is_error=true, .err=builtin___v_error(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("unable to open url: "), 0xfe10, {.d_s = result.output}}, {_SLIT0, 0, { .d_c = 0 }}}))), .data={E_STRUCT} };
	}
	return (_result_void){0};
}
_result_os__Stat os__stat(string path) {
	struct stat s;
	{ // Unsafe block
		i32 res = stat(((char*)(path.str)), &s);
		if (res != 0) {
			return (_result_os__Stat){ .is_error=true, .err=os__error_posix(((os__SystemError){.msg = (string){.str=(byteptr)"", .is_lit=1},.code = _const_os__error_code_not_set,})), .data={E_STRUCT} };
		}
		_result_os__Stat _t2;
		builtin___result_ok(&(os__Stat[]) { ((os__Stat){
			.dev = s.st_dev,
			.inode = s.st_ino,
			.mode = s.st_mode,
			.nlink = s.st_nlink,
			.uid = s.st_uid,
			.gid = s.st_gid,
			.rdev = s.st_rdev,
			.size = s.st_size,
			.atime = s.st_atime,
			.mtime = s.st_mtime,
			.ctime = s.st_ctime,
		}) }, (_result*)(&_t2), sizeof(os__Stat));
		 
		return _t2;
	}
	return (_result_os__Stat){0};
}
_result_os__Stat os__lstat(string path) {
	struct stat s;
	{ // Unsafe block
		i32 res = lstat(((char*)(path.str)), &s);
		if (res != 0) {
			return (_result_os__Stat){ .is_error=true, .err=os__error_posix(((os__SystemError){.msg = (string){.str=(byteptr)"", .is_lit=1},.code = _const_os__error_code_not_set,})), .data={E_STRUCT} };
		}
		_result_os__Stat _t2;
		builtin___result_ok(&(os__Stat[]) { ((os__Stat){
			.dev = s.st_dev,
			.inode = s.st_ino,
			.mode = s.st_mode,
			.nlink = s.st_nlink,
			.uid = s.st_uid,
			.gid = s.st_gid,
			.rdev = s.st_rdev,
			.size = s.st_size,
			.atime = s.st_atime,
			.mtime = s.st_mtime,
			.ctime = s.st_ctime,
		}) }, (_result*)(&_t2), sizeof(os__Stat));
		 
		return _t2;
	}
	return (_result_os__Stat){0};
}
os__FileType os__Stat_get_filetype(os__Stat st) {
	u32 _t1 = (st.mode & ((u32)(S_IFMT)));
	
	if (_t1 == (((u32)(S_IFREG)))) {
		return os__FileType__regular;
	}
	else if (_t1 == (((u32)(S_IFDIR)))) {
		return os__FileType__directory;
	}
	else if (_t1 == (((u32)(S_IFCHR)))) {
		return os__FileType__character_device;
	}
	else if (_t1 == (((u32)(S_IFBLK)))) {
		return os__FileType__block_device;
	}
	else if (_t1 == (((u32)(S_IFIFO)))) {
		return os__FileType__fifo;
	}
	else if (_t1 == (((u32)(S_IFLNK)))) {
		return os__FileType__symbolic_link;
	}
	else if (_t1 == (((u32)(S_IFSOCK)))) {
		return os__FileType__socket;
	}
	else {
		return os__FileType__unknown;
	}
	return 0;
}
os__FileMode os__Stat_get_mode(os__Stat st) {
	return ((os__FileMode){.typ = os__Stat_get_filetype(st),.owner = ((os__FilePermission){.read = ((st.mode & ((u32)(S_IRUSR)))) != 0,.write = ((st.mode & ((u32)(S_IWUSR)))) != 0,.execute = ((st.mode & ((u32)(S_IXUSR)))) != 0,}),.group = ((os__FilePermission){.read = ((st.mode & ((u32)(S_IRGRP)))) != 0,.write = ((st.mode & ((u32)(S_IWGRP)))) != 0,.execute = ((st.mode & ((u32)(S_IXGRP)))) != 0,}),.others = ((os__FilePermission){.read = ((st.mode & ((u32)(S_IROTH)))) != 0,.write = ((st.mode & ((u32)(S_IWOTH)))) != 0,.execute = ((st.mode & ((u32)(S_IXOTH)))) != 0,}),});
}
bool os__is_dir(string path) {
	_result_os__Stat _t1 = os__stat(path);
	if (_t1.is_error) {
		return false;
	}
	
 	os__Stat attr = (*(os__Stat*)_t1.data);
	return os__Stat_get_filetype(attr) == os__FileType__directory;
}
bool os__is_link(string path) {
	_result_os__Stat _t1 = os__lstat(path);
	if (_t1.is_error) {
		return false;
	}
	
 	os__Stat attr = (*(os__Stat*)_t1.data);
	return os__Stat_get_filetype(attr) == os__FileType__symbolic_link;
}
VV_LOC os__PathKind os__kind_of_existing_path(string path) {
	os__PathKind res = ((os__PathKind){.is_file = 0,.is_dir = 0,.is_link = 0,});
	_result_os__Stat _t1 = os__lstat(path);
	if (_t1.is_error) {
		return res;
	}
	
 	os__Stat attr = (*(os__Stat*)_t1.data);
	res.is_file = os__Stat_get_filetype(attr) == os__FileType__regular;
	res.is_dir = os__Stat_get_filetype(attr) == os__FileType__directory;
	res.is_link = os__Stat_get_filetype(attr) == os__FileType__symbolic_link;
	return res;
}
VV_LOC void main__vphp_task_auto_startup(void) {
	vphp__ITask__static__register(_S("AnalyzeTask"), (voidptr)	anon_fn_e0873e5963f3179a_40___vphp__ITask_146);
}
// export alias: vphp_task_auto_startup -> main__vphp_task_auto_startup
void vphp_task_auto_startup(void) {
	return main__vphp_task_auto_startup();
}
VV_LOC void main__main(void) {
	string target_file = _S("v_logic.v");
	builtin__println(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("\360\237\233\240\357\270\217  1. \350\277\220\350\241\214 Codegen\357\274\214\347\233\256\346\240\207\346\226\207\344\273\266: "), 0xfe10, {.d_s = target_file}}, {_S(" ..."), 0, { .d_c = 0 }}})));
	os__Result gen_res = os__execute(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("v run tools/codegen.v "), 0xfe10, {.d_s = target_file}}, {_SLIT0, 0, { .d_c = 0 }}})));
	if (gen_res.exit_code != 0) {
		builtin__println(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("\342\235\214 Codegen \345\244\261\350\264\245: "), 0xfe10, {.d_s = gen_res.output}}, {_SLIT0, 0, { .d_c = 0 }}})));
		return;
	}
	builtin__println(_S("\360\237\233\240\357\270\217  2. \350\275\254\350\257\221 V \351\200\273\350\276\221..."));
	os__Result v_res = os__execute(_S("v -enable-globals -gc none -path \"@vlib:.:..\" -shared -o v_logic.c ."));
	if (v_res.exit_code != 0) {
		builtin__println(builtin__string__plus(_S("\342\235\214 V \347\274\226\350\257\221\345\244\261\350\264\245: "), v_res.output));
		return;
	}
	builtin__println(_S("\360\237\233\240\357\270\217  3. GCC \346\234\200\347\273\210\351\223\276\346\216\245..."));
	string php_inc = builtin__string_trim_space(os__execute(_S("php-config --includes")).output);
	string php_ldflags = builtin__string_trim_space(os__execute(_S("php-config --ldflags")).output);
	string php_libs = builtin__string_trim_space(builtin__string_replace(os__execute(_S("php-config --libs")).output, _S("-lzip"), _S("")));
	string gcc_cmd = builtin__string__plus(builtin__string__plus(builtin__string__plus(_S("gcc -shared -fPIC -DCOMPILE_DL_V_PHP_EXT=1 "), builtin__str_intp(2, _MOV((StrIntpData[]){{_SLIT0, 0xfe10, {.d_s = php_inc}}, {_S(" v_logic.c php_bridge.c ../vphp/v_bridge.c -o v_php_ext.so "), 0, { .d_c = 0 }}}))), _S("-I../vphp ")), builtin__str_intp(3, _MOV((StrIntpData[]){{_SLIT0, 0xfe10, {.d_s = php_ldflags}}, {_S(" "), 0xfe10, {.d_s = php_libs}}, {_S(" -undefined dynamic_lookup -fvisibility=default"), 0, { .d_c = 0 }}})));
	if (os__system(gcc_cmd) != 0) {
		builtin__eprintln(_S("\342\235\214 GCC \347\274\226\350\257\221\345\244\261\350\264\245"));
		return;
	}
	builtin__println(_S("\342\234\205 \346\236\204\345\273\272\346\210\220\345\212\237\357\274\201v_php_ext.so \345\267\262\345\260\261\347\273\252\343\200\202"));
}
VV_LOC void main__v_reverse_string(zval* z_in, zval* z_out) {
	{ // Unsafe block
		vphp__Val in_val = ((vphp__Val){.raw = z_in,});
		vphp__Val out_val = ((vphp__Val){.raw = z_out,});
		string s = vphp__Val_to_string(in_val);
		if ((s).len == 0) {
			vphp__throw_exception(_S("String is empty!"), 400);
			return;
		}
		vphp__Val_set_string(out_val, builtin__string_reverse(s));
	}
}
// export alias: v_reverse_string -> main__v_reverse_string
void v_reverse_string(zval* z_in, zval* z_out) {
	return main__v_reverse_string(z_in, z_out);
}
VV_LOC void main__v_logic_main(zend_execute_data* ex, zval* retval) {
	{ // Unsafe block
		Array_vphp__Val args = vphp__get_args(ex);
		if (args.len < 1) {
			vphp__throw_exception(_S("\350\207\263\345\260\221\351\234\200\350\246\201\344\270\200\344\270\252\345\217\202\346\225\260"), 400);
			return;
		}
		string main_str = vphp__Val_to_string((*(vphp__Val*)builtin__array_get(args, 0)));
		int repeat_count = 1;
		if (args.len >= 2) {
			repeat_count = ((int)(vphp__Val_as_int((*(vphp__Val*)builtin__array_get(args, 1)))));
		}
		string res = builtin__string_reverse(builtin__string_repeat(main_str, repeat_count));
		vphp__Val out = ((vphp__Val){.raw = retval,});
		vphp__Val_set_string(out, res);
	}
}
// export alias: v_logic_main -> main__v_logic_main
void v_logic_main(zend_execute_data* ex, zval* retval) {
	return main__v_logic_main(ex, retval);
}
VV_LOC void main__v_add(zend_execute_data* ex, zval* retval) {
	vphp__Context ctx = vphp__new_context(ex, retval);
	i64 a = vphp__Context_arg_T_i64(ctx, 0);
	i64 b = vphp__Context_arg_T_i64(ctx, 1);
	vphp__return_val_T_i64(ctx, (i64)(a + b));
}
// export alias: v_add -> main__v_add
void v_add(zend_execute_data* ex, zval* retval) {
	return main__v_add(ex, retval);
}
VV_LOC void main__v_greet(zend_execute_data* ex, zval* retval) {
	vphp__Context ctx = vphp__new_context(ex, retval);
	string name = vphp__Context_arg_T_string(ctx, 0);
	vphp__return_val_T_string(ctx, builtin__str_intp(2, _MOV((StrIntpData[]){{_S("Hello, "), 0xfe10, {.d_s = name}}, {_S(" from V!"), 0, { .d_c = 0 }}})));
}
// export alias: v_greet -> main__v_greet
void v_greet(zend_execute_data* ex, zval* retval) {
	return main__v_greet(ex, retval);
}
VV_LOC void main__v_process_list(zend_execute_data* ex, zval* retval) {
	vphp__Context ctx = vphp__new_context(ex, retval);
	Array_string input_list = vphp__Context_arg_T_Array_string(ctx, 0);
	{ // Unsafe block
		vphp_array_init(retval);
		for (int i = (int)(input_list.len - 1); i >= 0; i--) {
			string val = (*(string*)builtin__array_get(input_list, i));
			vphp_array_push_string(retval, ((char*)(val.str)));
		}
	}
}
// export alias: v_process_list -> main__v_process_list
void v_process_list(zend_execute_data* ex, zval* retval) {
	return main__v_process_list(ex, retval);
}
VV_LOC void main__v_test_map(zend_execute_data* ex, zval* retval) {
	vphp__Context ctx = vphp__new_context(ex, retval);
	Map_string_string config = vphp__Context_arg_T_Map_string_string(ctx, 0);
	if (_IN_MAP(ADDR(string, _S("name")), ADDR(map, config))) {
		builtin__println(builtin__string__plus(_S("Received name: "), (*(string*)builtin__map_get(ADDR(map, config), &(string[]){_S("name")}, &(string[]){ (string){.str=(byteptr)"", .is_lit=1} }))));
	}
	vphp__Context_return_string(ctx, builtin__str_intp(2, _MOV((StrIntpData[]){{_S("Map processed, keys: "), 0xfe10, {.d_s = Array_string_str(builtin__map_keys(&config))}}, {_SLIT0, 0, { .d_c = 0 }}})));
}
// export alias: v_test_map -> main__v_test_map
void v_test_map(zend_execute_data* ex, zval* retval) {
	return main__v_test_map(ex, retval);
}
VV_LOC void main__v_get_config(zend_execute_data* ex, zval* retval) {
	vphp__Context ctx = vphp__new_context(ex, retval);
	vphp__Val input = vphp__Context_arg_raw(ctx, 0);
	_result_vphp__Val _t1 = vphp__Val_get(input, _S("db_name"));
	if (_t1.is_error) {
		vphp__report_error(_const_vphp__e_warning, _S("db_name is missing, using default"));
		vphp__Context_return_string(ctx, _S("bullsoft_db"));
		return;
	}
	
 	vphp__Val db_val = (*(vphp__Val*)_t1.data);
	vphp__Context_return_string(ctx, vphp__Val_to_string(db_val));
}
// export alias: v_get_config -> main__v_get_config
void v_get_config(zend_execute_data* ex, zval* retval) {
	return main__v_get_config(ex, retval);
}
VV_LOC void main__v_get_user(zend_execute_data* ex, zval* retval) {
	vphp__Context ctx = vphp__new_context(ex, retval);
	vphp__Val raw_id = vphp__Context_arg_raw(ctx, 0);
	builtin__println(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("DEBUG: PHP ID Type: "), 0xfe07, {.d_i32 = vphp__Val_type_id(raw_id)}}, {_SLIT0, 0, { .d_c = 0 }}})));
	i64 user_id = vphp__Context_arg_T_i64(ctx, 0);
	Map_string_string user_data = builtin__new_map(sizeof(string), sizeof(string), &builtin__map_hash_string, &builtin__map_eq_string, &builtin__map_clone_string, &builtin__map_free_string)
	;
	builtin__map_set(&user_data, &(string[]){_S("id")}, &(string[]) { builtin__i64_str(user_id) });
	builtin__map_set(&user_data, &(string[]){_S("name")}, &(string[]) { _S("Gu Weigang") });
	builtin__map_set(&user_data, &(string[]){_S("role")}, &(string[]) { _S("Developer") });
	builtin__map_set(&user_data, &(string[]){_S("company")}, &(string[]) { _S("Bullsoft") });
	vphp__Context_return_object(ctx, user_data);
}
// export alias: v_get_user -> main__v_get_user
void v_get_user(zend_execute_data* ex, zval* retval) {
	return main__v_get_user(ex, retval);
}
VV_LOC void main__v_call_back(zend_execute_data* ex, zval* retval) {
	vphp__Context ctx = vphp__new_context(ex, retval);
	vphp__Val php_version = vphp__call_php(_S("phpversion"), builtin____new_array_with_default(0, 0, sizeof(vphp__Val), 0));
	vphp__Context_return_string(ctx, builtin__string__plus(_S("V knows PHP version is: "), vphp__Val_to_string(php_version)));
}
// export alias: v_call_back -> main__v_call_back
void v_call_back(zend_execute_data* ex, zval* retval) {
	return main__v_call_back(ex, retval);
}
VV_LOC void main__v_new_coach(zend_execute_data* ex, zval* retval) {
	vphp__Context ctx = vphp__new_context(ex, retval);
	{ // Unsafe block
		u8* p = builtin___v_malloc(sizeof(main__Coach));
		main__Coach* c = ((main__Coach*)(p));
		c->name = _S("Bullsoft_Master");
		vphp__Context_return_res(ctx, p, _S("coach"));
	}
}
// export alias: v_new_coach -> main__v_new_coach
void v_new_coach(zend_execute_data* ex, zval* retval) {
	return main__v_new_coach(ex, retval);
}
VV_LOC void main__v_new_db(zend_execute_data* ex, zval* retval) {
	vphp__Context ctx = vphp__new_context(ex, retval);
	{ // Unsafe block
		u8* p = builtin___v_malloc(sizeof(main__Database));
		main__Database* db = ((main__Database*)(p));
		db->connected = true;
		vphp__Context_return_res(ctx, p, _S("db"));
	}
}
// export alias: v_new_db -> main__v_new_db
void v_new_db(zend_execute_data* ex, zval* retval) {
	return main__v_new_db(ex, retval);
}
VV_LOC void main__v_check_res(zend_execute_data* ex, zval* retval) {
	vphp__Context ctx = vphp__new_context(ex, retval);
	vphp__Val res_val = vphp__Context_arg_raw(ctx, 0);
	{ // Unsafe block
		voidptr ptr = vphp__Val_to_res(res_val);
		if (ptr == ((void*)0)) {
			vphp__Context_return_string(ctx, _S("Invalid Resource"));
			return;
		}
		main__Coach* coach = ((main__Coach*)(ptr));
		vphp__Context_return_string(ctx, builtin__string__plus(_S("Hello, "), coach->name));
	}
}
// export alias: v_check_res -> main__v_check_res
void v_check_res(zend_execute_data* ex, zval* retval) {
	return main__v_check_res(ex, retval);
}
VV_LOC void main__v_analyze_fitness_data(zend_execute_data* ex, zval* retval) {
	vphp__Context ctx = vphp__new_context(ex, retval);
	string name = vphp__Context_arg_T_string(ctx, 0);
	Array_f64 hr_data = vphp__Context_arg_T_Array_f64(ctx, 1);
	Map_string_string config = vphp__Context_arg_T_Map_string_string(ctx, 2);
	if (vphp__Context_has_exception(ctx)) {
		return;
	}
	if (hr_data.len == 0) {
		vphp__Context_return_string(ctx, _S("Error: No heart rate data provided"));
		return;
	}
	f64 total = 0.0;
	f64 max = 0.0;
	f64 min = (*(f64*)builtin__array_get(hr_data, 0));
	for (int _t1 = 0; _t1 < hr_data.len; ++_t1) {
		f64 hr = ((f64*)hr_data.data)[_t1];
		total += hr;
		if (hr > max) {
			max = hr;
		}
		if (hr < min) {
			min = hr;
		}
	}
	f64 avg = (f64)(total / ((f64)(hr_data.len)));
	string* _t3 = (string*)(builtin__map_get_check(ADDR(map, config), &(string[]){_S("mode")}));
	_option_string _t2 = {0};
	if (_t3) {
		*((string*)&_t2.data) = *((string*)_t3);
	} else {
		_t2.state = 2; _t2.err = builtin___v_error(_S("map key does not exist"));
	}
	;
	if (_t2.state != 0) {
		*(string*) _t2.data = _S("standard");
	}
	
	string mode = (*(string*)_t2.data);
	string risk = _S("Low");
	if (max > 170) {
		risk = _S("High Risk");
	}
	main__MotionReport report = ((main__MotionReport){
		.user_name = name,
		.max_hr = max,
		.min_hr = min,
		.avg_hr = avg,
		.risk_level = risk,
		.device_mode = mode,
	});
	vphp__Context_return_struct_T_main__MotionReport(ctx, report);
}
// export alias: v_analyze_fitness_data -> main__v_analyze_fitness_data
void v_analyze_fitness_data(zend_execute_data* ex, zval* retval) {
	return main__v_analyze_fitness_data(ex, retval);
}
VV_LOC void main__v_get_alerts(zend_execute_data* ex, zval* retval) {
	vphp__Context ctx = vphp__new_context(ex, retval);
	Array_main__HeartPoint alerts = builtin____new_array_with_default(0, 0, sizeof(main__HeartPoint), 0);
	builtin__array_push((array*)&alerts, _MOV((main__HeartPoint[]){ ((main__HeartPoint){.timestamp = 1677481200,.hr = 155.0,}) }));
	builtin__array_push((array*)&alerts, _MOV((main__HeartPoint[]){ ((main__HeartPoint){.timestamp = 1677481260,.hr = 162.5,}) }));
	vphp__Context_return_list_T_main__HeartPoint(ctx, alerts);
}
// export alias: v_get_alerts -> main__v_get_alerts
void v_get_alerts(zend_execute_data* ex, zval* retval) {
	return main__v_get_alerts(ex, retval);
}
VV_LOC void main__v_complex_test(zend_execute_data* ex, zval* retval) {
	vphp__Context ctx = vphp__new_context(ex, retval);
	string s = vphp__Context_arg_T_string(ctx, 0);
	int i = vphp__Context_arg_T_int(ctx, 1);
	bool b = vphp__Context_arg_T_bool(ctx, 2);
	Array_f64 list = vphp__Context_arg_T_Array_f64(ctx, 3);
	if (vphp__Context_has_exception(ctx)) {
		return;
	}
	Map_string_string res = builtin__new_map(sizeof(string), sizeof(string), &builtin__map_hash_string, &builtin__map_eq_string, &builtin__map_clone_string, &builtin__map_free_string)
	;
	builtin__map_set(&res, &(string[]){_S("str_val")}, &(string[]) { s });
	builtin__map_set(&res, &(string[]){_S("int_val")}, &(string[]) { builtin__int_str(i) });
	builtin__map_set(&res, &(string[]){_S("bool_val")}, &(string[]) { builtin__bool_str(b) });
	builtin__map_set(&res, &(string[]){_S("list_len")}, &(string[]) { builtin__int_str(list.len) });
	vphp__Context_return_map(ctx, res);
}
// export alias: v_complex_test -> main__v_complex_test
void v_complex_test(zend_execute_data* ex, zval* retval) {
	return main__v_complex_test(ex, retval);
}
VV_LOC void main__v_analyze_user_object(zend_execute_data* ex, zval* retval) {
	vphp__Context ctx = vphp__new_context(ex, retval);
	vphp__Val user_obj = vphp__Context_arg_raw(ctx, 0);
	if (!vphp__Val_is_object(user_obj)) {
		vphp__throw_exception(builtin__str_intp(2, _MOV((StrIntpData[]){{_S("Expected object, got "), 0xfe10, {.d_s = vphp__Val_type_name(user_obj)}}, {_SLIT0, 0, { .d_c = 0 }}})), 0);
		return;
	}
	string name = vphp__Val_get_prop_string(user_obj, _S("name"));
	int age = vphp__Val_get_prop_int(user_obj, _S("age"));
	if (vphp__Context_has_exception(ctx)) {
		return;
	}
	string res_msg = builtin__str_intp(3, _MOV((StrIntpData[]){{_S("V \344\276\247\346\224\266\345\210\260\345\257\271\350\261\241\346\225\260\346\215\256\357\274\232\345\247\223\345\220\215="), 0xfe10, {.d_s = name}}, {_S(", \345\271\264\351\276\204="), 0xfe07, {.d_i32 = age}}, {_SLIT0, 0, { .d_c = 0 }}}));
	vphp__Context_return_string(ctx, res_msg);
}
// export alias: v_analyze_user_object -> main__v_analyze_user_object
void v_analyze_user_object(zend_execute_data* ex, zval* retval) {
	return main__v_analyze_user_object(ex, retval);
}
VV_LOC void main__v_trigger_user_action(zend_execute_data* ex, zval* retval) {
	vphp__Context ctx = vphp__new_context(ex, retval);
	vphp__Val user_obj = vphp__Context_arg_raw(ctx, 0);
	if (!vphp__Val_is_object(user_obj)) {
		vphp__throw_exception(_S("\351\234\200\350\246\201 User \345\257\271\350\261\241"), 0);
		return;
	}
	vphp__Val score_val = ((vphp__Val){.raw = vphp_new_zval(),});
	vphp__Val_set_int(score_val, 100);
	vphp__Val res = vphp__Val_call(user_obj, _S("updateScore"), builtin__new_array_from_c_array(1, 1, sizeof(vphp__Val), _MOV((vphp__Val[1]){score_val})));
	if (vphp__Context_has_exception(ctx)) {
		return;
	}
	vphp__Context_return_string(ctx, builtin__string__plus(_S("Action triggered, PHP returned: "), vphp__Val_to_string(res)));
}
// export alias: v_trigger_user_action -> main__v_trigger_user_action
void v_trigger_user_action(zend_execute_data* ex, zval* retval) {
	return main__v_trigger_user_action(ex, retval);
}
VV_LOC void main__v_call_php_closure(zend_execute_data* ex, zval* retval) {
	vphp__Context ctx = vphp__new_context(ex, retval);
	vphp__Val cb = vphp__Context_arg_raw(ctx, 0);
	vphp__Val msg = ((vphp__Val){.raw = vphp_new_zval(),});
	vphp__Val_set_string(msg, _S("Message from V Engine"));
	vphp__Val res = vphp__Val_invoke(cb, builtin__new_array_from_c_array(1, 1, sizeof(vphp__Val), _MOV((vphp__Val[1]){msg})));
	if (vphp__Context_has_exception(ctx)) {
		return;
	}
	vphp__Context_return_string(ctx, builtin__string__plus(_S("Closure executed, PHP said: "), vphp__Val_to_string(res)));
}
// export alias: v_call_php_closure -> main__v_call_php_closure
void v_call_php_closure(zend_execute_data* ex, zval* retval) {
	return main__v_call_php_closure(ex, retval);
}
VV_LOC Array_f64 main__AnalyzeTask_run(main__AnalyzeTask t) {
	return builtin__new_array_from_c_array(3, 3, sizeof(f64), _MOV((f64[3]){1.1, 2.2, 3.3}));
}
void _vinit(int ___argc, voidptr ___argv) {
	// Initializations of consts for module builtin.closure
	g_closure = ((builtin__closure__Closure){.ClosureMutex = ((builtin__closure__ClosureMutex){E_STRUCT}),.closure_ptr = 0,.closure_get_data = ((void*)0),.closure_cap = 0,.v_page_size = ((int)(0x4000)),}); // global 3
{
{
Array_fixed_u8_12 _t1;
#if defined(__V_amd64)
#elif defined(__V_x86)
#elif defined(__V_arm64)
	{ Array_fixed_u8_12 _t2 = {((u8)(0x11)), 0x00, 0xFE, 0x5C, 0x30, 0x00, 0xFE, 0x58, 0x00, 0x02, 0x1F, 0xD6}	;
	memcpy(&_t1, &_t2, sizeof(Array_fixed_u8_12));
	}
	;
#elif defined(__V_arm32)
#elif defined(__V_rv64)
#elif defined(__V_rv32)
#elif defined(__V_s390x)
#elif defined(__V_ppc64le)
#elif defined(__V_loongarch64)
#else
#endif
	memcpy(&_const_builtin__closure__closure_thunk, &_t1, sizeof(Array_fixed_u8_12));
}
}
{
{
Array_fixed_u8_8 _t3;
#if defined(__V_amd64)
#elif defined(__V_x86)
#elif defined(__V_arm64)
	{ Array_fixed_u8_8 _t4 = {((u8)(0x20)), 0x02, 0x66, 0x9E, 0xC0, 0x03, 0x5F, 0xD6}	;
	memcpy(&_t3, &_t4, sizeof(Array_fixed_u8_8));
	}
	;
#elif defined(__V_arm32)
#elif defined(__V_rv64)
#elif defined(__V_rv32)
#elif defined(__V_s390x)
#elif defined(__V_ppc64le)
#elif defined(__V_loongarch64)
#else
#endif
	memcpy(&_const_builtin__closure__closure_get_data_bytes, &_t3, sizeof(Array_fixed_u8_8));
}
}
{
{
	_const_builtin__closure__closure_size_1 = ((u32)(2 * ((u32)(sizeof(voidptr)))) > ((u32)(12)) ? ((u32)(2 * ((u32)(sizeof(voidptr))))) : ((u32)((u32)(((u32)(12)) + ((u32)(sizeof(voidptr)))) - 1)));
}
}
	_const_builtin__closure__closure_size = ((int)((_const_builtin__closure__closure_size_1 & ~((u32)(((u32)(sizeof(voidptr))) - 1)))));
	// Initializations of consts for module math.bits
	_const_math__bits__overflow_error = _S("Overflow Error");
	// Initializations of consts for module strconv
	_const_strconv__digit_pairs = _S("00102030405060708090011121314151617181910212223242526272829203132333435363738393041424344454647484940515253545556575859506162636465666768696071727374757677787970818283848586878889809192939495969798999");
	_const_strconv__base_digits = _S("0123456789abcdefghijklmnopqrstuvwxyz");
	_const_strconv__i64_min_int32 = (i64)(((i64)(-2147483647)) - 1);
	_const_strconv__i64_max_int32 = (i64)(((i64)(2147483646)) + 1);
	// Initializations of consts for module builtin
	_const_digit_pairs = _S("00102030405060708090011121314151617181910212223242526272829203132333435363738393041424344454647484940515253545556575859506162636465666768696071727374757677787970818283848586878889809192939495969798999");
	_const_si_s_code = _S("0xfe10");
	_const_si_g32_code = _S("0xfe0e");
	_const_si_g64_code = _S("0xfe0f");
	g_live_reload_info = *(voidptr*)&((voidptr[]){0}[0]); // global 5
	_const_none__ = I_None___to_Interface_IError(((None__*)builtin__memdup(&(None__){.Error = ((Error){E_STRUCT}),}, sizeof(None__))));
	_const_min_i64 = ((i64)((int_literal)(-9223372036854775807LL - 1)));
	_const_max_i64 = ((i64)(9223372036854775807LL));
	// Initializations of consts for module vphp
	g_registry = *(vphp__TaskRegistry**)&((vphp__TaskRegistry*[]){0}[0]); // global 5
	// Initializations of consts for module os
	_const_os__fslash_str = _S("/");
	_const_os__dot_dot = _S("..");
	_const_os__empty_str = _S("");
	_const_os__dot_str = _S(".");
	_const_os__path_separator = _S("/");
	_const_os__path_delimiter = _S(":");
	_const_os__path_devnull = _S("/dev/null");
{
{
	_const_os__o_rdonly = O_RDONLY;
}
}
{
{
	_const_os__o_wronly = O_WRONLY;
}
}
{
{
	_const_os__o_rdwr = O_RDWR;
}
}
{
{
	_const_os__o_create = O_CREAT;
}
}
{
{
	_const_os__o_noctty = O_NOCTTY;
}
}
{
{
	_const_os__o_trunc = O_TRUNC;
}
}
{
{
	_const_os__o_append = O_APPEND;
}
}
{
{
	_const_os__o_nonblock = O_NONBLOCK;
}
}
{
{
	_const_os__o_sync = O_SYNC;
}
}
	_const_os__wd_at_startup = os__getwd();
	_const_os__executable_suffixes = builtin__new_array_from_c_array(1, 1, sizeof(string), _MOV((string[1]){_S("")}));
{
{
int _t1;
#if defined(_WIN32)
#else
	_t1 = STDOUT_FILENO;
	;
#endif
	_const_os__fd_stdout = _t1;
}
}
{
{
int _t2;
#if defined(_WIN32)
#else
	_t2 = STDERR_FILENO;
	;
#endif
	_const_os__fd_stderr = _t2;
}
}
	g_main_thread_id = ((u64)(pthread_self())); // global 3
	_const_os__args = builtin__arguments();
}
void _vcleanup(void) {
}
__attribute__ ((constructor))
void _vinit_caller() {
	static bool once = false; if (once) {return;} once = true;
	_vinit(0,0);
}
__attribute__ ((destructor))
void _vcleanup_caller() {
	static bool once = false; if (once) {return;} once = true;
	_vcleanup();
}

int main(int ___argc, char** ___argv){
	g_main_argc = ___argc;
	g_main_argv = ___argv;
	_vinit(___argc, (voidptr)___argv);
	main__main();
	_vcleanup();
	return 0;
}
// THE END.
