#!/usr/bin/env zx
/* eslint-disable max-len */
// region ZX Util
import fs from 'fs-extra';

const join = path.join;
const resolve = path.resolve;
const filename = path.basename(__filename);
const cwd = () => process.cwd();
const exit = process.exit;
const _printTag = '' || filename;

function exist (path) {
  return fs.existsSync(path);
}

function isDir (path) {
  return exist(path) && fs.lstatSync(path).isDirectory();
}

function isFile (path) {
  return exist(path) && fs.lstatSync(path).isFile();
}

async function iterateDir (path, fn) {
  if (!isDir(path)) {
    return;
  }

  for (const file of fs.readdirSync(path)) {
    await fn(file);
  }
}

function read (path) {
  return fs.readFileSync(path, { encoding: 'utf8' });
}

// you should require when possible(optimized in js)
function readJsonSlow (path) {
  return fs.readJSONSync(path);
}

function write (p, content) {
  const dir = path.dirname(p);
  if (!exist(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }

  return fs.writeFileSync(p, content);
}

function writeJson (path, json) {
  return write(path, JSON.stringify(json, null, 2));
}

function remove (path) {
  if (!exist(path)) {
    return;
  }

  if (fs.lstatSync(path).isDirectory()) {
    return fs.rmSync(path, { force: true, recursive: true });
  } else {
    return fs.rmSync(path, { force: true });
  }
}

function addLine (str, added, backward = false) {
  if (backward) {
    return added + '\n' + str;
  } else {
    return str + '\n' + added;
  }
}

function addLineToFile (path, added, backward = false) {
  return write(path, addLine(read(path), added, backward));
}

function print (...args) {
  echo(chalk.blue(`[${_printTag}]`, ...args));
}

function printSuccess (...args) {
  echo(chalk.bold.bgBlue(`[${_printTag}]`, ...args));
}

function printError (...args) {
  echo(chalk.bold.bgRed(`[${_printTag}]`, ...args));
}

function asrt (condition, ...args) {
  if (!condition) {
    echo(chalk.bold.bgRed(`[${_printTag}]`, ...args));
    exit(1);
  }
}

// endregion

async function generateAndroidCodegen () {
  print('Generating Android codegen...');

  // Generate codegen to temp directory
  await $`npx -y @react-native-community/cli codegen --path example --platform android --source library`;

  const sourceDir = 'example/android/app/build/generated/source/codegen';
  const targetDir = 'android/build/generated/source/codegen';
  // Ensure android/build directory exists
  await $`rm -rf ${targetDir} && mkdir -p ${targetDir}`;

  // Move generated files from temp to android/build
  await $`mv ${sourceDir}/* ${targetDir}/`;

  printSuccess('Android codegen completed successfully!');
}

async function generateIosCodegen () {
  print('Generating iOS codegen...');
  await $`npx -y @react-native-community/cli codegen --path example/ --outputPath example/ios --platform ios --source library`;
  printSuccess('iOS codegen completed successfully!');
}

async function main () {
  const platform = argv._[0]; // Get platform from command line args

  print(`Running React Native codegen for ${platform || 'all platforms'}...`);

  try {
    if (platform === 'android') {
      await generateAndroidCodegen();
    } else if (platform === 'ios') {
      await generateIosCodegen();
    } else {
      // Both platforms
      await generateAndroidCodegen();
      await generateIosCodegen();
      printSuccess('Codegen completed successfully for both platforms!');
    }
  } catch (error) {
    printError('Codegen failed:', error.message);
    exit(1);
  }
}

main();
