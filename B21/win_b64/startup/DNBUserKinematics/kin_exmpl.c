/**
 * @fullreview CZO 04:09:02
 * @quickreview CZO 05:02:17
 * @quickreview CZO 05:04:29
 */


/*******************************************************************************
**
**                      USER KINEMATICS EXAMPLE
**
**  Copyright (c) 1990 Delmia Corporation, All rights reserved.
**
**  This file contains an example of a kinematics routine for the 
**  shared library.  This example will work for 4 DOF 2 Config (left and right
**  elbow) scara robots such as the ASEA/IRB300.  By default,
**  kin_usr1 is mapped to this routine.
**
**  For a description of kinematics solutions refer to:
**
**      Paul, Richard P., "Robot Manipulators: Mathematics, Programming
**      and Control", The MIT Press, Cambridge, Massachusetts, 1981.
**
**  DESCRIPTION OF ARGUMENTS
**
**  double T6[4][4]        4x4 position matrix of center of wrist. This is 
**                         the goal point MINUS the tool frame and mounting 
**                         plate offsets. This is the easiest point to start 
**                         the inverse kinematic solution from, and is the 
**                         traditional approach.
**
**                         NOTE: T6 matrix may be transposed from your usual
**                         notation.
**
**                              | nx ny nz 0 | \\
**                         T6 = | ox oy oz 0 |  > direction cosines (9)
**                              | ax ay az 0 | /
**                              | px py pz 1 | -> position terms (3)
**
**                         px = T6[3][0]; 
**
**  double link_lengths[]  Distance between joint axis along link length
**
**  double link_offsets[]  Offset between joint axis along joint axis
**
**                         These two arrays can be considered the Denevitt-
**                         Hartenburg variables described in Paul's book, or
**                         any convenient scheme the user desires.
**
**  double solutions[][]   A two dimensional array contains all possible 
**                         solutions for robot arm. It is up to user to
**                         decide how many solutions are possible, and to 
**                         provide all solutions when routine is called:
**                         elbow up, elbow down, etc.  The CONFIGS 
**                         Button in IGRIP allows user to view all possible
**                         solutions and may provide insight into importance
**                         of this array.
**
**  int warnings[]         Array providing warning states for each solution
**                         such as unreachable, singular, etc. Possible warning
**                         states are defined in include file shlibdefs.h 
**                         and are:
**
**                         WARN_GOOD_SOLUTION
**                         WARN_JOINT_LIMIT_EXCEEDED 
**                         WARN_UNREACHABLE
**                         WARN_SINGULAR_SOLUTION
**
**       NOTE: shlibdefs.h is automatically included by the IGRIP Shared 
**             Library Make system.  For further details regarding the building 
**             of the shared library, refer to the IGRIP Motion Pipeline 
**             Reference Guide
**
**
**  Words of encouragement
**
**      Writing inverse kinematics routines is a challenge. Invariably
**      you will make mistakes which later seem trivial.  Even experts on
**      the subject loathe writing a new routine.  The usual problems
**      are matching the routines view of the world with the device
**      definition.  You must check that where this routine thinks is 
**      the axis origin, or the zero reference position, is the same
**      as the IGRIP device.  Also make sure that each agree upon the positive
**      sense of direction.  These are the most common foul ups.  Next,
**      the mounting plate offset may be wrong, so when first debugging
**      your routine, set the mounting plate and tool frame offsets to
**      zero.  Next check for dropped signs in your equations.  Maybe
**      an inverse trig function is returning an angle in a different quadrant
**      than the one you want.  Perhaps you should be using atan2 instead 
**      of atan (or vice-versa).  Remember that trig and inverse trig function
**      angles are in radians.  Also, check array indices.  Remember that 
**      arrays start at zero not one, so link_4's offset is at link_offsets[3].
**      Are you referring to T6[3][2], when you mean T6[2][3]? Remember that 
**      transformation matrices may be transposed from standard text book 
**      definitions.  Once you get your routine to work you will have earned
**      the title of kinematician.
**
*******************************************************************************/

