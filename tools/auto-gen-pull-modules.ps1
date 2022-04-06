& $PSScriptRoot/gen-pull-modules.ps1

git ls-files --error-unmatch $PSScriptRoot/pull-modules.ps1 2>&1 | Out-Null
$IsNew=$LastExitCode
git diff --exit-code $PSScriptRoot/pull-modules.ps1 2>&1 | Out-Null
$HasChanged=$LastExitCode

if($IsNew -ne 0 -or $HasChanged -ne 0){
  git add "$PSScriptRoot/pull-modules.ps1"
  git commit -m 'Regenerate pull-modules.ps1'
  git push origin "$(git rev-parse --abbrev-ref HEAD)"
}
