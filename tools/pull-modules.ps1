$repo="https://github.com/uyha/cmake-modules"
$raw_repo="https://raw.githubusercontent.com/uyha/cmake-modules/master"
$modules = @(
  "Ccache.cmake"
  "CompileOptions.cmake"
  "Conan.cmake"
  "FindConan.cmake"
  "FindPoetry.cmake"
  "Poetry.cmake"
)
$destinations = $modules | ForEach-Object { "cmake/$_" }
$directories = @(
  "cmake/"
)

foreach($directory in $directories){
  if(-not (Test-Path $directory -PathType Container)){
    [void](New-Item $directory -ItemType Directory)
  }
}

$urls = $modules | ForEach-Object {"$($raw_repo)/$_"}
Start-BitsTransfer -Source $urls -Destination $destinations
