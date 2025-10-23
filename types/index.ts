// Common types used across the application

export interface TabBarIconProps {
  color: string;
  focused: boolean;
  size?: number;
}

export interface ProfileOption {
  id: string;
  title: string;
  icon: string;
  onPress: () => void;
  showArrow?: boolean;
}

export interface FeatureCard {
  id: string;
  title: string;
  description: string;
  icon: string;
  color: string;
}

export interface NavigationProps {
  navigation?: any;
  route?: any;
}

export type ColorScheme = 'light' | 'dark' | 'system';

export interface ThemeColors {
  background: string;
  foreground: string;
  card: string;
  cardForeground: string;
  popover: string;
  popoverForeground: string;
  primary: string;
  primaryForeground: string;
  secondary: string;
  secondaryForeground: string;
  muted: string;
  mutedForeground: string;
  accent: string;
  accentForeground: string;
  destructive: string;
  destructiveForeground: string;
  border: string;
  input: string;
  ring: string;
  chart1: string;
  chart2: string;
  chart3: string;
  chart4: string;
  chart5: string;
  tint: string;
  tabIconDefault: string;
  tabIconSelected: string;
}

export interface AppConfig {
  name: string;
  version: string;
  buildNumber: string;
  environment: 'development' | 'staging' | 'production';
}