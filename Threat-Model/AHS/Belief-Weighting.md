1. Purpose
Belief-Weighting mendefinisikan bagaimana AHS mengubah tingkat kepercayaan terhadap hipotesis arsitektur berdasarkan perilaku sistem target.
Bukan deteksi framework.
Bukan klasifikasi signature.
Ini adalah probabilistic credibility adjustment terhadap hipotesis yang sudah ada di Knowledge-State.
AHS tidak menambah hipotesis.
AHS hanya menggeser distribusi keyakinan.

2. Representation
Setiap hipotesis dalam Knowledge-State memiliki nilai:
Hypothesis H_i
belief ∈ [0,1]
confidence ∈ [0,1]
stability ∈ [0,1]
Makna:
| Variable   | Arti                         |
| ---------- | ---------------------------- |
| belief     | probabilitas hipotesis benar |
| confidence | kekuatan bukti kumulatif     |
| stability  | konsistensi antar observasi  |
Σ belief(H_i) = 1
AHS wajib mempertahankan distribusi probabilitas.

3. Evidence Model
AHS tidak memakai label semantik.
AHS hanya menerima evidence vector:
E = {
 anomaly_score
 state_volatility
 reflection_strength
 timing_irregularity
 header_instability
 route_mutability
}
Nilai range:
0.0 → baseline normal
1.0 → sangat abnormal

4. Weight Update Function
Bobot diperbarui menggunakan pembaruan Bayesian tereduksi (bounded update).

4.1 Raw Update
posterior(H) ∝ prior(H) × likelihood(E | H)
Namun likelihood tidak eksplisit → diproksikan melalui compatibility score.

4.2 Compatibility Score
## Compatibility Score (Formal Definition)

### Expected Behavior Representation
Each hypothesis H has a behavior signature:
expected_behavior(H) = {
    header_pattern: [feature_1, feature_2, ...],
    timing_profile: (mean, variance),
    state_model: enum[stateful, stateless, hybrid],
    error_format: pattern
}

### Observed Behavior Representation
observed_behavior(E) = {
    header_pattern: extracted from SignalBundle,
    timing_profile: from timing_profile field,
    state_model: derived from state_transition,
    error_format: from response_class
}

### Distance Metric (Weighted Hamming)
distance(H, E) = Σ w_i * mismatch(feature_i)

Where:
- header_pattern mismatch: Jaccard distance
- timing_profile mismatch: normalized absolute difference
- state_model mismatch: binary (0 or 1)
- error_format mismatch: string similarity (Levenshtein)

Weights:
w_header = 0.35
w_timing = 0.20
w_state = 0.30
w_error = 0.15

### Example Calculation
Hypothesis: Django
Expected: {header: [csrftoken, sessionid], timing: (150ms, 30ms), state: stateful}
Observed: {header: [csrftoken], timing: (145ms, 25ms), state: stateful}

distance_header = 1 - |{csrftoken}| / |{csrftoken, sessionid}| = 0.5
distance_timing = |150 - 145| / 150 = 0.033
distance_state = 0 (match)
distance_error = (not calculated yet)

distance_total = 0.35*0.5 + 0.20*0.033 + 0.30*0 = 0.18
compatibility = 1 - 0.18 = 0.82

4.3 Practical Update Formula
Δbelief(H) = α * (compatibility - 0.5) * evidence_strength
Dimana:
α = learning rate stage-1 (default 0.18)
evidence_strength = mean(E)

4.4 Normalization
Setelah update:
belief(H_i) = belief(H_i) / Σ belief(all)
Distribusi wajib kembali valid.

5. Stability Control
Untuk mencegah oscillation:
stability(H) = 1 - variance(belief_history(H))
Jika stability rendah:
α := α × 0.4
Artinya sistem mengurangi sensitivitas — target dianggap noisy / deceptive.

6. Confidence Update
Confidence tidak naik dari satu observasi.
confidence(H) += evidence_strength × stability × 0.25
confidence(H) capped at 1.0

7. Anti-Hallucination Guard
AHS dilarang menaikkan belief jika:
evidence_strength < 0.15
AND anomaly_score rendah
Artinya:
tidak ada bukti → tidak boleh ada peningkatan keyakinan

8. Suspicion Injection
Jika perilaku sistem sangat abnormal:
if anomaly_score > 0.8 AND stability rendah:
    reduce all belief by 20%
    redistribute to "unknown architecture"
Tujuan:
menghindari false architectural certainty.

9. Stage-01 Constraints
Selama Stage-1:
max belief(H_single) ≤ 0.82
Kenapa:
pentester tidak boleh over-confident sebelum surface mapping.
Dampak Sistem
Dengan aturan ini:
SNXX tidak akan "menebak framework"
hanya meningkatkan atau menurunkan kredibilitas model
noise → memperlambat keyakinan
konsistensi → memperkuat keyakinan
deception → memaksa agnostik state
Ini menjadikan output stabil untuk briefing pentester.
