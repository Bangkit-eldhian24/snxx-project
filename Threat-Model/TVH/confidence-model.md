---

# TVH/confidence-model.md — Confidence Evaluation Model

---

## 1. Purpose

Setiap Threat Vector Hypothesis (TVH) diberi skor keyakinan.

Skor merepresentasikan:

> epistemic confidence — bukan exploit probability

Artinya:

* bukan peluang sukses attack
* bukan severity
* bukan CVSS

Melainkan:

> seberapa kuat arsitektur target mengindikasikan kelas kelemahan tertentu

---

## 2. Core Principle

Confidence berasal dari tiga sumber:

```
confidence = belief × coherence × stability
```

| Komponen  | Makna                                |
| --------- | ------------------------------------ |
| belief    | dukungan evidence terhadap hipotesis |
| coherence | konsistensi antar layer              |
| stability | ketahanan terhadap observasi baru    |

Semua bernilai ∈ (0,1)

---

## 3. Belief Score

Belief diambil dari Epistemic-Stratum posterior.

```
belief = normalized hypothesis posterior
```

Interpretasi:

| Belief   | Arti        |
| -------- | ----------- |
| <0.25    | spekulatif  |
| 0.25–0.5 | indikatif   |
| 0.5–0.75 | kuat        |
| >0.75    | sangat kuat |

Belief tidak boleh 1.0 (guardrail epistemik).

---

## 4. Coherence Score

Mengukur apakah bukti lintas layer saling mendukung.

### Formula Konseptual

```
coherence = supporting_relations / total_relations
```

Relasi:

* edge → gateway
* gateway → app
* app → auth
* auth → state

Jika satu layer menyangkal layer lain → coherence turun drastis.

### Interpretasi

| Coherence | Arti                          |
| --------- | ----------------------------- |
| tinggi    | model arsitektur konsisten    |
| rendah    | kemungkinan deception / noise |

---

## 5. Stability Score

Menilai apakah hipotesis bertahan terhadap observasi tambahan.

### Konsep

```
stability = 1 − belief_variance_over_time
```

Jika belief sering berubah:

→ hipotesis rapuh

Jika stabil:

→ layak diuji manual

---

## 6. Final Confidence Score

```
TVH_confidence = belief × coherence × stability
```

---

## 7. Confidence Interpretation

| Score     | Meaning       | Action                     |
| --------- | ------------- | -------------------------- |
| <0.15     | noise         | abaikan                    |
| 0.15–0.35 | weak lead     | low priority testing       |
| 0.35–0.6  | viable        | manual probing             |
| 0.6–0.8   | strong        | focused testing            |
| >0.8      | critical lead | primary investigation path |

---

## 8. Relation to AHS

AHS tidak menentukan confidence
AHS hanya menentukan **risk budget allocation**

```
priority = confidence × impact × feasibility × risk_budget
```

TVH = reasoning
AHS = operational decision

---

## 9. Guardrails

Confidence tidak boleh:

* naik dari satu evidence tunggal
* naik tanpa coherence
* stabil tanpa observasi berulang

Jika terjadi → epistemic violation.

---

## 10. Stage-01 Limitation

Belum mempertimbangkan:

* attacker skill model
* exploit complexity
* chained exploitation
* time-based behavior

Stage-01 hanya untuk investigasi awal.

---

Dokumen confidence model selesai.
