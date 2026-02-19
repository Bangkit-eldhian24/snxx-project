---

# TVH/schema.md — Threat Vector Hypothesis Data Schema

---

## 1. Purpose

Schema ini mendefinisikan bentuk representasi internal TVH sebagai *knowledge object*.

TVH harus:

* serializable
* comparable
* traceable ke evidence
* revisable tanpa kehilangan histori inferensi

Schema ini tidak mengatur scoring algoritma, hanya struktur informasi.

---

## 2. Core Object

```
ThreatVectorHypothesis
```

Merepresentasikan satu kemungkinan jalur eksploitasi berbasis arsitektur.

---

## 3. High Level Structure

```
TVH
├── id
├── title
├── category
├── target_layer
├── preconditions
├── reasoning_basis
├── supporting_evidence
├── contradicting_evidence
├── confidence
├── impact_scope
├── feasibility
└── state
```

---

## 4. Field Definitions

### 4.1 Identity

```
id: string
```

Identifier unik stabil.
Tidak berubah walaupun confidence berubah.

```
title: string
```

Deskripsi singkat vector (human readable, non-narrative).

Contoh:

```
Direct Origin Access Bypassing CDN
Cache Key Confusion Possibility
Session Boundary Ambiguity
```

---

### 4.2 Classification

```
category: enum
```

Jenis vektor serangan konseptual.

Nilai awal Stage-1:

```
exposure
isolation_break
trust_boundary
state_confusion
routing_inconsistency
authentication_assumption
```

---

### 4.3 Target Layer

```
target_layer: enum
```

Layer tempat exploit terjadi:

```
edge
gateway
application
runtime
auth
cross_layer
```

---

### 4.4 Preconditions

```
preconditions: list<condition>
```

Kondisi arsitektur yang harus benar agar vektor mungkin.

Contoh:

```
origin reachable
shared cache exists
state derived from header
```

Precondition bukan evidence — ini logical requirement.

---

### 4.5 Reasoning Basis

```
reasoning_basis: list<hypothesis_reference>
```

Hipotesis SNXX yang melahirkan TVH.

TVH harus selalu dapat ditelusuri ke hypothesis.

---

### 4.6 Evidence

```
supporting_evidence: list<evidence_reference>
contradicting_evidence: list<evidence_reference>
```

Bukan raw signal — hanya evidence terverifikasi epistemic layer.

Evidence dapat menambah atau mengurangi confidence.

---

### 4.7 Confidence

```
confidence: float (0,1)
```

Keyakinan SNXX bahwa kondisi eksploitasi mungkin.

Bukan probabilitas vulnerability.
Ini probabilitas *model arsitektur benar*.

---

### 4.8 Impact Scope

```
impact_scope: enum
```

Perkiraan area dampak:

```
local
user_scope
tenant_scope
global
unknown
```

---

### 4.9 Feasibility

```
feasibility: enum
```

Kesulitan eksploitasi konseptual:

```
trivial
practical
complex
theoretical
```

Tidak berdasarkan payload — berdasarkan constraint arsitektur.

---

### 4.10 State

```
state: enum
```

Status epistemik TVH:

```
emerging
stable
weakening
invalidated
```

---

## 5. Knowledge Rules

1. TVH tidak boleh ada tanpa hypothesis
2. Evidence dapat mengubah confidence, bukan existence
3. TVH hanya invalid jika kontradiksi struktural muncul
4. TVH tidak dihapus — hanya invalidated

---

## 6. Non-Properties

TVH tidak memiliki:

* exploit payload
* request template
* CVE mapping
* vulnerability confirmation
* scanner result

---

## 7. Conceptual Example

```
id: tvh-origin-bypass
category: trust_boundary
target_layer: edge

preconditions:
  - reverse_proxy_present
  - origin_reachable

reasoning_basis:
  - infrastructure.cdn > 0.70
  - topology.direct_ip_possible

confidence: 0.64
impact_scope: global
feasibility: practical
state: stable
```

---

## 8. Stage-01 Limitation

Schema belum mendukung:

* temporal evolution
* multi-stage exploit chains
* attacker capability modeling
* environmental context

Akan diperluas pada stage berikutnya.

---

Dokumen schema selesai.
