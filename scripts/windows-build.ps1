# Windows PowerShell script for building Expo React Native app
# This script handles the build process with Windows-specific optimizations

param(
    [string]$Platform = "all",
    [string]$Profile = "development",
    [switch]$Local = $false,
    [switch]$Clear = $false,
    [switch]$Help = $false
)

if ($Help) {
    Write-Host "Windows Expo Build Script" -ForegroundColor Green
    Write-Host "Usage: .\windows-build.ps1 [options]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Cyan
    Write-Host "  -Platform <platform>  Platform to build (android, ios, all) [default: all]" -ForegroundColor White
    Write-Host "  -Profile <profile>    Build profile (development, preview, production) [default: development]" -ForegroundColor White
    Write-Host "  -Local               Build locally instead of using EAS" -ForegroundColor White
    Write-Host "  -Clear               Clear build cache before building" -ForegroundColor White
    Write-Host "  -Help                Show this help message" -ForegroundColor White
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Cyan
    Write-Host "  .\windows-build.ps1" -ForegroundColor White
    Write-Host "  .\windows-build.ps1 -Platform android -Profile production" -ForegroundColor White
    Write-Host "  .\windows-build.ps1 -Local -Clear" -ForegroundColor White
    exit 0
}

# Set error action preference
$ErrorActionPreference = "Stop"

# Function to check prerequisites
function Test-Prerequisites {
    Write-Host "Checking prerequisites..." -ForegroundColor Cyan
    
    # Check Node.js
    try {
        $nodeVersion = node --version
        Write-Host "✓ Node.js $nodeVersion" -ForegroundColor Green
    } catch {
        Write-Error "Node.js is not installed. Please install Node.js 18+ from https://nodejs.org/"
        exit 1
    }
    
    # Check npm
    try {
        $npmVersion = npm --version
        Write-Host "✓ npm $npmVersion" -ForegroundColor Green
    } catch {
        Write-Error "npm is not available. Please ensure Node.js and npm are properly installed."
        exit 1
    }
    
    # Check if we're in the right directory
    if (-not (Test-Path "package.json")) {
        Write-Error "package.json not found. Please run this script from the project root directory."
        exit 1
    }
    
    # Check if EAS CLI is installed (for cloud builds)
    if (-not $Local) {
        try {
            npx eas --version | Out-Null
            Write-Host "✓ EAS CLI is available" -ForegroundColor Green
        } catch {
            Write-Warning "EAS CLI not found. Installing..."
            npm install -g @expo/eas-cli
        }
    }
}

# Function to install dependencies
function Install-Dependencies {
    Write-Host "Installing dependencies..." -ForegroundColor Cyan
    
    if (-not (Test-Path "node_modules")) {
        Write-Host "Installing npm packages..." -ForegroundColor Yellow
        npm install
    } else {
        Write-Host "✓ Dependencies already installed" -ForegroundColor Green
    }
}

# Function to run prebuild
function Invoke-Prebuild {
    Write-Host "Running prebuild..." -ForegroundColor Cyan
    
    $prebuildArgs = @("prebuild")
    
    if ($Clear) {
        $prebuildArgs += "--clean"
        Write-Host "✓ Clean prebuild enabled" -ForegroundColor Yellow
    }
    
    try {
        npx expo @prebuildArgs
        Write-Host "✓ Prebuild completed successfully" -ForegroundColor Green
    } catch {
        Write-Error "Prebuild failed. Error: $_"
        exit 1
    }
}

# Function to build for Android
function Build-Android {
    Write-Host "Building for Android..." -ForegroundColor Cyan
    
    if ($Local) {
        Write-Host "Building locally..." -ForegroundColor Yellow
        try {
            npx expo run:android
            Write-Host "✓ Android build completed locally" -ForegroundColor Green
        } catch {
            Write-Error "Local Android build failed. Error: $_"
            exit 1
        }
    } else {
        Write-Host "Building with EAS..." -ForegroundColor Yellow
        try {
            npx eas build --platform android --profile $Profile
            Write-Host "✓ Android build submitted to EAS" -ForegroundColor Green
        } catch {
            Write-Error "EAS Android build failed. Error: $_"
            exit 1
        }
    }
}

