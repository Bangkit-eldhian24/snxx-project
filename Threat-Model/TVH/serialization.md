---

# TVH/serialization.md — Threat Vector Hypothesis Serialization

---

## 1. Purpose

Serialization mendefinisikan bagaimana objek TVH direpresentasikan secara deterministik dalam format terstruktur.

Tujuan:

* Persistensi hasil reasoning
* Perbandingan lintas run
* Replay dan regression testing
* Integrasi dengan truth-profile
* Audit epistemic

Serialization bukan mekanisme evaluasi, hanya representasi.

---

## 2. Canonical Format

Format standar Stage-01: **JSON (canonical, deterministic)**

Syarat:

* UTF-8
* Key ordering stabil
* Tidak ada field null
* Tidak ada field opsional kosong
* Floating point fixed precision (4 decimal places recommended)

---

## 3. Canonical JSON Structure

```json
{
  "id": "string",
  "title": "string",
  "category": "enum",
  "target_layer": "enum",
  "preconditions": ["string"],
  "reasoning_basis": ["string"],
  "supporting_evidence": ["string"],
  "contradicting_evidence": ["string"],
  "confidence": 0.0000,
  "impact_scope": "enum",
  "feasibility": "enum",
  "state": "enum"
}
```

---

## 4. Deterministic Ordering Rule

Field order wajib:

1. id
2. title
3. category
4. target_layer
5. preconditions
6. reasoning_basis
7. supporting_evidence
8. contradicting_evidence
9. confidence
10. impact_scope
11. feasibility
12. state

Ini penting untuk:

* diffing antar run
* hash comparison
* CI regression

---

## 5. Numeric Precision

Confidence harus:

* Float
* Range (0,1)
* 4 decimal precision
* Rounded (not truncated)

Contoh valid:

```
0.6421
0.3500
```

Tidak valid:

```
.64
1.0
0
```

---

## 6. Evidence Reference Format

Evidence direferensikan dengan ID simbolik, bukan raw data.

Contoh:

```
"supporting_evidence": [
  "ev-header-server-cloudflare",
  "ev-tls-issuer-cloudflare-inc"
]
```

Raw observation disimpan di modul lain.

TVH hanya menyimpan referensi epistemic.

---

## 7. Vector Set Serialization

Output runtime bukan satu TVH, melainkan set.

```
ThreatVectorSet
```

Struktur:

```json
{
  "target": "string",
  "timestamp": "ISO-8601",
  "engine_version": "string",
  "vectors": [ TVH_OBJECTS ],
  "global_stability": 0.0000
}
```

---

## 8. Deterministic Hashing

Untuk regression testing:

```
vector_hash = SHA256(canonical_json)
```

Hash berubah hanya jika:

* confidence berubah
* state berubah
* evidence berubah
* structural field berubah

Bukan karena urutan key berubah.

---

## 9. Replay Compatibility

Serialization harus kompatibel dengan:

* replay harness
* truth-profile comparison
* stage-to-stage diff

Setiap TVH dapat dibandingkan:

```
previous.confidence vs current.confidence
previous.state vs current.state
```

---

## 10. State Transition Rules

Valid transitions:

```
emerging → stable
stable → weakening
weakening → invalidated
```

Tidak boleh:

```
invalidated → stable
```

Karena epistemic monotonicity dijaga di Stage-01.

---

## 11. Stage-01 Limitation

Belum mendukung:

* exploit chain grouping
* temporal graph serialization
* attacker persona annotation
* probabilistic branching trees

Akan diperluas pada Stage-02.

---

Serialization spec selesai.

Dengan ini:

* Konsep ✔
* Schema ✔
* Taxonomy ✔
* Confidence model ✔
* Serialization ✔

