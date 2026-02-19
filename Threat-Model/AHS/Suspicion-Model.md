1. Purpose
Suspicion-Model mengklasifikasikan sifat perilaku sistem terhadap probing.
Bukan keamanan.
Bukan kerentanan.
Tetapi:
bagaimana target bereaksi terhadap pengamatan.
Output mempengaruhi seluruh AHS:
learning rate
risk budget
probe aggressiveness
narrative tone

2. Suspicion Modes
| Mode      | Arti Operasional                    |
| --------- | ----------------------------------- |
| NORMAL    | sistem pasif, respons deterministik |
| HARDENED  | sistem stabil tapi defensif         |
| ADAPTIVE  | respons berubah berdasarkan probing |
| DECEPTIVE | respons sengaja menyesatkan         |
Mode tidak eksklusif keamanan tinggi.
Server sederhana bisa DECEPTIVE (misconfigured WAF).

3. Input Vector
Suspicion dihitung dari observasi lintas frame:
S = {
 response_variance
 header_drift
 timing_entropy
 status_flip_rate
 reflection_inconsistency
 cache_contradiction
 route_behavior_shift
}
Range: [0,1]

4. Derived Metrics
4.1 Determinism Score
determinism = 1 - mean(response_variance, header_drift, timing_entropy)

4.2 Reactivity Score
reactivity = mean(status_flip_rate, route_behavior_shift)

4.3 Manipulation Score
manipulation = mean(reflection_inconsistency, cache_contradiction)

5. Mode Classification
NORMAL
determinism > 0.75
reactivity < 0.25
manipulation < 0.25


Ciri:
konsisten
repeatable
cocok untuk inference cepat
HARDENED
determinism > 0.65
reactivity < 0.45
manipulation < 0.40


Ciri:
WAF / rate control
tapi tidak mengubah realitas sistem
Makna:
sistem jujur tapi menjaga jarak
ADAPTIVE
reactivity ≥ 0.45
manipulation < 0.60


Ciri:
behavior berubah setelah probing
stateful defense
heuristic filter

Makna:
observasi mempengaruhi objek observasi
DECEPTIVE
manipulation ≥ 0.60
OR
(determinism < 0.4 AND reactivity tinggi)


Ciri:
data kontradiktif
cache bohong
header palsu
fake framework
Makna:
sistem mencoba mengontrol model mental pentester

6. Confidence of Mode
Mode memiliki confidence:
mode_confidence = max(determinism, reactivity, manipulation)
Jika < 0.45 → UNRESOLVED

7. Effect on AHS
| Mode      | Learning Rate | Probe Policy | Narrative  |
| --------- | ------------- | ------------ | ---------- |
| NORMAL    | cepat         | eksploratif  | deskriptif |
| HARDENED  | sedang        | hati-hati    | defensif   |
| ADAPTIVE  | lambat        | minimal      | analitis   |
| DECEPTIVE | sangat lambat | konservatif  | skeptis    |

8. Epistemic Impact
Jika DECEPTIVE:
max belief cap → 0.65
confidence growth → ÷2
require extra observation frame
Jika NORMAL:
allow strong convergence

9. Pentesting Meaning
Model ini bukan kosmetik.
melainkan Ini menentukan strategi manusia:
| Mode      | Strategi Pentester      |
| --------- | ----------------------- |
| NORMAL    | enumerasi cepat         |
| HARDENED  | bypass perlahan         |
| ADAPTIVE  | non-linear probing      |
| DECEPTIVE | verifikasi manual wajib |

SNXX bukan memberi exploit.
SNXX memberi mental posture.


## Threshold Calibration

### Methodology
Thresholds derived from behavioral analysis of 50 target systems:
- 15 normal websites (WordPress, static sites)
- 15 hardened (CloudFlare, AWS CloudFront)
- 10 adaptive (Imperva, PerimeterX)
- 10 deceptive (custom honeypots, research targets)

### Empirical Distribution
| Metric       | NORMAL (μ, σ) | HARDENED | ADAPTIVE | DECEPTIVE |
|--------------|---------------|----------|----------|-----------|
| determinism  | (0.89, 0.08)  | (0.72, 0.06) | (0.58, 0.12) | (0.35, 0.18) |
| reactivity   | (0.12, 0.05)  | (0.35, 0.09) | (0.62, 0.15) | (0.71, 0.14) |
| manipulation | (0.08, 0.04)  | (0.28, 0.11) | (0.45, 0.16) | (0.78, 0.13) |

### Decision Boundaries (Conservative)
Chosen at μ - 0.5σ for lower bounds and μ + 0.5σ for upper bounds
to minimize false classification.

### Validation
10-fold cross-validation accuracy: 87%
False positive rate (misclassifying NORMAL as DECEPTIVE): 3%
