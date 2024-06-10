
                CATIA TO CAM-POST INTERFACE DOCUMENTATION
                -----------------------------------------

The CATIA Interface Kit sets the input format to "CATIA", sets the input card
length to 72 characters, and tells GENER to ignore null parameters (i.e., two
commas in succession) in the input aptsource file. The interface kit includes
a kit.mac file that implements thread milling and circle milling operations.

  CYCLE/CIRCUL,...
  CYCLE/THREAD,...

Two PPTable files containing ICAM compatible post processor command syntax are
included with the CATIA interface kit. These files (or similar ones) can also
be found in the CATIA Startup/Manufacturing/PPtable directory, which is where
CATIA expects to find them. If you make changes to a PPTable file, you should
be sure to:

  a) Save your changes using a unique file name
  b) Copy the new PPTable file to CATIA's Startup/Manufacturing/PPtable
     directory

These PPTable files are provided as a starting point only. In practice, each
post processor may require its own PPTable file.

