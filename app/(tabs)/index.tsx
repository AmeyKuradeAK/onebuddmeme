import React from 'react';
import { Image } from 'expo-image';
import { Platform, StyleSheet, Alert } from 'react-native';

import { HelloWave } from '@/components/hello-wave';
import ParallaxScrollView from '@/components/parallax-scroll-view';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Link } from 'expo-router';
import { Colors } from '@/constants/theme';
import { useColorScheme } from '@/hooks/use-color-scheme';
import { FeatureCard } from '@/types';

const features: FeatureCard[] = [
  {
    id: '1',
    title: 'Cross-Platform',
    description: 'Works on iOS, Android, and Web',
    icon: 'iphone',
    color: '#007AFF',
  },
  {
    id: '2',
    title: 'TypeScript',
    description: 'Full TypeScript support',
    icon: 'chevron.left.forwardslash.chevron.right',
    color: '#3178C6',
  },
  {
    id: '3',
    title: 'Modern UI',
    description: 'Beautiful and responsive design',
    icon: 'paintbrush.fill',
    color: '#FF6B6B',
  },
  {
    id: '4',
    title: 'Fast Development',
    description: 'Hot reload and instant updates',
    icon: 'bolt.fill',
    color: '#4ECDC4',
  },
];

export default function HomeScreen(): React.JSX.Element {
  const colorScheme = useColorScheme();
  const colors = Colors[colorScheme ?? 'light'];

  const handleFeaturePress = (feature: FeatureCard) => {
    Alert.alert(feature.title, feature.description);
  };

  const renderFeatureCard = (feature: FeatureCard) => (
    <ThemedView 
      key={feature.id} 
      style={[styles.featureCard, { borderColor: colors.border }]}
      onTouchEnd={() => handleFeaturePress(feature)}
    >
      <IconSymbol 
        size={32} 
        name={feature.icon} 
        color={feature.color} 
        style={styles.featureIcon}
      />
      <ThemedText type="subtitle" style={styles.featureTitle}>
        {feature.title}
      </ThemedText>
      <ThemedText style={[styles.featureDescription, { color: colors.tabIconDefault }]}>
        {feature.description}
      </ThemedText>
    </ThemedView>
  );

  return (
    <ParallaxScrollView
      headerBackgroundColor={{ light: '#A1CEDC', dark: '#1D3D47' }}
      headerImage={
        <Image
          source={require('@/assets/images/partial-react-logo.png')}
          style={styles.reactLogo}
        />
      }>
      <ThemedView style={styles.titleContainer}>
        <ThemedText type="title">Welcome!</ThemedText>
        <HelloWave />
      </ThemedView>
      
      <ThemedView style={styles.stepContainer}>
        <ThemedText type="subtitle">Features</ThemedText>
        <ThemedText style={styles.sectionDescription}>
          Discover what makes this app special
        </ThemedText>
        <ThemedView style={styles.featuresGrid}>
          {features.map(renderFeatureCard)}
        </ThemedView>
      </ThemedView>

      <ThemedView style={styles.stepContainer}>
        <ThemedText type="subtitle">Quick Actions</ThemedText>
        <ThemedView style={styles.actionsContainer}>
          <Link href="/modal" asChild>
            <ThemedView style={[styles.actionButton, { backgroundColor: colors.tint }]}>
              <IconSymbol size={20} name="plus" color="white" />
              <ThemedText style={styles.actionButtonText}>Open Modal</ThemedText>
            </ThemedView>
          </Link>
          <ThemedView 
            style={[styles.actionButton, { backgroundColor: colors.secondary }]}
            onTouchEnd={() => Alert.alert('Share', 'Share functionality coming soon!')}
          >
            <IconSymbol size={20} name="square.and.arrow.up" color={colors.foreground} />
            <ThemedText style={[styles.actionButtonText, { color: colors.foreground }]}>
              Share
            </ThemedText>
          </ThemedView>
        </ThemedView>
      </ThemedView>

      <ThemedView style={styles.stepContainer}>
        <ThemedText type="subtitle">Development</ThemedText>
        <ThemedText>
          Edit <ThemedText type="defaultSemiBold">app/(tabs)/index.tsx</ThemedText> to see changes.
          Press{' '}
          <ThemedText type="defaultSemiBold">
            {Platform.select({
              ios: 'cmd + d',
              android: 'cmd + m',
              web: 'F12',
            })}
          </ThemedText>{' '}
          to open developer tools.
        </ThemedText>
      </ThemedView>
    </ParallaxScrollView>
  );
}

const styles = StyleSheet.create({
  titleContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  stepContainer: {
    gap: 12,
    marginBottom: 16,
  },
  sectionDescription: {
    fontSize: 16,
    opacity: 0.8,
    marginBottom: 16,
  },
  featuresGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 12,
  },
  featureCard: {
    flex: 1,
    minWidth: '45%',
    padding: 16,
    borderRadius: 12,
    borderWidth: 1,
    alignItems: 'center',
    gap: 8,
  },
  featureIcon: {
    marginBottom: 4,
  },
  featureTitle: {
    textAlign: 'center',
    fontSize: 16,
    fontWeight: '600',
  },
  featureDescription: {
    textAlign: 'center',
    fontSize: 14,
    lineHeight: 20,
  },
  actionsContainer: {
    flexDirection: 'row',
    gap: 12,
  },
  actionButton: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 8,
    gap: 8,
  },
  actionButtonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: '600',
  },
  reactLogo: {
    height: 178,
    width: 290,
    bottom: 0,
    left: 0,
    position: 'absolute',
  },
});
