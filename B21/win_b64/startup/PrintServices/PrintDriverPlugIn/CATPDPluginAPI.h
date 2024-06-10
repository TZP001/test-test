#ifndef CATPDPPLUGINAPI_H
#define CATPDPPLUGINAPI_H
// COPYRIGHT Dassault Systemes 2002
//-----------------------------------------------------------------------
// File CATPDPPluginAPI.h
//-----------------------------------------------------------------------
//
// Desc: 
//  CATIA Print Driver Plugin API  Header 
//
//  An implementation of all API function is required
// 
// Copyright (c) 2002 Dassault Systemes All rights reserved.
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
// Specific for Windows DLL mecanism.
// The following ifdef block is the standard way of creating macros which make exporting 
// from a DLL. All files within this DLL are compiled with the __CATPDPPLUGIN
// symbol defined on the command line. this symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see 
// ExportedByCATPDPPLUGIN functions as being imported from a DLL, wheras this DLL sees symbols
// defined with this macro as being exported.
#ifdef _WINDOWS_SOURCE
#if defined(__CATPDPPLUGIN)
#define ExportedByCATPDPPLUGIN __declspec(dllexport)
#else
#define ExportedByCATPDPPLUGIN __declspec(dllimport)
#endif
#else
#define ExportedByCATPDPPLUGIN
#endif
//-----------------------------------------------------------------------


 
//------------------------------------------------------------------------------
// Miscellaneous declaration
//------------------------------------------------------------------------------
#define CATPDPError  void
#define CATPDP_NO_ERROR  0

//------------------------------------------------------------------------------
// 
// Structure data parameters filled by the CATIA Printer Manager 
// 
//------------------------------------------------------------------------------
typedef struct _CATPDPParameters
{
   
   float formWidth;   	  	// The width of the paper form
   float formHeight; 	  	// The height of the paper form
   int   formOrientation; 	// The orientation of the paper form 
			  	//  0 = Portrait
   			  	//  1 = Landscape
   			  	//  2 = Best Fit  
   float xOrigin;		// The x coordinate of the image to print
   float yOrigin;		// The y coordinate of the image to print
   float scale;			// The image scale
   float leftMargin;		// The paper left margin 
   float rightMargin;		// The paper right margin 
   float topMargin;		// The paper top margin 
   float bottomMargin;		// The paper bottom  margin
   int   rotation;		// The image rotation
   				//  0 = 0 degree measured counterclockwise from the horizontal
   				//  1 = 90 degrees measured counterclockwise from the horizontal
   				//  2 = 180 degrees measured counterclockwise from the horizontal
   				//  3 = 270 degrees measured counterclockwise from the horizontal
   int   mapToPaper;		// The mapping to paper flag (1 if true, 0 either)
   int   whitePixelMode;	// The white pixel flag (1 if printing in black, 0 either)
   char  banner[1024];		// The string banner
   int   bannerPosition;	// The banner position
				//  0 = Without banner
   				//  1 = The banner is at the top of the image printed
   				//  2 = The banner is at the bottom of the image printed
				//  3 = The banner is at the left of the image printed
   				//  4 = The banner is at the right of the image printed
   int   logoVisibility;	// The logo visibility (1 if being seen, 0 either)
   char  logoPath[1024];	// The path of the logo file name
   int   colorMode;		// The print color mode
   				//  0 = RGB
   				//  1 = Grey Scale
   				//  2 = Monochrome
   int   quality;		// The print quality (between 0 to 100)
   float gamma;			// The gamma correction
   int   lineWidthSpecification; // The line with specification mode
				   //  0 = Absolute
				   //  1 = Scaled
				   //  2 = No Thickness
   int   lineTypeSpecification;	// The line type specification mode
				   //  0 = Absolute
				   //  1 = Scaled
   int   lineCap;		// The line cap
  	                	//  0 = line ends are flat
				//  1 = line ends are squared
				//  2 = line ends are round
   float backgroundColorRed;	 // The red component of the background color
   float backgroundColorGreen;   // The green component of the background color
   float backgroundColorBlue;	 // The blue component of the background color
} CATPDPParameters;


//------------------------------------------------------------------------------
// 
// API Description
// 
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// 			CATPDP_Begin
//
//  Desc:
//    Driver initialization with parameters provided by the interactive dialog
//  ------------------------------------------------------------------------------
//  Input : 
//		CATPDPParameters& param
//  ------------------------------------------------------------------------------
//  Output: 
//------------------------------------------------------------------------------
extern "C" ExportedByCATPDPPLUGIN CATPDPError CATPDP_Begin(const CATPDPParameters& param);



//------------------------------------------------------------------------------
// 			CATPDP_End
//
//  Desc:
// 	Driver ending
//  ------------------------------------------------------------------------------
//  Input : 
//
//  ------------------------------------------------------------------------------
//  Output: 
//------------------------------------------------------------------------------
extern "C" ExportedByCATPDPPLUGIN CATPDPError CATPDP_End();



