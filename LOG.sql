**********************************************************;
* SAS Install Reporter for SAS 8 or SAS 9                *;
* Purpose:  to show what SAS products are installed      *;
*                                                        *;
* Version 2 -- 5/15/09  changes and additions:           *;
*                                                        *;
*   1. corrected custom product versions and code builds *;
*   2. filter out repetitive .ini-detected components    *;
*   3. better determination of clients in install path   *;
*   4. adjust for SAS 9.2 installation path difference   *;
*   5. allow to run on UNIX                              *;
*   6. if XCMD allowed, find SAS products in the Windows *;
*      registry                                          *;
*   7. if XCMD allowed, get report from other SAS vers.  *;
*                                                        *;
* Version 3 -- 5/12/11  changes and additions:           *;
*                                                        *;
*   8. report hot fixes from installaion registry        *;
*   9. report additional software installed per registry *;
*  10. report other deployment information per registry  *;
*  11. on Windows, report defined Windows SAS services   *;
**********************************************************;

%macro sasinstallreporter;

/* ensure this code only attempted on UNIX or Windows */
%if %index(%str(CM*OS*VM*),%substr(&SYSSCP,1,2)*) %then
  %do;
    data _null_;
       abort return 4;
    run;
  %end;

%let slsh = %str(/);
%let xcmd = %sysfunc(getoption(xcmd));

options formdlim='-' nosyntaxcheck nostimer;
%if &SYSSCP = WIN %then
  %do;
    options noxwait xsync;
    %let slsh = %str(\);
  %end;

** get location of SAS installation:  **;
%let sasroot = %sysget(SASROOT);

** get SASHOME level for applications and such **;
%let sashome = &sasroot;

%do %until(("&SYSVLONG" < "9.02") or (%sysfunc(fileexist(&sashome.&slsh.deploymntreg))));
  %let sashome = %sysfunc(reverse(%bquote(&sashome)));
  %let upone = %index(%bquote(&sashome),&slsh);
  %let sashome = %substr(%bquote(&sashome),&upone+1);
  %let sashome = %sysfunc(reverse(%bquote(&sashome)));
%end;

** get machine name: **;
%if &SYSSCP = WIN %then
  %let machine = %sysget(COMPUTERNAME);
%else
%if &XCMD = XCMD %then
  %do;
    filename host pipe 'hostname';
    data _null_;
       infile host;
       input;
       call symput('MACHINE',trim(_infile_));
       stop;
    run;
    filename host;
  %end;
%else
  %let machine = UNKNOWN;

/* Under DMS, use Output window to avoid remote/help browser issues */
%if &SYSVER >= 9.3 and %substr(&SYSPROCESSNAME,1,3) = DMS %then
  %do;
    ods graphics off;
    ods html close;
    ods listing;
  %end;

***********************************************************************;
* This code determines what is licensed by parsing the output from    *;
* PROC SETINIT.  It then also creates a $license format that can be   *;
* used in printing the custom product versions and other steps.       *;
***********************************************************************;

filename license temp;
%let license=%sysfunc(pathname(license));
proc setinit outfile="&license"; run;

data license;
   length prodnum $ 10 cmpont $ 64;
   label  prodnum = 'PRODNUM';
   label  cmpont = 'COMPONENT ----------------------------------------';
   keep   prodnum cmpont;
   infile "&license" lrecl=100 pad;
   input;
   if _infile_ =: "   EXPIRE" then
      do;
         prodnum=substr(_infile_,11,10);
         len=index(_infile_,' */')-25;
         cmpont=substr(_infile_,25,len);
         output;
      end;
run;

filename license;

data licensed;
   length label $ 64 begin $ 10;
   retain fmtname "license" type "c";
   set license(rename=(prodnum=start
                       cmpont=label));
run;

proc format cntlin=licensed; run;

* Set SASVER macro variable now in case runstatus changes it: ;

%let sasver = &sysver;

************************************************************************;
* The following code runs if SAS is 9.1.3 and allows surfacing certain *;
* custom product versions and executable build versions.               *;
************************************************************************;

