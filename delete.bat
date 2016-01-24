REM Usage:
REM Drag the file/folder to delete to this batch script and select YES.
REM

DEL /F /A /Q \\?\%1
RD /S /Q \\?\%1
