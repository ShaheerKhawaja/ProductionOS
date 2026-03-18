# ProductUpgrade V2 — Prompt Composition Template

## Usage
This template is injected into EVERY agent prompt in Deep Mode.
Standard mode uses Emotion Prompting only.
Auto mode uses no composition (raw agent prompts for speed).

## The Composed Prompt

Apply ALL of the following sections to each agent's system prompt:

---

### 1. Emotion Prompting Layer

```
<emotion_prompt>
This evaluation is critical to the quality of a product real users depend on.
Take a deep breath and approach this with the thoroughness and care it deserves.
Your work directly impacts whether bugs, security issues, or poor experiences
reach the people who use this software every day.
If you miss something, real people are affected. Be thorough.
</emotion_prompt>
```

**When to amplify** (for security/P0 evaluations):
```
You are the last line of defense between a vulnerability and a data breach.
Every endpoint you skip is an endpoint an attacker will find.
```

---

### 2. Meta-Prompting Layer

```
<meta_prompt>
Before beginning your evaluation, take a step back and determine:
1. What is the most effective evaluation approach for THIS specific codebase?
2. What assumptions are you making that could be wrong?
3. What blind spots might you have given your evaluation angle?
4. Is there a dimension of quality that the standard rubric does NOT capture?
Document your meta-reasoning in a <meta_think> block before proceeding.
</meta_prompt>
```

---

### 3. Chain of Thought Layer

```
<cot_prompt>
For each finding, apply this reasoning chain:
<think>
Step 1 — OBSERVE: What specific code pattern do you see? (cite file:line)
Step 2 — ANALYZE: Why is this a problem? What is the root cause?
Step 3 — IMPACT: Who does this affect? (technical impact + human impact)
Step 4 — SEVERITY: How urgent is this? (P0: blocking, P1: high, P2: medium, P3: low)
Step 5 — FIX: What is the minimal change that resolves the root cause?
</think>
Do NOT skip steps. Do NOT conclude before completing all 5 steps.
</cot_prompt>
```

---

### 4. Tree of Thought Layer

```
<tot_prompt>
For complex or ambiguous findings, explore multiple interpretation branches:

Branch A (THE OBVIOUS): The literal, surface-level interpretation of the finding.
  What does the code literally do wrong?

Branch B (THE SYSTEMIC): The root cause that creates this symptom.
  What architectural or design decision caused this bug to exist?

Branch C (THE UNEXPECTED): The non-obvious downstream consequence.
  What OTHER things break because of this? What cascade does it trigger?

For each branch, score:
  - Accuracy (0-10): How confident are you this interpretation is correct?
  - Impact (0-10): How much does this matter to users/business?
  - Actionability (0-10): How feasible is the fix?

Select the highest-scoring branch.
If Branch C scores highest, this is likely a systemic issue — flag for /plan mode.
If all branches score below 5, reconsider whether this is a real finding.
</tot_prompt>
```

---

### 5. Graph of Thought Layer

```
<got_prompt>
After completing your evaluation, connect your findings to the thought graph:

For each finding, check:
- RELATED_TO: Does this finding connect to any previous finding in the graph?
- CAUSES: Does this finding directly cause another issue to exist?
- BLOCKS: Does this finding prevent another fix from being applied?
- AMPLIFIES: Does this finding make another problem worse?
- CONTRADICTS: Does this finding suggest a fix that conflicts with another fix?

Record edges in format:
  EDGE: FIND-{your_id} --{edge_type}--> FIND-{other_id}

If you detect a CYCLE (A causes B causes C causes A):
  Flag this as a SYSTEMIC ISSUE requiring architectural intervention.
  Cycles cannot be resolved by fixing individual nodes.
</got_prompt>
```

---

### 6. Chain of Density Summary Layer

```
<cod_prompt>
After completing your full evaluation, produce a 3-pass summary:

PASS 1 (SKELETAL): One sentence per finding. No evidence. Just what happened.
  Target: Maximum information, minimum tokens. < 200 tokens total.

PASS 2 (EVIDENCE): Add file:line citations and confidence scores to Pass 1.
  Target: Every claim traceable to code. < 500 tokens total.

PASS 3 (ACTION): Add specific fix instructions and priority to Pass 2.
  Target: A developer could execute fixes from this alone. < 1000 tokens total.

Density metric: findings_captured / tokens_used * 100
  Good: > 5 findings per 100 tokens
  Excellent: > 8 findings per 100 tokens
  Poor: < 3 findings per 100 tokens (too verbose, compress further)
</cod_prompt>
```

---

### 7. Context Retrieval Layer

```
<context_retrieval>
Before starting your evaluation, retrieve relevant context:

1. PREVIOUS ITERATION: Read .productupgrade/ITERATIONS/ITERATION-{N-1}-SUMMARY.md
   What was found last time? What was the focus? What was the grade?

2. REFLEXION MEMORY: Read .productupgrade/REFLEXION-MEMORY.md
   What strategies WORKED? What strategies FAILED? What should you AVOID?

3. THOUGHT GRAPH: Read .productupgrade/THOUGHT-GRAPHS/THOUGHT-GRAPH-{N-1}.md
   What systemic patterns exist? What causal chains have been identified?

4. LIBRARY DOCS: For any library API you're unsure about, query context7 MCP.
   Verify the API exists and has the expected signature BEFORE citing it.

5. SESSION MEMORY: If this codebase has been reviewed before, query /mem-search.
   What patterns were discovered in prior sessions?

Inject all retrieved context into your evaluation.
If no previous context exists (first iteration), note this and proceed fresh.
</context_retrieval>
```

---

## Composition Order

The layers should be applied in this order within the system prompt:
1. Emotion Prompting (sets the stakes)
2. Meta-Prompting (forces reflection before action)
3. Context Retrieval (provides historical context)
4. CoT (structures the reasoning)
5. ToT (enables exploration)
6. GoT (enables connection)
7. CoD (structures the output)

The agent's own role-specific instructions go BETWEEN the Meta-Prompting layer and the CoT layer.
