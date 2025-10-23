# Windows PowerShell script to start Expo development server
# This script provides Windows-specific optimizations for Expo development

param(
    [string]$Platform = "all",
    [switch]$Clear = $false,
    [switch]$Tunnel = $false,
    [switch]$Help = $false
)

if ($Help) {
    Write-Host "Windows Expo Start Script" -ForegroundColor Green
    Write-Host "Usage: .\windows-start.ps1 [options]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Cyan
    Write-Host "  -Platform <platform>  Platform to start (android, ios, web, all) [default: all]" -ForegroundColor White
    Write-Host "  -Clear               Clear Metro cache before starting" -ForegroundColor White
    Write-Host "  -Tunnel              Use tunnel connection for development" -ForegroundColor White
    Write-Host "  -Help                Show this help message" -ForegroundColor White
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Cyan
    Write-Host "  .\windows-start.ps1" -ForegroundColor White
    Write-Host "  .\windows-start.ps1 -Platform android -Clear" -ForegroundColor White
    Write-Host "  .\windows-start.ps1 -Tunnel" -ForegroundColor White
    exit 0
}

# Set error action preference
$ErrorActionPreference = "Stop"

# Function to check if a command exists
function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Function to check Node.js version
function Test-NodeVersion {
    try {
        $nodeVersion = node --version
        $version = [version]($nodeVersion -replace 'v', '')
        $minVersion = [version]"18.0.0"
        
        if ($version -lt $minVersion) {
            Write-Warning "Node.js version $nodeVersion detected. Recommended version is 18.0.0 or higher."
        } else {
            Write-Host "✓ Node.js version $nodeVersion is compatible" -ForegroundColor Green
        }
    } catch {
        Write-Error "Node.js is not installed or not in PATH. Please install Node.js 18+ from https://nodejs.org/"
        exit 1
    }
}

# Function to check if Expo CLI is installed
function Test-ExpoCLI {
    if (-not (Test-Command "npx")) {
        Write-Error "npx is not available. Please ensure Node.js and npm are properly installed."
        exit 1
    }
    
    try {
        npx expo --version | Out-Null
        Write-Host "✓ Expo CLI is available" -ForegroundColor Green
    } catch {
        Write-Warning "Expo CLI not found. Installing globally..."
        npm install -g @expo/cli
    }
}

# Function to check dependencies
function Test-Dependencies {
    if (-not (Test-Path "package.json")) {
        Write-Error "package.json not found. Please run this script from the project root directory."
        exit 1
    }
    
    if (-not (Test-Path "node_modules")) {
        Write-Warning "node_modules not found. Installing dependencies..."
        npm install
    }
    
    Write-Host "✓ Dependencies are ready" -ForegroundColor Green
}

# Function to set up Windows-specific environment
function Set-WindowsEnvironment {
    # Set NODE_OPTIONS for better performance on Windows
    $env:NODE_OPTIONS = "--max-old-space-size=4096"
    
    # Set Metro bundler options for Windows
    $env:METRO_BUNDLER_OPTIONS = "--reset-cache"
    
    # Enable Windows-specific optimizations
    $env:EXPO_USE_WINDOWS_OPTIMIZATIONS = "true"
    
    Write-Host "✓ Windows environment configured" -ForegroundColor Green
}

# Function to start Expo with platform-specific options
function Start-ExpoDevelopment {
    $expoArgs = @("start")
    
    switch ($Platform.ToLower()) {
        "android" { $expoArgs += "--android" }
        "ios" { $expoArgs += "--ios" }
        "web" { $expoArgs += "--web" }
        "all" { }
        default {
            Write-Warning "Invalid platform '$Platform'. Using 'all' instead."
        }
    }
    
    if ($Clear) {
        $expoArgs += "--clear"
        Write-Host "✓ Metro cache will be cleared" -ForegroundColor Yellow
    }
    
    if ($Tunnel) {
        $expoArgs += "--tunnel"
        Write-Host "✓ Using tunnel connection" -ForegroundColor Yellow
    }
    
    Write-Host "Starting Expo development server..." -ForegroundColor Cyan
    Write-Host "Platform: $Platform" -ForegroundColor White
    Write-Host "Clear cache: $Clear" -ForegroundColor White
    Write-Host "Tunnel: $Tunnel" -ForegroundColor White
    Write-Host ""
    
    try {
        npx expo @expoArgs
    } catch {
        Write-Error "Failed to start Expo development server. Error: $_"
        exit 1
    }
}

# Main execution
Write-Host "🚀 Windows Expo Development Server" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green
Write-Host ""

# Pre-flight checks
Test-NodeVersion
Test-ExpoCLI
Test-Dependencies
Set-WindowsEnvironment

Write-Host ""
Write-Host "Starting development server..." -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

# Start the development server
Start-ExpoDevelopment