03 — TOPOLOGY STRATUM
Structural Mapping Layer

1. Purpose
Topology Stratum bertanggung jawab untuk:
Mengubah SignalSet menjadi model struktur arsitektur target yang konsisten.
Layer ini:
tidak membuat kesimpulan keamanan
tidak membuat confidence
tidak memilih hipotesis
tidak menyebut teknologi secara final
Outputnya adalah TopologyGraph — bukan diagnosis.

2. Input Contract
SignalSet (dari Observation Stratum)
LayerTaxonomy (static definition)
Topology tidak boleh membaca KnowledgeState maupun HypothesisSemantics.

3. Output Contract
TopologyGraph
Contoh bentuk:
Edge_Node
   ↓
Reverse_Proxy_Node
   ↓
Application_Node
Atau:
Client
  → CDN_Layer
  → Gateway_Layer
  → App_Layer
Bukan:
Cloudflare → Nginx → NextJS
Nama vendor tidak boleh muncul di layer ini.

4. Node Construction Rules
4.1 Node = Behavior Cluster
Node dibuat dari pola perilaku response, bukan identitas software.
Contoh mapping:
| Observed Signal Pattern                  | Node Type         |
| ---------------------------------------- | ----------------- |
| certificate issuer berbeda domain origin | Edge Node         |
| header rewrite antar request             | Proxy Node        |
| cookie lifecycle stabil                  | Application Node  |
| inconsistent error template              | Multi-Origin Node |

4.2 Boundary Detection
Boundary terjadi bila:
header berubah antar path
status behavior berubah drastis
TLS vs HTTP behavior mismatch
caching behavior tidak konsisten
Boundary ≠ vulnerability
Boundary = kemungkinan pemisahan komponen sistem

4.3 Multi-Layer Handling
Jika terdapat indikasi bertingkat:
edge cache
→ origin cache
→ application
Maka harus dibuat node terpisah walaupun belum pasti.
Topology harus over-segment, bukan under-segment.

5. Edge Semantics
Relasi antar node:
passes_through
terminates_tls
rewrites_headers
originates_response
Contoh:
Edge_Node terminates_tls
Proxy_Node rewrites_headers
App_Node originates_response
Tidak boleh:
Edge_Node protects
Proxy_Node filters attack
Karena itu security meaning.

6. Stateless vs Stateful Hint (Structural Only)
Topology boleh menandai behavioral pattern, bukan kesimpulan:
session_artifact_observed = true
session_artifact_stable = true
Bukan:
stateful_authentication = true
Keputusan itu milik Epistemic layer.

7. CDN / WAF Handling
Topology tidak boleh menyebut:
CDN
WAF
Load balancer
Sebagai gantinya gunakan:
Edge_Node
Traffic_Shaping_Node
Shielding_Node
Makna keamanan baru muncul nanti.

8. Conflict Preservation
Jika dua perilaku bertentangan:
cache present
cache bypass
Topology harus menyimpan keduanya dalam node berbeda, bukan memilih salah satu.

9. Graph Requirements
TopologyGraph harus:
Directed
Layered
Acyclic (untuk stage 1)
Evidence-traceable

10. Failure Conditions
Topology dianggap rusak jika:
Mengandung probabilitas
Mengandung istilah keamanan
Menghapus kontradiksi signal
Menghasilkan single-layer untuk sistem multi-behavior

11. Non-Goals
Topology bukan:
technology fingerprint
vulnerability assessment
threat classification
Topology adalah model bentuk sistem, bukan maknanya.
