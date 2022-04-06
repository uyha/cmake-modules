$modules = Get-ChildItem *.cmake -Recurse | `
           Resolve-Path -Relative | `
           ForEach-Object {$_ -Replace "\.\\"} | `
           ForEach-Object {$_ -Replace "\\", "/"} | `
           ForEach-Object {"`"$_`""}
$directories = Get-ChildItem *cmake -Recurse | `
               Resolve-Path -Relative | `
               Split-Path | `
               Where-Object { $_ -ne '.' } | `
               Sort-Object -Unique | `
               Split-Path -Leaf |
               ForEach-Object {"`"$_`""}

Set-Content -Path $PSScriptRoot/pull-modules.ps1 -Value @"
`$repo="https://github.com/uyha/cmake-modules"
`$raw_repo="https://raw.githubusercontent.com/uyha/cmake-modules/master"
`$modules = @(
  $($modules -Join "`n  ")
)
`$directories = @(
  $($directories -Join "`n  ")
)

foreach(`$directory in `$directories){
  if(-not (Test-Path `$directory -PathType Container)){
    [void](New-Item `$directory -ItemType Directory)
  }
}

`$urls = `$modules | ForEach-Object {"`$(`$raw_repo)/`$_"}
Start-BitsTransfer -Source `$urls -Destination `$modules
"@
