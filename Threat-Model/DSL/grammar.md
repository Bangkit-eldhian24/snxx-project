---

# SNXX DSL — Grammar Definition (Revised Authoritative)

**Stage:** 1
**Grammar Style:** EBNF
**Scope:** Structural probabilistic inference language
------------------------------------------------------

## 1. Design Constraints

DSL bersifat:

* Deterministic
* Declarative
* Non‑Turing complete
* Side‑effect free
* Closed‑world

Tidak mendukung:

* loops
* function calls
* dynamic declarations
* arithmetic expressions
* runtime symbol creation

---

## 2. Lexical Tokens

```
letter ::= "A"…"Z" | "a"…"z"
digit  ::= "0"…"9"

IDENTIFIER ::= letter { letter | digit | "_" | "." }
STRING     ::= '"' { any_char_except_quote } '"'
FLOAT      ::= digit { digit } "." digit { digit }
WS         ::= space | tab | newline

comment ::= "#" { any_char } newline
```

---

## 3. Top‑Level Structure

```
program ::= { comment | declaration | rule }

declaration ::= signal_decl
              | hypothesis_decl
              | prior_decl
```

---

## 4. Signal Declaration

```
signal_decl ::= "signal" IDENTIFIER ":" layer ";"

layer ::= "edge"
        | "gateway"
        | "application"
        | "runtime"
        | "auth"
```

---

## 5. Hypothesis Declaration

```
hypothesis_decl ::=
    "hypothesis" IDENTIFIER "{"
        "layer:" layer ";"
        "prior:" FLOAT ";"
    "}"
```

### Constraints

* prior ∈ (0,1)
* prior ≠ 0
* prior ≠ 1

---

## 6. Optional Prior Update

```
prior_decl ::= "update_prior" IDENTIFIER "to" FLOAT ";"
```

Static tuning only.

---

## 7. Rule Definition

```
rule ::=
    "rule" IDENTIFIER "{"
        "when" condition_list ";"
        "then" action_list ";"
    "}"
```

---

## 8. Conditions

```
condition_list ::= disjunction

disjunction ::= conjunction { "or" conjunction }

conjunction ::= condition { "and" condition }

condition ::=
      presence_condition
    | absence_condition
    | value_condition
    | belief_condition
    | grouped_condition
```

### 8.1 Grouping

```
grouped_condition ::= "(" condition_list ")"
```

### 8.2 Presence

```
presence_condition ::= "present" "(" IDENTIFIER ")"
```

### 8.3 Absence

```
absence_condition ::= "absent" "(" IDENTIFIER ")"
```

### 8.4 Value Condition

```
value_condition ::= IDENTIFIER "contains" STRING
```

### 8.5 Belief Condition

```
belief_condition ::= IDENTIFIER belief_comparator FLOAT

belief_comparator ::= ">" | "<" | ">=" | "<="
```

Constraint: IDENTIFIER harus resolve ke hypothesis symbol table.

---

## 9. Actions

```
action_list ::= action { action }

action ::= increase_action
         | decrease_action
```

### 9.1 Increase

```
increase_action ::= "increase" IDENTIFIER "by" FLOAT
```

### 9.2 Decrease

```
decrease_action ::= "decrease" IDENTIFIER "by" FLOAT
```

### Constraints

* IDENTIFIER harus hypothesis
* FLOAT ∈ (0,1)
* Evaluator wajib memastikan posterior < 1

---

## 10. Closed World Rule

Parser harus menolak jika:

* signal tidak dideklarasikan
* hypothesis tidak dideklarasikan
* layer tidak valid
* action target bukan hypothesis

---

## 11. Evaluation Contract (Non‑Syntactic)

1. Semua rule dievaluasi satu kali per cycle.
2. Order rule tidak mempengaruhi hasil akhir.
3. Belief update cumulative dan capped.
4. Tidak ada rule yang boleh membuat atau menghapus hypothesis.
5. Evaluator tidak boleh mengubah struktur DSL.
6. Semua identifier resolve melalui symbol table statis.

---

## 12. Stage‑01 Limitation

Tidak mendukung:

* temporal operators
* graph traversal
* cross‑session memory
* arithmetic combination of beliefs
* vulnerability semantics

Stage‑01 hanya untuk architectural inference.
