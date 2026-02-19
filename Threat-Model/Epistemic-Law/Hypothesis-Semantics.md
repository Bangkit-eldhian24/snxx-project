
Ini bagian paling berbahaya secara desain.
Di sinilah sistem bisa menjadi:

* **engine reasoning deterministik**
  atau
* **LLM halusinatif yang overconfident**

Kita akan buat ini seperti **calculus**, bukan heuristik bebas.

---

# Hypothesis Semantics Specification (HSS)

## Inference Calculus for Framework & Risk Modeling

---

## 1. Domain Boundary

Hypothesis Engine hanya boleh menerima input:

```
KnowledgeGraph
```

Bukan:

* Raw Signal
* Evidence
* Entropy langsung
* External CVE DB
* Prior model training

Jika dilanggar → epistemic breach.

---

## 2. Definisi Formal

```
Fact := stable knowledge unit
Hypothesis := logical construct derived from facts
Conclusion := hypothesis with sufficient support
```

Hierarki:

```
Facts → Hypothesis → Conclusion
```

---

## 3. Hypothesis Object Model

```
Hypothesis {
    id: UUID
    target: HypothesisTarget
    supporting_facts: FactID[]
    contradicting_facts: FactID[]
    rule_id: RuleID
    confidence: float
    status: HypothesisStatus
}
```

Tidak boleh field lain.

---

## 4. HypothesisTarget

Target bukan hanya framework.

```
enum HypothesisTarget {
    TECHNOLOGY
    FRAMEWORK
    RUNTIME
    SERVER
    LIBRARY
    SECURITY_CONTROL
    MISCONFIGURATION
}
```

Contoh:

* Django
* Express
* PHP
* nginx
* Missing CSP
* Directory listing enabled

---

## 5. Inference Rule Model

Hypothesis hanya boleh dibuat melalui Rule.

```
Rule {
    rule_id
    preconditions: FactPattern[]
    exclusions: FactPattern[]
    weight: float
}
```

Tidak ada improvisasi.

---

## 6. FactPattern

Pattern berbentuk:

```
(feature == value)
AND / OR
absence(feature)
AND
stability >= threshold
```

Tidak boleh fuzzy string.
Tidak boleh embedding similarity.

---

## 7. Rule Evaluation

Jika semua precondition terpenuhi:

```
support_score += rule.weight
```

Jika exclusion terpenuhi:

```
hypothesis.status = blocked
```

---

## 8. Confidence Calculation

Confidence bukan ML probability.

```
confidence =
    Σ(rule_weight × fact_confidence)
    − Σ(conflict_penalty)
```

Dibatasi:

```
0 ≤ confidence ≤ 1
```

---

## 9. Hypothesis Status

```
enum HypothesisStatus {
    CANDIDATE
    SUPPORTED
    CONTESTED
    BLOCKED
    CONFIRMED
    REJECTED
}
```

Threshold contoh:

| Confidence | Status    |
| ---------- | --------- |
| <0.3       | candidate |
| 0.3–0.6    | supported |
| 0.6–0.85   | contested |

> 0.85 + no conflict | confirmed |

---

## 10. Exclusive Hypothesis Sets

Jika KnowledgeGraph punya exclusive facts:

Engine harus membentuk:

```
ExclusiveHypothesisSet {
    members[]
    resolution_strategy
}
```

Strategi:

* Highest confidence wins
* Or remain contested

Tidak boleh memilih tanpa dasar.

---

## 11. Negative Inference

Absence bisa membentuk hypothesis.

Contoh:

```
absence(CSP)
AND stability high
→ hypothesis: missing_security_control
```

---

## 12. Multi-Layer Constraint

Hypothesis harus selaras dengan Layer Taxonomy (dokumen berikutnya).

Contoh:
Jika layer Application tidak menunjukkan PHP artifact,
maka hypothesis PHP runtime harus penalized.

---

## 13. No Shortcut Rule

Dilarang:

* Regex → framework
* Header match tunggal → version claim
* Entropy tinggi → langsung identifikasi

Semua harus melalui Rule.

---

## 14. Conclusion Formation

Conclusion hanya boleh terbentuk jika:

```
confidence > threshold
AND
no unresolved conflict
AND
environment_stability high
```

Conclusion bersifat:

```
assertion with traceable proof chain
```

---

## 15. Proof Traceability

Setiap conclusion wajib punya:

```
ProofChain {
    fact → rule → hypothesis → conclusion
}
```

Tanpa ini → tidak sah.

---

