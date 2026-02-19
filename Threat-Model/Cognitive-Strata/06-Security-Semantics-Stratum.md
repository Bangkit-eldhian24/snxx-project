06 — SECURITY SEMANTICS STRATUM
Attack Surface Interpretation Layer

1. Purpose
Security Semantics Stratum bertanggung jawab untuk:
Menerjemahkan HypothesisSet menjadi implikasi keamanan berbasis arsitektur.
Layer ini tidak mencari vulnerability spesifik.
Layer ini tidak menghasilkan payload.
Layer ini hanya mengidentifikasi:
kemungkinan attack surface
zona kepercayaan (trust boundary)
area fragilitas struktural

2. Input Contract
HypothesisSet
KnowledgeStateFrame
TopologyGraph
Security Mapping Rules (static)
Layer ini tidak boleh membaca Narrative.

3. Output Contract
SecuritySurfaceModel
Contoh:
{
  "trust_boundaries": [
    "client_to_edge",
    "edge_to_origin"
  ],
  "surface_candidates": [
    "origin_exposure_vector",
    "cache_inconsistency_vector",
    "session_handling_variation"
  ],
  "structural_risk_indicators": [
    "multi_origin_conflict",
    "header_rewrite_instability"
  ]
}
Tidak boleh ada CVE.
Tidak boleh ada exploit chain.

4. Security Mapping Rule
Setiap hipotesis memiliki implikasi keamanan yang deterministik.
Contoh:
| Hypothesis              | Security Surface              |
| ----------------------- | ----------------------------- |
| edge_terminated_tls     | origin exposure possibility   |
| multi_origin_backend    | inconsistent auth enforcement |
| cache_mediated_response | cache poisoning surface       |
| stateless_auth_model    | token replay surface          |
Mapping ini harus berada di dokumen statik (tidak diimprovisasi runtime).

5. Trust Boundary Identification
Layer ini harus mengidentifikasi boundary:
boundary_A: client → edge
boundary_B: edge → origin
boundary_C: origin → internal service
Boundary ≠ vulnerability
Boundary = titik transisi kontrol

6. Fragility Detection
Fragility bukan vulnerability.
Fragility adalah:
kondisi arsitektur yang sensitif terhadap kesalahan konfigurasi
Contoh:
header_rewrite + inconsistent cache
→ fragile_caching_layer

7. Conflict Amplification
Jika Reasoning memiliki dua hipotesis kompetitif:
Security Semantics harus menghasilkan union surface, bukan memilih salah satu.
Karena pentester harus siap terhadap dua kemungkinan dunia.

8. No Exploit Semantics
Dilarang menghasilkan:
SQL injection
XSS
RCE
SSRF payload
Yang boleh:
input_validation_surface
origin_reachability_surface
authentication_boundary_surface

9. Risk Level (Optional Stage 1)
Jika ingin memberi bobot, gunakan kategori kualitatif:
| Level             | Meaning                     |
| ----------------- | --------------------------- |
| LOW_EXPOSURE      | surface kecil               |
| MODERATE_EXPOSURE | beberapa boundary           |
| HIGH_EXPOSURE     | banyak fragility & boundary |
Tidak boleh numeric scoring di stage ini.

10. Failure Conditions
Layer ini gagal jika:
Menghasilkan CVE
Menghasilkan exploit detail
Menggunakan payload
Menyebut software vendor

11. Non-Goals
Security Semantics bukan:
vulnerability scanner
exploit advisor
automated attacker
Security Semantics adalah:
architectural risk translator