#include <shlibdefs.h>

/*
** IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT 
** IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT 
** IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT 
** IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT 
**
** USER SHOULD CHANGE THESE VALUES APPROPRIATELY
**                       |                       
**                       |                      
**                      \ /                    
**                       v                                         */

#define NUM_SOLUTIONS    2        /* Number of possible solutions  */
#define NUM_DOFS         4        /* Number of joints to be solved */

/*                       ^  
**                      / \ 
**                       |
**                       |
** USER SHOULD CHANGE THESE VALUES APPROPRIATELY
**
** IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT 
** IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT 
** IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT 
** IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT 
*/


/*
 * User must supply this function
*/

DllExport int
get_kin_config( char *kin_routine, int *kin_dof, int *solution_count, int *usrKinDataHint )
{
    if( strcmp( kin_routine, "kin_user" ) == 0 )
    {
        *kin_dof = NUM_DOFS;
        *solution_count = NUM_SOLUTIONS;

	/*
	 * this indicates kin_usr's last argument (void *pData)
	 * will be DLM_Data_KinStat
	 */
	*usrKinDataHint = USR_KIN_DATA_KINSTAT;
	return 0;
    }

    return 1;
}


static char JointType[2][24] = { "ROTATIONAL", "TRANSLATIONAL" };
static char KinMode[2][24] = { "Normal", "TrackTCP" };


/* 
** Routine Name 
*/

DllExport int
kin_user(
           link_lengths,
           link_offsets,
           T6,           /* See above for description of these arguments */
           solutions,
           warnings,
	   pData
           )

/* 
** Passed Variable Declarations 
*/

double T6[4][4],
      link_lengths[],
      link_offsets[],
      solutions[][NUM_SOLUTIONS];

int   warnings[];
void *pData; /* usr routine should NEVER delete pData */

