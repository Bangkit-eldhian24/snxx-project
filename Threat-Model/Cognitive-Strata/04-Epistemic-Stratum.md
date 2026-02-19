04 — EPISTEMIC STRATUM
Knowledge State Construction Layer

1. Purpose
Epistemic Stratum bertanggung jawab untuk:
Mengubah TopologyGraph menjadi KnowledgeState yang valid secara epistemik.
Layer ini menentukan:
apa yang diketahui
apa yang mungkin benar
apa yang belum diketahui
apa yang kontradiktif
Layer ini tidak membuat hipotesis keamanan
Layer ini hanya membangun state of knowledge

2. Input Contract
TopologyGraph
SignalSet
Knowledge-State.md (static law)
Epistemic tidak boleh membaca Hypothesis Semantics.

3. Output Contract
KnowledgeStateFrame
Contoh:
{
  "cdn_presence": "LIKELY",
  "stateful_session": "SUPPORTED",
  "origin_visibility": "UNKNOWN",
  "multi_origin": "CONTESTED"
}

4. Knowledge Domain
Setiap fact harus berada pada domain epistemik:
| State      | Meaning                           |
| ---------- | --------------------------------- |
| CONFIRMED  | dibuktikan langsung oleh evidence |
| SUPPORTED  | konsisten oleh beberapa evidence  |
| LIKELY     | indikasi kuat namun tidak stabil  |
| WEAK       | indikasi lemah                    |
| UNKNOWN    | tidak ada evidence                |
| CONTESTED  | evidence konflik                  |
| IMPOSSIBLE | dilanggar oleh evidence           |
Tidak ada probabilitas numerik di layer ini.

5. Evidence Binding
Setiap state harus punya trace:
fact → supporting_evidence[]
fact → contradicting_evidence[]
Tanpa trace → state invalid.

6. Absence as Information
Ketidakhadiran signal adalah evidence.
Contoh:
| Tidak ditemukan | Makna epistemik       |
| --------------- | --------------------- |
| cookie          | kemungkinan stateless |
| csrf token      | mungkin API driven    |
| error detail    | kemungkinan hardened  |
Namun hanya menghasilkan:
SUPPORTED / WEAK
Tidak boleh CONFIRMED.

7. Contradiction Handling
Jika dua evidence bertentangan:
Set-Cookie present
Authorization header required
Maka:
auth_mechanism = CONTESTED
Epistemic tidak boleh memilih salah satu.

8. Temporal Stability (Frame Validation)
Knowledge harus konsisten minimal N observation frames.
Default:
stable_if_consistent >= 2 frames
confirmed_if_consistent >= 3 frames
Jika berubah:
→ downgrade state

9. Layer Awareness
Epistemic boleh menyatakan knowledge per-node:
Edge_Node.session_support = IMPOSSIBLE
App_Node.session_support = SUPPORTED
Bukan global langsung.

10. Derived Knowledge Rules
Epistemic boleh membuat turunan hanya jika deterministik.
Contoh valid:
cookie absent + auth header required
→ session_storage unlikely
Contoh invalid:
cookie absent → API
Karena itu interpretasi.

11. Failure Conditions
Epistemic dianggap gagal jika:
Mengandung teknologi spesifik
Mengandung vulnerability
Mengandung probabilitas %
Mengandung kata “secure / insecure”
Melompati CONTESTED state

12. Non-Goals
Epistemic bukan:
threat modeling
attack planning
risk assessment
Epistemic hanya:
kondisi pengetahuan mesin tentang realitas target
