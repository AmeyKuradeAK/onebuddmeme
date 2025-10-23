import React from 'react';
import { StyleSheet, ScrollView, Alert } from 'react-native';
import { Image } from 'expo-image';
import { Link } from 'expo-router';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors } from '@/constants/theme';
import { useColorScheme } from '@/hooks/use-color-scheme';

interface ProfileOption {
  id: string;
  title: string;
  icon: string;
  onPress: () => void;
  showArrow?: boolean;
}

export default function ProfileScreen() {
  const colorScheme = useColorScheme();
  const colors = Colors[colorScheme ?? 'light'];

  const profileOptions: ProfileOption[] = [
    {
      id: 'settings',
      title: 'Settings',
      icon: 'gearshape.fill',
      onPress: () => Alert.alert('Settings', 'Settings screen coming soon!'),
      showArrow: true,
    },
    {
      id: 'notifications',
      title: 'Notifications',
      icon: 'bell.fill',
      onPress: () => Alert.alert('Notifications', 'Notification settings coming soon!'),
      showArrow: true,
    },
    {
      id: 'privacy',
      title: 'Privacy & Security',
      icon: 'lock.fill',
      onPress: () => Alert.alert('Privacy', 'Privacy settings coming soon!'),
      showArrow: true,
    },
    {
      id: 'help',
      title: 'Help & Support',
      icon: 'questionmark.circle.fill',
      onPress: () => Alert.alert('Help', 'Help center coming soon!'),
      showArrow: true,
    },
    {
      id: 'about',
      title: 'About',
      icon: 'info.circle.fill',
      onPress: () => Alert.alert('About', 'App version 1.0.0'),
      showArrow: true,
    },
  ];

  const renderProfileOption = (option: ProfileOption) => (
    <ThemedView key={option.id} style={styles.optionContainer}>
      <ThemedView style={styles.optionContent}>
        <IconSymbol 
          size={24} 
          name={option.icon} 
          color={colors.tint} 
          style={styles.optionIcon}
        />
        <ThemedText style={styles.optionTitle}>{option.title}</ThemedText>
      </ThemedView>
      {option.showArrow && (
        <IconSymbol 
          size={16} 
          name="chevron.right" 
          color={colors.tabIconDefault} 
        />
      )}
    </ThemedView>
  );

  return (
    <ScrollView style={[styles.container, { backgroundColor: colors.background }]}>
      <ThemedView style={styles.header}>
        <ThemedView style={styles.avatarContainer}>
          <Image
            source={require('@/assets/images/icon.png')}
            style={styles.avatar}
          />
        </ThemedView>
        <ThemedText type="title" style={styles.userName}>John Doe</ThemedText>
        <ThemedText style={[styles.userEmail, { color: colors.tabIconDefault }]}>
          john.doe@example.com
        </ThemedText>
      </ThemedView>

      <ThemedView style={styles.section}>
        <ThemedText type="subtitle" style={styles.sectionTitle}>
          Account
        </ThemedText>
        {profileOptions.slice(0, 3).map(renderProfileOption)}
      </ThemedView>

      <ThemedView style={styles.section}>
        <ThemedText type="subtitle" style={styles.sectionTitle}>
          Support
        </ThemedText>
        {profileOptions.slice(3).map(renderProfileOption)}
      </ThemedView>

      <ThemedView style={styles.footer}>
        <Link href="/modal" asChild>
          <ThemedView style={[styles.logoutButton, { borderColor: colors.tint }]}>
            <IconSymbol 
              size={20} 
              name="rectangle.portrait.and.arrow.right" 
              color={colors.tint} 
            />
            <ThemedText style={[styles.logoutText, { color: colors.tint }]}>
              Sign Out
            </ThemedText>
          </ThemedView>
        </Link>
      </ThemedView>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  header: {
    alignItems: 'center',
    paddingVertical: 32,
    paddingHorizontal: 20,
  },
  avatarContainer: {
    width: 100,
    height: 100,
    borderRadius: 50,
    overflow: 'hidden',
    marginBottom: 16,
    borderWidth: 3,
    borderColor: '#007AFF',
  },
  avatar: {
    width: '100%',
    height: '100%',
  },
  userName: {
    marginBottom: 4,
  },
  userEmail: {
    fontSize: 16,
  },
  section: {
    marginBottom: 24,
  },
  sectionTitle: {
    paddingHorizontal: 20,
    paddingVertical: 12,
    fontSize: 18,
    fontWeight: '600',
  },
  optionContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 20,
    paddingVertical: 16,
    borderBottomWidth: 0.5,
    borderBottomColor: 'rgba(0,0,0,0.1)',
  },
  optionContent: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  optionIcon: {
    marginRight: 16,
  },
  optionTitle: {
    fontSize: 16,
    flex: 1,
  },
  footer: {
    padding: 20,
    marginTop: 20,
  },
  logoutButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 16,
    borderWidth: 1,
    borderRadius: 12,
  },
  logoutText: {
    fontSize: 16,
    fontWeight: '600',
    marginLeft: 8,
  },
});