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
- **⚠️ CRITICAL**: Usage section shows HOW TO USE existing utilities/classes/functions, NOT their definitions
- Usage snippets demonstrate practical application, NOT implementation details
- Contain snippets as concise as possible, only required pieces.
- If the pattern has multiple variants or usage modes, include all of them in the Usage section. Each variant should be a concise, one-line example showing different configurations or use cases.

````markdown
# <Pattern Name>

[EXPLANATION] one or two line of excerpt, explanation of this code pattern

## Usage

```[language]
// Direct usage example
[Actual code snippet as used in practice]
```

````

Example:

````markdown
# Zod Schema Definition

[EXPLANATION] how to create a zod schema definition

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

Example - Utility Function Usage:

````markdown
# API Error Handler Usage

[EXPLANATION] handle api error with apiErrorHandler utility

## Usage

```typescript
// How to use the existing apiErrorHandler utility
try {
  const data = await fetchUserData(userId);
  return data;
} catch (error) {
  return apiErrorHandler(error, 'Failed to fetch user data');
}

// How to use in React components
const handleSubmit = async () => {
  try {
    await createUser(userData);
  } catch (error) {
    const errorMessage = apiErrorHandler(error);
    setError(errorMessage);
  }
};
```
````

Example with multiple variants:

````markdown
# Button Component

[EXPLANATION] Button component usage

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

1. **⚠️ CLARIFY PATTERN PURPOSE**: If the pattern intent is ambiguous, MUST ask user to clarify:
   - "Are you looking to save how to USE existing utilities/components?"
   - "Or are you looking to save how to DEFINE/CREATE similar utilities/components?"
   - "Or are you looking to save a specific implementation pattern?"

2. Generate <formatted content> with the above rules.
3. Execute: 
   ```bash
   npx -y cc-self-refer pattern create "api-error-handler" <<'EOF'
   <formatted content>
   EOF
   ```

## Reference Commands

If users want to reference existing content while creating patterns:

```bash
# View existing patterns
npx cc-self-refer pattern list
npx cc-self-refer pattern search "<keyword>"  
npx cc-self-refer pattern view "<pattern-id>"
```
