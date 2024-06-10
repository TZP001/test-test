1. For safety (In case of network or other problems), create a backup of 
   your Project data. Make a copy of the DB (DataBase) folder. This will
   generally be in the Installation directory of the Delmia Process 
   Engineer Server (for example "C:\DELMIA\PPRServer\DB")

2. To avoid getting the login screen at multiple times while updating 
   your Projects, set your E5 user name and password in these 
   environment variables
   > set DELMIA_DETAILING_UPDATE_LOGIN=your_user_name
   > set DELMIA_DETAILING_UPDATE_PASSWORD=your_password

3. Get all your Project Information. For that, execute the 
   "CATIPDDetailingUpdate" Batch with the "-projects" option.    
   You can find this Batch file inside
   "<V5 Installation directory>\intel_a\code\bin" 
   > CATIPDDetailingUpdate -projects
   
4. This will generate a text file called "DetailingUpdateProjectsInfo.txt" 
   in the system temp directory, whose location can be found out by running 
   the  CATIPDDetailingUpdate executable with the "-outputDir" option". 
      
   The generate file ("DetailingUpdateProjectsInfo.txt") will look somewhat like this
   
   *****************************************************************
   * Project Name: Chassis Assembly
   * Project Short Name: CAXFR1109
   * Project ID: d619d871-c97a-11d6-ad92-00b0d078ae8e@XDOErgoProject
   * Project Creation Date: 09/16/2002
   * Project Modification Date: 09/16/2002
   *****************************************************************
                                
   *****************************************************************
   * Project Name: Engine Assembly
   * Project Short Name: EAVGB6754
   * Project ID: 7d8edead-c1bf-11d6-ad90-00b0d078ae8e@XDOErgoProject
   * Project Creation Date: 09/06/2002
   * Project Modification Date: 09/16/2002
   *****************************************************************
   
   Note: The Project IDs obtained in your Projects may be in a different format
   and may look like this 
   * Project ID: $id$(0:0-9471#0, 168)
        
5. Update the Projects one by one using the Batch by supplying the Project IDs 
   obtained from the file "DetailingUpdateProjectsInfo.txt" as an argument
   For example:
   > CATIPDDetailingUpdate d619d871-c97a-11d6-ad92-00b0d078ae8e@XDOErgoProject
 
6. Two files will be generated for each Project in the system temp directory, 
   whose location can be found out by running the  CATIPDDetailingUpdate executable 
   with the "-outputDir" option".

   i)  DetailingUpdateResults_<Date_Time_Stamp>.txt
   ii) DetailingUpdateTraces_<Date_Time_Stamp>.txt  
    
7. Open the "DetailingUpdateResults_<Date_Time_Stamp>.txt" file. 
   It will look something like this
   ******************************
   * Project: Chassis Assembly
   * Object:  Workplan_Line1
   * Detailing: Detailing_Line1_4537    
   * Load Detailing: SUCCEEDED
   * Save Detailing: SUCCEEDED
   ******************************
   ******************************
   * Project: Chassis Assembly
   * Object:  Workplan_Line2
   * Detailing: Detailing_Line2_5694    
   * Load Detailing: SUCCEEDED
   * Save Detailing: SUCCEEDED
   ******************************

8. The "Load Detailing" and "Save Detailing" should be followed by the word 
   "SUCCEEDED". If the word "FAILED" appears in the file, or for any other 
   information contact Delmia (contact information below) and send us all the
   generated files. 

9. Unset your user name and password from the environment variables
   > set DELMIA_DETAILING_UPDATE_LOGIN=
   > set DELMIA_DETAILING_UPDATE_PASSWORD=

10. Contact Information:

   Delmia Corp,
   5500 New King St.
   Troy, MI 48098
   +1-248-267-9696 (Tel)
   +1-248-267-8585 (Fax)

   Direct Contact:
   Yannick Audoir   (+1-248-205-5139)
   Pradeep Chandran (+1-248-205-5178)
   Yuri Menezes     (+1-248-205-5280)



