---

# TVH/00-Concept.md — Threat Vector Hypothesis (Concept Definition)

---

## 1. Definition

**Threat Vector Hypothesis (TVH)** adalah representasi formal dari *kemungkinan kondisi eksploitasi* yang diturunkan dari struktur sistem.

TVH tidak menyatakan bahwa kerentanan ada.
TVH menyatakan bahwa **arsitektur memungkinkan eksploitasi terjadi apabila kondisi tertentu terpenuhi**.

> TVH adalah model keyakinan attacker terhadap exploitability sistem.

---

## 2. Position in SNXX Cognition

Alur inferensi:

```
Observation → Topology → Epistemic → Reasoning → Security Semantics → TVH
```

TVH merupakan hasil akhir dari reasoning keamanan:

| Layer              | Output                            |
| ------------------ | --------------------------------- |
| Security Semantics | attack surface interpretation     |
| TVH                | exploitable conditions hypothesis |

TVH bukan bagian dari reasoning proses.
TVH adalah *state pengetahuan setelah reasoning selesai*.

---

## 3. Philosophical Model

SNXX tidak mencari vulnerability.
SNXX membangun model kemungkinan eksploitasi.

Perbedaan ontologis:

| Konsep                   | Makna                       |
| ------------------------ | --------------------------- |
| Vulnerability            | bug konkret                 |
| Weakness                 | kelemahan desain            |
| Attack Surface           | area interaksi              |
| Threat Vector Hypothesis | jalur eksploitasi potensial |

TVH menyatakan:

> Jika sistem berperilaku konsisten dengan model arsitekturnya, maka eksploitasi X mungkin dilakukan.

---

## 4. Properties

TVH memiliki sifat berikut:

### Conditional

Bergantung pada struktur sistem, bukan hasil scanning.

```
CDN origin exposure mungkin terjadi
jika origin dapat diakses langsung
```

### Non-Binary

TVH tidak benar atau salah.

TVH memiliki tingkat keyakinan.

```
possible
likely
strong
```

### Architecture-Derived

TVH muncul dari relasi antar komponen, bukan signature.

### Non-Exploitative

TVH tidak memerlukan payload, brute force, atau exploit attempt.

---

## 5. Relationship to Pentesting

TVH bukan hasil pentest.
TVH adalah *panduan berpikir pentester*.

| Tahap     | Peran             |
| --------- | ----------------- |
| Recon     | menghasilkan data |
| SNXX      | membangun TVH     |
| Pentester | memverifikasi TVH |

Pentesting mengkonfirmasi atau menolak TVH.

---

## 6. Difference from Vulnerability Detection

| Scanner              | TVH                       |
| -------------------- | ------------------------- |
| mencari bug          | memodelkan exploitability |
| payload driven       | reasoning driven          |
| menghasilkan finding | menghasilkan hypothesis   |
| confirmation         | investigation target      |

TVH dapat benar walaupun tidak ada vulnerability,
karena TVH adalah properti arsitektur, bukan implementasi.

---

## 7. TVH as Knowledge Object

TVH diperlakukan sebagai objek pengetahuan:

* dapat didukung evidence
* dapat dilemahkan evidence
* dapat dibatalkan evidence

Namun tidak pernah "dieksekusi".

SNXX tidak menyerang sistem.
SNXX memahami sistem.

---

## 8. Output Role

TVH menjadi dasar untuk:

* strategi pengujian manual
* prioritas investigasi
* narasi keamanan

Tetapi TVH sendiri bukan rekomendasi testing.

TVH hanya menjawab:

> Apa yang mungkin dilakukan attacker terhadap sistem ini?

---

## 9. Non-Goals

TVH tidak:

* mendeteksi CVE
* melakukan exploitasi
* menghasilkan payload
* memastikan vulnerability
* memberi remediation

---

## 10. Summary

Threat Vector Hypothesis adalah model formal kemungkinan eksploitasi berbasis arsitektur.

SNXX tidak mengatakan:

> "Sistem rentan"

SNXX mengatakan:

> "Sistem dapat diserang dengan cara berikut jika asumsi arsitektur benar"

---
