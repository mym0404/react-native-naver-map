# Plan Resolve - Execute Strategic Plans with TODO Tracking

Load a strategic plan and systematically work through all todos until completion with interactive progress tracking.

**Usage**: `/plan-resolve <id|keyword>`

## ⚠️ CRITICAL: Direct Plan File Modification Required

**This command requires direct modification of the original plan file in `.claude/plans/` directory:**

1. **TODO Checkboxes**: Mark completed todos with `[x]` directly in the plan file
2. **Success Criteria**: Update success criteria checkboxes `[x]` as they are achieved  
3. **File Location Display**: The `plan view` command shows the exact file path for direct editing
4. **Real-time Progress**: Check off items in the actual plan file to track progress

**Workflow Pattern:**
- Load plan with `npx cc-self-refer plan view <id>` (shows file location)
- Edit the plan file directly: `.claude/plans/001-example-plan.md`
- Check off `- [x]` completed todos and success criteria as you complete them
- Use the plan file as your live progress tracker throughout implementation

## Purpose

This command facilitates comprehensive execution of strategic plans by:
1. Loading the plan and extracting all TODO items
2. Creating a working TODO list for systematic progress tracking
3. Continuously working through ALL todos until 100% completion
4. Providing interactive clarification when plan details are ambiguous
5. Updating success criteria based on actual implementation progress

## What does this command do

### ⚠️ IMPORTANT: CLI Command Execution Required

**This command MUST execute the following `cc-self-refer` CLI commands. Do NOT implement the functionality directly.**

### CLI Commands Used

```bash
# Step 1: Load the plan for implementation reference
npx -y cc-self-refer plan view <id_or_keyword> 
```

### Command Arguments
- `id_or_keyword`: Plan ID number or search keyword

### Expected Workflow - Comprehensive TODO-Driven Implementation

1. **Load Plan Content**: Display the full strategic plan with all sections
2. **Reference Plan Details**: Use the loaded plan document as primary reference for all implementation decisions
3. **Extract TODO Items**: Parse all todos from the plan into a working task list
4. **Initialize TODO Tracking**: Create structured TODO list with status tracking
5. **Continuous Implementation Loop**:
   - Mark current todo as "in_progress" 
   - Work on the specific todo item
   - Ask clarifying questions if plan details are unclear or ambiguous
   - Update success criteria if implementation reveals new requirements
   - Mark todo as "completed" only when fully implemented
   - Immediately move to next pending todo
   - **NEVER STOP** until all todos are completed
6. **Success Criteria Validation**: Verify all success criteria are met
7. **Plan Completion**: Confirm all objectives achieved

## Usage Examples

### View by Plan ID

```bash
/plan-resolve 3
```

### Search by Keyword

```bash
/plan-resolve authentication
```

### List All Plans

```bash
/plan-resolve
```

## Output Formats

### Single Match

```markdown
# Plan Loaded: [Title]

## File: `.claude/plans/[filename]`

[Full plan content displayed]
```

### Multiple Matches

```markdown
# Multiple Plans Found for "[keyword]"

1. **[Plan 1]** (`3-darkmode.md`)
   📝 Brief: [Excerpt]
2. **[Plan 2]** (`5-api-optimization.md`)
   📝 Brief: [Excerpt]

**Select**: `/plan-resolve <number>` to view specific plan
```

## Interactive Features

### Detailed Implementation Process

When executing a plan, follow this comprehensive workflow:

#### Phase 1: Plan Analysis and TODO Extraction
```markdown
# Plan Loaded: [Title]

## Extracting TODO Items...
Found [X] todos in plan:
- [ ] Todo Item 1
- [ ] Todo Item 2  
- [ ] Todo Item 3
...

## Extracting Success Criteria...
Found [Y] success criteria:
- [ ] Success Criterion 1
- [ ] Success Criterion 2
...

**Ready to begin implementation**
```

#### Phase 2: Continuous TODO Implementation Loop

**Critical Implementation Rules:**
1. **ONLY ONE TODO AT A TIME**: Mark exactly one todo as "in_progress"
2. **COMPLETE BEFORE MOVING**: Never abandon a todo without completion
3. **ASK WHEN UNCLEAR**: If plan details are ambiguous, ask user for clarification
4. **UPDATE CRITERIA**: Modify success criteria if implementation reveals new requirements
5. **NEVER STOP**: Continue until ALL todos are completed

