00 — STRATA CONTRACT
SNXX Cognitive Runtime Constitution

1. Purpose
Cognitive-Strata adalah pipeline deterministik yang mengubah interaksi terbatas dengan target menjadi model arsitektur yang dapat dipertanggungjawabkan secara epistemik.
Strata tidak menghasilkan kebenaran absolut.
Strata hanya menghasilkan justified belief state.

2. Core Principles
2.1 Evidence Supremacy
Tidak ada state boleh dibuat tanpa jejak signal ontology.
no_signal → no_state
state → traceable_signal

2.2 Monotonic Knowledge
Strata tidak boleh “menebak ulang”.
Knowledge hanya boleh:
unknown → possible → likely → confirmed
Tidak boleh turun kecuali ada kontradiksi eksplisit.

2.3 Layer Isolation
Setiap strata hanya mengetahui:
| Strata      | Boleh tahu         |
| ----------- | ------------------ |
| Interaction | knowledge gaps     |
| Observation | raw response       |
| Topology    | signals            |
| Epistemic   | topology facts     |
| Reasoning   | epistemic states   |
| Security    | hypotheses         |
| Narrative   | security semantics |


2.4 No Semantic Shortcut
Strata dilarang menghasilkan konsep yang tidak ada pada Epistemic-Law vocabulary.
Contoh terlarang:
"probably wordpress"
"looks like nginx"
Wajib:
compatible_with(http.reverse_proxy)
consistent_with(cache_layer)

2.5 Explainability Preservation
Setiap output harus dapat direkonstruksi:
narrative
 ← semantics
 ← hypothesis
 ← epistemic state
 ← topology
 ← signals
 ← interaction
Jika rantai terputus → output invalid.

3. Data Flow Model
Interaction
    ↓
Observation
    ↓
Topology
    ↓
Epistemic
    ↓
Reasoning
    ↓
Security Semantics
    ↓
Narrative
Tidak ada jalur balik kecuali melalui knowledge gap request.

4. Mutation Rules
| Strata      | Boleh membuat    | Tidak boleh membuat |
| ----------- | ---------------- | ------------------- |
| Interaction | observation plan | signal              |
| Observation | signal           | topology            |
| Topology    | structural fact  | hypothesis          |
| Epistemic   | belief state     | security risk       |
| Reasoning   | hypothesis       | attack              |
| Security    | attack surface   | payload             |
| Narrative   | strategy         | inference           |


5. Contradiction Handling
Jika dua fakta bertentangan:
confirmed ∧ impossible → contradiction state
Efek:
Hypothesis dibekukan
Knowledge diturunkan menjadi contested
Interaction diminta observasi baru
Strata tidak boleh memilih salah satu.

6. Confidence Semantics
SNXX tidak menggunakan probabilitas pada strata awal.
Confidence adalah status epistemik:

| State      | Makna                 |
| ---------- | --------------------- |
| confirmed  | must be true          |
| likely     | supported             |
| possible   | insufficient evidence |
| unknown    | no observation        |
| impossible | contradicted          |

7. Knowledge Gap Protocol
Hanya Interaction boleh meminta observasi baru.
Trigger:
required_observation emitted by Reasoning
Tidak ada strata lain boleh melakukan probing.

8. Failure Conditions
Runtime dianggap rusak jika:
Narrative mengandung konsep di luar ontology
Hypothesis tidak memiliki epistemic support
State tidak punya signal origin
Observation dibuat tanpa interaction

9. Non-Goals
SNXX bukan:
vulnerability scanner
exploit generator
fingerprint matcher
signature detector
SNXX adalah architectural reasoning system.
