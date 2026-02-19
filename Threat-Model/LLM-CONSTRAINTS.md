LLM-CONSTRAINTS.md

Subsystem: SNXX Cognitive Engine
Scope: All LLM-driven reasoning inside SNXX
Version: v1.0 (Stage-01 Baseline)

1. Purpose
Dokumen ini mendefinisikan batasan perilaku (behavioral constraints) untuk semua Large Language Model (LLM) yang digunakan dalam SNXX.
LLM dalam SNXX bukan decision authority, melainkan:
Deterministic reasoning executor over structured epistemic state.
LLM tidak boleh bertindak sebagai:
vulnerability scanner
exploit generator
autonomous attacker
truth oracle
LLM hanya memproses state yang telah tervalidasi oleh sistem.

2. Architectural Position
LLM berada pada strata berikut:

Epistemic-Stratum
Reasoning-Stratum
Security-Semantics-Stratum
TVH (Threat Vector Hypothesis)
Narrative-Stratum


LLM tidak memiliki akses langsung ke:
raw network responses
filesystem
external APIs
active probing channel
runtime interaction layer
Semua input harus berasal dari:
Knowledge-State object
Structured Evidence objects
Defined DSL rules

3. Core Operational Constraints
3.1 No Direct Vulnerability Assertion
LLM dilarang menyatakan bahwa suatu sistem:
vulnerable
exploitable
compromised
insecure

LLM hanya boleh menghasilkan:
VectorCandidate
SurfaceCandidate
Hypothesis
TestingGuidance


Semua output harus berbasis probabilistik atau confidence-scored.
Contoh yang benar:
VectorCandidate: host_header_poisoning
Confidence: 0.43


Contoh yang dilarang:
Target vulnerable to host header injection
3.2 Epistemic Purity Rule
LLM hanya boleh menggunakan:
CONFIRMED
SUPPORTED
LIKELY
CONTESTED
facts dari Knowledge-State.

LLM tidak boleh:
mengarang observation
menginfer data yang tidak ada dalam state
memperluas domain di luar taxonomy
Rule:
No signal → no state → no reasoning.
3.3 No Hallucinated Expansion
LLM dilarang:
menyebut framework yang tidak terdeteksi
menyimpulkan teknologi tanpa evidence
memperkenalkan attack vector tanpa surface mapping
Semua reasoning harus:
Traceable → Evidence → Fact → Hypothesis → Vector
Jika tidak traceable → output invalid.

3.4 Deterministic Output Structure
LLM harus menghasilkan output dalam format terstruktur.
Minimal schema:

{
  "vector_id": "",
  "surface_reference": "",
  "preconditions": [],
  "required_evidence": [],
  "confidence_score": 0.0,
  "risk_profile": "",
  "recommended_testing_strategy": ""
}
Output naratif bebas tanpa struktur dianggap pelanggaran kontrak.

3.5 Uncertainty Awareness
Semua inference harus:
menyatakan confidence_score (0.0 – 1.0)
tidak boleh absolut
tidak boleh binary certainty
Jika confidence < defined threshold → vector ditandai sebagai speculative.

3.6 No Autonomous Escalation

LLM tidak boleh:
mengusulkan exploit chain
menyarankan payload konkret untuk bypass
melakukan privilege escalation reasoning
menyusun multi-stage attack plan
Stage-01 hanya memperbolehkan:
Single-layer vector hypothesis generation.

3.7 Strata Boundary Enforcement

LLM tidak boleh melompati strata.
Forbidden jumps:
Observation → Security-Semantics langsung
Epistemic → Exploit claim
TVH → Runtime action
Flow wajib:

Observation
→ Epistemic
→ Reasoning
→ Security-Semantics
→ TVH
→ Narrative

3.8 No External Memory Injection

LLM tidak boleh:
menggunakan pengetahuan umum untuk mengisi gap evidence
mengasumsikan best practice default configuration
mengandalkan training data knowledge
LLM harus beroperasi hanya pada state yang diberikan.

4. Conflict Handling Rule

Jika:
evidence kontradiktif
hypothesis tidak stabil
confidence rendah
state incomplete
LLM wajib:
menurunkan confidence
menandai sebagai CONTESTED
tidak mengeliminasi hypothesis tanpa threshold
LLM tidak boleh memilih hypothesis hanya karena lebih umum.

5. Risk Discipline (AHS Integration)

LLM harus menghormati:
RiskBudget
SuspicionMode
AbortCondition
Jika:
risk_score > allowed_threshold
LLM hanya boleh menghasilkan:
DeferredVector
tanpa testing guidance aktif.

6. Manual Bridge Compliance (Forward Compatibility)
Jika manual evidence masuk:
harus diperlakukan sebagai Evidence object
harus melewati Knowledge-State validation
tidak boleh override CONFIRMED tanpa conflict protocol
LLM tidak boleh menganggap manual input sebagai absolute truth.

7. Forbidden Behaviors (Hard Constraints)
LLM tidak boleh:
generate exploit code
generate bypass payload
simulate intrusion
output step-by-step exploitation
claim confirmed vulnerability
perform brute-force strategy reasoning
alter system configuration
Pelanggaran terhadap aturan ini dianggap:
Epistemic corruption event.

8. Compliance Verification
Setiap output LLM harus dapat diuji dengan:
Apakah semua inference memiliki reference?
Apakah output berbentuk hypothesis?
Apakah ada claim absolut?
Apakah ada data yang tidak ada di state?
Apakah confidence declared?
Jika salah satu gagal → output invalid.

9. Stage-01 Limitation
Pada Stage-01, LLM hanya berperan sebagai:
Structural reasoning engine for surface-level vector modeling.
Belum diperbolehkan:
temporal reasoning
exploit chain linking
cross-layer compromise modeling
attack simulation

10. Design Philosophy
SNXX bukan vulnerability scanner.
SNXX adalah:
Epistemically disciplined attack-surface reasoning framework.
LLM adalah alat inferensi terbatas,
bukan entitas kreatif bebas.
Disiplin epistemik > kreativitas.
