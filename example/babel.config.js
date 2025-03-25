const path = require('path');
const pak = require('../package.json');

module.exports = {
  presets: ['module:@react-native/babel-preset'],
  plugins: [
    [
      'module-resolver',
      {
        extensions: ['.tsx', '.ts', '.js', '.json'],
        alias: {
          // eslint-disable-next-line no-undef
          [pak.name]: path.join(__dirname, '..', pak.source),
        },
      },
    ],
  ],
};