**Example Implementation Flow:**
```markdown
# TODO Progress: [3/15] Complete

## Currently Working On:
🔄 **[in_progress]** Implement Self Referring Model diagram with Mermaid.js

## Status:
- Working on custom `<SelfReferDiagram />` component
- Need clarification: Should the diagram be interactive or static?
- Updated success criteria: Added mobile responsiveness requirement

**User Input Needed**: 
Should the Self Referring Model diagram include interactive clickable nodes 
that show detailed explanations, or should it be a static visualization?

## Next Up:
- [ ] Create MDX components for interactive command demos
- [ ] Write command documentation auto-generation script
- [ ] Set up GitHub Actions workflow for deployment
```

#### Phase 3: Interactive Clarification Pattern

**When Plan Details Are Unclear:**
```markdown
## ⚠️ Clarification Needed

**Current TODO**: [Specific todo item]
**Issue**: [What is unclear or ambiguous]
**Options**: 
1. [Option A with implications]
2. [Option B with implications] 
3. [Option C with implications]

**Question**: [Specific question for user]

**Impact**: This decision affects:
- [Affected component 1]
- [Affected component 2]
- [Timeline implications]
```

#### Phase 4: Success Criteria Updates

**When Implementation Reveals New Requirements:**
```markdown
## 📝 Success Criteria Update

**Original Criterion**: [Original success criterion]
**Proposed Update**: [Updated criterion based on implementation reality]
**Reason**: [Why the update is necessary]

**Additional Criteria Discovered**:
- [New criterion 1]: [Justification]
- [New criterion 2]: [Justification]

**User Approval**: Do you approve these success criteria updates?
```

#### Phase 5: Final Validation and Completion

```markdown
# 🎉 Plan Implementation Complete

## TODO Summary: [15/15] Complete ✅
All implementation tasks have been completed successfully.

## Success Criteria Validation: [13/13] Met ✅
All success criteria have been verified and met.

## Implementation Notes:
- [Key achievement 1]
- [Key achievement 2]  
- [Important decisions made]
- [Challenges overcome]

## Files Created/Modified:
- [List of files with brief descriptions]

**Plan Status**: COMPLETED
**Next Steps**: [Any follow-up recommendations]
```

## Integration Benefits

### Implementation Context

- Provides strategic background for development tasks
- Clarifies requirements and success criteria
- Shows relationship to other project components

### Decision Reference

- Access to original architectural decisions
- Context for technical choices
- Risk assessment and mitigation strategies

### Progress Tracking

- Clear view of completed vs remaining work
- Timeline and milestone awareness
- Dependencies and blocking factors

## Best Practices

### TODO Management Best Practices

1. **Complete Sequential Processing**: Always work through todos in logical order
2. **Single Focus Rule**: Only mark one todo as "in_progress" at any time
3. **Completion Verification**: Verify each todo is 100% complete before moving on
4. **Interactive Clarification**: Ask users for guidance when plan details are unclear
5. **Success Criteria Updates**: Modify success criteria when implementation reveals new requirements
6. **Progress Communication**: Keep users informed of current progress and next steps

### Implementation Best Practices

7. **Regular Reference**: Check relevant plans before starting implementation
8. **Continuous Progress**: Never abandon the implementation process until all todos are complete
9. **Keyword Search**: Use descriptive terms for faster plan discovery
10. **ID Bookmarking**: Remember frequently accessed plan IDs
11. **Documentation Updates**: Update plan files with implementation insights
12. **Quality Validation**: Ensure all success criteria are met before marking plan complete

### User Interaction Best Practices

13. **Clear Communication**: Provide specific questions when clarification is needed
14. **Options Presentation**: Present clear alternatives when plan details are ambiguous
15. **Impact Explanation**: Explain how decisions affect overall implementation
16. **Progress Transparency**: Show current progress and remaining work clearly
17. **Decision Recording**: Document important decisions made during implementation


## Reference Commands

If users want to reference existing content while creating specs:

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
