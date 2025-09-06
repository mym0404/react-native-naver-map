# Plan Create - Interactive Implementation Planning System

Create comprehensive implementation plans through deep interactive dialogue.

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

Execute CLI command to create the plan:

```bash
npx -y cc-self-refer plan create "<plan-title>" <<'EOF'
<comprehensive-plan-content>
EOF
```

### Interactive Q&A Strategy

**Start broad, then get specific based on answers:**

Example for "implement rate limiting":
```
Round 1 - Context:
- What's your API framework?
- Do you have Redis available?
- Current traffic patterns?

Round 2 - Requirements (based on Round 1):
- Rate limit thresholds?
- Different limits per user type?
- Which endpoints to protect?

Round 3 - Implementation:
- User identification method?
- Response when exceeded?
- Monitoring needs?

[Continue until all details clear]
```

## Plan Document Template

```markdown
# <Task Name>

## Overview
[Concise description of what needs to be done, why it's needed, and expected outcome]

## Implementation
[Detailed technical implementation including:
- Framework/library choices (without version, assume latest versions'll be used)
- Specific files to create/modify with exact paths
- Code snippets or pseudo-code for core logic
- Package dependencies to install
- API endpoints or interfaces to implement
- Database schema changes if needed
- Configuration and environment variables]

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

### Example Plan

```markdown
# Fix Memory Leak in WebSocket Handler

## Overview
Resolve memory leak causing server crashes after 24 hours of operation. Event listeners are not being properly cleaned up on disconnect.

## Implementation
**Root Cause:** Event listeners not removed on socket disconnect
**Affected Service:** WebSocket server (`src/services/websocket.ts`)

**Fix approach:**
```typescript
// Add cleanup in disconnect handler
socket.on('disconnect', () => {
  socket.removeAllListeners();
  clearInterval(heartbeatInterval);
  delete activeSockets[socket.id];
});
```

**Memory profiling:**
- Use Chrome DevTools for heap snapshots
- Monitor with `process.memoryUsage()`

## Todo List
- [ ] Add memory profiling logs
- [ ] Implement proper cleanup handlers
- [ ] Test with connection stress tool
- [ ] Monitor for 48 hours in staging
- [ ] Deploy fix to production

## Success Criteria
- [ ] Memory usage stable over 48 hours
- [ ] No orphaned event listeners in heap dumps
- [ ] Server handles 10k connect/disconnect cycles

## References
- Page #23: Previous WebSocket issues
- Pattern #7: Resource cleanup patterns
```

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

## Key Principles

1. **Deep Discovery Through Dialogue** - Have extensive conversations to understand every implementation detail
2. **Adaptive Questioning** - Each question builds on previous answers to go deeper
3. **Comprehensive Planning** - Don't stop until all technical and business requirements are clear
4. **Actionable Plans** - Create specific, implementable plans with clear steps
5. **Context-Aware** - Consider existing codebase patterns and constraints

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

