/**
* @fullreview GTL NSI 02:11:15
* @quickReview GTL 02:11:19
*/
//-----------------------------------------------------------------------
// File: CATPDPPluginTemplate.cpp
//------------------------------------------------------------------------------
//
// Desc: 
//  This file is an example program for CATIA Printer Driver Plugin integration. 
//  This example program may be used, distributed and modified without limitation.
// ------------------------------------------------------------------------------
//
// The 10 following function can be overwriting for a Plugin Driver implementation
// > Add you own code for each of the 10 functions
// > Build a DLL (refers to the CATPDPPlugin.mak Makefile for generation NMAKE CATDPDPlugin.mak)
// > Add the resulting module (DLL or .so) to the V5 Printer Driver Manager 
//      - File / Printer Setup or Start->Programs->CATIA->Tools->Printer Setup
//      - Add a 3DPLM Printer and customize as a V5 Printer Driver Plugin.
//      - As parameter specifies the library name and path of the Printer Plugin Driver Module (DLL or .so)
// 
// CATPDPError CATPDP_Begin(const CATPDPParameters& param)
// CATPDPError CATPDP_End()
// CATPDPError CATPDP_DefineColor(int iIndex, float iR, float iG, float iB)
// CATPDPError CATPDP_SelectDrawColor(int index)
// CATPDPError CATPDP_SetDrawWidth(float width)
// CATPDPError CATPDP_MoveTo(float x, float y)
// CATPDPError CATPDP_LineTo(float x, float y)
// CATPDPError CATPDP_SelectFillColor(int index)
// CATPDPError CATPDP_FillArea(int, const int*, const float*)
// CATPDPError CATPDP_DrawBitmap(float x, float y, const int type,  const unsigned char * pixels, const int size)
// 
// ---------------------------------------------------------------------------------------------------------------
// 
// Copyright (c) 2002 Dassault Systemes All rights reserved.
//-----------------------------------------------------------------------------------------------------------------
// Must be include to access to the V5 Print Driver API
#include "CATPDPluginAPI.h"


//------------------------------------------------------------------------------
// 			CATPDP_Begin
//------------------------------------------------------------------------------------
extern "C" ExportedByCATPDPPLUGIN CATPDPError CATPDP_Begin(const CATPDPParameters& param)
{
   // TODO: add your code here.
}

//------------------------------------------------------------------------------
// 			CATPDP_End
//------------------------------------------------------------------------------------
extern "C" ExportedByCATPDPPLUGIN CATPDPError CATPDP_End()
{
   // TODO: add your code here.
}


//------------------------------------------------------------------------------
// 			CATPDP_DefineColor
//------------------------------------------------------------------------------------
extern "C" ExportedByCATPDPPLUGIN CATPDPError CATPDP_DefineColor(int iIndex, float iR, float iG, float iB)
{
   // TODO: add your code here.
}

//------------------------------------------------------------------------------
// 			CATPDP_SelectDrawColor
//------------------------------------------------------------------------------------
extern "C" ExportedByCATPDPPLUGIN CATPDPError CATPDP_SelectDrawColor(int index)
{
   // TODO: add your code here.
}

//------------------------------------------------------------------------------
// 			CATPDP_SetDrawWidth
//------------------------------------------------------------------------------------
extern "C" ExportedByCATPDPPLUGIN CATPDPError CATPDP_SetDrawWidth(float width)
{
   // TODO: add your code here.
}

//------------------------------------------------------------------------------
// 			CATPDP_MoveTo
//------------------------------------------------------------------------------------
extern "C" ExportedByCATPDPPLUGIN CATPDPError CATPDP_MoveTo(float x, float y)
{
   // TODO: add your code here.
}

//------------------------------------------------------------------------------
// 			CATPDP_LineTo
//------------------------------------------------------------------------------------
extern "C" ExportedByCATPDPPLUGIN CATPDPError CATPDP_LineTo(float x, float y)
{
   // TODO: add your code here.
}

//------------------------------------------------------------------------------
// 			CATPDP_SelectFillColor
//------------------------------------------------------------------------------------
extern "C" ExportedByCATPDPPLUGIN CATPDPError CATPDP_SelectFillColor(int index)
{
   // TODO: add your code here.
}

//------------------------------------------------------------------------------
// 			CATPDP_FillArea
//------------------------------------------------------------------------------------
extern "C" ExportedByCATPDPPLUGIN CATPDPError CATPDP_FillArea(int, const int*, const float*)
{
   // TODO: add your code here.
}

//------------------------------------------------------------------------------
// 			CATPDP_DrawBitmap
//------------------------------------------------------------------------------------
extern "C" ExportedByCATPDPPLUGIN CATPDPError CATPDP_DrawBitmap(float x, float y, const int type,  const unsigned char * pixels, const int size)
{
   // TODO: add your code here.
}



