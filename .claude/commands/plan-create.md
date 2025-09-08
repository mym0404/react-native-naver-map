# Plan Create - Interactive Implementation Planning System

Create comprehensive development plans markdown content through deep interactive dialogue and run cli with that content.

**Usage**: `/plan-create`

## Purpose

This command initiates a comprehensive implementation planning process through extensive conversation. It transforms basic ideas into detailed, actionable implementation plans.

### ⚠️ IMPORTANT: CLI Command Execution Required

**This command MUST execute the `cc-self-refer plan create` CLI command after the interactive planning phase.**

### CLI Commands Used

```bash
# Create the implementation plan after planning:
npx -y cc-self-refer plan create "<plan-title>" <<'EOF'
<plan-content>
EOF
```

## Interactive Deep-Dive Process

## Interactive Planning Process

**Simple Workflow:**
1. Ask what the user wants to plan
2. Have a conversation to understand details
3. Create the plan with CLI command

**MANDATORY: Infinite Interactive Dialogue Process**

**Start by asking:**
```
What would you like to plan?

Please describe:
- What you want to implement
- The problem it solves
- Your current tech setup
```

**CRITICAL: After every user response, analyze what implementation details are still missing and ask deeper questions. NEVER stop asking until you know exactly how to implement everything.**

**Self-Assessment Questions - Ask yourself after each user response:**
- "What files exactly need to be created or modified?"
- "What specific code changes are required?"
- "What dependencies need to be installed?"
- "What configuration changes are needed?"
- "How will this integrate with existing code?"
- "What testing approach should be used?"

**Continuous Implementation Deep-Dive Pattern:**
- If user says "add authentication" → Ask: Which files handle auth? What database changes? JWT or sessions? Middleware needed? Registration flow? Password reset?
- If user says "improve performance" → Ask: What specific bottlenecks? Which components are slow? Database queries? Frontend rendering? API endpoints? Caching strategy?
- If user says "refactor components" → Ask: Which exact components? What's the new structure? How to maintain backwards compatibility? Migration steps?

**Keep Digging Until You Know:**
- Exact file paths that need changes
- Specific functions/components to create/modify
- Complete dependency list with versions
- Step-by-step implementation sequence
- All configuration changes required
- Comprehensive testing strategy
- Success criteria with measurable outcomes

**Signs You Need More Implementation Details:**
- You don't know exact file paths → ASK MORE
- You're unsure about code structure → ASK MORE
- Dependencies are unclear → ASK MORE
- Implementation steps are vague → DRILL DOWN
- Testing approach is undefined → ASK MORE
- You can't write specific todo items → ASK MORE

**ONLY create the plan when you can confidently say: "I know exactly which files to modify, what code to write, what dependencies to install, and how to test everything."**

After complete implementation understanding, create the plan using:

```bash
npx -y cc-self-refer plan create "<plan-title>" <<'EOF'
<plan-content>
EOF
```

## Plan Document Template

**IMPORTANT: the following implementation details are just example. The content of implementation section will vary depend on the plan requirement. **

