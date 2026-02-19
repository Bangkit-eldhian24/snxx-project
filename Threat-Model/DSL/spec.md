---

# SNXX DSL — Specification

**File:** `DSL/spec.md`
**Stage:** 1 — Architecture Inference
**Status:** Normative Definition (Authoritative Semantics)

---

## 1. Tujuan DSL

SNXX DSL adalah bahasa deklaratif untuk merepresentasikan *epistemic inference* terhadap sistem target berbasis observasi terbatas.

DSL **tidak digunakan untuk:**

* eksploitasi
* payload
* scanning
* deteksi kerentanan

DSL hanya digunakan untuk:

> mengubah observasi → pengetahuan → model arsitektur

---

## 2. Model Epistemik

SNXX tidak bekerja pada kebenaran absolut.
SNXX bekerja pada **state pengetahuan**.

Semua kesimpulan berada dalam bentuk:

```
belief(hypothesis) ∈ (0,1)
```

Bukan:

```
true / false
```

Engine tidak pernah menghasilkan kepastian.

---

## 3. Unit Konseptual

DSL memiliki empat entitas inti.

| Entitas    | Fungsi                       | Ontologis  |
| ---------- | ---------------------------- | ---------- |
| SIGNAL     | Jenis observasi yang mungkin | vocabulary |
| FACT       | Kejadian observasi aktual    | evidence   |
| HYPOTHESIS | Model tentang sistem         | belief     |
| RULE       | Mekanisme inferensi          | reasoning  |

---

## 4. SIGNAL

SIGNAL mendefinisikan **apa yang boleh diamati**.

SIGNAL bukan data runtime.
SIGNAL adalah *kelas fenomena*.

Contoh konseptual:

```
header.server
cookie.session_id
tls.certificate_issuer
body.csrf_token
```

### Properti

* Closed vocabulary
* Tidak boleh dibuat saat runtime
* Tidak memiliki nilai
* Tidak menyimpulkan apa pun

SIGNAL adalah batas persepsi SNXX.

---

## 5. FACT

FACT adalah instansiasi SIGNAL saat runtime.

```
FACT = observation(SIGNAL, value | presence | absence)
```

Contoh:

```
header.server = "cloudflare"
cookie.session_id = absent
```

### Properti

* Tidak mengandung interpretasi
* Tidak boleh memodifikasi belief
* Hanya menyatakan kondisi epistemik

FACT adalah apa yang diketahui, bukan apa artinya.

---

## 6. HYPOTHESIS

HYPOTHESIS adalah model penjelasan tentang sistem.

```
HYPOTHESIS = explanatory model
```

Contoh:

```
framework.nextjs
auth.token_based
architecture.layered
```

### Properti

* Memiliki prior
* Memiliki confidence
* Tidak pernah pasti
* Tidak boleh dibuat oleh engine
* Hanya dapat diperbarui

---

## 7. RULE

RULE menghubungkan FACT ke HYPOTHESIS.

RULE bukan signature.
RULE adalah *argumen probabilistik*.

```
IF kondisi observasi konsisten
THEN belief diperbarui
```

RULE tidak boleh:

* menetapkan kebenaran
* membuat hipotesis baru
* menghapus fakta

RULE hanya mengubah tingkat kepercayaan.

---

## 8. Absence Semantics

Ketidakhadiran observasi adalah informasi.

```
absence(signal) ≠ null
absence(signal) = evidence
```

Makna:

> sistem memilih tidak memperlihatkan sesuatu

Likelihood absence selalu < presence certainty.

---

## 9. Conflict Model

Dua hipotesis dapat kompatibel, kompetitif, atau kontradiktif.

Engine tidak memilih satu.
Engine menjaga distribusi belief.

Jika konflik tinggi:

```
knowledge_state = contested
```

SNXX lebih memilih ketidakpastian daripada kesimpulan salah.

---

## 10. Bayesian Guardrails

Aturan wajib:

1. Posterior tidak boleh 1.0
2. Prior berbasis frekuensi dunia nyata
3. Evidence tidak menciptakan hipotesis
4. Absence tidak bernilai nol likelihood
5. Konflik menurunkan confidence

Jika dilanggar → sistem berubah menjadi classifier, bukan reasoning engine.

---

## 11. Layer Binding

SIGNAL berasal dari layer sistem.

```
edge
gateway
application
runtime
```

Inference lintas layer hanya sah melalui RULE.

---

## 12. Knowledge State

SNXX menghasilkan state pengetahuan, bukan hasil scan.

Output:

```
compatible_with
suggests
consistent_with
insufficient_evidence
```

Tidak pernah:

```
detected
confirmed
vulnerable
```

---

## 13. Saturation Principle

Jika observasi tidak cukup:

> model harus berhenti berkembang

Engine wajib dapat menyatakan:

```
model epistemically incomplete
```

---

## 14. Determinism Requirement

Makna DSL harus:

* tidak ambigu
* dapat diparse mesin
* tidak tergantung AI
* tidak berubah oleh narasi

LLM hanya menjelaskan hasil, bukan menentukan hasil.

---

## 15. Konsekuensi Arsitektural

DSL adalah sumber kebenaran SNXX.

Jika DSL berubah → interpretasi sistem berubah
Jika engine berubah → proyek mati

**Rule file boleh berkembang
Core evaluator tidak boleh ditulis ulang**

---

Selesai.

---