%if "&SYSVLONG" > "9.01.01M3" %then
  %do;

    filename statlog temp;
    proc printto log=statlog new; run;
    proc product_status allinfo; run;
    proc printto; run;

    data prodstat;
       infile statlog firstobs=1 length=len;
       length component $64 custver $10 imgver $16;
       retain component custver imgver ' ';
       *format component $license.;
       label component = 'COMPONENT ------------------------------------'
             custver = 'Custom version' imgver = 'Build version';
       input;
       if _infile_ =: 'NOTE: SAS' then
          do;
             call symput('sasver',substr(_infile_,11));
          end;
       if _infile_ =: 'For ' then
          do;
             if component ^= ' ' then
                output;
             component = substr(_infile_,5,len-8);
             component = put(component,$license.);
             imgver = ' ';
          end;
       if _infile_ =: '   Custom' then
          custver = substr(_infile_,32);
       if _infile_ =: '   Image' then
          imgver = substr(_infile_,31);
    run;
    filename statlog;
  %end;

%global _SASSPLEVEL;
%let _SASSPLEVEL = SAS &sasver (&sysvlong4);

************************************************************************;
* Define format to identify products associated with hot fixes.        *;
************************************************************************;

proc format;
   value $hfprod
   'BA','BB','BC','BD','BX' = 'Base SAS'
   'AD' = 'SAS/Access Interface to ADABAS'
   'DD' = 'SAS/Access Interface to CA-Datacom/DB'
   'D2' = 'SAS/Access Interface to DB2'
   'SQ' = 'SAS/Access Interface to DB2 for VM'
   'ID' = 'SAS/Access Interface to CA-IDMS'
   'MS' = 'SAS/Access Interface to IMS-DL/I'
   'IF' = 'SAS/Access Interface to Informix'
   'IG' = 'SAS/Access Interface to CA-OpenIngres'
   'OD' = 'SAS/Access Interface to ODBC Server'
   'OL' = 'SAS/Access Interface to OLE DB'
   'OC' = 'SAS/Access Interface to Oracle'
   'PF' = 'SAS/Access Interface to PC File Formats'
   'PE' = 'SAS/Access Interface to PeopleSoft'
   'R3' = 'SAS/Access Interface to R/3'
   'BW' = 'SAS/Access Interface to SAP BW'
   'SB' = 'SAS/Access Interface to Sybase'
   'S2' = 'SAS/Access Interface to System 2000'
   'TE' = 'SAS/Access Interface to Teradata'
   'NW' = 'SAS/Access Interface to HP Neoview'
   'NZ' = 'SAS/Access Interface to Netezza'
   'YQ' = 'SAS/Access Interface to MySQL'
   'AS' = 'SAS/ASSIST'
   'CT' = 'SAS/CONNECT'
   'ES' = 'SAS/EIS'
   'DT' = 'Enterprise Miner'
   'ET' = 'SAS/ETS'
   'FS' = 'SAS/FSP'
   'GN' = 'SAS/Genetics'
   'GR' = 'SAS/GRAPH'
   'ML' = 'SAS/IML'
   'IH' = 'Integration Technologies'
   'WB' = 'SAS/IntrNet'
   'IS' = 'IT Service Vision'
   'MX' = 'SAS/MDDB Server'
   'OR' = 'SAS/OR'
   'QC' = 'SAS/QC'
   'RI' = 'Risk Dimensions'
   'SH' = 'SAS/SHARE'
   'ST' = 'SAS/STAT'
   'TM' = 'SAS Text Miner'
   'WH' = 'SAS Warehouse Administrator'
   'WD' = 'WebHound'
   'WW' = 'Jscore'
   'HP' = 'SAS HPF'
   'QL' = 'SAS Data Quality Server'
   'SD' = 'SAS/SECURE'
   'HO' = 'Service Pack'
   'AM' = 'SAS Anti-Money Laundering'
   'WN' = 'SAS Web Analytics'
   'IN' = 'SAS Scoring Accelerator for Teradata'
   'MM' = 'SAS Marketing Automation'
   'CG' = 'Campaign Management Component'
   'SP' = 'Strategic Performance Management'
   'FI' = 'Financial Managment Solution'
   'APCORE'      = 'Analytics Platform'
   'DMINECLT'    = 'Enterprise Miner client'
   'CITATNWEB'   = 'SAS Web Report Studio'
   'DATABLDR'    = 'DI Studio'
   'JPORTAL'     = 'Information Delivery Portal'
   'JPS'         = 'Foundation Services'
   'MAPCNTR'     = 'Information Map Studio'
   'QRSERVICES'  = 'Query and Reporting Services'
   'SMC'         = 'SAS Management Console'
   'WEBINFRAKIT' = 'SAS Web Infrastructure Kit'
   'WEBOLAPVR'   = 'SAS Web OLAP Viewer'
   'WEBRPTVR'    = 'SAS Web Report Viewer'
   'MITIBRIDGE'  = 'SAS Metadata Bridge'
   'EMAAUXDATAIO','EMACORE','EMALAUNCHER','EMASMC','EMAWEBNPORT'
                 = 'SAS Digital Marketing'
   'FORCASTSTDO' = 'Forecast Studio'
   'FORCASTSRVR' = 'Forecast Server'
   'DA'          = 'Enterprise Miner Server'
   'MMAPI'       = 'Model Manager Mid Tier'
   'MMGUI'       = 'Model Manager Client'
   'TMCLIENT'    = 'Text Miner Client'
   'CR'          = 'Credit Scoring'
   ;
