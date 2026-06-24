# Banking System — OOD Problem

## Problem Statement

Design a banking system that supports multiple accounts and basic banking operations via a CLI.

---

## Commands

```
create_bank <bank_id>

create_account <bank_id> <account_id> <account_type> <initial_balance>
# account_type: savings | current

deposit <account_id> <amount>

withdraw <account_id> <amount>

transfer <from_account_id> <to_account_id> <amount>

balance <account_id>

statement <account_id>
# prints all transactions for the account

close_account <account_id>

exit
```

---

## Rules

### General
- An account cannot be created with a negative or zero initial balance.
- Withdrawals cannot exceed the available balance.
- A closed account cannot perform any operations.
- Every deposit, withdrawal, and transfer must be recorded as a transaction with a timestamp.

### Savings Account
- Minimum balance requirement of **500**.
- Balance cannot drop below 500 after any operation.

### Current Account
- No minimum balance requirement.
- Daily withdrawal limit of **50,000**.

### Transfers
- Transfers between accounts in the **same bank** are free.
- Transfers **across banks** charge a **2% fee** on the sender.

### Statement
- Prints all transactions in chronological order with running balance.

---

## What You're Expected to Model

- The right classes and their responsibilities
- Where rules and validations live
- How transactions are recorded
- Error handling strategy
- Clean separation between CLI, coordination, and domain

---

## Out of Scope

- Persistence — in-memory only
- Authentication
- Concurrency
