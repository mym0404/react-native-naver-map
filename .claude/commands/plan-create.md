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

## ⚠️ CRITICAL: Command Priority Override

**When `/plan-create` is executed, it IMMEDIATELY overrides any other active modes (Spec Mode, etc.)**

- DO NOT use ExitPlanMode during discovery
- DO NOT use TodoWrite for implementation tasks during discovery
- DO NOT start implementation or make code changes
- FOCUS ONLY on understanding requirements through dialogue
- ONLY create plan documents via CLI - NO implementation

### Step 1: Initial Scope Understanding (MANDATORY)

**CRITICAL: Only proceed to Step 4 (CLI execution) after completing Steps 1-3 dialogue. Do not use implementation tools during discovery phase.**

When user types `/plan-create`, the agent MUST first ask:

```
I'll help you create a comprehensive implementation plan through detailed conversation.

First, I need to understand what you're planning to implement:

**What would you like to plan?**

Please describe in detail:
- The feature, fix, or system you want to implement
- The problem it solves or requirement it fulfills
- Your current technical environment and constraints
- Any specific approaches or technologies you're considering

The more detail you provide about the implementation context and requirements, the better I can help create a plan that perfectly fits your project's needs and constraints.

Take your time - this initial context is crucial for creating an actionable implementation plan.
```

### Step 2: Extensive Interactive Discovery

Based on the user's response, engage in a **fully interactive, extensive dialogue** to understand every implementation aspect:

**Technical Context Deep-Dive:**
- Current tech stack and framework versions
- Existing architecture and patterns
- Database and infrastructure setup
- Authentication and security requirements
- Performance and scalability needs
- Testing and deployment processes

**Implementation Requirements Discovery:**
- Specific functionality and user stories
- Technical design and architecture decisions
- Files and modules that need changes
- Dependencies and integrations required
- Error handling and edge cases
- Success metrics and validation criteria

### Step 3: Implementation Planning

After thorough discovery, determine the plan structure based on implementation type:

**For New Features:**
- User stories and acceptance criteria
- Technical architecture and design patterns
- Database schema changes
- API endpoints and interfaces
- Frontend components and user flows
- Integration points and data flow
- Testing strategy and scenarios

**For Bug Fixes:**
- Root cause analysis and diagnosis
- Impact assessment and affected systems
- Fix strategy and implementation approach
- Testing and validation requirements
- Deployment and rollback considerations

**For Performance/Refactoring:**
- Current bottlenecks and target metrics
- Refactoring strategy and migration steps
- Backward compatibility considerations
- Monitoring and observability improvements
- Rollout and validation approach

### Step 4: Create Implementation Plan

**CRITICAL: ONLY CREATE PLAN DOCUMENT - DO NOT IMPLEMENT**

Execute CLI command to create the plan:

```bash
npx -y cc-self-refer plan create "<plan-title>" <<'EOF'
<comprehensive-plan-content>
EOF
```

**AFTER CLI EXECUTION:**
- STOP immediately after creating the plan document
- DO NOT start implementation
- DO NOT edit code files  
- DO NOT use Write, Edit, or MultiEdit tools
- Plan creation is COMPLETE - user must execute implementation separately

## Plan Document Template

======================TEMPLATE=====================
```markdown
# <Task Name>

## Overview
[Concise description of what needs to be done, why it's needed, and expected outcome]

## Implementation

### Prerequisites and Setup
[Dependencies to install (npm/yarn/pnpm packages, system requirements)]
[Environment variables and configuration files to create/modify]
[Database setup, migrations, or schema changes needed]
[Authentication setup, API keys, or credentials required]
[Development tools, CLI installations, or workspace configuration]

### Core Implementation
[Specific files to create with full paths (e.g., src/components/NewFeature.tsx)]
[Existing files to modify with exact locations and changes needed]
[Code snippets, function signatures, or architectural patterns to implement]
[State management setup (Redux, Context, Zustand patterns)]
[API endpoints to create/modify with request/response schemas]
[Business logic implementation with algorithms or data processing steps]
[UI components with props interfaces and styling requirements]

### Integration and Testing
[Integration points with existing systems, APIs, or third-party services]
[Unit test files to create with test scenarios and mock requirements]
[Integration test setup for API endpoints or component interactions]
[End-to-end test scenarios for user workflows]
[Performance testing considerations and benchmarks]
[Error handling implementation and fallback strategies]

### Deployment and Finalization
[Build process modifications or new build scripts]
[Environment-specific configuration for staging/production]
[Database migration scripts or data seeding requirements]
[Monitoring, logging, or analytics implementation]
[Documentation updates (README, API docs, component docs)]
[Version control considerations (branching, PR requirements)]

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

