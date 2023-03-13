rem ************************************************* **************************
rem Take snapshots for the VMS kubemaster-1, kubeworker-1, kubeworker-2
rem 
rem @author: Martien van den Akker, Oracle Netherlands Consulting.
rem 
rem ***************************************************************************
@echo off
rem Get date from: https://stackoverflow.com/questions/10945572/windows-batch-formatted-date-into-variable
@for /f %%x in ('wmic path win32_localtime get /format:list ^| findstr "="') do set %%x
@set TODAY=%Year%-%Month%-%Day%
@echo %TODAY%
@set KM1_NAME=kubemaster-1
@set KM1_SNAPSHOT_NAME="%KM1_NAME%_%TODAY%"
@set KM1_SNAPSHOT_DESCRIPTION="Snapshot taken on %TODAY%"
@set KW1_NAME=kubeworker-1
@set KW1_SNAPSHOT_NAME="%KW1_NAME%_%TODAY%"
@set KW1_SNAPSHOT_DESCRIPTION="Snapshot taken on %TODAY%"
@set KW2_NAME=kubeworker-2
@set KW2_SNAPSHOT_NAME="%KW2_NAME%_%TODAY%"
@set KW2_SNAPSHOT_DESCRIPTION="Snapshot taken on %TODAY%"
rem Take snapshot from: https://www.techrepublic.com/article/how-to-automate-virtualbox-snapshots-with-the-vboxmanage-command/
@echo Take snapshot for %KM1_NAME%, Snapshot name: %KM1_SNAPSHOT_NAME%, description: %KM1_SNAPSHOT_DESCRIPTION%
@VBoxManage snapshot %KM1_NAME% take %KM1_SNAPSHOT_NAME% --description %KM1_SNAPSHOT_DESCRIPTION%
@echo Take snapshot for %KW1_NAME%, Snapshot name: %KW1_SNAPSHOT_NAME%, description: %KW1_SNAPSHOT_DESCRIPTION%
@VBoxManage snapshot %KW1_NAME% take %KW1_SNAPSHOT_NAME% --description %KW1_SNAPSHOT_DESCRIPTION%
@echo Take snapshot for %KW2_NAME%, Snapshot name: %KW2_SNAPSHOT_NAME%, description: %KW2_SNAPSHOT_DESCRIPTION%
@VBoxManage snapshot %KW2_NAME% take %KW2_SNAPSHOT_NAME% --description %KW2_SNAPSHOT_DESCRIPTION%