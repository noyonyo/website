# AI Task Planning Template - Starter Framework

> **About This Template:** This is a systematic framework for planning and executing technical projects with AI assistance. Use this structure to break down complex features, improvements, or fixes into manageable, trackable tasks that AI agents can execute effectively.

---

## 1. Framework Integration

### Complexity Assessment
Rate each factor (1-5) and sum for complexity score:
1. **Multiple unrelated actions** (1-5) - User request combines several different requirements that need coordination: ___
2. **Cross-cutting concerns** (1-5) - Multiple files in different project areas need modification: ___
3. **Codebase investigation required** (1-5) - Understanding existing mechanisms/patterns before proceeding: ___
4. **Assumptions need validation** (1-5) - Many unknowns requiring research, testing, or user clarification: ___
5. **Library/technology research** (1-5) - General investigation of unfamiliar tools or approaches needed: ___

**Total Complexity Score**: ___/25
**Process Type**: [Simple (5-10) / Moderate (11-15) / Complex (16-25)]

### Process Compliance Checklist
- [ ] Complexity scoring completed (refer to task.mdc)
- [ ] Investigation file will be created: `ai-docs/context/investigations/[task-name].md`
- [ ] Chain-of-thought reasoning will be documented (8-step process)
- [ ] Quality gates identified (refer to task-execution-process.mdc)
- [ ] Frontend complexity assessed if applicable (refer to frontend-react-developer.mdc)

---

## 2. Task Overview

### Task Title
<!-- Give your task a clear, specific name that describes what you're building or fixing -->
**Title:** [Brief, descriptive title - e.g., "Add User Authentication System" or "Fix Payment Integration Bug"]

### Goal Statement
<!-- Write one paragraph explaining what you want to achieve and why it matters for your project -->
**Goal:** [Clear statement of the end result you want and the business/user value it provides]

---

## 3. Chain-of-Thought Analysis

### Mandatory Reasoning Process
Complete all 8 steps before implementation (refer to task.mdc for details):

1. **Analysis**: What exactly is being requested and why?
   - **Request**: [Clear statement of what user wants]
   - **Business Value**: [Why this matters for the project]
   - **Confidence**: ___/10

2. **Context Assessment**: What existing patterns/constraints apply?
   - **Existing Patterns**: [Current implementations to consider]
   - **Technical Constraints**: [Limitations to work within]
   - **Confidence**: ___/10

3. **Options Evaluation**: What are 3+ implementation approaches and trade-offs?
   - **Option A**: [Approach with pros/cons]
   - **Option B**: [Approach with pros/cons]
   - **Option C**: [Approach with pros/cons]
   - **Confidence**: ___/10

4. **Decision Rationale**: Why is this specific approach recommended?
   - **Chosen Approach**: [Selected option]
   - **Reasoning**: [Why this is best]
   - **Confidence**: ___/10

5. **Risk Assessment**: What could go wrong and how to mitigate?
   - **Technical Risks**: [Implementation challenges]
   - **Business Risks**: [User/project impact]
   - **Mitigation Strategies**: [How to address risks]
   - **Confidence**: ___/10

6. **Confidence Assessment**: Rate confidence (1-10) for each decision and list what would increase certainty
   - **Overall Confidence**: ___/10
   - **Low Confidence Areas**: [What needs more research]
   - **Confidence Boosters**: [What information would help]

