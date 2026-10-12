# Execute only on a GitHub-hosted Windows runner.
$ErrorActionPreference = 'Stop'
if ($env:GITHUB_ACTIONS -ne 'true' -or $env:RUNNER_ENVIRONMENT -ne 'github-hosted') {
    throw 'Windows branding generation must run on GitHub-hosted Actions.'
}

$runner = Join-Path $PSScriptRoot '../apps/crunch_cartel/windows/runner'
$mainPath = Join-Path $runner 'main.cpp'
$main = Get-Content -LiteralPath $mainPath -Raw
[System.IO.File]::WriteAllText($mainPath, $main.Replace('L"crunch_cartel"', 'L"Crunch Cartel"').Replace('1280, 720', '1366, 768'))
$resourcePath = Join-Path $runner 'Runner.rc'
$resource = Get-Content -LiteralPath $resourcePath -Raw
[System.IO.File]::WriteAllText($resourcePath, $resource.Replace('"crunch_cartel"', '"Crunch Cartel"').Replace('com.crunchcartel', 'Crunch Cartel'))

Add-Type -AssemblyName System.Drawing
Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public static class IconNative { [DllImport("user32.dll")] public static extern bool DestroyIcon(IntPtr handle); }'
$bitmap = [System.Drawing.Bitmap]::new(64, 64)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.Clear([System.Drawing.Color]::FromArgb(9, 10, 9))
$brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 229, 0))
$points = [System.Drawing.Point[]]@(
    [System.Drawing.Point]::new(35, 5),
    [System.Drawing.Point]::new(13, 37),
    [System.Drawing.Point]::new(29, 37),
    [System.Drawing.Point]::new(25, 59),
    [System.Drawing.Point]::new(51, 25),
    [System.Drawing.Point]::new(35, 25)
)
$graphics.FillPolygon($brush, $points)
$handle = $bitmap.GetHicon()
$icon = [System.Drawing.Icon]::FromHandle($handle)
$stream = [System.IO.File]::Create((Join-Path $runner 'resources/app_icon.ico'))
try { $icon.Save($stream) }
finally {
    $stream.Dispose()
    $icon.Dispose()
    [void][IconNative]::DestroyIcon($handle)
    $brush.Dispose()
    $graphics.Dispose()
    $bitmap.Dispose()
}