{


/* 
** Local Variable Declarations (add variable declarations as appropriate)
*/

double nx, ny, az,
      px, py, pz;

double link1, link2, link3;

double rr, RR,
      cos_1, cos_2, 
      theta1, theta2, theta3, theta4, theta;

#if 1
/*
 * using pData
 */
    int i;

    DLM_Data_KinStat *pDLM_Data = (DLM_Data_KinStat *) pData;
    if( pDLM_Data )
    {
        printf( "\n\ndof_count: %d\n", pDLM_Data->dof_count ); /* Number of DOFs for the current IK device */

        printf( "\njoint_types:\n" ); /* For each of the DOF, joint type as ROTATIONAL or TRANSLATIONAL */
        for( i = 0; i < pDLM_Data->dof_count; i++ )
            printf( "%s ", JointType[(pDLM_Data->joint_types)[i]] );

        printf( "\n\nkin_mode: %s\n", KinMode[pDLM_Data->kin_mode] ); /* Kin mode for current IK call (normal or tracking) */

        printf( "\njoint_values:\n" ); /* current joint values for each of the device DOFs */
        for( i = 0; i < pDLM_Data->dof_count; i++ )
	    printf( "%12.4f ", pDLM_Data->joint_values[i] );

        printf( "\n\njnt_trvl_lmts lower:\n" ); /* current lower joint travel limits for the IK device, lower: jnt_trvl_lmts[0] */
        for( i = 0; i < pDLM_Data->dof_count; i++ )
	    printf( "%12.4f ", pDLM_Data->jnt_trvl_lmts[0][i] );

        printf( "\n\njnt_trvl_lmts upper:\n" ); /* current upper joint travel limits for the IK device, lower: jnt_trvl_lmts[0] */
        for( i = 0; i < pDLM_Data->dof_count; i++ )
	    printf( "%12.4f ", pDLM_Data->jnt_trvl_lmts[1][i] );

        printf( "\n\nmount plate offset (x y z yaw pitch roll:\n" ); /* Mount Plate offset definition for the current IK device*/
        for( i = 0; i < 6; i++ )
	    printf( "%12.4f ", pDLM_Data->mount_plate_offset[i] );

        printf( "\n\ncurrent tool point offset (x y z yaw pitch roll:\n" ); /* Current Tool Point offset for the IK device*/
        for( i = 0; i < 6; i++ )
	    printf( "%12.4f ", pDLM_Data->curr_tool_offset[i] );

        printf( "\n\n" );
    }
#endif

/***--------------- Execution Begins Here ----------------------------------***/

    /*
    ** DO NOT REMOVE THIS BLOCK OF CODE
    ** IT IS REQUIRED TO PROPERLY SET THE NUMBER OF KINEMATIC
    ** DOFS FOR THE DEVICE
    */

    if( !kin_check_definition( NUM_DOFS, NUM_SOLUTIONS ) )
    {
        /* 
        ** Inconsistency between device definition and inverse
        ** kinematics routine exists. A warning message has been 
        ** issued and routine aborted
        */
        return( 1 );
    }

/***---------------- User code begins here ---------------------------------***/

    /*
    ** Copy arrays into meaningful variables
    */

    link1 = link_lengths[0];
    link2 = link_lengths[1];
    link3 = link_lengths[2];

    nx = T6[0][0];
    ny = T6[0][1];

    az = T6[2][2];

    px = T6[3][0];
    py = T6[3][1];
    pz = T6[3][2];

    /*
    ** If each of the p elements are zero, then the desired location is
    ** at the shoulder -- this is impossible to reach/calculate.        
    ** set warnigs and exit.                                             
    */

    if( (fabs( px ) <= ZERO_TOL && fabs( py ) <= ZERO_TOL) ||
         fabs( az + 1.0 ) >= ZERO_TOL )
    {
        warnings[ 0 ] = WARN_UNREACHABLE; 
        warnings[ 1 ] = WARN_UNREACHABLE; 
        return( 1 );
    }

    RR = px*px + py*py;
    rr = sqrt( RR );

    if( rr > (link1 + link2) )
    {
        warnings[ 0 ] = WARN_UNREACHABLE; 
        warnings[ 1 ] = WARN_UNREACHABLE; 
        return( 1 );
    }

    /*
    **  COMPUTE THETA
    */

     theta = atan2(py,px);

    /*
    **  COMPUTE THETA1
    */

    cos_1 = (RR + link1*link1 - link2*link2 )/(2.*link1*rr);

    if( fabs( cos_1 ) > 1.0 )
    {
        warnings[ 0 ] = WARN_UNREACHABLE; 
        warnings[ 1 ] = WARN_UNREACHABLE; 
        return( 1 );
    }

    theta1 = acos( cos_1 );

    solutions[ 0 ][ 0 ] = theta + theta1;
    solutions[ 0 ][ 1 ] = theta - theta1;

    /*
    **  COMPUTE THETA2
    */

    cos_2 = (link1*link1 + link2*link2 - RR)/(2.*link1*link2);

    theta2 = acos( cos_2 ) - PI;

    solutions[ 1 ][ 0 ] =  theta2;
    solutions[ 1 ][ 1 ] = -theta2;

    /*
    **  COMPUTE THETA3
    */

    theta3 = link3 - pz;

    solutions[ 2 ][ 0 ] = theta3;
    solutions[ 2 ][ 1 ] = theta3;

    /*
    **  COMPUTE THETA4
    */

    if( fabs(nx) <= ZERO_TOL && 
        fabs(ny) <= ZERO_TOL )  
    {
        warnings[ 0 ] = WARN_SINGULAR_SOLUTION; 
        warnings[ 1 ] = WARN_SINGULAR_SOLUTION; 
        return( 1 );
    }

    theta4 = -atan2( ny, nx );

    solutions[ 3 ][ 0 ] = theta4 + (theta + theta1 + theta2);
    solutions[ 3 ][ 1 ] = theta4 + (theta - theta1 - theta2);

    warnings[ 0 ] = WARN_GOOD_SOLUTION; 
    warnings[ 1 ] = WARN_GOOD_SOLUTION; 

    return( 0 );

}   /* End of kin_user_example */
