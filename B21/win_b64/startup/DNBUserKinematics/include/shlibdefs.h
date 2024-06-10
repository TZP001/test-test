#ifndef	_SHLIBDEFS_H_
#define _SHLIBDEFS_H_


#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <math.h>
#include "errdefs.h"

/*
 * allow symbols to be exported on the Windows platform
 */
#ifdef WINDOWS_SOURCE
#ifdef __DNBSHLIB_
#define	DNBSHLIBDllExport    __declspec(dllexport)
#else
#define	DNBSHLIBDllExport    __declspec(dllimport)
#endif
#ifdef _DNBUSERLIB
#define	DllExport    __declspec(dllexport)
#else
#define	DllExport    __declspec(dllimport)
#endif
#else
#define	DNBSHLIBDllExport
#define	DllExport
#endif

#define STATUS_OKAY			0
#define STATUS_ERROR			1

#define WARN_GOOD_SOLUTION		0
#define WARN_JOINT_LIMITS_EXCEEDED	1
#define WARN_UNREACHABLE		2
#define WARN_SINGULAR_SOLUTION		5

#define ROTATIONAL			0
#define TRANSLATIONAL			1

#define TRANS_X				13
#define TRANS_Y				14
#define TRANS_Z				15

#define ROTATE_X			16
#define ROTATE_Y			17
#define ROTATE_Z			18

#define  TYPE_UNKNOWN			0
#define  TYPE_ABB_S2			1
#define  TYPE_ABB_S3			2
#define  TYPE_ABB_S4			3
#define  TYPE_ADEPT			4
#define  TYPE_AKR			5
#define  TYPE_BM100			6
#define  TYPE_CINCI			7
#define  TYPE_CIMCORP			8
#define  TYPE_CLOOS			9
#define  TYPE_COMAU			10
#define  TYPE_CYBOTECH			11
#define  TYPE_DAIHEN			12
#define  TYPE_FANUC_RJ			13
#define  TYPE_FANUC_RJ_TPE		14
#define  TYPE_GMF_KAREL			15
#define  TYPE_GMF_RC			16
#define  TYPE_GMF_RF			17
#define  TYPE_GMF_RG			18
#define  TYPE_GMF_RH			19
#define  TYPE_GRACO			20
#define  TYPE_IGM_2			21
#define  TYPE_IGM_3			22
#define  TYPE_KOMATSU			23
#define  TYPE_KUKA			24
#define  TYPE_MOTOMAN_ERC		25
#define  TYPE_MOTOMAN_MRC		26
#define  TYPE_NACHI			27
#define  TYPE_PANASONIC			28
#define  TYPE_SHINMAYWA			29
#define  TYPE_SIEMENS			30
#define  TYPE_TRALLFA			31
#define  TYPE_UNIMATION			32
#define  TYPE_YAMAHA			33

#ifdef PI
#undef PI
#endif
#define PI 				3.14159265358979323846

#ifndef ZERO_TOL
#define ZERO_TOL			0.00001
#endif

#define DEG_TOL				0.001
#define FALSE				0
#define TRUE				1

#ifdef min
#undef min
#undef max
#endif

#define	max(a,b) ((a)>(b)?(a):(b))
#define	min(a,b) ((a)<(b)?(a):(b))

#ifndef _DNB_TRIGSIMPL_
#ifdef sqrt
#undef sqrt
#endif
#define sqrt        DNBVMAP_Sqrt
#ifdef asin
#undef asin
#endif
#define asin        DNBVMAP_Asin
#ifdef acos
#undef acos
#endif
#define acos        DNBVMAP_Acos
#ifdef atan
#undef atan
#endif
#define atan        DNBVMAP_Atan
#ifdef atan2
#undef atan2
#endif
#define atan2       DNBVMAP_Atan2
#endif


/**
 ** #defines for shared library routines for which
 ** the name of corresponding internal function is different
 **/

