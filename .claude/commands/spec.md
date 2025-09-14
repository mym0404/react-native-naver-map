# Spec - Comprehensive Project Specification System

Create detailed project specifications markdown content through deep interactive dialogue and run cli with that content.

**Usage**: `/spec`

## Purpose

This command initiates a comprehensive specification creation process through extensive conversation. It can generate either complete multi-file product specifications or individual spec documents based on your needs.

### ⚠️ IMPORTANT: CLI Command Execution Required

**This command MUST execute multiple `cc-self-refer spec create` CLI commands after the interactive planning phase.**

### CLI Commands Used

```bash
# Create each specification file after planning:
npx cc-self-refer spec create "<spec-title>" <<'EOF'
<spec-content>
EOF
```

## Interactive Deep-Dive Process

## Interactive Specification Process

**Simple Workflow:**
1. Ask what the user wants to specify
2. Have a conversation to understand the requirements
3. Create specification files with CLI commands

**MANDATORY: Infinite Interactive Dialogue Process**

**Start by asking:**
```
What would you like to specify?

Please describe:
- The system/feature/product you want to specify
- Whether this is a complete product or specific functionality  
- The core problem it solves
```

**CRITICAL: After every user response, analyze what information is still missing and ask deeper questions. NEVER stop asking until you have complete clarity.**

**Self-Assessment Questions - Ask yourself after each user response:**
- "What technical details are still unclear?"
- "What user scenarios haven't been explored?"
- "What integration points are missing?"
- "What business rules need clarification?"
- "What data structures are undefined?"
- "What edge cases haven't been considered?"

**Continuous Deep-Dive Pattern:**
- If user says "authentication system" → Ask: How will users register? Social login? Password policies? Session management? Token refresh? Multi-factor auth?
- If user says "e-commerce" → Ask: What products? How's inventory managed? Payment methods? Order workflow? Shipping? Returns?
- If user says "React app" → Ask: Which React version? State management? Routing? Styling? Build tools? Testing framework?

**Keep Digging Until:**
- You can write detailed specs without making ANY assumptions
- Every technical component is clearly defined
- All user workflows are mapped out
- All data structures are specified
- All integrations are identified
- All business rules are documented

**Signs You Need More Information:**
- You're thinking "I assume..." → ASK MORE
- You're unsure about technical implementation → ASK MORE
- User gave high-level answers → ASK FOR SPECIFICS
- Any requirement seems vague → DRILL DOWN
- You don't know exact file structures → ASK MORE

**ONLY create specifications when you can confidently say: "I understand every aspect of this system and can write comprehensive specifications without guessing anything."**

After complete understanding, create specifications using:

Execute CLI commands to create each specification:

```bash
# Example for e-commerce platform specifications
npx cc-self-refer spec create "E-commerce Product Vision" <<'EOF'
# E-commerce Platform Product Vision

## Executive Summary
[Comprehensive vision based on conversation]

## Business Objectives
[Detailed objectives extracted from dialogue]
...
EOF

npx cc-self-refer spec create "User Personas and Journeys" <<'EOF'
# User Personas and Customer Journeys

## Primary Personas
[Detailed personas developed through conversation]
...
EOF

# Continue for all planned specifications...
```

## Expected Output Examples

### Initial Project Setup Specs
```
├── 001-system-architecture.md
├── 002-database-schema.md
├── 003-api-structure.md
├── 004-authentication-system.md
└── 005-deployment-configuration.md
```

### Feature-Based Specs (Most Common Pattern)

**E-commerce Project Evolution:**
```
├── 001-initial-setup.md
├── 002-user-registration-feature.md
├── 003-product-catalog-feature.md
├── 004-shopping-cart-feature.md
├── 005-payment-integration-feature.md
├── 006-order-tracking-feature.md
├── 007-review-system-feature.md
├── 008-recommendation-engine-feature.md
├── 009-admin-dashboard-feature.md
└── 010-inventory-management-feature.md
```

**SaaS Platform Features:**
```
├── 011-subscription-billing-feature.md
├── 012-team-collaboration-feature.md
├── 013-notification-system-feature.md
├── 014-data-export-feature.md
├── 015-api-rate-limiting-feature.md
├── 016-audit-logging-feature.md
└── 017-two-factor-auth-feature.md
```

### Individual Feature Specification Content

**Example: 005-payment-integration-feature.md**
```markdown
# Payment Integration Feature

## Overview
Enable users to make payments through multiple payment providers

## User Stories
- As a customer, I want to pay with credit card
- As a customer, I want to save payment methods
- As a business, I need PCI compliance

## Technical Requirements

### Data Model Changes
- New tables: payment_methods, transactions
- User table: add stripe_customer_id

### API Endpoints
- POST /api/payments/process
- GET /api/payments/methods
- POST /api/payments/methods
- DELETE /api/payments/methods/:id

### Business Logic
- Payment retry logic
- Refund handling
- Currency conversion
- Tax calculation

### Integration Points
- Stripe API integration
- PayPal SDK integration
- Webhook handlers

### Security Considerations
- PCI DSS compliance
- Token vault implementation
- Sensitive data encryption
```

## Key Principles

1. **Deep Discovery Through Dialogue** - Have extensive conversations to understand every nuance
2. **Adaptive Questioning** - Each question builds on previous answers to go deeper
3. **Comprehensive Coverage** - Don't stop until you understand the complete vision
4. **Multiple File Generation** - Create as many specification files as needed to properly document the project
5. **Business & Technical Balance** - Capture both the business vision and technical requirements

## Output Characteristics

The specifications created should:
- Capture the essence and vision discussed in the conversation
- Be detailed enough for implementation teams to execute
- Include context and reasoning behind decisions
- Cross-reference related specifications
- Provide clear success criteria

This command transforms specification creation into a deep collaborative process that produces comprehensive, multi-file project documentation that truly captures the project's vision and requirements.

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
