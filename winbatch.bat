@echo off
cls

@echo ===================================
@echo dont forget to add in your UnrealTournament/System/UnrealTournament.ini the following lines in this exact order:
@echo EditPackages=MutHelloWorldUdp
@echo EditPackages=MutHelloWorld
@echo EditPackages=DecoupledStarterBolt
@echo EditPackages=DecoupledEnforcer
@echo EditPackages=DecoupledShockRifle
@echo EditPackages=DecoupledSuperShockRifle
@echo EditPackages=DecoupledFlakCannon
@echo EditPackages=DecoupledMinigun2
@echo EditPackages=DecoupledBioRifle
@echo EditPackages=DecoupledImpactHammer
@echo EditPackages=DecoupledPulseGun
@echo EditPackages=DecoupledSniperRifle
@echo EditPackages=DecoupledRipper
@echo EditPackages=DecoupledEightball
@echo EditPackages=DecoupledTranslocator
@echo EditPackages=DecoupledChainSaw
@echo EditPackages=DecoupledWarHeadLauncher
@echo ===================================

break>../UnrealTournament/System/UnrealTournament.log
del ..\UnrealTournament\System\MutHelloWorld.u
del ..\UnrealTournament\System\DecoupledEnforcer.u
del ..\UnrealTournament\System\DecoupledShockRifle.u
del ..\UnrealTournament\System\DecoupledSuperShockRifle.u
del ..\UnrealTournament\System\DecoupledFlakCannon.u
del ..\UnrealTournament\System\DecoupledMinigun2.u
del ..\UnrealTournament\System\DecoupledBioRifle.u
del ..\UnrealTournament\System\DecoupledImpactHammer.u
del ..\UnrealTournament\System\DecoupledPulseGun.u
del ..\UnrealTournament\System\DecoupledSniperRifle.u
del ..\UnrealTournament\System\DecoupledRipper.u
del ..\UnrealTournament\System\DecoupledEightball.u
del ..\UnrealTournament\System\DecoupledTranslocator.u
del ..\UnrealTournament\System\DecoupledChainSaw.u
del ..\UnrealTournament\System\DecoupledWarHeadLauncher.u
del ..\UnrealTournament\System\DecoupledStarterBolt.u
del ..\UnrealTournament\System\MutHelloWorldUdp.u

rmdir ..\UnrealTournament\MutHelloWorld /s/q
rmdir ..\UnrealTournament\DecoupledEnforcer /s/q
rmdir ..\UnrealTournament\DecoupledShockRifle /s/q
rmdir ..\UnrealTournament\DecoupledSuperShockRifle /s/q
rmdir ..\UnrealTournament\DecoupledFlakCannon /s/q
rmdir ..\UnrealTournament\DecoupledMinigun2 /s/q
rmdir ..\UnrealTournament\DecoupledBioRifle /s/q
rmdir ..\UnrealTournament\DecoupledImpactHammer /s/q
rmdir ..\UnrealTournament\DecoupledPulseGun /s/q
rmdir ..\UnrealTournament\DecoupledSniperRifle /s/q
rmdir ..\UnrealTournament\DecoupledRipper /s/q
rmdir ..\UnrealTournament\DecoupledEightball /s/q
rmdir ..\UnrealTournament\DecoupledTranslocator /s/q
rmdir ..\UnrealTournament\DecoupledChainSaw /s/q
rmdir ..\UnrealTournament\DecoupledWarHeadLauncher /s/q
rmdir ..\UnrealTournament\DecoupledStarterBolt /s/q
rmdir ..\UnrealTournament\MutHelloWorldUdp /s/q

xcopy mutator\MutHelloWorld ..\UnrealTournament\MutHelloWorld /e/h/k/c/i
xcopy mutator\DecoupledEnforcer ..\UnrealTournament\DecoupledEnforcer /e/h/k/c/i
xcopy mutator\DecoupledShockRifle ..\UnrealTournament\DecoupledShockRifle /e/h/k/c/i
xcopy mutator\DecoupledSuperShockRifle ..\UnrealTournament\DecoupledSuperShockRifle /e/h/k/c/i
xcopy mutator\DecoupledFlakCannon ..\UnrealTournament\DecoupledFlakCannon /e/h/k/c/i
xcopy mutator\DecoupledMinigun2 ..\UnrealTournament\DecoupledMinigun2 /e/h/k/c/i
xcopy mutator\DecoupledBioRifle ..\UnrealTournament\DecoupledBioRifle /e/h/k/c/i
xcopy mutator\DecoupledImpactHammer ..\UnrealTournament\DecoupledImpactHammer /e/h/k/c/i
xcopy mutator\DecoupledPulseGun ..\UnrealTournament\DecoupledPulseGun /e/h/k/c/i
xcopy mutator\DecoupledSniperRifle ..\UnrealTournament\DecoupledSniperRifle /e/h/k/c/i
xcopy mutator\DecoupledRipper ..\UnrealTournament\DecoupledRipper /e/h/k/c/i
xcopy mutator\DecoupledEightball ..\UnrealTournament\DecoupledEightball /e/h/k/c/i
xcopy mutator\DecoupledTranslocator ..\UnrealTournament\DecoupledTranslocator /e/h/k/c/i
xcopy mutator\DecoupledChainSaw ..\UnrealTournament\DecoupledChainSaw /e/h/k/c/i
xcopy mutator\DecoupledWarHeadLauncher ..\UnrealTournament\DecoupledWarHeadLauncher /e/h/k/c/i
xcopy mutator\DecoupledStarterBolt ..\UnrealTournament\DecoupledStarterBolt /e/h/k/c/i
xcopy mutator\MutHelloWorldUdp ..\UnrealTournament\MutHelloWorldUdp /e/h/k/c/i

..\UnrealTournament\System\ucc make
::..\UnrealTournament\System\UnrealTournament.exe