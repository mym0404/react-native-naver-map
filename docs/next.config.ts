import nextra from 'nextra';

// Set up Nextra with its configuration
const withNextra = nextra({
  // contentDirBasePath: '/docs',
  defaultShowCopyCode: true,
  codeHighlight: true,
  readingTime: true,
});

// Export the final Next.js config with Nextra included
export default withNextra({
  turbopack: {
    resolveAlias: {
      // Path to your `mdx-components` file with extension
      // 'next-mdx-import-source-file': './src/mdx-components.tsx',
    },
  },
});
