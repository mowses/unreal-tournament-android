break>../UnrealTournament/System/UnrealTournament.log
del ..\UnrealTournament\System\MutHelloWorld.u
del ..\UnrealTournament\System\MutHelloWorldUdp.u
rmdir ..\UnrealTournament\MutHelloWorld /s/q
rmdir ..\UnrealTournament\MutHelloWorldUdp /s/q
xcopy mutator\MutHelloWorld ..\UnrealTournament\MutHelloWorld /e/h/k/c/i
xcopy mutator\MutHelloWorldUdp ..\UnrealTournament\MutHelloWorldUdp /e/h/k/c/i
..\UnrealTournament\System\ucc make
::..\UnrealTournament\System\UnrealTournament.exe