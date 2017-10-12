@echo off
rem 设置q.k位置
set qhome=%~dp0q

rem 切换到当前盘符
%~d0

rem 启动 tickerplant
cd  %~dp0\q\tick
start "tickerplant(5010)" /min %~dp0\q\w32\q.exe tick/tick.q   -p 5010 -u %~dp0\q\qusers

rem 等待0.5秒，确保tickerplant已启动
ping 127.0.0.1 -n 5 -w 500 > nul

rem 启动 rdb
cd  %~dp0\q\tick
start "rdb(5011)" /min %~dp0\q\w32\q.exe tick/tick/r.q -p 5011  -U %~dp0\q\qusers

rem 启动 hdb
cd  %~dp0\q\tick
start "hdb(5012)" /min %~dp0\q\w32\q.exe tick/hdb.q -p 5012 -U %~dp0\q\qusers

rem 启动 show 
cd  %~dp0\q\tick
start "show(5019)" /min %~dp0\q\w32\q.exe tick/cx.q show -p 5019 -U %~dp0\q\qusers

rem 启动 wind data feed
cd  %~dp0
start "windmd(5015)" /min %~dp0\q\w32\q.exe windmd.q -p 5015  -U %~dp0\q\qusers

cd %~dp0


