library(sasr)

#get a sas session. This function returns the last session created or creates a new sas session if there are no previous session
sas_session <- get_sas_session()


#submit a code to sas compute
result <- run_sas("
   proc freq data = sashelp.heart;
   tables _CHARACTER_;
   run;
 ")


#result contains LOG and LST

#See Log
print(head(result$LOG))

#See Result
print(head(result$LST))


#can we copy sas dataset to R? for this let us produce some output first


result <- run_sas("
   proc freq data = sashelp.heart;
   tables _CHARACTER_ / out=FreqCount;
   run;
 ")


#copy the data

freq_count <-  sas_session$sd2df('FreqCount',libref='WORK')

print(freq_count)

#move some data from R to sas we will move mtcars dataframe available in R to SAS WORK library

upload <- sas_session$df2sd(mtcars,table ='mt_df',libref='WORK')


#Now we can run SAS PROCS on WORK.mt_df dataset


result <- run_sas("
   proc freq data = work.mt_df;
   tables _NUMERIC_ / out=mean;
   run;
 ")


#we can check if the table was created in SAS session

sas_session$datasets(libref="WORK")