run;

%macro dash(filllen);
   %do i = 1 %to &filllen;%str( )%end;
%mend;

%let ls = %sysfunc(getoption(ls));
%let ps = %sysfunc(getoption(ps));

Title1 'SAS Install Reporter Version 3.0';

%let filllen = %eval(&ls-%length(&_SASSPLEVEL.SITE: &SYSSITE));
Title3 "&_SASSPLEVEL%dash(&filllen)SITE: &SYSSITE";

%let filllen = %eval(&ls-%length(HOST: &machine.OS: &SYSSCP (&SYSSCPL)));
Title4 "HOST: &machine%dash(&filllen)OS: &SYSSCP (&SYSSCPL)";

Proc print data=license noobs uniform label;
  title6 "1: Products, components, or solutions that are licensed";
run;

%let installer= %str( );
%let configloc=;
data orders;  length order $ 32;  stop;  run;

%if "&SYSVLONG" > "9.02.01" %then
  %do;
    ***********************************************************************;
    * This code determines what is installed by reading the Registry.jnl  *;
    * file in a SAS 9.2+ environment. This covers products, most clients, *;
    * solutions, and hot fixes for all.                                   *;
    ***********************************************************************;

    data components(drop=hotfix order applied)
         hotfixes(drop=custver component order)
         orders(keep=order);
       length component $ 64 custver $ 16 compid $ 16 hotfix $ 8 applied $ 20;
       label component = 'COMPONENT ----------------------------------------';
       label hotfix = 'HOT FIX -------';
       label applied = "APPLIED -------------------";
       length order $ 32;
       infile "&sashome.&slsh.deploymntreg&slsh.registry.jnl";
       input;
       inname=index(_infile_,' name="'); drop inname;  /* common to many */
       if index(_infile_,'value="order"') then
          do;
             order=scan(substr(_infile_,inname),2,'"');
             if order ^= lag(order) then
                output orders;
             return;
          end;
       if index(_infile_,'"sashome"') then
          do;
             call symput('sashome',scan(substr(_infile_,inname),2,'"'));
             return;
          end;
       if index(_infile_,'CONFIG/Configuration001') then
          do;
             call symput('configloc',scan(substr(_infile_,inname),2,'"'));
             return;
          end;
       if index(_infile_,'install_user') then
          do;
             call symput('installer',scan(substr(_infile_,inname),2,'"'));
             return;
          end;

       component=' ';
       if index(_infile_,'displayname') and index(_infile_,'maintenance/1"')=0 then
          do;
             component=scan(substr(_infile_,inname),2,'"');
             compid=scan(_infile_,4,'/');
             custver=scan(scan(_infile_,5,'/'),1,'"');
             if compid='test' then
                component=' ';
          end;
       if index("0123456789",substr(component,1,1)) then delete;
       if component ^= ' ' and component ^=: 'Hotfix' then
          output components;
       else if component =: 'Hotfix' then
          do;
             hotfix = substr(component,8);
             applied = substr(_infile_,1,20);
             output hotfixes;
          end;
    run;
    proc sort data=components; by compid descending custver; run;
    proc sort data=components nodupkey; by compid; run;
    proc sort data=hotfixes nodup; by hotfix; run;
    proc sort data=hotfixes;  by compid; run;
    data hotfixes(drop=custver compid);
       merge hotfixes(in=hf) components;  by compid;  if hf;
    run;
    proc sort data=hotfixes nodupkey; by hotfix; run;
  %end;