//------------------------------------------------------------------------------
// 			CATPDP_DefineColor
//
//  Desc:
//  Defines a color in the palette in rgb coordinates
//  ------------------------------------------------------------------------------
//  Input : 
//  	int iIndex 	the index in the color table (between 0 and 255)
//  	float iRed	the red color in RGB coordinates (between 0 and 1)
//  	float iGreen	the green color in RGB coordinates (between 0 and 1)
//  	float iBlue 	the blue color in RGB coordinates (between 0 and 1)
//  ------------------------------------------------------------------------------
//  Output: 
//------------------------------------------------------------------------------
extern "C" ExportedByCATPDPPLUGIN CATPDPError CATPDP_DefineColor(int iIndex, float iRed, float iGreen, float iBlue);



//------------------------------------------------------------------------------
// 		CATPDP_SelectDrawColor
//
//  Desc:
// 	Selects the current drawing color
//  ------------------------------------------------------------------------------
//  Input : 
//  	int iIndex 	the index of the current drawing color (between 0 and 255)
//  ------------------------------------------------------------------------------
//  Output: 
//------------------------------------------------------------------------------
extern "C" ExportedByCATPDPPLUGIN CATPDPError CATPDP_SelectDrawColor(int iIndex);



//------------------------------------------------------------------------------
// 		CATPDP_SetDrawWidth
//
//  Desc:
// 	Selects the current draw width
//  ------------------------------------------------------------------------------
//  Input : 
//  	float iWidth 	the current draw width 
//  ------------------------------------------------------------------------------
//  Output: 
//------------------------------------------------------------------------------
extern "C" ExportedByCATPDPPLUGIN CATPDPError CATPDP_SetDrawWidth(float iWidth);


//------------------------------------------------------------------------------
//		 CATPDP_MoveTo
//
//  Desc:
// 	Moves the pen to (x, y) in device coordinates without drawing
//  ------------------------------------------------------------------------------
//  Input : 
//  	float iX 	the X coordinate move
//  	float iY 	the Y coordinate move
//  ------------------------------------------------------------------------------
//  Output: 
//------------------------------------------------------------------------------
extern "C" ExportedByCATPDPPLUGIN CATPDPError CATPDP_MoveTo(float iX, float iY);




//------------------------------------------------------------------------------
//			CATPDP_LineTo
//
//  Desc:
// 	Draws a line from the current pen position to (x, y) in device coordinates
//  	with current draw color, line type and draw width
//  ------------------------------------------------------------------------------
//  Input : 
//  	float iX 	the X coordinate to draw
//  	float iY 	the Y coordinate to draw
//  ------------------------------------------------------------------------------
//  Output: 
//------------------------------------------------------------------------------
extern "C" ExportedByCATPDPPLUGIN CATPDPError CATPDP_LineTo(float iX, float iY);

//------------------------------------------------------------------------------
// 			CATPDP_SelectFillColor
//
//  Desc:
// 	Selects the current filling color
//  ------------------------------------------------------------------------------
//  Input : 
//  	int iIndex 	the index of the current filling color
//  ------------------------------------------------------------------------------
//  Output: 
//------------------------------------------------------------------------------
extern "C" ExportedByCATPDPPLUGIN CATPDPError CATPDP_SelectFillColor(int iIndex);



//------------------------------------------------------------------------------
// 			CATPDP_FillArea
//
//  Desc:
// 	Fills a polypolygon in device coordinates with current fill color
//  ------------------------------------------------------------------------------
//  Input : 
//  	int iOutlines 	the number of polygons in the polypolygon
//  	int *iCorners 	the array of outlines integers giving the number of corners
//      	           in each polygon
//  	float *iCoord 	the array of floats giving the coordinates of alls corners 
//      	           of each polygon
//  ------------------------------------------------------------------------------
//  Output: 
//------------------------------------------------------------------------------
extern "C" ExportedByCATPDPPLUGIN CATPDPError CATPDP_FillArea(int iOutlines, const int* iCorners, const float* iCoord);



//------------------------------------------------------------------------------
// 			CATPDP_DrawBitmap
//
// Desc:
// 	Draws a bitmap in device coordinates at the given (x, y) position
//  ------------------------------------------------------------------------------
//  Input : 
//  	int iType 	0 if RGB bitmap, 1 if Black and White bitamp
//  	char* iPixels 	the array of pixels
//  	int iSize 	the size of the pixel array
//  ------------------------------------------------------------------------------
//  Output: 
//------------------------------------------------------------------------------
extern "C" ExportedByCATPDPPLUGIN CATPDPError CATPDP_DrawBitmap(float iX, float iY, const int iTypeColor, 
			      const unsigned char* iPixels,
			      const int iSize);


#endif




