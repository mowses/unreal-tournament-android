:: dont forget to add in your UnrealTournament/System/UnrealTournament.ini the following lines:
:: EditPackages=CustomFireWeapons
:: EditPackages=MutHelloWorldUdp
:: EditPackages=MutHelloWorld

@echo off
cls

@echo ===================================
@echo dont forget to add in your UnrealTournament/System/UnrealTournament.ini the following lines:
@echo EditPackages=CustomFireWeapons
@echo EditPackages=MutHelloWorldUdp
@echo EditPackages=MutHelloWorld
@echo ===================================
@echo also, replace the following line in your UnrealTournament/System/User.ini:
@echo LeftMouse=Fire to LeftMouse=Foo
@echo ===================================

break>../UnrealTournament/System/UnrealTournament.log
del ..\UnrealTournament\System\MutHelloWorld.u
del ..\UnrealTournament\System\CustomFireWeapons.u
del ..\UnrealTournament\System\MutHelloWorldUdp.u

rmdir ..\UnrealTournament\MutHelloWorld /s/q
rmdir ..\UnrealTournament\CustomFireWeapons /s/q
rmdir ..\UnrealTournament\MutHelloWorldUdp /s/q

xcopy mutator\MutHelloWorld ..\UnrealTournament\MutHelloWorld /e/h/k/c/i
xcopy mutator\CustomFireWeapons ..\UnrealTournament\CustomFireWeapons /e/h/k/c/i
xcopy mutator\MutHelloWorldUdp ..\UnrealTournament\MutHelloWorldUdp /e/h/k/c/i

..\UnrealTournament\System\ucc make
::..\UnrealTournament\System\UnrealTournament.exe