@echo off
REM ****************************************************************************
REM Vivado (TM) v2019.2 (64-bit)
REM
REM Filename    : elaborate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for elaborating the compiled design
REM
REM Generated by Vivado on Sun Apr 19 22:07:31 -0600 2020
REM SW Build 2708876 on Wed Nov  6 21:40:23 MST 2019
REM
REM Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
REM
REM usage: elaborate.bat
REM
REM ****************************************************************************
echo "xelab -wto 635397c302724b48bc83c18a8cb2b85f --incr --debug typical --relax --mt 2 -L work -L xil_defaultlib -L secureip --snapshot LPU_test_behav xil_defaultlib.LPU_test -log elaborate.log"
call xelab  -wto 635397c302724b48bc83c18a8cb2b85f --incr --debug typical --relax --mt 2 -L work -L xil_defaultlib -L secureip --snapshot LPU_test_behav xil_defaultlib.LPU_test -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
