Di sini kita berhenti “melihat”, dan mulai menyatakan apa yang sah untuk diketahui.

Batas kerasnya:

Knowledge ≠ Signal
Knowledge adalah hasil stabilisasi observasi terhadap waktu dan konflik.

Tidak ada framework detection di sini.
Tidak ada hipotesis.
Hanya epistemologi mesin.

Knowledge State Specification (KSS)
Part 1 — From Observation to Fact
1. Tujuan Knowledge State

Signal graph hanyalah kumpulan kejadian.

Knowledge State menentukan:

kapan observasi boleh disebut fakta
kapan masih indikasi
kapan harus ditolak


Engine inference tidak boleh memakai signal langsung.
Ia hanya boleh memakai knowledge.

2. Definisi Formal
Signal  = event yang terlihat
Evidence = signal yang tervalidasi lokal
Knowledge = evidence yang stabil lintas observasi


Hierarki:

Signal → Evidence → Knowledge

3. Evidence Qualification

Signal tidak otomatis menjadi evidence.

Syarat minimal:

3.1 Structural Validity

Nilai sesuai grammar tipe signal.

Contoh:

Set-Cookie harus parseable
Header harus RFC-valid
HTML harus DOM-consistent


Jika tidak:

invalid_signal → discarded

3.2 Observability Integrity

Signal harus berasal dari interaksi valid:

no timeout
no partial response
no truncated body


Jika gagal → unreliable_signal

3.3 Reproducibility Check

Minimal satu re-observation.

seen_once → tentative
seen_twice → evidence


Kecuali signal volatile (ditandai di ontology).

4. Evidence Classification

Setelah lolos, evidence diberi tipe epistemik:
| Type        | Arti              |
| ----------- | ----------------- |
| direct      | diamati langsung  |
| derived     | hasil parsing     |
| behavioral  | hasil respon aksi |
| absence     | hasil ketiadaan   |
| statistical | hasil agregasi    |


5. Knowledge Formation

Evidence menjadi knowledge jika stabil.

knowledge_confidence =
    stability
  × integrity
  × observation_count_factor


Bukan probabilitas teknologi.
Ini probabilitas kebenaran pengamatan.

5.1 Stability Requirement

Default:

>= 3 observation frames


atau

>= 2 frame + REPEATS + no conflict

5.2 Conflict Resolution

Jika conflict ada:

knowledge_state = contested


Belum boleh dipakai inference.

6. Knowledge Types
6.1 Deterministic Knowledge

Tidak berubah lintas observasi.

Contoh:

cookie name pattern
static path structure

6.2 Dynamic Knowledge

Berubah tapi terkontrol.

Contoh:

csrf token format
etag pattern
request id prefix

6.3 Negative Knowledge

Ketiadaan stabil.

OPTIONS never returns Allow
No directory listing
No compression support


Ini penting untuk narrowing hypothesis.

6.4 Exclusive Knowledge

Saling meniadakan.

Jika dua knowledge conflict permanen:

create exclusive pair


Inference nanti wajib memilih.

7. Knowledge Decay

Server bisa berubah selama scan.

Tambahkan TTL:

knowledge_ttl = f(volatility, observation_gap)


Jika expired:

knowledge → stale
stale tidak boleh dipakai inference

8. Knowledge Consistency Score

Sistem menjaga integritas global:

consistency =
  non_conflicting_knowledge /
  total_knowledge


Jika terlalu rendah:

environment = unstable
inference forbidden

9. Knowledge Graph Output

Output modul ini:

KnowledgeGraph {
    facts[]
    contested[]
    stale[]
    negative_facts[]
    exclusive_sets[]
    environment_stability
}


Ini satu-satunya input legal untuk Hypothesis Engine.

10. Prinsip Keamanan Epistemik

Inference dilarang memakai:

raw signal

single observation

conflicted evidence

stale knowledge

Dengan kata lain:

Engine tidak boleh menebak dari “indikasi”.
