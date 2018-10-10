/* --------------------------------------------------------------------
  CÓDIGO PARA IMPORTAR BASE DE RETRONO DO ESCOB'S
   -------------------------------------------------------------------- */
 DATA ESCOBS.RETORNO;
    LENGTH
        P_DLETRA         $ 1
        P_CODI           $ 20
        P_NOME           $ 36
        P_SEXO           $ 1
        P_CGCCPF         $ 14
        FILLER           $ 2
        P_TIPO           $ 2
        P_NUMT           $ 18
        P_FILIAL         $ 5
        P_TOTPAR         $ 2
        P_PARCI          $ 2
        P_PARCF          $ 2
        P_VENCIM         $ 8
        P_DPGDEV         $ 8
        P_SITUAC         $ 3
        P_VLRPRI         $ 12
        P_OBSDEVC        $ 30
        P_OBSDEVN        $ 3
        P_TIPPAG         $ 1
        P_NUMREC         $ 7
        P_VLRTOT         $ 12
        P_VLRJUR         $ 12
        P_VLRMUL         $ 12
        P_VLRTXS         $ 12
        P_VLRCOM         $ 12
        P_VLRACDS        $ 12
        P_VLRLIQ         $ 12
        P_NBORD          $ 7
        P_DEMI           $ 8
        P_DATACO         $ 8
        P_VLRACO         $ 12
        P_TSALPRI        $ 12
        P_DIVTOT         $ 12
        P_DIVJUR         $ 12
        P_DIVMUL         $ 12
        P_DIVHON         $ 12
        P_DIVCOM         $ 12
        P_PRIORIT        $ 12
        P_DESCPRIOT      $ 12
        P_CODBAN         $ 4
        P_NUMCHE         $ 8
        P_CODAGE         $ 8
        P_ID_EMP         $ 17
        P_COBR           $ 5
        P_PER_CO         $ 3
        P_CAMP           $ 5
        P_NUMACORDO      $ 15
        P_VLACORDO       $ 12 ;
    FORMAT
        P_DLETRA         $CHAR1.
        P_CODI           $CHAR20.
        P_NOME           $CHAR36.
        P_SEXO           $CHAR1.
        P_CGCCPF         $CHAR14.
        FILLER           $CHAR2.
        P_TIPO           $CHAR2.
        P_NUMT           $CHAR18.
        P_FILIAL         $CHAR5.
        P_TOTPAR         $CHAR2.
        P_PARCI          $CHAR2.
        P_PARCF          $CHAR2.
        P_VENCIM         $CHAR8.
        P_DPGDEV         $CHAR8.
        P_SITUAC         $CHAR3.
        P_VLRPRI         $CHAR12.
        P_OBSDEVC        $CHAR30.
        P_OBSDEVN        $CHAR3.
        P_TIPPAG         $CHAR1.
        P_NUMREC         $CHAR7.
        P_VLRTOT         $CHAR12.
        P_VLRJUR         $CHAR12.
        P_VLRMUL         $CHAR12.
        P_VLRTXS         $CHAR12.
        P_VLRCOM         $CHAR12.
        P_VLRACDS        $CHAR12.
        P_VLRLIQ         $CHAR12.
        P_NBORD          $CHAR7.
        P_DEMI           $CHAR8.
        P_DATACO         $CHAR8.
        P_VLRACO         $CHAR12.
        P_TSALPRI        $CHAR12.
        P_DIVTOT         $CHAR12.
        P_DIVJUR         $CHAR12.
        P_DIVMUL         $CHAR12.
        P_DIVHON         $CHAR12.
        P_DIVCOM         $CHAR12.
        P_PRIORIT        $CHAR12.
        P_DESCPRIOT      $CHAR12.
        P_CODBAN         $CHAR4.
        P_NUMCHE         $CHAR8.
        P_CODAGE         $CHAR8.
        P_ID_EMP         $CHAR17.
        P_COBR           $CHAR5.
        P_PER_CO         $CHAR3.
        P_CAMP           $CHAR5.
        P_NUMACORDO      $CHAR15.
        P_VLACORDO       $CHAR227. ;
    INFORMAT
        P_DLETRA         $CHAR1.
        P_CODI           $CHAR20.
        P_NOME           $CHAR36.
        P_SEXO           $CHAR1.
        P_CGCCPF         $CHAR14.
        FILLER           $CHAR2.
        P_TIPO           $CHAR2.
        P_NUMT           $CHAR18.
        P_FILIAL         $CHAR5.
        P_TOTPAR         $CHAR2.
        P_PARCI          $CHAR2.
        P_PARCF          $CHAR2.
        P_VENCIM         $CHAR8.
        P_DPGDEV         $CHAR8.
        P_SITUAC         $CHAR3.
        P_VLRPRI         $CHAR12.
        P_OBSDEVC        $CHAR30.
        P_OBSDEVN        $CHAR3.
        P_TIPPAG         $CHAR1.
        P_NUMREC         $CHAR7.
        P_VLRTOT         $CHAR12.
        P_VLRJUR         $CHAR12.
        P_VLRMUL         $CHAR12.
        P_VLRTXS         $CHAR12.
        P_VLRCOM         $CHAR12.
        P_VLRACDS        $CHAR12.
        P_VLRLIQ         $CHAR12.
        P_NBORD          $CHAR7.
        P_DEMI           $CHAR8.
        P_DATACO         $CHAR8.
        P_VLRACO         $CHAR12.
        P_TSALPRI        $CHAR12.
        P_DIVTOT         $CHAR12.
        P_DIVJUR         $CHAR12.
        P_DIVMUL         $CHAR12.
        P_DIVHON         $CHAR12.
        P_DIVCOM         $CHAR12.
        P_PRIORIT        $CHAR12.
        P_DESCPRIOT      $CHAR12.
        P_CODBAN         $CHAR4.
        P_NUMCHE         $CHAR8.
        P_CODAGE         $CHAR8.
        P_ID_EMP         $CHAR17.
        P_COBR           $CHAR5.
        P_PER_CO         $CHAR3.
        P_CAMP           $CHAR5.
        P_NUMACORDO      $CHAR15.
        P_VLACORDO       $CHAR227. ;
    INFILE 'CAMINHO DO ARQUIVO'
        LRECL=1122
        ENCODING="WLATIN1"
        TRUNCOVER ;
    INPUT
        @1     P_DLETRA         $CHAR1.
        @2     P_CODI           $CHAR20.
        @22    P_NOME           $CHAR36.
        @58    P_SEXO           $CHAR1.
        @59    P_CGCCPF         $CHAR14.
        @73    FILLER           $CHAR2.
        @75    P_TIPO           $CHAR2.
        @77    P_NUMT           $CHAR18.
        @95    P_FILIAL         $CHAR5.
        @100   P_TOTPAR         $CHAR2.
        @102   P_PARCI          $CHAR2.
        @104   P_PARCF          $CHAR2.
        @106   P_VENCIM         $CHAR8.
        @114   P_DPGDEV         $CHAR8.
        @122   P_SITUAC         $CHAR3.
        @125   P_VLRPRI         $CHAR12.
        @137   P_OBSDEVC        $CHAR30.
        @167   P_OBSDEVN        $CHAR3.
        @170   P_TIPPAG         $CHAR1.
        @171   P_NUMREC         $CHAR7.
        @178   P_VLRTOT         $CHAR12.
        @190   P_VLRJUR         $CHAR12.
        @202   P_VLRMUL         $CHAR12.
        @214   P_VLRTXS         $CHAR12.
        @226   P_VLRCOM         $CHAR12.
        @238   P_VLRACDS        $CHAR12.
        @250   P_VLRLIQ         $CHAR12.
        @262   P_NBORD          $CHAR7.
        @269   P_DEMI           $CHAR8.
        @277   P_DATACO         $CHAR8.
        @285   P_VLRACO         $CHAR12.
        @297   P_TSALPRI        $CHAR12.
        @309   P_DIVTOT         $CHAR12.
        @321   P_DIVJUR         $CHAR12.
        @333   P_DIVMUL         $CHAR12.
        @345   P_DIVHON         $CHAR12.
        @357   P_DIVCOM         $CHAR12.
        @369   P_PRIORIT        $CHAR12.
        @381   P_DESCPRIOT      $CHAR12.
        @393   P_CODBAN         $CHAR4.
        @397   P_NUMCHE         $CHAR8.
        @405   P_CODAGE         $CHAR8.
        @413   P_ID_EMP         $CHAR17.
        @430   P_COBR           $CHAR5.
        @435   P_PER_CO         $CHAR3.
        @438   P_CAMP           $CHAR5.
        @443   P_NUMACORDO      $CHAR15.
        @458   P_VLACORDO       $CHAR227. ;
RUN;