#define mat_matrix              dg_matrix
#define mat_ident		dg_ident
#define mat_set			dg_setmat
#define mat_get			dg_getmat
#define mat_cat			dg_catmat
#define mat_translate		dg_trans
#define mat_rotate_x		dg_rotatex
#define mat_rotate_y		dg_rotatey
#define mat_rotate_z		dg_rotatez
#define mat_rotate_k		dg_rotatek
#define mat_invert		dg_invert
#define mat_rot_to_k		dg_rot_to_k
#define mat_copy		dg_cpymat
#define mat_rot_to_x_k		dg_rot_to_x_k
#define mat_rot_to_y_k		dg_rot_to_y_k
#define mat_rot_to_kar_k	dg_rot_to_kar_k
#define mat_xform_to_xyzrpy	dg_xform_to_xyzrpy
#define mat_xyzAB_to_xform	dg_xyzAB_to_xform
#define kin_check_definition    DNBVMAP_kin_check_definition

typedef double dg_matrix[4][4];
typedef int error_code;

/*
 * get_kin_config(), *usrKinDataHint = USR_KIN_DATA_NULL
 * the last argument (void *pData) of the usr routine is NULL
 */
#define    USR_KIN_DATA_NULL  0

/*
 * get_kin_config(), *usrKinDataHint = USR_KIN_DATA_KINSTAT
 * the last argument (void *pData) of the usr routine is DLM_Data_KinStat
 */
#define    USR_KIN_DATA_KINSTAT 1

/*
 * DLM_Data_KinStat.kin_mode valid values
 */
#define KIN_MODE_NORMAL     0
#define KIN_MODE_TRACK_TCP  1
#define KIN_MODE_OTHER      2

typedef struct
{
    int dof_count;                 /* Number of DOFs for the current IK device */
    int *joint_types;              /* For each of the DOF, joint type as ROTATIONAL or TRANSLATIONAL */
    int kin_mode;                  /* Kin mode for current IK call (normal or tracking) */
    double *joint_values;          /* current joint values for each of the device DOFs */
    double *jnt_trvl_lmts[2];      /* current joint travel limits for the IK device, lower: jnt_trvl_lmts[0] */
	double mount_plate_offset[6];  /* Mount Plate offset definition (as X Y Z Yaw Pitch Roll) for the current IK device*/
	double curr_tool_offset[6];    /* Current Tool Point offset from Mount Plate (as X Y Z Yaw Pitch Roll) for the IK device*/
} DLM_Data_KinStat;


/*
 * External Routines Available From Delmia
 */
DNBSHLIBDllExport void    mat_ident();
DNBSHLIBDllExport void    mat_set();
DNBSHLIBDllExport void    mat_get();
DNBSHLIBDllExport void    mat_cat();
DNBSHLIBDllExport void    mat_translate();
DNBSHLIBDllExport void    mat_rotate_x();
DNBSHLIBDllExport void    mat_rotate_y();
DNBSHLIBDllExport void    mat_rotate_z();
DNBSHLIBDllExport void    mat_rotate_k();
DNBSHLIBDllExport void    mat_invert();
DNBSHLIBDllExport void    mat_rot_to_k();
DNBSHLIBDllExport void    mat_rot_to_kar_k();
DNBSHLIBDllExport void    mat_xform_to_xyzrpy();
DNBSHLIBDllExport void    mat_xyzAB_to_xform();
DNBSHLIBDllExport void    mat_copy();
DNBSHLIBDllExport void    mat_rot_to_x_k();
DNBSHLIBDllExport void    mat_rot_to_y_k();
DNBSHLIBDllExport int     kin_check_definition(int, int);

DNBSHLIBDllExport double   DNBVMAP_Sqrt(double);
DNBSHLIBDllExport double   DNBVMAP_Asin(double);
DNBSHLIBDllExport double   DNBVMAP_Acos(double);
DNBSHLIBDllExport double   DNBVMAP_Atan(double);
DNBSHLIBDllExport double   DNBVMAP_Atan2(double,double);


#endif /* _SHLIBDEFS_H_ */
