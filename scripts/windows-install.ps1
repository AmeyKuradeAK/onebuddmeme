# Windows PowerShell script for installing Expo React Native dependencies
# This script handles the complete setup process for Windows development

param(
    [switch]$Global = $false,
    [switch]$Dev = $false,
    [switch]$Help = $false
)

if ($Help) {
    Write-Host "Windows Expo Install Script" -ForegroundColor Green
    Write-Host "Usage: .\windows-install.ps1 [options]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Cyan
    Write-Host "  -Global    Install global dependencies (Expo CLI, EAS CLI)" -ForegroundColor White
    Write-Host "  -Dev       Install development dependencies only" -ForegroundColor White
    Write-Host "  -Help      Show this help message" -ForegroundColor White
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Cyan
    Write-Host "  .\windows-install.ps1" -ForegroundColor White
    Write-Host "  .\windows-install.ps1 -Global" -ForegroundColor White
    Write-Host "  .\windows-install.ps1 -Dev" -ForegroundColor White
    exit 0
}

# Set error action preference
$ErrorActionPreference = "Stop"

# Function to check if running as administrator
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to check if a command exists
function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Function to check Node.js installation
function Test-NodeJS {
    Write-Host "Checking Node.js installation..." -ForegroundColor Cyan
    
    if (-not (Test-Command "node")) {
        Write-Host "❌ Node.js is not installed" -ForegroundColor Red
        Write-Host "Please install Node.js 18+ from https://nodejs.org/" -ForegroundColor Yellow
        Write-Host "Make sure to select 'Add to PATH' during installation" -ForegroundColor Yellow
        exit 1
    }
    
    try {
        $nodeVersion = node --version
        $version = [version]($nodeVersion -replace 'v', '')
        $minVersion = [version]"18.0.0"
        
        if ($version -lt $minVersion) {
            Write-Warning "Node.js version $nodeVersion detected. Recommended version is 18.0.0 or higher."
            Write-Host "Please update Node.js from https://nodejs.org/" -ForegroundColor Yellow
        } else {
            Write-Host "✓ Node.js $nodeVersion is installed and compatible" -ForegroundColor Green
        }
    } catch {
        Write-Error "Failed to check Node.js version. Please reinstall Node.js."
        exit 1
    }
}

# Function to check npm installation
function Test-npm {
    Write-Host "Checking npm installation..." -ForegroundColor Cyan
    
    if (-not (Test-Command "npm")) {
        Write-Error "npm is not available. Please reinstall Node.js with npm included."
        exit 1
    }
    
    try {
        $npmVersion = npm --version
        Write-Host "✓ npm $npmVersion is installed" -ForegroundColor Green
    } catch {
        Write-Error "Failed to check npm version. Please reinstall Node.js."
        exit 1
    }
}

# Function to install global dependencies
function Install-GlobalDependencies {
    Write-Host "Installing global dependencies..." -ForegroundColor Cyan
    
    $globalPackages = @(
        "@expo/cli",
        "@expo/eas-cli"
    )
    
    foreach ($package in $globalPackages) {
        Write-Host "Installing $package..." -ForegroundColor Yellow
        try {
            npm install -g $package
            Write-Host "✓ $package installed successfully" -ForegroundColor Green
        } catch {
            Write-Warning "Failed to install $package globally. You may need to run as administrator."
            Write-Host "Try running: npm install -g $package" -ForegroundColor Yellow
        }
    }
}

# Function to install project dependencies
function Install-ProjectDependencies {
    Write-Host "Installing project dependencies..." -ForegroundColor Cyan
    
    if (-not (Test-Path "package.json")) {
        Write-Error "package.json not found. Please run this script from the project root directory."
        exit 1
    }
    
    # Install all dependencies
    Write-Host "Installing npm packages..." -ForegroundColor Yellow
    try {
        npm install
        Write-Host "✓ Project dependencies installed successfully" -ForegroundColor Green
    } catch {
        Write-Error "Failed to install project dependencies. Error: $_"
        exit 1
    }
    
    # Install development dependencies if requested
    if ($Dev) {
        Write-Host "Installing development dependencies..." -ForegroundColor Yellow
        try {
            npm install --save-dev
            Write-Host "✓ Development dependencies installed successfully" -ForegroundColor Green
        } catch {
            Write-Warning "Some development dependencies may not have installed correctly."
        }
    }
}

