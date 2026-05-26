const { getDefaultConfig, mergeConfig } = require('@react-native/metro-config');
const path = require('path');
const rootPackageJson = require('../package.json');

const root = path.resolve(__dirname, '..');
const modules = Object.keys(rootPackageJson.peerDependencies ?? {});

const defaultConfig = getDefaultConfig(__dirname);

const projectNodeModules = path.resolve(__dirname, 'node_modules');
const rootNodeModules = path.resolve(root, 'node_modules');

/**
 * Metro configuration
 * https://facebook.github.io/metro/docs/configuration
 *
 * @type {import('metro-config').MetroConfig}
 */
const config = {
  watchFolders: [root, projectNodeModules, rootNodeModules],

  // Keep peer dependencies resolved from the hoisted workspace root.
  resolver: {
    sourceExts: [...new Set([...defaultConfig.resolver?.sourceExts, 'json'])],
    nodeModulesPaths: [
      ...defaultConfig.resolver?.nodeModulesPaths,
      projectNodeModules,
      rootNodeModules,
    ],

    extraNodeModules: modules.reduce(
      (acc, name) => {
        acc[name] = path.join(rootNodeModules, name);
        return acc;
      },
      {
        ...defaultConfig.resolver?.extraNodeModules,
        '@mj-studio/react-native-naver-map': path.resolve(root),
      }
    ),
  },

  transformer: {
    getTransformOptions: async () => ({
      transform: {
        experimentalImportSupport: false,
        inlineRequires: true,
      },
    }),
  },
};

const merged = mergeConfig(defaultConfig, config);
// console.log(JSON.stringify(merged, null, 2))
module.exports = merged;
