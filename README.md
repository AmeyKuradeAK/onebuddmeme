# Expo React Native App with Windows Support 🚀

A modern, well-structured Expo React Native application with 3-tab navigation, TypeScript support, and Windows PowerShell build scripts.

## Features

- ✅ **3-Tab Navigation**: Home, Explore, and Profile screens
- ✅ **TypeScript**: Full TypeScript support with strict configuration
- ✅ **Modern UI**: Beautiful, responsive design with theming
- ✅ **Cross-Platform**: Works on iOS, Android, and Web
- ✅ **Windows Support**: PowerShell scripts for Windows development
- ✅ **Code Quality**: ESLint, Prettier, and testing setup
- ✅ **Latest Dependencies**: Up-to-date packages and best practices

## Quick Start

### Prerequisites

- Node.js 18+ ([Download](https://nodejs.org/))
- npm or yarn
- Expo CLI (installed automatically)

### Installation

1. **Clone and install dependencies:**
   ```bash
   git clone <your-repo>
   cd your-app
   npm install
   ```

2. **For Windows users - Use the PowerShell script:**
   ```powershell
   # Install all dependencies and global tools
   npm run windows:install
   
   # Start development server
   npm run windows:start
   ```

3. **For all platforms - Standard commands:**
   ```bash
   # Install dependencies
   npm install
   
   # Start development server
   npm start
   ```

## Development

### Available Scripts

#### Standard Commands
```bash
npm start              # Start Expo development server
npm run android        # Start on Android
npm run ios           # Start on iOS
npm run web           # Start on Web
npm run lint          # Run ESLint
npm run lint:fix      # Fix ESLint issues
npm run type-check    # Run TypeScript type checking
npm test              # Run tests
```

#### Windows-Specific Commands
```powershell
npm run windows:start     # Start with Windows optimizations
npm run windows:build     # Build for all platforms
npm run windows:install   # Complete Windows setup
```

### Project Structure

```
├── app/                    # App screens and navigation
│   ├── (tabs)/            # Tab navigator screens
│   │   ├── index.tsx      # Home screen
│   │   ├── explore.tsx    # Explore screen
│   │   ├── profile.tsx    # Profile screen
│   │   └── _layout.tsx    # Tab layout configuration
│   ├── _layout.tsx        # Root layout
│   └── modal.tsx          # Modal screen
├── components/            # Reusable components
├── constants/             # App constants and theme
├── hooks/                 # Custom React hooks
├── types/                 # TypeScript type definitions
├── scripts/               # Build and utility scripts
│   ├── windows-start.ps1  # Windows start script
│   ├── windows-build.ps1  # Windows build script
│   └── windows-install.ps1 # Windows install script
└── assets/               # Images and static assets
```

## Building

### Development Build
```bash
# Build for all platforms (development)
npm run build:all

# Build for specific platform
npm run build:android
npm run build:ios
```

### Windows Build Script
```powershell
# Build with Windows optimizations
.\scripts\windows-build.ps1

# Build for specific platform
.\scripts\windows-build.ps1 -Platform android

# Build with production profile
.\scripts\windows-build.ps1 -Profile production

# Local build (without EAS)
.\scripts\windows-build.ps1 -Local
```

## Code Quality

This project includes:

- **TypeScript**: Strict type checking and modern TypeScript features
- **ESLint**: Code linting with Expo configuration
- **Jest**: Testing framework with React Native support
- **Prettier**: Code formatting (configured via ESLint)

### Running Quality Checks
```bash
npm run lint          # Check code style
npm run lint:fix      # Fix code style issues
npm run type-check    # Check TypeScript types
npm test              # Run tests
```

## Windows Development

### PowerShell Scripts

The project includes three PowerShell scripts optimized for Windows development:

1. **`windows-install.ps1`**: Complete setup and dependency installation
2. **`windows-start.ps1`**: Start development server with Windows optimizations
3. **`windows-build.ps1`**: Build the app with Windows-specific configurations

### Windows-Specific Features

- **Performance Optimizations**: Configured for Windows development environment
- **Memory Management**: Optimized Node.js memory settings
- **Metro Bundler**: Windows-specific bundler configurations
- **Error Handling**: Better error messages and troubleshooting

### Troubleshooting Windows Issues

1. **PowerShell Execution Policy**:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. **Node.js Path Issues**:
   - Ensure Node.js is in your PATH
   - Restart PowerShell after Node.js installation

3. **Permission Issues**:
   - Run PowerShell as Administrator for global installations
   - Check antivirus software blocking npm operations

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## Learn More

- [Expo Documentation](https://docs.expo.dev/)
- [React Native Documentation](https://reactnative.dev/)
- [TypeScript Documentation](https://www.typescriptlang.org/)
- [Expo Router Documentation](https://expo.github.io/router/)

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Happy coding! 🎉**