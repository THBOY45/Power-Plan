# ============================================================================
#  SUPER Performance - installation / verification du plan d'alimentation
#  A executer en PowerShell ADMINISTRATEUR (clic droit > Executer en tant
#  qu'administrateur), depuis le dossier contenant SUPER_PERFORMANCE.pow.
#
#  1. importe SUPER_PERFORMANCE.pow
#  2. (re)applique tous les reglages un par un avec powercfg
#  3. active le plan
# ============================================================================
#Requires -Version 5.1
#Requires -RunAsAdministrator
[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$PlanName = "SUPER Performance"
$PowFile  = Join-Path $PSScriptRoot "SUPER_PERFORMANCE.pow"
$GuidRe   = '[0-9a-fA-F]{8}-(?:[0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}'

function Get-SchemeGuid {
    param([string]$Name)
    $line = (& powercfg.exe /list | Select-String -SimpleMatch $Name | Select-Object -First 1)
    if ($line) { return ([regex]::Match($line.ToString(), $GuidRe)).Value }
    return $null
}

Write-Host "==> Import de $PowFile"
if (Test-Path $PowFile) {
    $out = & powercfg.exe /import "$PowFile" 2>&1
    $scheme = Get-SchemeGuid -Name $PlanName
    if (-not $scheme) { $scheme = ([regex]::Match(($out -join "`n"), $GuidRe)).Value }
} else {
    Write-Warning "Fichier .pow introuvable, creation depuis 'Performances elevees'."
    $scheme = $null
}

if (-not $scheme) {
    Write-Host "==> Creation du plan depuis 'Performances elevees'"
    $out    = & powercfg.exe -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>&1
    $scheme = ([regex]::Match(($out -join "`n"), $GuidRe)).Value
    if (-not $scheme) { throw "Impossible de creer le plan d'alimentation." }
    & powercfg.exe -changename $scheme $PlanName "Performances maximales AC/DC - aucun etat d'economie d'energie"
}

Write-Host "==> Plan : $scheme"

# Subgroup                          Setting                              AC  DC
$S = @(
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="893dee8e-2bef-41e0-89c6-b55d0929964c"; AC=100; DC=100},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="893dee8e-2bef-41e0-89c6-b55d0929964d"; AC=100; DC=100},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="bc5038f7-23e0-4960-96da-33abaf5935ec"; AC=100; DC=100},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="bc5038f7-23e0-4960-96da-33abaf5935ed"; AC=100; DC=100},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="be337238-0d82-4146-a960-4f3749d470c7"; AC=2;   DC=2},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="45bcc044-d885-43e2-8605-ee0ec6e96b59"; AC=100; DC=100},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="36687f9e-e3a5-4dbf-b1dc-15eb381c6863"; AC=0;   DC=0},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="36687f9e-e3a5-4dbf-b1dc-15eb381c6864"; AC=0;   DC=0},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="36687f9e-e3a5-4dbf-b1dc-15eb381c6865"; AC=0;   DC=0},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="465e1f50-b610-473a-ab58-00d1077dc418"; AC=2;   DC=2},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="465e1f50-b610-473a-ab58-00d1077dc419"; AC=2;   DC=2},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="984cf492-3bed-4488-a8f9-4286c97bf5aa"; AC=1;   DC=1},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="0cc5b647-c1df-4637-891a-dec35c318583"; AC=100; DC=100},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="0cc5b647-c1df-4637-891a-dec35c318584"; AC=100; DC=100},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="ea062031-0e34-4ff1-9b6d-eb1059334028"; AC=100; DC=100},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="ea062031-0e34-4ff1-9b6d-eb1059334029"; AC=100; DC=100},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="2ddd5a84-5a71-437e-912a-db0b8c788732"; AC=1;   DC=1},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="943c8cb6-6f93-4227-ad87-e9a3feec08d1"; AC=50;  DC=50},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="4d2b0152-7d5c-498b-88e2-34345392a2c5"; AC=15;  DC=15},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb"; AC=0;   DC=0},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="5d76a2ca-e8c0-402f-a133-2158492d58ad"; AC=1;   DC=1},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="94d3a615-a899-4ac5-ae2b-e4d8f634367f"; AC=1;   DC=1},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="93b8b6dc-0698-4d1c-9ee4-0644e900c85d"; AC=2;   DC=2},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="bae08b81-2d5e-4688-ad6a-13243356654b"; AC=2;   DC=2},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="616cdaa5-695e-4545-97ad-97dc2d1bdd88"; AC=100; DC=100},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="616cdaa5-695e-4545-97ad-97dc2d1bdd89"; AC=100; DC=100},
  @{Sub="54533251-82be-4824-96c1-47b60b740d00"; Id="619b7505-003b-4e82-b7a6-4dd29c300971"; AC=100; DC=100},
  @{Sub="7516b95f-f776-4464-8c53-06167f40cc99"; Id="3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e"; AC=0;   DC=0},
  @{Sub="7516b95f-f776-4464-8c53-06167f40cc99"; Id="8ec4b3a5-6868-48c2-be75-4f3044be88a7"; AC=0;   DC=0},
  @{Sub="7516b95f-f776-4464-8c53-06167f40cc99"; Id="17aaa29b-8b43-4b94-aafe-35f64daaf1ee"; AC=0;   DC=0},
  @{Sub="7516b95f-f776-4464-8c53-06167f40cc99"; Id="fbd9aa66-9553-4097-ba44-ed6e9d65eab8"; AC=0;   DC=0},
  @{Sub="7516b95f-f776-4464-8c53-06167f40cc99"; Id="90959d22-d6a1-49b9-af93-bce885ad335b"; AC=0;   DC=0},
  @{Sub="238c9fa8-0aad-41ed-83f4-97be242c8f20"; Id="29f6c1db-86da-48c5-9fdb-f2b67b1f44da"; AC=0;   DC=0},
  @{Sub="238c9fa8-0aad-41ed-83f4-97be242c8f20"; Id="9d7815a6-7ee4-497e-8888-515a05f02364"; AC=0;   DC=0},
  @{Sub="238c9fa8-0aad-41ed-83f4-97be242c8f20"; Id="94ac6d29-73ce-41a6-809f-6363ba21b47e"; AC=0;   DC=0},
  @{Sub="238c9fa8-0aad-41ed-83f4-97be242c8f20"; Id="bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d"; AC=0;   DC=0},
  @{Sub="0012ee47-9041-4b5d-9b77-535fba8b1442"; Id="6738e2c4-e8a5-4a42-b16a-e040e769756e"; AC=0;   DC=0},
  @{Sub="0012ee47-9041-4b5d-9b77-535fba8b1442"; Id="80e3c60e-bb94-4ad8-bbe0-0d3195efc663"; AC=0;   DC=0},
  @{Sub="0012ee47-9041-4b5d-9b77-535fba8b1442"; Id="0b2d69d7-a2a1-449c-9680-f91c70521c60"; AC=0;   DC=0},
  @{Sub="0012ee47-9041-4b5d-9b77-535fba8b1442"; Id="dab60367-53fe-4fbc-825e-521d069d2456"; AC=0;   DC=0},
  @{Sub="0012ee47-9041-4b5d-9b77-535fba8b1442"; Id="fc95af4d-40e7-4b6d-835a-56d131dbc80e"; AC=0;   DC=0},
  @{Sub="0012ee47-9041-4b5d-9b77-535fba8b1442"; Id="dbc9e238-6de9-49e3-92cd-8c2b4946b472"; AC=0;   DC=0},
  @{Sub="2a737441-1930-4402-8d77-b2bebba308a3"; Id="48e6b7a6-50f5-4782-a5d4-53bb8f07e226"; AC=0;   DC=0},
  @{Sub="2a737441-1930-4402-8d77-b2bebba308a3"; Id="d4e98f31-5ffe-4ce1-be31-1b38b384c009"; AC=0;   DC=0},
  @{Sub="501a4d13-42af-4429-9fd1-a8218c268e20"; Id="ee12f906-d277-404b-b6da-e5fa1a576df5"; AC=0;   DC=0},
  @{Sub="2e601130-5351-4d9d-8e04-252966bad054"; Id="d502f7ee-1dc7-4efd-a55d-f04b6f5c0545"; AC=0;   DC=0},
  @{Sub="2e601130-5351-4d9d-8e04-252966bad054"; Id="c36f0eb4-2988-4a70-8eee-0884fc2c2433"; AC=0;   DC=0},
  @{Sub="19cbb8fa-5279-450e-9fac-8a3d5fedd0c1"; Id="12bbebe6-58d6-4636-95bb-3217ef867c1a"; AC=0;   DC=0},
  @{Sub="0d7dbae2-4294-402a-ba8e-26777e8488cd"; Id="309dce9b-bef4-4119-9921-a851fb12f0f4"; AC=1;   DC=1}
)

foreach ($s in $S) {
    & powercfg.exe -setacvalueindex $scheme $s.Sub $s.Id $s.AC | Out-Null
    & powercfg.exe -setdcvalueindex $scheme $s.Sub $s.Id $s.DC | Out-Null
}
& powercfg.exe /setactive $scheme | Out-Null
Write-Host "==> $($S.Count) reglages appliques (AC + DC)."
& powercfg.exe /getactivescheme
Write-Host "Termine. Pour revenir en arriere : powercfg /setactive SCHEME_BALANCED"
