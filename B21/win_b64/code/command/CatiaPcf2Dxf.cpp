/**
 * @fullreview LTG sa00290 02:08:23
 */
///this is the debug version of user program 
//disable any view related stuff

#include <stdio.h>
#include <tchar.h>
#include <iostream.h>

#import "exeisogen.dll"

#include "pisogen.h"

#define FILE_SIZE 2000
#define DEBUG 1

extern "C" void CreateEncrypt( int , char *, long);

int getValues(char *inputFilePath,
	      char **pcfFile, char **rootDirSlash, 
	      char **project, char **style,
	      char **dimUnits, char **boreUnits, 
	      char **weightUnits, 
	      char **drgFormat, 
	      char **messageLevel);

void main(int argc, char *argv[])
{
	if(DEBUG)
        {
	  printf("Start CATIAPcf2Dxf Application\n");
        }

	printf("arg1 = %s \n",argv[1]);
	
	int rc = -1;
	char handshake[LEN_ENCRYPT + 1];
	char errorText[256], messagefile[256], Filenames[256];
	long lday, lmonth, lyear, lhour, lmin;
	long numsecs;
	long FileCount;
	long lStatus;
	
	///Get the inputs
	char *pcfFile = NULL;
	char *rootDirSlash = NULL;
	char *project = NULL;
	char *style = NULL;
	char *dimUnits = NULL;
	char *boreUnits = NULL;
	char *weightUnits = NULL;
	char *drgFormat = NULL;
	char *messageLevel = NULL;
     
	if(DEBUG)
	printf("calling getvalues Line %d \n",__LINE__);

        rc =  getValues(argv[1],&pcfFile,
                        &rootDirSlash,
                        &project,
                    &style,
                    &dimUnits, 
	            &boreUnits,
	            &weightUnits,
                    &drgFormat,
		    &messageLevel);

	try
	{
	  CoInitialize(NULL);

	  exeisogen::_xisogenPtr		pxisogen(__uuidof(exeisogen::xisogen));

	   // Set exeisogen properties
		numsecs = pxisogen->AliasTm(&lday, &lmonth, &lyear, &lhour, &lmin);

		CreateEncrypt(PISO_MODE_FULL, handshake, numsecs);
       
		//char *pcfFilePath = new char[strlen("C:\\ISOGen008\\LocalPcf\\Inputs\\")+50];
		//strcpy(pcfFilePath,"C:\\ISOGen008\\LocalPcf\\Inputs\\");

		//cout << "Input Pcf File Name " << endl;
                //char pcfFileName[50] ;
		//cin >> pcfFileName;
		
		//strcat(pcfFilePath, pcfFileName);
		
		pxisogen->pcfname = pcfFile;
		pxisogen->handshake = handshake;

		pxisogen->PIsogenRoot = rootDirSlash;
		pxisogen->PIsogenProject = project;
		pxisogen->PIsogenStyle = style;

		/*
		pxisogen->dimUnits = DIM_UNITS_USER;
		pxisogen->boreUnits = BORE_UNITS_USER;
		pxisogen->weightUnits = WEIGHT_UNITS_USER;
		*/
		int tmpdim;
		int tmpbore;
		int tmpweight;
        
                /*
                rc = SetIsoUnits(dimUnits,
				 boreUnits,
				 weightUnits,
				 &tmpdim,
				 &tmpbore,
				 &tmpweight);
		
		if(DEBUG)
                {
		   printf("after SetIsoUnits() is called Line %d \n",__LINE__);
                }


	        pxisogen->dimUnits = tmpdim;
		pxisogen->boreUnits = tmpbore;
		pxisogen->weightUnits = tmpweight;
		
                */
	        pxisogen->dimUnits = DIM_UNITS_USER;
		pxisogen->boreUnits = BORE_UNITS_USER;
		pxisogen->weightUnits = WEIGHT_UNITS_USER;

		pxisogen->DrawingFormat = DXF_FORMAT;

                /*
                int viewFlag =  -1;
                rc = GetViewFlag(view,&viewFlag);
                if( rc == 0 )
                {
		pxisogen->ViewPoint = viewFlag;
                 if(DEBUG)
		 {
                   printf("viewFlag = %d \n",viewFlag);
		 }
                } 
                */

		pxisogen->tolerance = 0;
		pxisogen->messageLevel = MSG_LEVEL_USER;
		pxisogen->demoMode = 0;
		pxisogen->errorText = errorText;
		pxisogen->messageFile = messagefile;

		lStatus = pxisogen->Run();

		strcpy(errorText, pxisogen->errorText);
		FileCount = pxisogen->nFiles;
		strcpy(Filenames, pxisogen->fileNames);

		printf("Status Code    : %d\n", lStatus);
		printf("Status Message : %s\n", errorText);
		printf("No Of Files    : %d\n", FileCount);
		//cout << "Input file:" << pcfFilePath << endl;
		if(FileCount)
		{
		  printf("Filename(s)    : %s\n", Filenames);
		}

		if(FileCount >= 1)
		{
			FILE *fp = fopen (argv[1] ,"a");
			//FILE *fp = fopen ("C:\\WINNT\\Profiles\\sa00290\\Local Settings\\Application Data\\DassaultSystemes\\CATTemp\\CATIAIsoInputs.txt" ,"a");
            if(fp)
			{
			int namlength = strlen(Filenames);
			char *file= new char[namlength];
            
			if(Filenames[namlength-1]== '|')
			{
				Filenames[namlength-1]= '\0';
			}
            fprintf(fp,"DRAWING_NAME1=%s\n",Filenames);
			 //fwrite();
			 fclose(fp);
			}
		}

		pxisogen = NULL;

		CoUninitialize();
	}
	catch (const _com_error& Err)
	{
	    if(DEBUG)
	    printf("Caught error thrown by Isogen \n");
		switch ( Err.Error() )
		{
		case REGDB_E_CLASSNOTREG:
			_tprintf(_T("Error : 0x%x - Personal Isogen component not registered"), Err.Error());
			break;
		default:
			_tprintf(_T("Error : 0x%x - %s\n"), Err.Error(), Err.ErrorMessage());
			break;
		}
	}

	if(DEBUG)
	printf("End CATIAPcf2Dxf Application\n");
}//main

