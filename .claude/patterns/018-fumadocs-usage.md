---
keywords: fumadocs,mdx,documentation,components,ui-patterns
language: mdx
explanation: Concise usage patterns for Fumadocs components and features in MDX
---

# Fumadocs Usage

## Page Conventions (Basic Setup)

### Frontmatter
Every MDX page should start with frontmatter to define page metadata:

```mdx
---
title: "Page Title"
description: "Page description for SEO and navigation"
icon: "BookOpen"
---

## Page Content

Your content here...
```

### Heading Level Convention
**IMPORTANT**: All MDX content should start with h2 (##) headings, NOT h1 (#).

```mdx
## Main Section
Content for main section...

### Subsection
Content for subsection...

#### Sub-subsection
Content for detailed section...
```

**Reason**: The page title is automatically generated from frontmatter, so content should start from h2 level for proper hierarchy.

### Content Structure Guidelines
- **Avoid "Next Steps" sections**: Don't include generic "다음 단계" or "Next Steps" sections at the end of documents
- **Focus on core content**: Keep documentation focused on the main topic without unnecessary navigation aids
- **Use cross-references naturally**: Link to related content inline rather than in dedicated sections
- **Avoid congratulatory callouts**: Don't use success callouts like "축하합니다!" or "Congratulations!" at the end of setup/completion sections
- **Avoid completion celebration callouts**: Remove callouts that celebrate task completion (e.g., "설정이 완료되었습니다!") - let the content speak for itself

### Meta.json Configuration
Use `meta.json` files to control folder structure and page ordering:

```json
{
  "title": "Folder Display Name",
  "icon": "FolderIcon",
  "defaultOpen": true,
  "pages": [
    "index",
    "getting-started",
    "---",
    {
      "title": "External Link",
      "href": "https://external.com",
      "external": true
    },
    "..."
  ]
}
```

**Example File Structure:**
- `content/docs/meta.json` - Root folder config
- `content/docs/index.mdx` - Main docs page
- `content/docs/guides/meta.json` - Guides folder config
- `(group)/` folders don't affect URLs

## Usage

### Icons

You can use Lucide Icon in MDX

```
import { Apple, Smartphone, Zap } from 'lucide-react'
...
```

### Tabs

**Note**: `<Tabs>` and `<Tab>` components are available globally in Fumadocs MDX - no import required.

```mdx
<Tabs items={['React', 'Vue', 'Svelte']}>
  <Tab value="React">
    ```tsx
    import { useState } from 'react';
    ```
  </Tab>
  <Tab value="Vue">
    ```vue
    <script setup>
    import { ref } from 'vue';
    </script>
    ```
  </Tab>
  <Tab value="Svelte">
    ```svelte
    <script>
    let count = 0;
    </script>
    ```
  </Tab>
</Tabs>

**IMPORTANT**: The `value` prop of `<Tab>` must exactly match the items in the `items` array of `<Tabs>`. Case-sensitive matching is required.

**Common Issue**: Using different values than items array will cause tabs content not to display:
```mdx
<!-- ❌ Wrong - Tab values don't match items -->
<Tabs items={['Camera', 'Region']}>
  <Tab value="Basic">Content 1</Tab>  <!-- Wrong value -->
  <Tab value="Basic">Content 2</Tab>  <!-- Wrong + duplicate value -->
</Tabs>

<!-- ✅ Correct - Tab values match items exactly -->
<Tabs items={['Camera', 'Region']}>
  <Tab value="Camera">Content 1</Tab>
  <Tab value="Region">Content 2</Tab>
</Tabs>
```

<Tabs groupId="lang" items={['JS', 'TS']} persist>
  <Tab value="JS">JavaScript code</Tab>
  <Tab value="TS">TypeScript code</Tab>
</Tabs>
```

### Accordion
```mdx
<Accordions type="single">
  <Accordion title="Question 1">Answer 1</Accordion>
  <Accordion title="Question 2" id="q2">Answer 2</Accordion>
</Accordions>
```

### Steps
```mdx
<Steps>
  <Step>### Step 1</Step>
  <Step>### Step 2</Step>
</Steps>

<div className="fd-steps [&_h3]:fd-step">
  ### Auto Step 1
  ### Auto Step 2
</div>
```

### Cards
```mdx
<Cards>
  <Card href="/docs" title="Documentation" icon={<BookIcon />}>
    Learn more about our docs
  </Card>
  <Card title="No Link Card">Static card content</Card>
</Cards>
```

### Callout
```mdx
<Callout>Default info message</Callout>
<Callout type="warn" title="Warning">Warning message</Callout>
<Callout type="error">Error message</Callout>
<Callout type="success">Error message</Callout>
```

### Files
```mdx
<Files>
  <Folder name="src" defaultOpen>
    <File name="index.ts" />
    <Folder name="components">
      <File name="Button.tsx" />
    </Folder>
  </Folder>
  <File name="package.json" />
</Files>
```

### Code Blocks

#### Basic Code Block
```mdx
\`\`\`typescript
const greeting: string = "Hello World";
console.log(greeting);
\`\`\`
```

#### Code Block with Title
```mdx
\`\`\`typescript title="utils/greeting.ts"
export const greeting = (name: string): string => {
  return `Hello, ${name}!`;
};
\`\`\`
```

#### Code Block with Line Highlighting
```mdx
\`\`\`typescript {2,4-6}
const user = {
  name: "John", // This line is highlighted
  age: 30,
  email: "john@example.com", // These lines
  address: "123 Main St",    // are also
  city: "New York"           // highlighted
};
\`\`\`
```

#### Code Block with Line Numbers
```mdx
\`\`\`typescript showLineNumbers
function fibonacci(n: number): number {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

console.log(fibonacci(10));
\`\`\`
```

#### Code Block with Line Numbers Starting from Specific Number
```mdx
\`\`\`typescript showLineNumbers{5}
// Line starts from 5
const API_KEY = process.env.API_KEY;
const API_URL = "https://api.example.com";

fetch(API_URL, {
  headers: { Authorization: `Bearer ${API_KEY}` }
});
\`\`\`
```

#### Code Tabs (Auto-grouped)
```mdx
\`\`\`ts tab="TypeScript"
const name: string = "Hello";
const age: number = 25;
\`\`\`

\`\`\`js tab="JavaScript"
const name = "Hello";
const age = 25;
\`\`\`
```

#### Code Tabs with Icons
```mdx
\`\`\`ts tab="<FileCode /> TypeScript"
interface User {
  name: string;
  email: string;
}
\`\`\`

\`\`\`js tab="<FileText /> JavaScript"
const user = {
  name: "John",
  email: "john@example.com"
};
\`\`\`
```

#### Code Block with Copy Button (Default)
```mdx
\`\`\`bash
npm install fumadocs-ui fumadocs-core
\`\`\`
```

#### Terminal/Shell Commands (No Copy Button)
```mdx
\`\`\`bash
$ npm run dev
> dev
> next dev

ready - started server on http://localhost:3000
\`\`\`
```

#### Diff Code Block
```mdx
\`\`\`diff
- const oldFunction = () => {
-   console.log("old");
- };
+ const newFunction = () => {
+   console.log("new and improved");
+ };
\`\`\`
```

#### Code Block with Custom Theme
```mdx
\`\`\`typescript theme="github-dark"
// This uses github-dark theme specifically
const darkTheme = true;
\`\`\`
```

#### Inline Code with Highlighting
```mdx
The \`const greeting = "Hello"\` variable is a string.
```

#### Code Block with Word Wrap
```mdx
\`\`\`typescript wrap
const veryLongLineOfCode = "This is a very long line of code that will wrap to the next line automatically when it exceeds the container width, making it easier to read on smaller screens";
\`\`\`
```

#### Shiki Transformers

##### Line Highlighting with Comments
```mdx
\`\`\`javascript
const greeting = "Hello World"; // [!code highlight]
console.log(greeting);
const farewell = "Goodbye"; // [!code highlight]
\`\`\`
```

##### Word Highlighting
```mdx
\`\`\`javascript
// Highlight specific words // [!code word:Fumadocs]
const library = "Fumadocs";
const framework = "Next.js";
\`\`\`
```

##### Diff Styling
```mdx
\`\`\`javascript
console.log('hewwo'); // [!code --]
console.log('hello'); // [!code ++]
const oldVar = 'old'; // [!code --]
const newVar = 'new'; // [!code ++]
\`\`\`
```

##### Focus Highlighting
```mdx
\`\`\`javascript
const observer = new ResizeObserver(() => {}); // [!code highlight]
const element = document.getElementById('target');
observer.observe(element);
\`\`\`
```

### Image Zoom
```mdx
![Description](/image.png)
```

### Banner
```mdx
<Banner>Site-wide announcement</Banner>
```

### InlineTOC
```mdx
<InlineTOC items={toc} />
```

### GithubInfo
```mdx
<GithubInfo owner="fuma-nama" repo="fumadocs" />
```

### Include Files
```mdx
<include>./shared-content.mdx</include>
```

### Dynamic Links (i18n)
```mdx
<DynamicLink href="/[lang]/docs">Docs</DynamicLink>
```

### OpenAPI
```mdx
<APIPage
  document="./openapi.json"
  operations={[{ path: '/api/users', method: 'get' }]}
/>
```

### Mermaid Diagrams
```mdx
<Mermaid
  chart="
graph TD;
  A[Start] --> B[Process];
  B --> C[End];
"
/>
```

### Page Export
```mdx
export { withArticle as default } from 'fumadocs-ui/page';

## Article Content
```

### Links
```mdx
[Internal Link](./other-page.mdx)
[External Link](https://example.com)
[Link to Heading](#custom-id)
```

### Lists
```mdx
- Unordered item 1
- Unordered item 2
  - Nested item
  - Another nested

1. Ordered item 1
2. Ordered item 2
   1. Nested ordered
   2. Another nested
```

### Tables
```mdx
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Row 1    | Data     | More     |
| Row 2    | Data     | More     |
```

### Blockquotes
```mdx
> This is a blockquote
>
> Multiple lines supported
```

### Horizontal Rule
```mdx
---
```

### NPM Install Commands

For npm package installation, use npm language tag for syntax highlighting:

```mdx
```npm
npm install package-name
```
```

### Task Lists
```mdx
- [x] Completed task
- [ ] Incomplete task
- [ ] Another todo
```

### Footnotes
```mdx
Here's a sentence with a footnote[^1].

[^1]: This is the footnote content.
```

### Math (KaTeX)
```mdx
Inline math: $E = mc^2$

Block math:
$$
\begin{aligned}
  \nabla \times \vec{E} &= -\frac{\partial \vec{B}}{\partial t} \\
  \nabla \times \vec{B} &= \mu_0 \vec{J} + \mu_0 \epsilon_0 \frac{\partial \vec{E}}{\partial t}
\end{aligned}
$$
```

### Definition Lists
```mdx
Term 1
:   Definition for term 1

Term 2
:   Definition for term 2
:   Another definition for term 2
```

### Strikethrough
```mdx
~~Strikethrough text~~
```

### Emphasis
```mdx
*Italic text*
_Also italic_

**Bold text**
__Also bold__

***Bold and italic***
___Also bold and italic___
```

### HTML in Markdown
```mdx
<div className="custom-class">
  Custom HTML content with <strong>formatting</strong>
</div>
```

### Keyboard Shortcuts
```mdx
Press <kbd>Ctrl</kbd> + <kbd>C</kbd> to copy
```

### Abbreviations
```mdx
The HTML specification is maintained by W3C.

*[HTML]: HyperText Markup Language
*[W3C]: World Wide Web Consortium
```

### AutoTypeTable
```mdx
<AutoTypeTable path="./../src/component/NaverMapView.tsx" name="NaverMapViewProps" />
```

Use AutoTypeTable to automatically generate documentation tables from TypeScript interfaces or types. Specify the relative path to the TypeScript file and the name of the type/interface to document.

### Code with Word Highlighting
```mdx
\`\`\`js /useState/
import { useState } from 'react';

function Counter() {
  const [count, setCount] = useState(0);
  return count;
}
\`\`\`
```

### Code with Focus
```mdx
\`\`\`js focus=2,4-5
function example() {
  console.log('1');
  console.log('2'); // focused
  console.log('3');
  console.log('4'); // focused
  console.log('5'); // focused
}
\`\`\`
```