%else
%if &SYSSCP = WIN %then
  %do;
    ***********************************************************************;
    * This code determines what is installed by reading the .ini files    *;
    * that are associated with each product on Windows.                   *;
    ***********************************************************************;

    filename inis "&sasroot\core\sasinst\data\*.ini";
    data components;
      length component $ 64;
      keep   component;
      label component = 'COMPONENT ----------------------------------------';
      infile inis;
      input;
      if _infile_=:'Component=' and index(_infile_,':::')=0 then
         do;
            component=scan(_infile_,2,':');
            output;
         end;
    run;
    filename inis;
%end;
%else
%if "&SYSVLONG" < "9.02.02" %then
  %do;
    ***********************************************************************;
    * This code determines what is installed by reading the history file  *;
    * that is associated with the install on UNIX.                        *;
    ***********************************************************************;

    %if "&SYSVER" >= "9.1" %then
      %do;
        filename inis "&sasroot/install/admin/history.install";
      %end;
    %else
      %do;
        filename inis "&sasroot/.install/history";
      %end;
    data components;
      length component $ 64;
      label component = 'COMPONENT ----------------------------------------';
      infile inis;
      input;
      if _infile_=:'ADD ' then
         component=scan(_infile_,4,':');
      else
         delete;
      if index(component,"Map of ") or
         index(component,"Maps of ") or
         index(component," Samples") then
         delete;
      if index(component," Software") then
         component=substr(component,1,
         index(component," Software"));
    run;
    filename inis;
  %end;

***********************************************************************;
* This code determines components and hot fixes that are installed in *;
* SAS 9.1.3 only (and are Java based) as determined by vpd.properties *;
* file.  On Windows, this is under the %WinDir% path, on UNIX it will *;
* be under the home directory (~) of the installer user.  If found,   *;
* these will be appended to the above components data set, and if any *;
* Java app hot fixes are found, an xhotfix data set will be created.  *;
***********************************************************************;

%if &SYSSCP = WIN %then
  %let vpddir = %SYSGET(WINDIR);
%else
  %let vpddir = %str(~);

%let xhotfix = 0;

%if %SYSFUNC(FILEEXIST(&vpddir.&slsh.vpd.properties)) and
    "&SYSVLONG" > "9.01.01M3" and "&SYSVLONG" < "9.02" %then
  %do;
    data javacomp(keep=component) xhotfix(keep=hotfix status component);
       length release $ 30 component $ 64 hotfix $ 16;
       retain status 'APPLIED    ';
       infile "&vpddir.&slsh.vpd.properties";
       input;
       if scan(_infile_,7,'|') =: "1=feature" then
          do;
             release=scan(_infile_,6,'|');
             if index(release,"Hotfix") then
                do;
                   hotfix=scan(release,3,' ');
                   component=upcase(compress(substr(hotfix,2),'0123456789'));
                   output xhotfix;
                   call symput('xhotfix',1);
                end;
             component=scan(_infile_,9,'|');
             if component ^= ' ' then output javacomp;
          end;
     run;
     proc append base=components new=javacomp force;  run;
     %if &xhotfix %then
       %do;
         proc sort nodup data=xhotfix;  by hotfix; run;
       %end;
  %end;

proc sort data=components nodupkey;
  by component;
