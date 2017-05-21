@echo off
cls

@echo ===================================
@echo dont forget to add in your UnrealTournament/System/UnrealTournament.ini the following lines:
@echo EditPackages=DecoupledEnforcer
@echo EditPackages=MutHelloWorldUdp
@echo EditPackages=MutHelloWorld
@echo ===================================

break>../UnrealTournament/System/UnrealTournament.log
del ..\UnrealTournament\System\MutHelloWorld.u
del ..\UnrealTournament\System\DecoupledEnforcer.u
del ..\UnrealTournament\System\MutHelloWorldUdp.u

rmdir ..\UnrealTournament\MutHelloWorld /s/q
rmdir ..\UnrealTournament\DecoupledEnforcer /s/q
rmdir ..\UnrealTournament\MutHelloWorldUdp /s/q

xcopy mutator\MutHelloWorld ..\UnrealTournament\MutHelloWorld /e/h/k/c/i
xcopy mutator\DecoupledEnforcer ..\UnrealTournament\DecoupledEnforcer /e/h/k/c/i
xcopy mutator\MutHelloWorldUdp ..\UnrealTournament\MutHelloWorldUdp /e/h/k/c/i

..\UnrealTournament\System\ucc make
::..\UnrealTournament\System\UnrealTournament.exe