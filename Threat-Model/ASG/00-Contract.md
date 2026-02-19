---

# Revisi `00-Contract.md` (ASG)

Berikut versi stabil — fokus: definisi formal, bukan implementasi.

---

## Attack Surface Graph — Contract

ASG (Attack Surface Graph) adalah representasi formal dari attackable system topology.

ASG bukan:

* vulnerability database
* scan result dump
* tool specific output

ASG adalah **structural model dari reachable security semantics**.

Stage-01 **HARUS menghasilkan graph yang valid terhadap kontrak ini.**

---

## 1. Graph Definition

ASG didefinisikan sebagai directed labeled multigraph:

```
ASG = (N, E, B, Σ, τ)
```

| Symbol | Meaning                        |
| ------ | ------------------------------ |
| N      | set of nodes (system entities) |
| E      | set of edges (interactions)    |
| B      | trust boundaries               |
| Σ      | semantic attributes            |
| τ      | state transitions              |

---

## 2. Node Types

Node merepresentasikan entitas yang memiliki attack surface.

Node tidak boleh berupa data mentah (string, HTML, response dump).

Node adalah **semantic object**.

### Required Node Classes

| Type      | Meaning                                   |
| --------- | ----------------------------------------- |
| Asset     | Logical system unit                       |
| Interface | Entry/exit interaction point              |
| Actor     | External interacting entity               |
| DataStore | Persistent storage                        |
| Control   | Auth / validation / enforcement mechanism |
| Execution | Code execution context                    |

### Node Invariant

Setiap node HARUS memiliki:

```
node.id        → stable identifier
node.class     → one of allowed types
node.trust     → trust zone
node.exposure  → internal | partner | public
node.origin    → evidence reference
```

---

## 3. Edge Types

Edge merepresentasikan kemungkinan interaksi — bukan hanya observed traffic.

Edge adalah **possible interaction channel**.

| Edge          | Meaning                       |
| ------------- | ----------------------------- |
| communicates  | message exchange              |
| reads         | data retrieval                |
| writes        | data modification             |
| executes      | code execution                |
| authenticates | identity assertion            |
| trusts        | implicit privilege acceptance |

### Edge Invariant

```
edge.source ∈ N
edge.target ∈ N
edge.type ∈ AllowedTypes
edge.direction is mandatory
edge.evidence optional but traceable
```

---

## 4. Trust Boundary Representation

Trust boundary bukan node dan bukan edge.

Boundary adalah *partition function*:

```
B: N → TrustZone
```

TrustZone minimum set:

```
{ Public, External, Internal, Privileged }
```

Boundary crossing terjadi jika:

```
B(source) ≠ B(target)
```

Boundary crossing adalah kandidat attack vector origin.

---

## 5. State Transition Model

ASG harus dapat menggambarkan perubahan privilege.

State tidak disimpan pada edge — tetapi sebagai rule:

```
τ : (Actor, Path) → NewPrivilegeState
```

Contoh:

```
Unauthenticated → Authenticated
User → Admin
Sandbox → System
```

Jika graph tidak mampu merepresentasikan transisi → graph invalid.

---

## 6. Evidence Constraint

Setiap elemen graph harus dapat ditelusuri ke observasi Stage-01.

```
evidence := observation reference
```

Graph tanpa traceability = hallucinated topology = invalid ASG

---

## 7. Valid ASG Criteria

ASG dianggap valid jika:

1. Semua node memiliki trust zone
2. Semua edge memiliki semantic meaning
3. Boundary crossings dapat dihitung
4. Minimal satu entrypoint actor → interface path ada
5. Semua entity memiliki origin evidence

Jika salah satu gagal → Stage-01 output rejected

---

## 8. Role in Pipeline

```
Stage-01 → produces ASG
TVH → consumes ASG
AHS → ranks TVH output
Narrative → human interpretation
```

ASG adalah satu-satunya sumber kebenaran struktural.

Tidak ada komponen lain boleh menginfer topology ulang.

---