# Function to build for iOS
function Build-iOS {
    Write-Host "Building for iOS..." -ForegroundColor Cyan
    
    if ($Local) {
        Write-Host "Building locally..." -ForegroundColor Yellow
        try {
            npx expo run:ios
            Write-Host "✓ iOS build completed locally" -ForegroundColor Green
        } catch {
            Write-Error "Local iOS build failed. Error: $_"
            exit 1
        }
    } else {
        Write-Host "Building with EAS..." -ForegroundColor Yellow
        try {
            npx eas build --platform ios --profile $Profile
            Write-Host "✓ iOS build submitted to EAS" -ForegroundColor Green
        } catch {
            Write-Error "EAS iOS build failed. Error: $_"
            exit 1
        }
    }
}

# Function to build for Web
function Build-Web {
    Write-Host "Building for Web..." -ForegroundColor Cyan
    
    try {
        npx expo export --platform web
        Write-Host "✓ Web build completed" -ForegroundColor Green
        Write-Host "Web build output: ./dist/" -ForegroundColor Yellow
    } catch {
        Write-Error "Web build failed. Error: $_"
        exit 1
    }
}

# Function to set up Windows-specific build environment
function Set-BuildEnvironment {
    Write-Host "Setting up Windows build environment..." -ForegroundColor Cyan
    
    # Set NODE_OPTIONS for better performance
    $env:NODE_OPTIONS = "--max-old-space-size=8192"
    
    # Set build-specific environment variables
    $env:EXPO_USE_WINDOWS_OPTIMIZATIONS = "true"
    $env:EXPO_BUILD_PROFILE = $Profile
    
    # Clear any existing build artifacts if requested
    if ($Clear) {
        Write-Host "Clearing build cache..." -ForegroundColor Yellow
        if (Test-Path "android") { Remove-Item -Recurse -Force "android" }
        if (Test-Path "ios") { Remove-Item -Recurse -Force "ios" }
        if (Test-Path "dist") { Remove-Item -Recurse -Force "dist" }
        npx expo r -c
    }
    
    Write-Host "✓ Build environment configured" -ForegroundColor Green
}

# Main execution
Write-Host "🔨 Windows Expo Build Script" -ForegroundColor Green
Write-Host "=============================" -ForegroundColor Green
Write-Host ""

# Validate parameters
if ($Platform -notin @("android", "ios", "web", "all")) {
    Write-Error "Invalid platform '$Platform'. Valid options: android, ios, web, all"
    exit 1
}

if ($Profile -notin @("development", "preview", "production")) {
    Write-Error "Invalid profile '$Profile'. Valid options: development, preview, production"
    exit 1
}

Write-Host "Build Configuration:" -ForegroundColor Cyan
Write-Host "  Platform: $Platform" -ForegroundColor White
Write-Host "  Profile: $Profile" -ForegroundColor White
Write-Host "  Local: $Local" -ForegroundColor White
Write-Host "  Clear Cache: $Clear" -ForegroundColor White
Write-Host ""

# Execute build process
Test-Prerequisites
Install-Dependencies
Set-BuildEnvironment

# Run prebuild for native platforms
if ($Platform -in @("android", "ios", "all")) {
    Invoke-Prebuild
}

# Execute builds based on platform
switch ($Platform.ToLower()) {
    "android" { Build-Android }
    "ios" { Build-iOS }
    "web" { Build-Web }
    "all" { 
        Build-Android
        Build-iOS
        Build-Web
    }
}

Write-Host ""
Write-Host "🎉 Build process completed successfully!" -ForegroundColor Green

if (-not $Local) {
    Write-Host "Check your EAS dashboard for build status and download links." -ForegroundColor Yellow
}