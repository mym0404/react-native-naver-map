const { getDefaultConfig, mergeConfig } = require('@react-native/metro-config')
const path = require('path')
const escape = require('escape-string-regexp')
const exclusionList = require('metro-config/src/defaults/exclusionList')
const pak = require('../package.json')

const root = path.resolve(__dirname, '..')
const modules = Object.keys({ ...pak.peerDependencies })

const defaultConfig = getDefaultConfig(__dirname)

const projectNodeModules = path.resolve(__dirname, 'node_modules')
const rootNodeModules = path.resolve(root, 'node_modules')

/**
 * Metro configuration
 * https://facebook.github.io/metro/docs/configuration
 *
 * @type {import('metro-config').MetroConfig}
 */
const config = {
  watchFolders: [root, projectNodeModules, rootNodeModules],

  // We need to make sure that only one version is loaded for peerDependencies
  // So we block them at the root, and alias them to the versions in example's node_modules
  resolver: {
    sourceExts: [...defaultConfig.resolver?.sourceExts, 'json'],
    // blacklistRE: exclusionList(
    //   modules.map(
    //     (m) =>
    //       new RegExp(`^${escape(path.join(root, 'node_modules', m))}\\/.*$`)
    //   )
    // ),
    nodeModulesPaths: [
      ...defaultConfig.resolver?.nodeModulesPaths,
      projectNodeModules,
      rootNodeModules,
    ],

    extraNodeModules: modules.reduce(
      (acc, name) => {
        acc[name] = path.join(__dirname, '../', 'node_modules', name)
        console.log(JSON.stringify(acc, null, 2))
        return acc
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
}

const merged = mergeConfig(defaultConfig, config)
// console.log(JSON.stringify(merged, null, 2))
module.exports = merged
