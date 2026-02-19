01 — INTERACTION STRATUM
Target Engagement Orchestrator

1. Purpose
Interaction Stratum bertanggung jawab menghasilkan rencana observasi terkontrol berdasarkan:
target descriptor
knowledge gaps
required observations dari Reasoning Stratum
Layer ini tidak membaca response dan tidak melakukan inferensi.
Interaction hanya memutuskan:
observasi apa yang perlu dilakukan untuk mengurangi ketidakpastian epistemik.

2. Input Contract
Interaction menerima:
TargetDescriptor
KnowledgeStateSnapshot
RequiredObservationSet (optional)
2.1 TargetDescriptor
Contoh:
{
  scheme: http|https,
  host: string,
  port: int,
  path: string
}
Tidak boleh berisi:
vulnerability hint
assumption teknologi
prior belief

2.2 KnowledgeStateSnapshot
Ringkasan dari Epistemic Stratum:
{
  cdn_presence: unknown|possible|likely|confirmed,
  auth_model: unknown|possible|likely|confirmed,
  framework_type: unknown|possible|likely|confirmed
}
Interaction hanya boleh membaca unknown atau contested sebagai gap.

2.3 RequiredObservationSet
Dihasilkan oleh Reasoning Stratum.
Contoh:
[
  "header_variation_check",
  "redirect_behavior",
  "tls_certificate_inspection"
]
Interaction tidak boleh membuat jenis observasi baru di luar ontology.

3. Output Contract
Interaction menghasilkan:
ObservationPlan
Contoh:
[
  { method: GET, path: "/", headers: default },
  { method: GET, path: "/", headers: randomized },
  { method: HEAD, path: "/", headers: default },
  { method: GET, path: "/nonexistent", headers: default }
]
Tidak boleh menyertakan:
payload eksploit
fuzzing string
brute-force list
injection pattern
Jika ada → kontrak dilanggar.

4. Interaction Rules
4.1 Minimal Sufficiency Rule
Interaction hanya boleh melakukan observasi yang dibutuhkan untuk:
membedakan dua hipotesis admissible
memvalidasi kontradiksi
mengisi knowledge gap
Bukan:
enumerate all endpoints
scan for admin
bruteforce directories

4.2 Deterministic Behavior
Input yang sama → ObservationPlan yang sama.
Tidak boleh ada:
random probing
adaptive fuzzing
state mutation

4.3 Bounded Surface Rule
Interaction hanya boleh mengakses:
root path
provided path
synthetic non-existing path (untuk baseline behavior)
header variation
method variation
TLS metadata
Tidak boleh:
deep crawling
login attempt
API exploration
POST form injection

5. Observation Types Allowed (Stage 1 Scope)
| Type             | Tujuan                   |
| ---------------- | ------------------------ |
| baseline_request | server fingerprinting    |
| header_variation | caching & edge detection |
| redirect_probe   | auth & routing inference |
| tls_metadata     | certificate & TLS model  |
| status_anomaly   | error handling model     |
Semua jenis observasi harus didefinisikan dalam Signal Ontology.

6. Knowledge Gap Resolution Protocol
Jika Reasoning menghasilkan:
required_observation: "edge_origin_separation_check"
Interaction harus menerjemahkan menjadi rencana konkret:
- request 1: default headers
- request 2: altered host header
- request 3: invalid path
Interaction tidak boleh menafsirkan makna security dari permintaan tersebut.

7. Failure Conditions
Interaction dianggap melanggar kontrak jika:
Menghasilkan lebih dari N observasi tanpa epistemic justification
Mengakses path yang tidak diminta
Mengirim payload aktif
Mengubah state target

8. Non-Goals
Interaction bukan:
crawler
fuzzer
scanner
exploit engine
Interaction adalah epistemic probe planner.
