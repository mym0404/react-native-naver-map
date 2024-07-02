import { TouchableOpacity, Text, View, Switch } from 'react-native';
import Slider from '@react-native-community/slider';
import * as React from 'react';

export const Btn = ({
  onPress,
  title,
}: {
  title: string;
  onPress: () => void;
}) => {
  return (
    <TouchableOpacity
      accessibilityRole={'button'}
      accessibilityLabel={title}
      style={{
        paddingVertical: 4,
        paddingHorizontal: 6,
        borderRadius: 4,
        borderWidth: 1,
        borderColor: '#aaa',
      }}
      onPress={onPress}
    >
      <Text style={{ fontWeight: 'bold', color: '#ddd', fontSize: 10 }}>
        {title}
      </Text>
    </TouchableOpacity>
  );
};

export const Toggle = ({
  onChange,
  text,
  value,
}: {
  value: boolean;
  onChange: (value: boolean) => void;
  text: string;
}) => {
  return (
    <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
      <Text style={{ fontWeight: 'bold', color: '#bbb', fontSize: 10 }}>
        {text}
      </Text>
      <Switch
        value={value}
        onValueChange={onChange}
        thumbColor={'white'}
        trackColor={{
          true: '#2a6',
          false: 'gray',
        }}
      />
    </View>
  );
};

export const Range = ({
  onChange,
  text,
  value,
  max,
  min,
}: {
  value?: number;
  onChange?: (value: number) => void;
  text: string;
  min?: number;
  max?: number;
}) => {
  return (
    <View style={{ flexDirection: 'row', alignItems: 'center', gap: 2 }}>
      <Text style={{ fontWeight: 'bold', color: '#bbb', fontSize: 10 }}>
        {text}
      </Text>
      <Slider
        style={{ width: 80, height: 32 }}
        minimumValue={min}
        maximumValue={max}
        minimumTrackTintColor={'#222222'}
        maximumTrackTintColor={'#000000'}
        onValueChange={onChange}
        value={value}
        thumbTintColor={'white'}
      />
    </View>
  );
};
