import React from 'react';
import { Text, TouchableOpacity, View } from 'react-native';

export const Header = ({
  title,
  onBack,
}: {
  title: string;
  onBack: () => void;
}) => {
  return (
    <View
      style={{
        paddingHorizontal: 16,
        paddingVertical: 12,
        backgroundColor: '#000',
        borderBottomWidth: 1,
        borderBottomColor: '#333',
        flexDirection: 'row',
        alignItems: 'center',
        gap: 12,
      }}
    >
      <TouchableOpacity
        onPress={onBack}
        style={{
          padding: 4,
        }}
      >
        <Text style={{ color: '#fff', fontSize: 18, fontWeight: 'bold' }}>
          ←
        </Text>
      </TouchableOpacity>
      <Text style={{ color: '#fff', fontSize: 16, fontWeight: 'bold' }}>
        {title}
      </Text>
    </View>
  );
};
