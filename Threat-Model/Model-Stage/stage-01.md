# Model-Stage/stage-01.md

# STAGE-01 — Architecture Construction Contract

---

## 1. Identity

Stage-01 adalah **Perception & Deterministic Architecture Construction Layer**.

Tujuan utamanya:

> Mengubah observasi terbatas menjadi Attack Surface Graph (ASG) yang valid secara struktural dan epistemik.

Stage-01 bukan vulnerability scanner.
Stage-01 bukan attack planner.
Stage-01 tidak menghasilkan exploit hypothesis.

Stage-01 hanya menghasilkan struktur.

---

## 2. Primary Output

Stage-01 dianggap berhasil hanya jika menghasilkan:

```
Valid ASG instance
```

ASG harus memenuhi seluruh kontrak pada dokumen ASG.

Jika ASG tidak valid → Stage-01 gagal.

---

## 3. Processing Model

Stage-01 pipeline:

```
Observation
→ Evidence Normalization
→ Semantic Classification
→ Node Construction
→ Edge Construction
→ Trust Zone Assignment
→ State Transition Registration
→ ASG Validation
```

Tidak ada langkah eksploitasi.
Tidak ada langkah vulnerability inference.

---

## 4. Determinism Requirement

Untuk input observasi identik:

```
Input A → ASG-X
Input A → ASG-X
```

Graph isomorphism harus identik.

Tidak boleh:

```
Input A → ASG-X
Input A → ASG-Y
```

Jika terjadi → desain inference rusak.

---

## 5. Mandatory Construction Guarantees

Stage-01 wajib menjamin:

### 5.1 Node Integrity

* Semua node memiliki class valid
* Semua node memiliki trust zone
* Semua node memiliki evidence reference
* Tidak ada orphan node

### 5.2 Edge Integrity

* Semua edge memiliki semantic type valid
* Direction eksplisit
* Source & target valid
* Tidak ada implicit edge

### 5.3 Trust Boundary Validity

Boundary crossing dapat dihitung sebagai:

```
B(source) ≠ B(target)
```

Jika tidak bisa dihitung → ASG invalid.

### 5.4 State Transition Presence

Jika sistem menunjukkan perubahan privilege atau authentication behavior,

maka rule τ harus terdaftar.

Jika stateful system terdeteksi tetapi tidak ada τ → invalid ASG.

---

## 6. Epistemic Constraints

Stage-01 tidak boleh:

* Menghasilkan vulnerability claim
* Menghasilkan attack path
* Menghasilkan payload
* Menghasilkan CVE mapping
* Menghasilkan exploit feasibility

Semua inference harus berhenti pada struktur.

---

## 7. Evidence Discipline

Setiap elemen ASG harus dapat ditelusuri:

```
Node → observation reference
Edge → observation reference or logical derivation rule
```

Graph tanpa traceability = hallucinated topology.

Hallucinated topology = reject.

---

## 8. Insufficient Evidence Handling

Jika observasi tidak cukup untuk membentuk minimal ASG valid:

Engine wajib menyatakan:

> insufficient evidence to construct ASG

Partial graph boleh dihasilkan, tetapi harus ditandai sebagai incomplete.

Tidak boleh mengisi celah dengan asumsi liar.

---

## 9. Acceptance Criteria

Stage-01 selesai jika:

### 9.1 ASG Compiles

* Semua invariants terpenuhi
* Tidak ada structural violation

### 9.2 Localhost Oracle Pass

Untuk sistem dengan ground truth diketahui:

* Topology utama termodelkan
* Trust boundary benar
* Tidak ada fabricated component

### 9.3 Noise Resilience

Jika sebagian evidence dihapus:

* Node berkurang
* Edge berkurang
* Graph tetap valid
* Tidak muncul node baru tanpa evidence

### 9.4 Conflict Handling

Jika evidence kontradiktif:

* Conflict tercatat
* ASG tidak memaksa konsistensi palsu
* Jika perlu → mark unstable

---

## 10. Output Specification

Stage-01 output wajib berupa:

```
ASG
ValidationReport
KnowledgeStateSummary
```

TVH bukan output Stage-01.
TVH adalah consumer ASG.

---

## 11. Completion Lock

Stage-01 dianggap locked ketika:

* Determinism terverifikasi
* ASG invariants stabil
* Tidak ada vulnerability leakage
* Oracle test lulus

Setelah lock:

Perubahan pada konstruksi node/edge memerlukan justifikasi formal.

Rewrite tanpa justifikasi epistemik = reset Stage-01.

---

END OF STAGE-01 CONTRACT
