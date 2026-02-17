const path = require('path');
const pak = require('../package.json');

module.exports = {
  dependencies: {
    '@mj-studio/react-native-naver-map': {
      root: path.resolve(__dirname, '../'),
    },
    '@react-native-community/slider': {
      root: path.resolve(
        __dirname,
        './node_modules/@react-native-community/slider'
      ),
    },
    'react-native-permissions': {
      root: path.resolve(__dirname, './node_modules/react-native-permissions'),
    },
  },
};