run;

Proc print data=components noobs uniform label;
  title6 "2: Products, components, or solutions that are physically installed";
run;

****************************************************************;
* This code checks to see what SAS maintenance is on, pre-9.2  *;
****************************************************************;

%if "&SYSSCP" ne "WIN" %then
  %do;
    /* on UNIX */
    %if "&SYSVER" >= "9.1" %then
      %let hfpath = &sasroot/install/admin/history.hotfix;
    %else
      %let hfpath = &sasroot/.install/hotfix%str(/)*.aud;

    %if %sysfunc(fileexist("&hfpath")) %then
      %do;
        filename inis "&hfpath";
        %if "&SYSVER" >= "9.1" %then
          %do;
            data hotfixes;
              length hotfix status $60 applied $25;
              label hotfix = 'HOTFIX' status="Status" applied= "Applied";
              infile inis;
              input;
              if _infile_=:'ADD ' then
                 do;
                    hotfix=scan(_infile_,6,' ');
                    status="Applied "||scan(_infile_,7,' ');
                    applied=scan(_infile_,2,':')||scan(_infile_,3,':')||scan(_infile_,4,':');
                 end;
              else
                 delete;
            run;
          %end;
        %else
          %do;
            data hotfixes;
               length file $ 200;  retain hotfix '                ' status 'APPLIED    ';
               length component $ 64;  retain component ' ';
               label component = 'COMPONENT ----------------------------------------';
               label hotfix = 'HOT FIX' status = 'APPLICATION STATUS';
               *format component $hfprod.;
               infile inis filename=file eov=foo end=done lrecl=200 pad;
               input;
               hotfix = substr(_infile_,1,6);
               if hotfix <= " " then delete;
               component=scan(_infile_,2,'%%');
               keep hotfix status component;
            run;
          %end;
        filename inis;
        proc sort data=hotfixes nodupkey;
          by hotfix;
        run;
      %end;
  %end;
%else
  %do;
    /* on WINdows */
    %if %sysfunc(fileexist("&sasroot\*wn.log")) %then
      %do;
        filename hotfixes "&sasroot\*wn.log";
        data hotfixes;
           length file $ 200;  retain hotfix '                ' status 'APPLIED    ';
           length component $ 64;  retain component ' ';
           label component = 'COMPONENT ----------------------------------------';
           label hotfix = 'HOT FIX' status = 'APPLICATION STATUS';
           format component $hfprod.;
           infile hotfixes filename=file eov=foo end=done;
           input;
           if foo or done then
              do;
                 output;  status='APPLIED';
              end;
           if _n_=1 or foo=1 then
              do;
                 hotfix=reverse(substr(scan(reverse(file),2,'\.'),3));
                 component=substr(hotfix,3,2);
              end;
           if _INFILE_=:"Could Not Copy" then
              status='INCOMPLETE!';
           foo=0;
           keep hotfix status component;
        run;
      %end;
  %end;
%if not(%sysfunc(exist(hotfixes))) %then
  %do;
    /* no hotfixes found at all */
    data hotfixes;
       retain hotfix '*NONE*' status '           ';
       label hotfix = 'HOT FIX' status = 'APPLICATION STATUS';
       output;  stop;
    run;
  %end;

%if &xhotfix %then
  %do;
     proc append base=hotfixes new=xhotfix force; run;
  %end;

proc print data=hotfixes noobs uniform label;
  title6 "3: Staus of Hot Fixes found for &_SASSPLEVEL";
run;

****************************************************************;
* This code checks to see what client apps are installed in    *;
* addition to the SAS system. Examples include  SAS Eminer     *;
* Tree Viewer, SAS System Viewer etc.  However, no further     *;
* analysis is done for these (hot fixes, etc.)                 *;
****************************************************************;

