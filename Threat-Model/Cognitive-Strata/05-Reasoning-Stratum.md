05 — REASONING STRATUM
Hypothesis Competition Layer

1. Purpose
Reasoning Stratum bertanggung jawab untuk:
Menghasilkan dan mengevaluasi hipotesis struktural yang menjelaskan KnowledgeState.
Layer ini menggunakan Hypothesis Semantics sebagai aturan logika formal.
Outputnya bukan keputusan final — tetapi ranking penjelasan terbaik.

2. Input Contract
KnowledgeStateFrame
TopologyGraph
Hypothesis-Semantics.md
Reasoning tidak boleh membaca Security Semantics maupun Narrative.

3. Output Contract
HypothesisSet
Contoh:
[
  {
    "hypothesis": "edge_terminated_tls_architecture",
    "status": "COMPETITIVE",
    "explains": ["tls_mismatch", "server_header_inconsistent"],
    "contradicts": [],
    "coverage": "HIGH"
  },
  {
    "hypothesis": "direct_origin_architecture",
    "status": "WEAK",
    "explains": ["stable_cookie"],
    "contradicts": ["tls_mismatch"]
  }
]

4. Hypothesis Nature
Hipotesis bukan fakta.
Hipotesis adalah:
model dunia yang paling menjelaskan evidence
Bukan:
hasil deteksi teknologi

5. Hypothesis States
| State       | Meaning                                          |
| ----------- | ------------------------------------------------ |
| DOMINANT    | menjelaskan mayoritas evidence tanpa konflik     |
| COMPETITIVE | menjelaskan banyak evidence dengan konflik kecil |
| WEAK        | menjelaskan sebagian kecil evidence              |
| INVALIDATED | bertentangan dengan evidence utama               |

6. Explanation Coverage
Setiap hipotesis harus menghitung:
coverage = explained_evidence / total_relevant_evidence
conflict = contradicting_evidence
Tanpa coverage → hipotesis tidak valid.

7. Competing World Models
Reasoning harus menyimpan beberapa model sekaligus.
Contoh:
Model A: reverse proxy architecture
Model B: multi-origin load balancing
Model C: application-level routing
SNXX tidak boleh memilih satu terlalu awal.

8. Non-Monotonic Logic
Evidence baru boleh menjatuhkan hipotesis lama.
Hypothesis valid → evidence baru → INVALIDATED
Reasoning tidak boleh mempertahankan hipotesis demi stabilitas output.

9. No Security Meaning Yet
Reasoning tidak boleh mengatakan:
vulnerable
hardened
protected
exploitable
Layer ini hanya menjawab:
arsitektur apa yang paling menjelaskan perilaku sistem

10. Structural vs Behavioral Hypothesis
Hipotesis dibagi dua:
Structural
menjelaskan bentuk sistem
edge gateway present
multi service backend
Behavioral
menjelaskan pola operasional
stateless auth design
cache mediated responses
Keduanya belum keamanan.

11. Conflict Preservation
Jika dua hipotesis kuat:
DOMINANT A
DOMINANT B
SNXX harus mempertahankan keduanya sampai Security layer.

12. Failure Conditions
Reasoning gagal jika:
Menghasilkan satu hipotesis tunggal tanpa kompetisi
Mengandung vulnerability statement
Menghapus hipotesis kalah
Menggunakan probabilitas numerik

13. Non-Goals
Reasoning bukan:
fingerprinting engine
vulnerability scanner
attack recommender
Reasoning adalah:
mesin pembanding model realitas target
