/**
* @quickreview GTL 02:12:11
* @fullreview GTL NSI 02:11:15
*/
//-----------------------------------------------------------------------
// File: CATPDPPluginTraces.cpp
//-----------------------------------------------------------------------
//
// Desc:
//  This file is an example program for CATIA Printer Driver Plugin integration.
//  This example program may be used, distributed and modified without limitation.
//
//  This is a sample print driver plugin producing traces output as result.
//
// Copyright (c) 2002 Dassault Systemes All rights reserved.
//-----------------------------------------------------------------------------
#include "iostream.h"
#include "CATPDPluginAPI.h"


//------------------------------------------------------------------------------------
ExportedByCATPDPPLUGIN CATPDPError CATPDP_Begin(const CATPDPParameters& param)
{
   // TODO: add your code here.
   cout << "CATPDP_Begin " << endl;
   cout << " formWidth  = " << param.formWidth << endl;
   cout << " formHeight = " << param.formHeight << endl;
   cout << " formOrientation = " << param.formOrientation << endl;
   cout << " xOrigin = " << param.xOrigin << endl;
   cout << " yOrigin = " << param.yOrigin << endl;
   cout << " scale =  " << param.scale << endl;
   cout << " leftMargin = " << param.leftMargin << endl;
   cout << " rightMargin = " << param.rightMargin << endl;
   cout << " topMargin = " << param.topMargin << endl;
   cout << " bottomMargin = " << param.bottomMargin << endl;
   cout << " rotation = " << param.rotation << endl;
   cout << " mapToPaper = " << param.mapToPaper << endl;
   cout << " whitePixelMode = " << param.whitePixelMode << endl;
   cout << " banner = " << param.banner << endl;
   cout << " bannerPosition = " << param.bannerPosition << endl;
   cout << " logoVisibility = " << param.logoVisibility << endl;
   cout << " logoPath = " << param.logoPath << endl;
   cout << " colorMode = " << param.colorMode << endl;
   cout << " quality = " << param.quality << endl;
   cout << " gamma = " << param.gamma << endl;
   cout << " lineWidthSpecification = " << param.lineWidthSpecification << endl;
   cout << " lineTypeSpecification = " << param.lineTypeSpecification << endl;
   cout << " lineCap = " << param.lineCap << endl;
   cout << " backgroundColorRed = " << param.backgroundColorRed << endl;
   cout << " backgroundColorGreen = " << param.backgroundColorGreen << endl;
   cout << " backgroundColorBlue = " << param.backgroundColorBlue << endl;
}

//------------------------------------------------------------------------------------
ExportedByCATPDPPLUGIN CATPDPError CATPDP_End()
{
   // TODO: add your code here.
   cout << "CATPDP_End" << endl;
}


//------------------------------------------------------------------------------------
ExportedByCATPDPPLUGIN CATPDPError CATPDP_DefineColor(int iIndex, float iR, float iG, float iB)
{
   // TODO: add your code here.
   cout << "CATPDP_DefineColor " << iIndex << " " << iR << " " << iG << " " << iB << endl;
}

//------------------------------------------------------------------------------------
ExportedByCATPDPPLUGIN CATPDPError CATPDP_SelectDrawColor(int index)
{
   // TODO: add your code here.
   cout << "CATPDP_SelectDrawColor " << index << endl;
}

//------------------------------------------------------------------------------------
ExportedByCATPDPPLUGIN CATPDPError CATPDP_SetDrawWidth(float width)
{
   // TODO: add your code here.
   cout << "CATPDP_SetDrawWidth " << width << endl;
}

//------------------------------------------------------------------------------------
ExportedByCATPDPPLUGIN CATPDPError CATPDP_MoveTo(float x, float y)
{
   // TODO: add your code here.
   cout << "CATPDP_MoveTo " << x << " " << y << endl;
}

//------------------------------------------------------------------------------------
ExportedByCATPDPPLUGIN CATPDPError CATPDP_LineTo(float x, float y)
{
   // TODO: add your code here.
   cout << "CATPDP_LineTo " << x << " " << y << endl;
}

//------------------------------------------------------------------------------------
ExportedByCATPDPPLUGIN CATPDPError CATPDP_SelectFillColor(int index)
{
   // TODO: add your code here.
   cout << "CATPDP_SelectFillColor " << index << endl;
}

//------------------------------------------------------------------------------------
ExportedByCATPDPPLUGIN CATPDPError CATPDP_FillArea(int, const int*, const float*)
{
   // TODO: add your code here.
   cout << "CATPDP_FillArea" << endl;
}

//------------------------------------------------------------------------------------
ExportedByCATPDPPLUGIN CATPDPError CATPDP_DrawBitmap(float x, float y, const int type,  const unsigned char * pixels, const int size)
{
   // TODO: add your code here.
   cout << "CATPDP_DrawBitmap " << x << " " << y << " " << type << " " << size << endl;
}
