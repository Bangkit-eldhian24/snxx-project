07 — NARRATIVE STRATUM
Human-Readable Threat Modeling Brief

1. Purpose
Narrative Stratum bertanggung jawab untuk:
Mengubah SecuritySurfaceModel menjadi briefing strategis yang dapat dipahami pentester tanpa mengubah makna epistemik.
Layer ini bukan reasoning layer.
Layer ini bukan LLM reasoning.
Layer ini adalah explanation renderer.

2. Input Contract
SecuritySurfaceModel
HypothesisSet
KnowledgeStateFrame
ConfidenceModel
Narrative tidak boleh membaca Observation langsung.
Semua informasi harus melewati layer sebelumnya.

3. Output Contract
ThreatBrief
Contoh struktur:
{
  "architectural_assessment": "...",
  "operational_posture": "...",
  "testing_strategy": "...",
  "confidence_notes": "...",
  "unknowns": "..."
}

Output boleh berupa teks manusia, bukan hanya JSON.

4. Narrative Rules
Narrative harus menggunakan epistemic language.
Gunakan kata:
suggests
consistent_with
indicates
compatible_with
unlikely
uncertain
Dilarang menggunakan:
confirmed
guaranteed
definitely
proven

5. Separation From Reasoning
Narrative tidak boleh:
menambah hipotesis baru
mengubah confidence
menggabungkan bukti baru
memperbaiki model
Jika itu terjadi → design violation

6. Strategic Output Format
Narrative menghasilkan 5 bagian tetap:
A. Architectural Interpretation
Menjelaskan model sistem secara konseptual.
B. Operational Posture
Menjelaskan bagaimana sistem kemungkinan dioperasikan (production hardened, layered, edge-heavy, dll).
C. Testing Direction
Memberi arah manual testing, bukan langkah eksploitasi.
D. Confidence Explanation
Menjelaskan kenapa sistem percaya pada modelnya.
E. Unknowns
Menjelaskan apa yang belum diketahui (penting untuk pentester).

7. Anti-Hallucination Constraint
Narrative hanya boleh berbicara tentang:
(Hypothesis ∪ KnowledgeState ∪ SecuritySurface)
Tidak boleh ada referensi eksternal.
Tidak boleh vendor naming.
Tidak boleh CVE.

8. Human Collaboration Goal
Output harus menjawab pertanyaan pentester sebelum membuka proxy:
| Pertanyaan                                    | Harus dijawab |
| --------------------------------------------- | ------------- |
| Sistem kira-kira layered atau monolith?       | Ya            |
| Fokus auth atau parsing?                      | Ya            |
| Ada kemungkinan origin exposure?              | Ya            |
| Perlu banyak probing atau sedikit tapi dalam? | Ya            |

9. Failure Conditions
Narrative dianggap gagal jika:
Memberi instruksi eksploitasi
Menghasilkan payload
Menyebut vulnerability spesifik
Bertindak seperti scanner report

10. Non-Goals
Narrative bukan:
report generator
vulnerability summary
bug bounty finder
Narrative adalah:
situational awareness briefing

11. End of Pipeline
Setelah layer ini:
Mesin berhenti berpikir
Manusia mulai berpikir
SNXX tidak menggantikan pentester.
SNXX mengurangi ketidakpastian awal sebelum analisis manual.
