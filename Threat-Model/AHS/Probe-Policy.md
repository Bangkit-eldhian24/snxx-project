1. Purpose
Probe-Policy mengatur pemilihan request berikutnya berdasarkan kebutuhan informasi,
bukan berdasarkan pencarian kerentanan.
SNXX tidak melakukan eksploitasi.
SNXX melakukan information discrimination.
Tujuan:
memaksimalkan pengurangan ketidakpastian per unit risiko.

2. Probe Philosophy
SNXX tidak mengejar coverage.
SNXX mengejar ambiguity collapse.
Setiap probe harus menjawab:
apakah ini membedakan dua hipotesis arsitektur?
Jika tidak → probe dilarang.

3. Probe Types
| Class      | Tujuan          | Contoh         |
| ---------- | --------------- | -------------- |
| Passive    | observasi ulang | repeat request |
| Variant    | perubahan kecil | header berbeda |
| Boundary   | uji limit       | method berbeda |
| Structural | uji relasi      | path sibling   |

3.1 Passive Probe
Tidak mengubah input.
Digunakan untuk:
variance detection
caching behaviour
CDN detection
Risiko: nol

3.2 Variant Probe
Perubahan mikro tanpa mengubah maksud request.
Contoh:
Accept-Language
User-Agent family
Header order
Tujuan:
membedakan framework parser vs proxy layer

3.3 Boundary Probe
Mengubah kategori request, bukan payload.
Contoh:
GET → HEAD
GET → OPTIONS
trailing slash
case sensitivity
Tujuan:
mengidentifikasi routing & middleware layer

3.4 Structural Probe
Mengubah hubungan endpoint.
Contoh:
/api/user
/api/user/
/api/user.json
/api/user/1
Tujuan:
model struktur backend

4. Probe Selection Rule
SNXX memilih probe berdasarkan Expected Information Gain (EIG)
Secara konseptual:
EIG = belief_entropy_before − expected_entropy_after
Praktiknya (heuristic):
| Kondisi                  | Probe Dipilih |
| ------------------------ | ------------- |
| high uncertainty         | boundary      |
| multi-framework conflict | structural    |
| unstable response        | passive       |
| proxy suspected          | variant       |

5. Disallowed Probes
SNXX tidak boleh:
payload injection
fuzzing
brute force
wordlist discovery
param mutation
auth probing
race attempts
Jika dilakukan → keluar dari domain threat modeling.

6. Rate Discipline
Probe bukan scanning.
default_interval ≥ human browsing cadence
burst forbidden
parallel forbidden
Tujuan:
menghindari behavioral artifact pada target

7. Suspicion Interaction
| Mode      | Perilaku Probe    |
| --------- | ----------------- |
| NORMAL    | bebas             |
| HARDENED  | pelan             |
| ADAPTIVE  | minimal           |
| DECEPTIVE | konfirmasi silang |

8. Abort Conditions
Jika:
server instability meningkat
mode berubah ke deceptive
confidence turun setelah probe
→ probing dihentikan
Karena observasi telah mempengaruhi sistem.

9. Output Contract
Probe tidak menghasilkan fakta.
Probe hanya menghasilkan observasi tambahan.
Semua interpretasi dilakukan di Reasoning Stratum.

## Probe Selection Algorithm (Stage-1)

### Entropy Calculation
Current belief entropy:
H_current = - Σ belief(H_i) * log2(belief(H_i))

### Expected Entropy After Probe
For each candidate probe P:
1. Enumerate possible outcomes O = {o_1, o_2, ...}
2. For each outcome o_j:
   - Estimate P(o_j | probe P)
   - Simulate belief update using Belief-Weighting
   - Calculate H_after(o_j)
3. Expected entropy:
   H_expected = Σ P(o_j) * H_after(o_j)

### Information Gain
IG(P) = H_current - H_expected

### Risk-Adjusted Selection
Score(P) = IG(P) / risk_cost(P)

Select probe with max(Score).

### Example
Current state:
- belief(Django) = 0.45
- belief(Laravel) = 0.35
- belief(Custom) = 0.20
- H_current = 1.48 bits

Candidate probes:
1. Check /api/csrf endpoint
   - If exists → IG = 0.62, risk = 0.25 → Score = 2.48
2. Repeat GET /
   - IG = 0.15, risk = 0.05 → Score = 3.0 ✓
   
Select: Repeat GET (passive confirmation)