# Function to set up Windows-specific environment
function Set-WindowsEnvironment {
    Write-Host "Setting up Windows-specific environment..." -ForegroundColor Cyan
    
    # Create .env file if it doesn't exist
    if (-not (Test-Path ".env")) {
        Write-Host "Creating .env file..." -ForegroundColor Yellow
        @"
# Expo Environment Variables
EXPO_USE_WINDOWS_OPTIMIZATIONS=true
NODE_OPTIONS=--max-old-space-size=4096
METRO_BUNDLER_OPTIONS=--reset-cache
"@ | Out-File -FilePath ".env" -Encoding UTF8
        Write-Host "✓ .env file created" -ForegroundColor Green
    }
    
    # Set up Windows-specific npm configuration
    Write-Host "Configuring npm for Windows..." -ForegroundColor Yellow
    try {
        npm config set script-shell powershell
        npm config set fund false
        npm config set audit false
        Write-Host "✓ npm configured for Windows" -ForegroundColor Green
    } catch {
        Write-Warning "Failed to configure npm settings. This is not critical."
    }
}

# Function to verify installation
function Test-Installation {
    Write-Host "Verifying installation..." -ForegroundColor Cyan
    
    # Test Expo CLI
    try {
        npx expo --version | Out-Null
        Write-Host "✓ Expo CLI is working" -ForegroundColor Green
    } catch {
        Write-Warning "Expo CLI may not be working correctly"
    }
    
    # Test EAS CLI
    try {
        npx eas --version | Out-Null
        Write-Host "✓ EAS CLI is working" -ForegroundColor Green
    } catch {
        Write-Warning "EAS CLI may not be working correctly"
    }
    
    # Test project dependencies
    if (Test-Path "node_modules") {
        Write-Host "✓ Project dependencies are installed" -ForegroundColor Green
    } else {
        Write-Warning "Project dependencies may not be installed correctly"
    }
}

# Function to display next steps
function Show-NextSteps {
    Write-Host ""
    Write-Host "🎉 Installation completed!" -ForegroundColor Green
    Write-Host "========================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Start the development server:" -ForegroundColor White
    Write-Host "   npm run windows:start" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "2. Or use the regular Expo commands:" -ForegroundColor White
    Write-Host "   npm start" -ForegroundColor Yellow
    Write-Host "   npm run android" -ForegroundColor Yellow
    Write-Host "   npm run ios" -ForegroundColor Yellow
    Write-Host "   npm run web" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "3. Build your app:" -ForegroundColor White
    Write-Host "   npm run windows:build" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "4. For more help:" -ForegroundColor White
    Write-Host "   npm run windows:start -Help" -ForegroundColor Yellow
    Write-Host "   npm run windows:build -Help" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Happy coding! 🚀" -ForegroundColor Green
}

# Main execution
Write-Host "📦 Windows Expo Install Script" -ForegroundColor Green
Write-Host "==============================" -ForegroundColor Green
Write-Host ""

# Check if running as administrator for global installs
if ($Global -and -not (Test-Administrator)) {
    Write-Warning "Installing global packages may require administrator privileges."
    Write-Host "Consider running PowerShell as Administrator for global installations." -ForegroundColor Yellow
    Write-Host ""
}

# Execute installation steps
Test-NodeJS
Test-npm

if ($Global) {
    Install-GlobalDependencies
}

Install-ProjectDependencies
Set-WindowsEnvironment
Test-Installation
Show-NextSteps