7. **Assumption Validation**: What assumptions am I making that need verification?
   - **Technical Assumptions**: [What we're assuming about the codebase]
   - **Business Assumptions**: [What we're assuming about requirements]
   - **Validation Needed**: [How to verify these assumptions]

8. **Alternative Perspectives**: What other interpretations of requirements are possible?
   - **Alternative Interpretation 1**: [Different way to understand the request]
   - **Alternative Interpretation 2**: [Another perspective]
   - **Clarifications Needed**: [Questions for the user]

### Self-Consistency Validation
Before proceeding, verify:
- [ ] No logical contradictions in recommendations
- [ ] Technical approach aligns with existing constraints
- [ ] All assumptions have been identified and validated
- [ ] Confidence levels are appropriate for decisions made
- [ ] Risk mitigation strategies are realistic

---

## 4. Project Analysis & Current State

### Technology & Architecture
<!-- This is where you document your current tech stack so the AI understands your environment -->
- **Frameworks & Versions:** TODO: List your main frameworks and versions
- **Language:** TODO: Specify your programming language and version
- **Database & ORM:** TODO: Define your database and ORM choice
- **UI & Styling:** TODO: List your UI framework and styling approach
- **Authentication:** TODO: Specify your authentication system
- **Key Architectural Patterns:** TODO: List your main architectural patterns

### Current State
<!-- Describe what exists today - what's working, what's broken, what's missing -->
[Analysis of your current codebase state, existing functionality, and what needs to be changed]

## 3. Context & Problem Definition

### Problem Statement
<!-- This is where you clearly define the specific problem you're solving -->
[Detailed explanation of the problem, including user impact, pain points, and why it needs to be solved now]

### Success Criteria
<!-- Define exactly how you'll know when this task is complete and successful -->
- [ ] [Specific, measurable outcome 1]
- [ ] [Specific, measurable outcome 2]
- [ ] [Specific, measurable outcome 3]

---

## 4. Development Mode Context

### Development Mode Context
<!-- This is where you tell the AI agent about your project's constraints and priorities -->
- **🚨 Project Stage:** TODO: Define if this is new development, production system, or legacy migration
- **Breaking Changes:** TODO: Specify if breaking changes are acceptable or must be avoided
- **Data Handling:** TODO: Define data preservation requirements
- **User Base:** TODO: Describe who will be affected by changes
- **Priority:** TODO: Set your speed vs stability priorities

---

## 5. Technical Requirements

### Functional Requirements
<!-- This is where the AI will understand exactly what the system should do - be specific about user actions and system behaviors -->

TODO: Define what users can do and what the system will automatically handle
- Example format: "User can [specific action]"
- Example format: "System automatically [specific behavior]" 
- Example format: "When [condition] occurs, then [system response]"

### Non-Functional Requirements
<!-- This is where you define performance, security, and usability standards -->
- **Performance:** TODO: Define response time and load handling requirements
- **Security:** TODO: Specify authentication and data protection needs
- **Usability:** TODO: Set user experience and accessibility standards
- **Responsive Design:** TODO: Define mobile, tablet, desktop support requirements
- **Theme Support:** TODO: Specify light/dark mode and brand requirements

### Technical Constraints
<!-- This is where you list limitations the AI agent must work within -->
- [Must use existing system X]
- [Cannot modify database table Y]
- [Must maintain compatibility with feature Z]

---

## 6. Data & Database Changes

### Database Schema Changes
<!-- This is where you specify any database modifications needed -->

TODO: Add your SQL schema changes here (new tables, columns, indexes, etc.)

### Data Model Updates
<!-- This is where you define TypeScript types, schema updates, or data structure changes -->

TODO: Define your TypeScript types, interfaces, and data structure changes

### Data Migration Plan
<!-- This is where you plan how to handle existing data during changes -->

TODO: Plan your data migration steps (backup, apply changes, transform data, validate)

---

## 7. API & Backend Changes

### Data Access Pattern Rules
<!-- This is where you tell the AI agent how to structure backend code in your project -->

TODO: Define where different types of code should go in your project (mutations, queries, API routes)

### Server Actions
<!-- List the backend mutation operations you need -->

TODO: List your create, update, delete operations and what they do

### Database Queries
<!-- Specify how you'll fetch data -->

TODO: Define your data fetching approach (direct queries vs separate functions)

---

## 8. Frontend Changes

### New Components
<!-- This is where you specify UI components to be created -->

TODO: List the new components you need to create and their purpose

### Page Updates
<!-- This is where you list pages that need modifications -->

TODO: List the pages that need changes and what modifications are required

### State Management
<!-- This is where you plan how data flows through your frontend -->

TODO: Define your state management approach and data flow strategy

---

## 9. Implementation Plan

### Phase-by-Phase Breakdown
For each phase, document all required elements:

#### Phase 1: [Phase Name]
- **Deliverables**: [Specific files and functionality to be created/modified]
- **Files Modified**: [Exact file paths - be specific]
- **Dependencies**: [What must be completed before this phase]
- **Confidence Level**: ___/10 [How certain are we about this approach?]
- **Assumptions**: [What we're assuming is true for this phase]
- **Risk Factors**: [What could go wrong in this phase]
- **Validation Criteria**: [How to verify this phase is complete]
- **Time Investment**: [Estimated effort - not time-bound for AI]

#### Phase 2: [Phase Name]
- **Deliverables**: [Specific outputs]
- **Files Modified**: [Exact file paths]
- **Dependencies**: [Prerequisites from previous phases]
- **Confidence Level**: ___/10
- **Assumptions**: [Phase-specific assumptions]
- **Risk Factors**: [Phase-specific risks]
- **Validation Criteria**: [How to verify completion]
- **Time Investment**: [Estimated effort level]

#### Phase 3: [Additional phases as needed]
[Continue pattern for all phases]

### Implementation Dependencies
- **Critical Path**: [Which phases must be completed in order]
- **Parallel Work**: [Which phases can be done simultaneously]
- **Blockers**: [External dependencies that could halt progress]

---

## 10. Task Completion Tracking

### Real-Time Progress Tracking
<!-- This is where you tell the AI agent to update progress as work is completed -->

TODO: Define how you want the AI to track and report progress on tasks

---

## 11. File Structure & Organization

TODO: Plan what new files to create and existing files to modify

---

## 12. Quality Assurance

### Before Implementation Checklist
- [ ] Context analysis completed
- [ ] Online research documented (3+ sources cited)
- [ ] Codebase patterns identified  
- [ ] Implementation options evaluated (3+ options)
- [ ] Decision rationale documented
- [ ] Chain-of-thought reasoning completed (all 8 steps)
- [ ] Confidence assessment provided for key decisions
- [ ] Assumptions explicitly identified and validated
- [ ] Internal consistency check passed (no logical contradictions)
- [ ] Technical feasibility confirmed
- [ ] Constraint compatibility verified

### During Implementation Checklist
- [ ] Progress documented in this task file
- [ ] Decisions captured with rationale
- [ ] Challenges and solutions noted
- [ ] Source verification for technical claims
- [ ] Confidence levels updated as new information emerges
- [ ] Assumption validity checked against implementation reality

### After Implementation Checklist
- [ ] Lessons learned documented
- [ ] Pattern updates noted
- [ ] Integration points documented
- [ ] Performance impact assessed
- [ ] User workflow impact evaluated
- [ ] Breaking changes identified and communicated

---

## 13. AI Agent Instructions

### Mandatory Process Requirements
🎯 **CHAIN-OF-THOUGHT**: Must complete all 8 steps of reasoning process before implementation
🎯 **CONFIDENCE SCORING**: Rate confidence (1-10) for all major decisions and document what would increase certainty
🎯 **ASSUMPTION VALIDATION**: Explicitly identify and validate all assumptions before proceeding
🎯 **CONSISTENCY CHECKING**: Verify no logical contradictions exist in recommendations
🎯 **QUALITY GATES**: Complete all before/during/after implementation checkpoints

### Investigation Protocol (for Complex Tasks)
1. **Context Analysis**: Use `codebase_search` to understand existing patterns
2. **Research Documentation**: Create investigation file `ai-docs/context/investigations/[task-name].md` with 3+ sources
3. **Decision Points**: Document options, trade-offs, and recommendations
4. **User Validation**: Verify findings with user before implementation
5. **Iterative Refinement**: Repeat investigation if significant gaps remain

### Communication Requirements
- **Progress Updates**: Document key decisions and rationale in real-time
- **Risk Alerts**: Flag immediately when assumptions need user validation
- **Confidence Reporting**: Communicate uncertainty levels and information gaps
- **Decision Transparency**: Explain why specific approaches were chosen
- **Completion Summary**: Document what was built, what changed, and lessons learned

### Framework Integration Requirements
- **Complexity Assessment**: Use task.mdc complexity scoring (1-25 scale)
- **Process Selection**: Apply appropriate depth based on complexity + confidence scores
- **Frontend Considerations**: Check frontend-react-developer.mdc for domain-specific complexity
- **Quality Standards**: Follow task-execution-process.mdc quality gates
- **Documentation**: Create all required investigation and pattern files

### Code Quality Standards
- **Follow project patterns**: Learn from existing codebase before implementing
- **Error handling**: Include comprehensive error handling and edge cases
- **Performance**: Consider performance implications and optimization opportunities
- **Accessibility**: Implement WCAG guidelines for frontend components
- **Testing**: Include unit tests and integration test considerations
- **Documentation**: Comment complex logic and document architectural decisions

---

## 14. Frontend-Specific Considerations (If Applicable)

### Frontend Complexity Indicators
Check if task involves (mark all that apply):
- [ ] State management changes (Redux, Zustand, Context API)
- [ ] Performance optimization (memoization, lazy loading, code splitting)
- [ ] Accessibility requirements (ARIA, keyboard navigation, screen readers)
- [ ] Responsive design (multiple breakpoints, mobile-first)
- [ ] Component architecture (reusable components, design systems)
- [ ] API integration (error handling, retry logic, loading states)
- [ ] Real-time updates (WebSocket, Server-Sent Events)
- [ ] Form handling (validation, submission, error states)

### Frontend Process Adaptation
- **High complexity indicators** → Trigger deep investigation
- **Low confidence in approach** → Require additional validation
- **Performance concerns** → Include benchmarking requirements
- **Accessibility needs** → Include WCAG compliance validation

---

## 15. Second-Order Impact Analysis

### Impact Assessment Categories
Document broader consequences of changes:

#### Code Impact
- **Breaking Changes**: [What existing functionality might break]
- **Integration Points**: [How changes affect other system parts]
- **Performance**: [Expected performance impact - positive/negative]
- **Security**: [Security implications of changes]

#### User Impact  
- **User Workflows**: [How user experience will change]
- **Learning Curve**: [What users need to learn/relearn]
- **Accessibility**: [Impact on users with disabilities]
- **Mobile Experience**: [Changes to mobile user experience]

#### Technical Debt
- **New Debt Created**: [Shortcuts or compromises made]
- **Debt Resolved**: [Technical debt this change fixes]
- **Future Maintenance**: [Ongoing maintenance requirements]
- **Documentation Needs**: [What documentation must be updated]

#### Business Impact
- **Feature Dependencies**: [Other features that depend on this change]
- **Timeline Impact**: [How this affects other planned work]
- **Resource Requirements**: [Ongoing resource needs]
- **Risk Mitigation**: [How to minimize negative impacts]

---
