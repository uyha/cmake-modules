& $PSScriptRoot/gen-pull-modules.ps1

git ls-files --error-unmatch $PSScriptRoot/pull-modules.ps1 2>&1 | Out-Null
$IsNew=$LastExitCode
git diff --exit-code $PSScriptRoot/pull-modules.ps1 2>&1 | Out-Null
$HasChanged=$LastExitCode

Write-Output "$IsNew $HasChanged"
if($IsNew -ne 0 -or $HasChanged -ne 0){
  git commit "$PSScriptRoot/gen-pull-modules.sh" -m 'Regenerate pull-modules.ps1'
  git push origin "$(git rev-parse --abbrev-ref HEAD)"
}
