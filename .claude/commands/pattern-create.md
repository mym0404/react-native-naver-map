# Code Pattern - Save Reusable Code Patterns

Extract code snippet or common pattern in project and run cc-self-refer pattern create command

**Usage**: `/pattern-create <pattern name> <snippet|filename with line number|description>`

## What does this command do

### ⚠️ IMPORTANT: CLI Command Execution Required

**This command MUST execute the following `cc-self-refer` CLI command.**

### CLI Command Used

```bash
npx -y cc-self-refer pattern create "<pattern-name>" <<'EOF'
<pattern-content>
EOF
```

### Command Arguments
- `pattern-name`: Name of the code pattern
- `pattern-content`: Complete code snippet or pattern content


### Pattern Content Structure

- Patterns should be **concise usage snippets** ready to copy-paste:
- Code should be **immediately usable**
- Minimal explanation, maximum utility
- Usage section can be one or more code snippets showing direct usage of the pattern.
- Contain snippets as concise as possible, only required pieces.
- If the pattern has multiple variants or usage modes, include all of them in the Usage section. Each variant should be a concise, one-line example showing different configurations or use cases.

````markdown
# <Pattern Name>

## Usage

```[language]
// Direct usage example
[Actual code snippet as used in practice]
```

````

Example:

````markdown
# Zod Schema Definition

## Usage

```typescript
export const userSchema = z.object({
  name: z.string().min(1, "Name is required"),
  email: z.string().email("Invalid email format"),
  age: z.number().min(18, "Must be 18 or older")
}).strict();

export type User = z.infer<typeof useSchema>;
```
````

Example with multiple variants:

````markdown
# Button Component

## Usage

### Basic Variants
```jsx
<Button>Default</Button>
<Button variant="primary">Primary</Button>
<Button variant="secondary">Secondary</Button>
<Button variant="destructive">Delete</Button>
```

### Size Variants
```jsx
<Button size="sm">Small</Button>
<Button size="lg">Large</Button>
```

### Combined Props
```jsx
<Button variant="primary" size="lg">Large Primary</Button>
<Button disabled>Disabled</Button>
```
````


## Usage Examples

### Save Pattern Examples

When user requests:

```bash
/pattern-create "api-error-handler" "snippet or filename with lines"
```

Claude will:

1. Generate <formatted content> with the above rules.
2. Execute: 
   ```bash
   npx -y cc-self-refer pattern create "api-error-handler" <<'EOF'
   <formatted content>
   EOF
   ```
