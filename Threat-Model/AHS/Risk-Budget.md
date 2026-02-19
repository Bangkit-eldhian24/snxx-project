1. Purpose
Risk-Budget membatasi total interaksi yang dapat dilakukan selama Stage-1.
Tujuan:
mencegah eskalasi agresif
mencegah adaptive detection
menjaga Stage-1 tetap reconnaissance-grade
mempertahankan epistemic purity
Risk bukan soal legal.
Risk adalah:
probabilitas bahwa observasi mempengaruhi sistem.

2. Risk Model
Setiap probe menghasilkan risk cost.
risk_cost ∈ [0,1]
Stage-1 memiliki:
risk_budget_initial = 1.0
Setiap probe:
risk_budget_remaining -= risk_cost
Jika:
risk_budget_remaining ≤ 0
→ probing berhenti.

3. Risk Cost Calculation
Risk dihitung dari 4 faktor:
R = w1*entropy
  + w2*state_change_probability
  + w3*detectability
  + w4*reactivity
Default weight:
w1 = 0.25
w2 = 0.30
w3 = 0.25
w4 = 0.20

3.1 Entropy
Seberapa jauh request berbeda dari baseline browsing.
Contoh:
header variant kecil → 0.1
method flip → 0.3
path structure change → 0.4

3.2 State Change Probability
Apakah request bisa memicu perubahan state backend.
Contoh:
GET static → 0.05
GET API → 0.20
POST form → dilarang Stage-1

3.3 Detectability
Apakah request terlihat tidak natural.
Dipengaruhi oleh:
cadence deviation
header abnormality
repetition pattern

3.4 Reactivity
Diambil dari Suspicion-Model.
Jika mode = ADAPTIVE:
reactivity factor × 1.5
Jika mode = DECEPTIVE:
reactivity factor × 2.0

4. Budget Regeneration
Stage-1 tidak boleh regeneratif.
Tidak ada refill otomatis.
Karena:
Observasi tetap tercatat di target.

5. Dynamic Adjustment
Jika mode berubah:
NORMAL
risk_budget_max = 1.0
HARDENED
risk_budget_max = 0.8
ADAPTIVE
risk_budget_max = 0.6
DECEPTIVE
risk_budget_max = 0.4
Ini artinya sistem boleh berhenti lebih cepat.
## Dynamic Budget Adjustment Protocol

### Mode Transition Handling
When suspicion mode changes from M1 to M2:

1. Calculate new max:
   risk_budget_max_new = budget_limit(M2)

2. If risk_budget_remaining > risk_budget_max_new:
   risk_budget_remaining = risk_budget_max_new
   emit_warning("Budget capped due to mode change")

3. If risk_budget_remaining ≤ risk_budget_max_new:
   No change (already within limit)

### State Transition Example
Initial: NORMAL mode
- risk_budget_max = 1.0
- risk_budget_remaining = 0.7 (after some probes)

Mode changes to ADAPTIVE:
- risk_budget_max = 0.6
- risk_budget_remaining = 0.6 (capped from 0.7)
- Effective remaining probes reduced

Mode changes to DECEPTIVE:
- risk_budget_max = 0.4
- risk_budget_remaining = 0.4 (capped from 0.6)
- Highly restricted

### Irreversible Property
Budget reduction due to mode change is IRREVERSIBLE.
Even if mode returns to NORMAL later, budget does not increase.

Rationale:
- Observational impact is cumulative
- Target has already reacted to probes

6. Hard Stop Conditions
Stage-1 langsung berhenti jika:
risk_budget_remaining < 0.15
suspicion mode berubah dua kali berturut-turut
belief instability meningkat

7. Epistemic Constraint
Risk-Budget tidak boleh dipakai untuk:
mengoptimalkan attack
mengatur brute force
menghitung exploit attempts
Risk-Budget hanya untuk inference boundary.

8. Pentester Interpretation
Dalam praktik nyata:
Risk-Budget = insting kamu saat bilang:
“cukup dulu, kalau diterusin bisa ke-detect.”
SNXX harus punya insting itu.
