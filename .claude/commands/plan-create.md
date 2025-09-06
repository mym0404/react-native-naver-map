# Plan Create - Create New Implementation Planning Document

Create comprehensive planning to implement specific product specification or requirement with interactive Q&A and run cli.

**Usage**: `/plan-create <plan-name> <description>`

## What does this command do

### ⚠️ IMPORTANT: CLI Command Execution Required

**This command MUST execute the following `cc-self-refer` CLI command.**

### Interactive Process Flow

1. **Analyze Initial Request**: Identify all information gaps from user's brief description
2. **Interactive Q&A Session**: Continue asking targeted questions until all implementation details are clear
3. **Generate Plan Content**: Create comprehensive plan markdown using all gathered information
4. **Execute CLI Command**: Save the plan using `npx -y cc-self-refer ` CLI (REQUIRED)

### Information Gathering Requirements

**Claude Code MUST think comprehensively and continue asking until understanding:**
- Complete technical context and constraints
- All implementation details and approaches
- Success criteria and validation methods
- Existing code patterns and dependencies
- Performance, security, and compatibility needs

### CLI Command Used

```bash
npx -y cc-self-refer plan create "<title>" <<'EOF'
<full-plan-content>
EOF
```

### Command Arguments
- `title`: Title of the plan
- `full-plan-content`: Complete markdown content generated after comprehensive Q&A session

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

## Usage Examples

### Create Plan Examples

When user requests:

```bash
/plan-create "implement rate limiting" "prevent API abuse with Redis-based rate limiting"
```

**Claude's Interactive Response:**

```
I'll help create a comprehensive plan for implementing rate limiting.
Let me gather essential information first:

**Technical Context:**
1. What web framework are you using?
2. Is Redis already in your infrastructure?
3. Are you running multiple server instances?

**Requirements:**
4. What rate limits do you need? (requests/minute)
5. Different limits for different users/endpoints?

Please answer these so I can ask more specific questions.
```

**User provides answers...**

**Claude continues gathering information:**
```
Based on your answers, I need to understand:

6. How do you identify users? (API key, JWT, IP?)
7. What response when limits exceeded? (429 status, custom message?)
8. Any services to whitelist?
9. Monitoring/alerting requirements?
```

**After all information gathered:**

1. Generate comprehensive plan using template with all Q&A information
2. Execute (REQUIRED):
   ```bash
   npx -y cc-self-refer plan create "implement rate limiting" <<'EOF'
   <generated plan content>
   EOF
   ```
3. Confirm: "✅ Plan created: 001-implement-rate-limiting.md"

