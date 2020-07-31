@echo off
cmd /r dir *.png, *.tif, *.jpg, *.jpeg, *.exr /b > filename.txt
set /p name_f=< filename.txt
set start_frame=%name_f:~-8,4%
set name_out=%name_f:~0,-8%
set frames=12
set ext=%name_f:~-4,5%
set loop_vid=3
for /f "tokens=1*" %%a in (filename.txt) do set last_frame=%%a:~-8,4%

ffmpeg -r %frames% -start_number %start_frame% -i %name_out%%%04d%ext% -vcodec libx264 -crf 25  -pix_fmt yuv420p %name_out%_out.mp4

ffmpeg -stream_loop %loop_vid% -i %name_out%_out.mp4 -c copy %name_out%_looped_out.mp4

ffmpeg -i %name_out%_out.mp4 %name_out%_out.gif
del filename.txt