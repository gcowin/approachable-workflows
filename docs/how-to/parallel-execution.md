# How to Add Parallel Execution

**Goal:** Run multiple activities concurrently to reduce wall-clock time.

**Use When:** You have independent tasks that don't depend on each other's results.

---

## The Pattern

```text
Validate Request
  Kind: Do Together
  Do These Activities Together:
    - Check Customer Credit
    - Check Inventory Availability
    - Check Fraud Indicators
  
  Wait For: All
  Time Limit: 30 seconds
  
  When All Complete:
    - If all passed → Process Order
    - If any failed → Reject Request
    - If timeout → Escalate
```

---

## Step 1: Identify Independent Activities

**Can run in parallel:**
- ✅ Looking up customer credit (external API)
- ✅ Checking inventory (database query)
- ✅ Checking fraud indicators (separate service)

**Cannot run in parallel:**
- ❌ Activities that depend on each other's outputs
- ❌ Activities that modify the same data
- ❌ Activities where order matters

**Example of dependency (NOT parallel):**
```text
# These must run in sequence:
Gather Records → Analyze Records → Verify Analysis
```

---

## Step 2: Define the Parallel Activity

```text
Validate Request
  Kind: Do Together
  Role: Coordinator
  Needs: Order details
  Do These Activities Together:
    - Check Customer Credit
    - Check Inventory Availability  
    - Check Fraud Indicators
  
  Wait For: All
  Time Limit: 30 seconds
  
  Creates: Validation results
  Verify: All checks completed
  Next: Process Order
```

**Key fields:**
- `Kind: Do Together` — Signals parallel execution
- `Do These Activities Together:` — List of activities to run
- `Wait For: All` — Wait for all to complete (or use `Any`)
- `Time Limit:` — Maximum wait time

---

## Step 3: Define the Individual Activities

Each parallel activity is defined normally:

```text
Check Customer Credit
  Role: Analyst
  Needs: Customer ID
  Do: Query credit service and return credit score
  Creates: Credit score, Credit status
  Verify: Credit service responded successfully
  If Failed: Log credit check failure

Check Inventory Availability
  Role: Researcher
  Needs: Product ID, Quantity
  Do: Check warehouse inventory levels
  Creates: Inventory status, Available quantity
  Verify: Inventory levels retrieved
  If Failed: Log inventory check failure

Check Fraud Indicators
  Role: Analyst
  Needs: Order details, Customer history
  Do: Run fraud detection rules
  Creates: Fraud risk score
  Verify: Fraud check completed
  If Failed: Log fraud check failure
```

---

## Step 4: Handle Results

### Wait For: All

All parallel activities must complete successfully:

```text
Validate Request
  Kind: Do Together
  Do These Activities Together:
    - Check Customer Credit
    - Check Inventory Availability
    - Check Fraud Indicators
  
  Wait For: All
  
  When All Complete:
    - If all passed → Process Order
    - If any failed → Reject Request
```

**Use when:** All checks are required for the workflow to proceed.

### Wait For: Any

First successful activity wins:

```text
Get Customer Data
  Kind: Do Together
  Do These Activities Together:
    - Query Primary CRM
    - Query Backup CRM
  
  Wait For: Any
  
  When Any Complete:
    - First success → Continue with that data
```

**Use when:** Multiple sources can provide the same data (redundancy/failover).

---

## Step 5: Handle Timeouts

```text
Validate Request
  Kind: Do Together
  Do These Activities Together:
    - Check Customer Credit
    - Check Inventory Availability
    - Check Fraud Indicators
  
  Time Limit: 30 seconds
  
  Next:
    - All completed → Process Order
    - Timeout → Escalate for manual review
```

**Best practice:** Always set a `Time Limit` to prevent hanging workflows.

---

## Complete Example

