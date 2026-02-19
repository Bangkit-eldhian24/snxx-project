---

# TVH/vector-taxonomy.md — Threat Vector Taxonomy

---

## 1. Purpose

Taxonomy mendefinisikan tipe *Threat Vector Hypothesis (TVH)* yang boleh dihasilkan sistem.

Tujuan:

* membatasi ruang interpretasi
* menjaga konsistensi reasoning
* memisahkan “bug” dari “attack possibility”
* memungkinkan ranking lintas target

TVH merepresentasikan:

> Architectural weakness class — not exploit instance

---

## 2. Classification Principles

Satu TVH harus memenuhi:

1. Berasal dari model arsitektur
2. Tidak menyebut payload spesifik
3. Tidak mengasumsikan vulnerability konkret
4. Dapat diverifikasi manual
5. Layer-aware

---

## 3. Top Level Categories

```
exposure
trust_boundary
isolation_break
state_confusion
routing_inconsistency
assumption_failure
control_desync
```

---

## 4. Category Definitions

---

### 4.1 Exposure

**Makna:** Resource internal dapat diakses tanpa jalur yang diharapkan.

Fokus: visibility leakage

Contoh konsep:

* origin langsung dapat diakses
* admin surface tidak terlindungi edge
* debug endpoint reachable publik

Bukan bug — ini *posisi sistem*.

Biasanya berasal dari:

```
edge → origin mismatch
proxy bypassability
misplaced security control
```

---

### 4.2 Trust Boundary

**Makna:** Sistem mempercayai data dari zona yang salah.

Fokus: misplaced trust

Contoh konsep:

* header dipercaya sebagai identitas
* IP dianggap autentik
* role diambil dari client context

Ini kelas penting karena banyak exploit modern muncul dari sini.

---

### 4.3 Isolation Break

**Makna:** Pemisahan logical context tidak benar-benar terisolasi.

Fokus: boundary collapse

Contoh:

* antar user context tercampur
* cache berbagi state
* tenant tidak benar-benar terpisah

Tidak selalu vulnerability — tapi indikasi risiko tinggi.

---

### 4.4 State Confusion

**Makna:** Server dan client memiliki persepsi state berbeda.

Fokus: state machine ambiguity

Contoh:

* login state ambigu
* session optional tapi privilege tetap ada
* csrf expectation tidak konsisten

Banyak auth bug berasal dari kategori ini.

---

### 4.5 Routing Inconsistency

**Makna:** Permintaan mencapai komponen berbeda dari asumsi desain.

Fokus: path ambiguity

Contoh:

* path diproses edge berbeda dengan origin
* method normalization berbeda
* encoding diinterpretasi beda

Ini sering menjadi dasar bypass.

---

### 4.6 Assumption Failure

**Makna:** Sistem beroperasi atas asumsi yang tidak selalu benar.

Fokus: invariant violation

Contoh:

* request dianggap selalu melalui gateway
* header tertentu selalu ada
* resource dianggap private

Ketika asumsi salah → kontrol keamanan runtuh.

---

### 4.7 Control Desynchronization

**Makna:** Dua mekanisme kontrol tidak sepakat terhadap keputusan akses.

Fokus: policy disagreement

Contoh:

* edge allow — origin deny
* cache allow — app deny
* auth layer vs business logic mismatch

Kategori ini sangat sering menghasilkan exploit serius.

---

## 5. Cross-Layer Mapping

| Category              | Biasanya Terjadi Antara Layer |
| --------------------- | ----------------------------- |
| exposure              | edge ↔ origin                 |
| trust_boundary        | client ↔ app                  |
| isolation_break       | app ↔ data                    |
| state_confusion       | client ↔ auth                 |
| routing_inconsistency | edge ↔ gateway                |
| assumption_failure    | design ↔ runtime              |
| control_desync        | multi control points          |

---

## 6. Non-Goals

Taxonomy tidak mencakup:

* SQLi
* XSS
* RCE
* CVE class
* payload technique

Itu domain exploitation, bukan modeling.

---

## 7. Stage-01 Scope

Stage-01 hanya menghasilkan **single-vector hypotheses**
Belum mendukung:

* chained vectors
* attacker capability tiers
* probabilistic attacker strategy

Akan muncul di stage berikutnya.

---

Dokumen taxonomy selesai.
