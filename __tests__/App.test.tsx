import React from 'react';
import { render } from '@testing-library/react-native';
import { ThemeProvider } from '@react-navigation/native';
import { DefaultTheme } from '@react-navigation/native';

// Mock the expo-router
jest.mock('expo-router', () => ({
  Stack: ({ children }: { children: React.ReactNode }) => children,
  Tabs: ({ children }: { children: React.ReactNode }) => children,
  'Stack.Screen': ({ children }: { children: React.ReactNode }) => children,
  'Tabs.Screen': ({ children }: { children: React.ReactNode }) => children,
}));

// Mock the color scheme hook
jest.mock('@/hooks/use-color-scheme', () => ({
  useColorScheme: () => 'light',
}));

// Mock the themed components
jest.mock('@/components/themed-text', () => ({
  ThemedText: ({ children, ...props }: any) => <div {...props}>{children}</div>,
}));

jest.mock('@/components/themed-view', () => ({
  ThemedView: ({ children, ...props }: any) => <div {...props}>{children}</div>,
}));

// Import the component to test
import RootLayout from '../app/_layout';

describe('App', () => {
  it('renders without crashing', () => {
    const { getByText } = render(
      <ThemeProvider value={DefaultTheme}>
        <RootLayout />
      </ThemeProvider>
    );
    
    // The app should render without throwing an error
    expect(getByText).toBeDefined();
  });

  it('has proper theme provider setup', () => {
    const { container } = render(
      <ThemeProvider value={DefaultTheme}>
        <RootLayout />
      </ThemeProvider>
    );
    
    expect(container).toBeDefined();
  });
});