```text
Workflow: Fast Order Validation
Goal: Validate orders with parallel checks

Receive Order
  Role: Coordinator
  Needs: Order request
  Do: Create order record and extract details
  Creates: Order details
  Verify: Order has customer ID and product ID
  Next: Validate Request

Validate Request
  Kind: Do Together
  Role: Coordinator
  Needs: Order details
  Do These Activities Together:
    - Check Customer Credit
    - Check Inventory Availability
    - Check Fraud Indicators
  
  Wait For: All
  Time Limit: 30 seconds
  
  Creates: Validation results
  Verify: All checks completed
  
  Next:
    - All passed → Process Order
    - Any failed → Reject Request
    - Timeout → Escalate for Manual Review

Check Customer Credit
  Role: Analyst
  Needs: Customer ID
  Do: Query credit service and return credit score
  Creates: Credit score (pass/fail)
  Verify: Credit service responded successfully
  If Failed: Mark as failed check

Check Inventory Availability
  Role: Researcher
  Needs: Product ID, Quantity
  Do: Check warehouse inventory levels
  Creates: Inventory status (available/unavailable)
  Verify: Inventory levels retrieved
  If Failed: Mark as failed check

Check Fraud Indicators
  Role: Analyst
  Needs: Order details, Customer history
  Do: Run fraud detection rules
  Creates: Fraud risk score (pass/fail)
  Verify: Fraud check completed
  If Failed: Mark as failed check

Process Order
  Role: Executor
  Needs: Order details, Validation results
  Do: Submit order to fulfillment system
  Verify: Order accepted by fulfillment
  Next: Notify Customer

Reject Request
  Role: Coordinator
  Needs: Validation results
  Do: Log rejection reason and notify customer
  Next: Completed

Escalate for Manual Review
  Role: Coordinator
  Needs: Order details, Partial validation results
  Do: Route to operations team for manual validation
  Next: Completed
```

---

## Performance Impact

### Sequential (54 seconds total)
```
Check Credit (20s) → Check Inventory (15s) → Check Fraud (19s) = 54s
```

### Parallel (20 seconds total)
```
Check Credit (20s) ┐
Check Inventory (15s) ├─ All complete = 20s (slowest)
Check Fraud (19s) ┘
```

**Speedup:** 2.7× faster with parallel execution!

---

## Common Patterns

### 1. Parallel Research

```text
Gather Data
  Kind: Do Together
  Do These Activities Together:
    - Fetch Customer Record
    - Fetch Policy Documents
    - Fetch Transaction History
  Wait For: All
  Next: Analyze Data
```

### 2. Parallel Notifications

```text
Notify All Parties
  Kind: Do Together
  Do These Activities Together:
    - Send Email to Customer
    - Post to Slack Channel
    - Update CRM Record
  Wait For: All
  Next: Completed
```

### 3. Failover with Any

```text
Retrieve Data
  Kind: Do Together
  Do These Activities Together:
    - Query Primary Database
    - Query Secondary Database
  Wait For: Any
  Time Limit: 10 seconds
  Next: Process Data
```

---

## Troubleshooting

### Issue: Activities complete in sequence, not parallel

**Cause:** Harness doesn't support parallel execution.

**Solution:** Use runtime skill or ensure harness has parallel execution capability.

### Issue: Timeout always triggers

**Cause:** One activity is too slow.

**Solution:** Increase `Time Limit` or optimize slow activity.

### Issue: "Wait For: Any" waits for all

**Cause:** Syntax error or harness doesn't support "Any" mode.

**Solution:** Check syntax. Verify harness capability.

---

## Next Steps

**Learn more:**
- [Activity Model](../explanation/activity-model.md) — Understanding activities and roles
- [Step-by-Step Tutorial](../tutorials/step-by-step.md) — Advanced features including Repeat

**See examples:**
- [Visual Patterns: Do Together](../reference/visual-patterns.md#pattern-5-parallel-execution)
- [Example Workflows](../../examples/examples.md) — Real-world workflows
