@echo off
REM Turns off the print messsages.

cmd /r dir *.png, *.tif, *.jpg, *.jpeg, *.exr /b > filename.txt
REM Creates a .txt file that contains the names of every file with those extensions (png, tif, jpg, jpeg, exr).

set /p name_f=< filename.txt
REM Store the name of the .txt file into a variable (for future uses)

set start_frame=%name_f:~-8,4%
REM Store the last four digits/characters of the first line in the file, that way we can know where the sequence begins

set name_out=%name_f:~0,-8%
REM Store only the name of the files without the numbers and extension by ignoring the last eight characters (for example 0001.jpg) 

set ext=%name_f:~-4,5%
REM Store the recognized extension in a variable

for /f "tokens=1*" %%a in (filename.txt) do set last_frame=%%a:~-8,4%
REM Runs a loop through all the names writen in the .txt to the last one, so it can know what is the last number of the sequence


set loop_vid=3
set frames=12
REM This are the only two variables you should edit, Loop_vid means the amount (plus one) of loops, and frames is the "frame_rate"


ffmpeg -r %frames% -start_number %start_frame% -i %name_out%%%04d%ext% -vcodec libx264 -crf 25  -pix_fmt yuv420p %name_out%_out.mp4
REM here we use all the info we stored before to run a ffmpeg code and save the output in .mp4

ffmpeg -stream_loop %loop_vid% -i %name_out%_out.mp4 -c copy %name_out%_looped_out.mp4
REM this ffmpeg code takes the exported .mp4 and loops it the times we defined in the variable

ffmpeg -i %name_out%_out.mp4 %name_out%_out.gif
REM this ffmpeg code converts the first .mp4 video to a .gif

del filename.txt
REM this deletes the .txt that were generated at the beginning for taking all the info needed for ffmpeg to work