int getValues(	char *inputFilePath,
				char **pcfFile,
				char **rootDirSlash,
				char **project,
				char **style,
				char **dimUnits,
				char **boreUnits,
				char **weightUnits,
				char **drgFormat,
			    char **messageLevel)
{
	int rc = 0;
	char store[FILE_SIZE];

    //FILE *fp = fopen ("C:\\WINNT\\Profiles\\sa00290\\Local Settings\\Application Data\\DassaultSystemes\\CATTemp\\CATIAIsoInputs.txt","r");
	FILE *fp = fopen (inputFilePath,"r");
	
	if(fp)
	{
		int flag = fread(store, sizeof(char),2000,fp);

		if(!feof(fp))
		{
			printf("error in reading file \n");
		}
        else
		{
			if(DEBUG)
		    printf("Line %d \n",__LINE__);
			
			char *home=strstr(store, "PCF_FILE_PATH=");
			
			if(DEBUG)
			{
			  printf("%s\n",store);
		          printf(" home pcf = %s \n", home);
			}
			
			char *end =strstr(store,"\n");
			int constStrSize = strlen("PCF_FILE_PATH=");
			int dirPathSize = 0;
			
			if ( home && end )
			{
				dirPathSize = end - (home + strlen("PCF_FILE_PATH="));
			}
			if (dirPathSize > 0) 
			{
				 *pcfFile = new char[dirPathSize+1];
			}
			
			if(*pcfFile)
			{
				strncpy(*pcfFile,home + constStrSize, dirPathSize);
				(*pcfFile)[dirPathSize]= '\0';
				printf(" pcf file = %s \n", *pcfFile);
			}
			
			if(DEBUG)
			{
				printf("Finding Root Dir Path \n");
			}

			home=strstr(store, "ROOT_DIR_PATH=");
			end =strstr(end + 1,"\n");
			constStrSize = strlen("ROOT_DIR_PATH=");
			
			if( home && end )
			{
				  dirPathSize= end- (home + strlen("ROOT_DIR_PATH="));
			}
			
			if(dirPathSize> 0)
			{
			  *rootDirSlash = new char[dirPathSize+1];
			}
				
			if(*rootDirSlash)
			{
					strncpy(*rootDirSlash,home + constStrSize, dirPathSize);
					(*rootDirSlash)[dirPathSize]= '\0';
					strcat(*rootDirSlash,"\\");					
					printf(" root dir path = %s \n", *rootDirSlash);
			}			
            
			if(DEBUG)
			{
				printf("Finding project ");
			}
			
			home=strstr(store, "PROJECT=");
			end =strstr(end + 1,"\n");
			
			constStrSize = strlen("PROJECT=");
			
			if( home && end )
			{
				  dirPathSize= end- (home + strlen("PROJECT="));
			}
			if (dirPathSize > 0 )
			{
				*project = new char[dirPathSize+1];
			}
				
			if(*project)
			{
				strncpy(*project,home + constStrSize, dirPathSize);
				(*project)[dirPathSize]= '\0';
				printf(" project = %s \n", *project);
			}			

			home = NULL; 
			home=strstr(store, "STYLE=");
			
			if(DEBUG)
			{
				printf("Finding style \n");
			}
			
			end =strstr(end + 1,"\n");
			constStrSize = strlen("STYLE=");
				
			if (home && end)
			{
				  dirPathSize= end- (home + strlen("STYLE="));
				  *style = new char[dirPathSize+1];
			}

			if(*style)
			{
					strncpy(*style,home + constStrSize, dirPathSize);
					(*style)[dirPathSize]= '\0';
					printf(" style = %s \n", *style);
			}		
			
			if(DEBUG)
			{
				printf("Finding dimension unit \n");
			}

			home = NULL;
			home= strstr(store, "DIMNSION_UNIT=");
			end = strstr(end + 1,"\n");
			constStrSize = strlen("DIMNSION_UNIT=");
			if(home && end )
			{
				  dirPathSize= end- (home + strlen("DIMNSION_UNIT="));
			}

			if(dirPathSize>0) 
			{
				  *dimUnits = new char[dirPathSize+1];
			}
			else
			{
				if(DEBUG)
				{
					printf("dirpathsize is less than 0 at line %d  \n",__LINE__);
				}
			}

				if(*dimUnits)
				{
					strncpy(*dimUnits,home + constStrSize, dirPathSize);
					(*dimUnits)[dirPathSize]= '\0';
					printf(" dimUnits = %s \n", *dimUnits);
				}		

				home=strstr(store, "BORE_UNIT=");
				end =strstr(end + 1,"\n");
				constStrSize = strlen("BORE_UNIT=");
				
				if (home && end)
				{
				  dirPathSize= end- (home + strlen("BORE_UNIT="));
				}
				
				*boreUnits = new char[dirPathSize+1];
			
				if(*boreUnits)
				{
					strncpy(*boreUnits,home + constStrSize, dirPathSize);
					(*boreUnits)[dirPathSize]= '\0';
					printf(" boreUnits = %s \n", *boreUnits);
				}

				home=strstr(store, "WEIGHT_UNIT=");
				end =strstr(end + 1,"\n");
				constStrSize = strlen("WEIGHT_UNIT=");
				
				if ( home && end )
				{
				   dirPathSize= end - (home + strlen("WEIGHT_UNIT="));
				}
				
				if (dirPathSize>0)
				{
				  *weightUnits = new char[dirPathSize+1];
				}
		        else
				{
			    	if(DEBUG)
					{
					  printf("dirpathsize is less than 0 at line %d  \n",__LINE__);
					}

				}

				if(DEBUG)
				{
					printf("finding drawing format \n");
				}

				if(*weightUnits)
				{
					strncpy(*weightUnits,home + constStrSize, dirPathSize);
					(*weightUnits)[dirPathSize]= '\0';
					printf(" weightUnits = %s \n", *weightUnits);
				}						

				home=strstr(store, "DRAWING_FORMAT=");
				end =strstr(end + 1,"\n");
				constStrSize = strlen("DRAWING_FORMAT=");
				if ( home && end) 
				{
				  dirPathSize= end- (home + strlen("DRAWING_FORMAT="));
				}
				if (dirPathSize>0)
				{
				  *drgFormat = new char[dirPathSize+1];
				}	
				else
				{
				 if(DEBUG)
				 {
					printf("dirpathsize is less than 0 at line %d  \n",__LINE__);
				 }
				}


				if(*drgFormat)
				{
					strncpy(*drgFormat,home + constStrSize, dirPathSize);
					(*drgFormat)[dirPathSize]= '\0';
					printf(" drgFormat = %s \n", *drgFormat);
				}

				home =  NULL;
				home=strstr(store, "VIEW=");
				end =strstr(end + 1,"\n");
				constStrSize = strlen("VIEW=");
				
				if (home && end ) 
				{
				  dirPathSize= end- (home + strlen("VIEW="));
				}
				
			   }//if able to read the file

				
				
		
            if(fp)
			{
			  fclose(fp);
	          if(DEBUG)
			  {
			  printf("The communication file between CATIA and user prog closed") ;
			  }
			  fp =  NULL;
			}
		}//if (fp)
	    return rc;	    
}

