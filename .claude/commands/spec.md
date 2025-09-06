# Spec - Comprehensive Project Specification System

Create detailed project specifications through deep interactive dialogue.

**Usage**: `/spec`

## Purpose

This command initiates a comprehensive specification creation process through extensive conversation. It can generate either complete multi-file product specifications or individual spec documents based on your needs.

### ⚠️ IMPORTANT: CLI Command Execution Required

**This command MUST execute multiple `cc-self-refer spec create` CLI commands after the interactive planning phase.**

### CLI Commands Used

```bash
# Create each specification file after planning:
npx -y cc-self-refer spec create "<spec-title>" <<'EOF'
<spec-content>
EOF
```

## Interactive Deep-Dive Process

### Step 1: Initial Scope Understanding (MANDATORY)

**CRITICAL: Only proceed to Step 4 (CLI execution) after completing Steps 1-3 dialogue. Do not use implementation tools during discovery phase.**

When user types `/spec`, the agent MUST first ask:

```
I'll help you create comprehensive project specifications through detailed conversation.

First, I need to understand what you're building:

**What would you like to specify?**

Please describe in detail:
- The system/feature/product you want to specify
- Whether this is a complete product or specific functionality
- The core problem it solves and how it works

The more detail you provide about the functionality and system design, the better I can help create specifications that capture every important aspect of your solution.

Take your time - this initial context is crucial for creating valuable specifications.
```

### Step 2: Extensive Interactive Discovery

Based on the user's response, engage in a **fully interactive, extensive dialogue** to understand every aspect:

### Step 3: Specification Planning

After thorough discovery, determine the specification structure based on scope:

**For Complete System/Initial Setup:**
- Core architecture and infrastructure
- Data models and database design
- API structure and authentication
- Security framework
- Base configurations

**For Individual Features (Most Common):**
Each feature gets its own comprehensive specification:
- Feature overview and user stories
- Data model changes/additions
- API endpoints needed
- Business logic and rules
- UI/UX requirements (if applicable)
- Integration points
- Testing scenarios

### Step 4: Create Multiple Specification Files

Execute CLI commands to create each specification:

```bash
# Example for e-commerce platform specifications
npx -y cc-self-refer spec create "E-commerce Product Vision" <<'EOF'
# E-commerce Platform Product Vision

## Executive Summary
[Comprehensive vision based on conversation]

## Business Objectives
[Detailed objectives extracted from dialogue]
...
EOF

npx -y cc-self-refer spec create "User Personas and Journeys" <<'EOF'
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