%if &SYSSCP = WIN or "&SYSVLONG" > "9.01.01M3" %then
  %do;

    filename appfile "&sashome.&slsh.";
    data temp2;
      length appname $ 64;
      label appname = 'COMPONENT ---------------------------';
      ap=dopen('appfile');
      nm=dnum(ap);
      do i=1 to nm;
         appname=dread(ap,i);
         appdot=index(appname,'.');
         if appdot then
            appdot = verify(substr(appname,appdot+1,1),'0123456789');
         if upcase(appname) not in ('SETUP LOGS', 'INSTALL', 'GEN1', 'UNINST',
                                    'DEPLOYMNTREG', 'INSTALLMISC')
         and not(appdot) then
            output;
      end;
      ap=dclose(ap);
      keep appname;
    run;
    filename appfile;

    %let t9 = %str( );

    ****************************************************************;
    * If we are on Windows, and if we can issue OS commands, then  *;
    * we can query the Windows registry to see what other SAS      *;
    * clients and solutions (EG, SMC, etc.) are installed.         *;
    ****************************************************************;

    %if &SYSSCP = WIN and &XCMD = XCMD %then
      %do;
        /* We can access the registry information as well !!! */
        %let t9 = %str(title9 "and applications registered in Windows--EXPECT DUPLICATES!!");
        filename appfile pipe 'reg query "HKLM\software\sas institute inc."';
        data temp3;
          length appname $ 64;
          label appname = 'COMPONENT ---------------------------';
          infile appfile;* firstobs=6;
          input;
          appname=scan(_infile_,4,'\');
          if upcase(appname) not in ('COMMON DATA', 'PLUGINS', ' ', 'THE SAS SYSTEM',
                                     'GEN1', 'INSTALLMISC', 'DEPLOYMNTREG', 'UNINST')
          then
             output;
          keep appname;
        run;
        filename appfile;
        %if "&SYSVLONG" > "9.02" %then
          %do;
            proc sort nodup;  by appname;  run;
            data temp3;
               merge temp3(in=reg)
                     components(rename=(component=appname));
               by appname;  if reg;
            run;
          %end;
        proc append base=temp2 new=temp3 force; run;
        proc sort nodup;  by appname;  run;
      %end;

    ***********************************************************;
    * Then we print out the SAS products and SAS components   *;
    * that are installed                                      *;
    ***********************************************************;

    %if &SYSSCP = WIN %then
      %let ftype = folders;
    %else
      %let ftype = directories;

    proc print data=temp2 noobs uniform label;
    title6 "4: Possible Other SAS Insitute Applications or Clients Installed";
    title8 "These are just &ftype or file names in the SAS installation path";
    &t9;
    run; quit;

  %end;

********************************************************************;
* This code provides information for certain things beyond basic   *;
* install information that is available in SAS 9.1.3 and later     *;
********************************************************************;

%if "&SYSVLONG" > "9.01.01M3" %then
  %do;
    *************************************************************************;
    * The following code runs if SAS is 9.1.3 and prints out the previously *;
    * determined custom product versions and executable build versions.     *;
    *************************************************************************;

    Proc print data=prodstat noobs uniform label;
    title6 "5: Custom Version Information for Selected SAS Institute Products or Components";
    run;


    ****************************************************************;
    * The following code runs if SAS is 9.1.3 and allows surfacing *;
    * the Java/JRE installation and version information.           *;
    ****************************************************************;

    %let currerr = &syserr;
    filename javalog temp;
    proc printto log=javalog new; run;
    proc javainfo; run;
    proc printto; run;
    %if not((&currerr = 0) and (&syserr ^= 0)) %then
      %do;
        title6 "6: SAS Java Environment Installation Information";
        title7 " ";
        data _null_;
           infile javalog firstobs=8;
           file print;
           input;
           if index(_infile_,'The SAS System') then
              delete;
           if _infile_ =: 'NOTE:' then
              stop;
           put '   ' _infile_;
        run;
      %end;
    filename javalog;

  %end;


********************************************************************;
* This code provides information for the SAS deployment -- who did *;
* the install, BI config location if found, and software orders.   *;
* The installer macro variable is only set if found in the above   *;
* step that reads and processes the SAS 9.2+ registry.jnl file.    *;
* On the wish list -- report the plan file used for BI install.    *;
********************************************************************;
%if %str(&installer) ^= %str( ) %then
  %do;

    %if "&configloc " ^= " " %then
      %do;
        %let levels =;
        %do i=1 %to 10;
          %if %sysfunc(fileexist("&configloc.&slsh.Lev&i")) %then
            %let levels = %trim(&levels)Lev&i..;
        %end;
        %let levels = %sysfunc(translate(&levels,%str( ),%str(.)));
      %end;

    title6 "7: Deployment information.";

    data _null_;
       file print;
       put " " / " ";
       put "SAS Home:                         &sashome";
       put "SAS Install User:                 &installer";
    %if "&configloc " ^= " " %then
      %do;
       put "BI or other configured location:  &configloc";
       put "            Configured level(s):  &levels";
      %end;
       put " ";
       put "SAS software orders deployed:";
       put " ";

       do i=1 to nobs;
          set orders point=i nobs=nobs;
          put order;
       end;
    %do %while(%length(&levels) > 3);
      %let level = %substr(&levels,1,4);
      %let levels = %left(%substr(&levels.%str(  ),5));
      %if %sysfunc(fileexist("&configloc.&slsh.&level.&slsh.Documents&slsh.Instructions*.html")) %then
        %do;
          length server $ 45 host $ 32 ports $ 20 port $ 20;
          put " ";
          put "&level Instructions.html appears to have these servers configured:";
          put " ";
          put @1 "SERVER NAME" @48 "HOST NAME" @ 83 "PORTS";
          %let pd = %sysfunc(min(&ls-83,20));
          put @1 45*"_" @48 32*"_" @83 &pd*"_";
          servers = 0;
          infile "&configloc.&slsh.&level.&slsh.Documents&slsh.Instructions*.html" end=done;
          do while(not(done));
             input;
             if _infile_ =: "<h3" or _infile_ =: "<h2" then
                do;
                   server=scan(_infile_,2,"<>");
                   host = " ";  ports = " ";
                end;
             if _infile_ =: "</table>" and server ^= " " and host ^= " " then
                do;
                   put @1 server @ 48 host @ 83 ports;
                   server = " ";  host = " ";  ports = " ";  servers = 1;
                end;
             if index(_infile_,">Host machine") then
                do until(index(_infile_,'"detailContent">'));
                   if index(_infile_,'"detailContent">') = 0 then
                      input;
                   dc = index(_infile_,'"detailContent">');
                   if dc then
                      host = scan(substr(_infile_,dc+16),1,"<>");
                end;
             if index(lowcase(_infile_),"port</td>") 
             or index(lowcase(_infile_),"ports</td>") then
                do until(index(_infile_,'"detailContent">'));
                   if index(_infile_,'"detailContent">') = 0 then
                      input;
                   dc = index(_infile_,'"detailContent">');
                   if dc then
                      do;
                         port = scan(substr(_infile_,dc+16),1,"<>");
                         if ports = " " then
                            ports = port;
                         else
                            ports = trim(ports)||" "||port;
                      end;
                end;
          end;
          done = 0;
          if servers = 0 then
             put "(No configured servers found and cannot check backup files)";
        %end;
    %end;
       stop;
    run;
  %end;


************************************************************************************;
* The following code runs only on Windows and IF the XCMD system option is on.  It *;
* first determines what, if any SAS-defined Windows Services there are, then which *;
* ones are running and what, if any, ports they use.                               *;
*                                                                                  *;
* Also, the code attempts to detect other installed versions of SAS, and if found, *;
* reports on the other installed versions products and such.                       *;
************************************************************************************;

%if &SYSSCP eq WIN and &XCMD = XCMD %then
  %do;
    filename services pipe "reg query ""HKLM\System\CurrentControlSet\Services"" /s";
    data SERVICES;
       length service $ 50 account $ 32;
       label  service="SAS Defined*Windows Service";
       label  account="Account";
       retain service " "  account " "  sassrv 0;
       drop sassrv;
       infile services pad;
       input;
       * translate tabs so command output is same on different versions of Windows;
       _infile_ = tranwrd(_infile_,'09'x,'    ');
       if _infile_ =: "    ImagePath" and index(_infile_,"&sashome\") then
          sassrv = 1;
       if substr(_infile_,1,1) ^= " " and sassrv then
          do;
             output;
             service = " ";  account = " ";  sassrv = 0;
          end;
       if sassrv and _infile_ =: "    DisplayName" then
          service = substr(_infile_,30);
       else
       if sassrv and _infile_ =: "    ObjectName" then
          account = substr(_infile_,29);
    run;
    filename services;
    proc sort;  by service; run;
    filename svcpids pipe "sc queryex";
    data SVC_PIDS;
       length service $ 50 pid $ 8;
       label  pid="Process ID*if running";
       retain service " ";
       infile svcpids;
       input;
       if _infile_ =: "DISPLAY_NAME" then
          service = substr(_infile_,15);
       else
       if _infile_ =: "        PID" then
          do;
             pid = scan(_infile_,2,' :');
             output;
          end;
    run;
    filename svcpids;
    proc sort;  by service; run;
    data services;
       merge services(in=sassvc) svc_pids;
       by service;
       if sassvc;
    run;
    filename listener pipe "netstat -a -n -o | find ""LISTENING""";
    data pidsport;
       length pid $ 8 ports $ 8;
       label ports="Ports in use";
       infile listener;
       input;
       ports = scan(_infile_,3,' :');
       pid   = scan(_infile_,7,' :');
    run;
    filename listener;
    proc sort data=pidsport;  by pid; run;
    proc sort data=services;  by pid; run;
    data services;
       merge services(in=sassvc) pidsport;
       by pid;
       if sassvc;
    run;
    proc sort;  by service pid;  run;

    title6 "8: SAS &sysver Defined and Installed Windows Services";

    proc print noobs label split="*";
       by service account pid;
       id service account pid;  var ports;
    run;

    %let verlist = %str( );
    filename chkinst pipe 'reg query "HKLM\Software\SAS Institute Inc.\The SAS System"';
    data others;
       retain verlist "                  ";
       infile chkinst;
       input;
       sasver=scan(_infile_,5,'\');
       if indexc(sasver,'0123456789.');
       if "&sysver" ^= sasver;
       put "SYSVER ^= SASVER:: (&SYSVER) -- (" sasver +(-1) ")";
       if not(sasver = "8" and "&sysver" =: "8");
       if verlist = ' ' then verlist = sasver;
       else verlist=left(trim(verlist))||","||trim(sasver);
       call symput('verlist',verlist);
    run;
    filename chkinst;
    %if &Verlist = %str( ) %then
      %do;
        title6 "9: Could not find another version of SAS to report on.";
        title8 "This ends the SAS Installation Report.";
        data null;  label blank="---"; blank = " ";  run;
        proc print data=null noobs label ; run;
      %end;
    %else
      %do;
        %put VERLIST = &verlist;
        %do i=1 %to 3;  /* never try more than 3 versions! */
          %let ver = %scan("&verlist",&i,%str(,%"));
          %let versas = &ver;
          %if &ver ^= %str( ) %then
            %do;
              filename getpath pipe "reg query ""HKLM\Software\SAS Institute Inc.\The SAS System\&ver""";
              data _null_;
                 length versas $ 32;
                 infile getpath;
                 input;
                 * translate tabs so command output is same on different versions of Windows;
                 _infile_ = tranwrd(_infile_,'09'x,'    ');
                 if index(_infile_,'DefaultRoot') then
                    do;
                       saspath = substr(_infile_,30);
                       call symput('saspath',trim(saspath));
                   end;
                 if index(_infile_,'DisplayName') then
                    do;
                       versas  = substr(_infile_,30);
                       call symput('versas',trim(versas));
                    end;
              run;
              %put SASPATH = "&saspath";
              %put VERSAS  = "&versas";
              title6 "9(&i): Found another version of SAS (&versas)";
              title7 "This version is installed at &saspath";
              data null;  label blank="---"; blank = " ";  run;
              proc print data=null noobs label ; run;
            %end;
        %end;
      %end;

  %end;

%mend;

/* whee--now run me! */

%sasinstallreporter;