======================TEMPLATE=====================
```markdown
# <Task Name>

## Overview
[Concise description of what needs to be done, why it's needed, and expected outcome]

## Implementation

### Required Content


**Technical Stack & Dependencies**
- Framework: [React, Vue, Node.js, etc.]
- Language & Version: [TypeScript 5.x, Node 18+, etc.]  
- Package Manager: [npm, pnpm, yarn]
- Required Dependencies: List exact package names and versions
- New Dependencies to Install: Exact commands to run
  ```bash
  npm install package-name@version
  pnpm add package-name
  ```

**Architecture & File Structure **
- Directory Structure: Show exact paths where files will be created/modified
- Component/Module Design: Describe the main classes, functions, or components
- Data Flow: How data moves through the system
- State Management: Redux, Context, or other patterns used

**Implementation Steps **
1. **Setup Phase**
   - Environment configuration
   - Dependency installation commands (exact CLI commands)
   - Database migration commands (if needed)

2. **Core Development**
   - File Creation: List all new files to create with their exact paths
   - File Modification: List existing files to modify with specific functions/sections
   - Code Patterns: Reference existing patterns or describe new ones

3. **Integration Phase**  
   - API Integration: Exact endpoint URLs, request/response formats
   - Component Integration: How new components connect to existing ones
   - Testing Integration: Test file locations and testing commands

4. **Validation & Deployment**
   - Build Commands: `npm run build`, `pnpm build`, etc.
   - Test Commands: `npm test`, `pnpm test`, `npm run e2e`, etc.
   - Linting Commands: `npm run lint`, `pnpm lint`, etc.

**Configuration Details **
- Environment Variables: Exact variable names and example values
- Config Files: Which files need modification (tsconfig.json, package.json, etc.)
- Build Settings: Webpack, Vite, or other build tool configurations

**External References **
- Documentation Links: Include exact URLs for libraries, APIs, or frameworks
- CLI Commands from Docs: Copy exact commands from documentation
  ```bash
  # Example: From Next.js docs
  npx create-next-app@latest my-app --typescript --tailwind
  ```
- Code Examples: Include relevant code snippets from documentation

**Error Handling & Edge Cases (에러 처리 및 엣지 케이스)**
- Common Error Scenarios: What could go wrong and how to handle it
- Validation Rules: Input validation, data validation requirements
- Fallback Strategies: What to do when primary approach fails

**Performance Considerations (성능 고려사항)**
- Optimization Strategies: Lazy loading, caching, bundling
- Monitoring: How to measure success (metrics, logging)
- Scalability: How the solution handles growth



## Todo List
- [ ] [Specific action item 1]
- [ ] [Specific action item 2]
- [ ] [Specific action item 3]
- [ ] [Additional tasks as needed]

## Success Criteria
- [ ] [Measurable outcome 1]
- [ ] [Measurable outcome 2]
- [ ] [Test or validation requirement]

## References
- Pattern #[N]: [Brief description if needed]
- Spec #[N]: [Spec title or topic]
- Page #[N]: [Previous session topic]
- File: `path/to/relevant/file.ts`
- Docs: [External documentation link if needed]
```

======================TEMPLATE END=====================

### Q&A Completion Checklist

**Only proceed to CLI execution when:**
- ✅ All technical decisions clarified
- ✅ Implementation approach validated
- ✅ Success criteria defined
- ✅ No ambiguous requirements

**If user seems impatient:**
"I need these details to create an actionable plan. The more specific the information, the better the plan will be."

### Plan Flexibility Guide

**The Implementation section should adapt to your task type:**

- **Feature Development**: Frameworks, libraries, new files to create
- **Bug Fixes**: Root cause analysis, specific code changes
- **Performance**: Metrics, optimization strategies, benchmarks  
- **Refactoring**: Architecture changes, migration steps
- **Configuration**: Environment variables, deployment settings
- **Integration**: API endpoints, authentication, data flow

**Keep it practical:** Include only what's needed for execution. Skip sections if they don't apply.

## Output Characteristics

The implementation plans created should:
- Capture complete technical requirements discussed in conversation
- Be detailed enough for developers to execute immediately
- Include specific file paths, code snippets, and dependencies
- Provide clear success criteria and validation steps
- Reference existing patterns, specs, or previous sessions when relevant

## Reference Commands

If users want to reference existing content while creating plans:

```bash
# View existing patterns
npx cc-self-refer pattern list
npx cc-self-refer pattern search "<keyword>"  
npx cc-self-refer pattern view "<pattern-id>"

# View existing specs  
npx cc-self-refer spec list
npx cc-self-refer spec search "<keyword>"
npx cc-self-refer spec view "<spec-id>"

# View existing plans
npx cc-self-refer plan list
npx cc-self-refer plan search "<keyword>"
npx cc-self-refer plan view "<plan-id>"
```

