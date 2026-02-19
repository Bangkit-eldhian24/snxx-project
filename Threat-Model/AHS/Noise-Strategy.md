1. Purpose
Noise-Strategy mengontrol pola temporal dan struktural dari observasi agar tidak menghasilkan signature otomasi.
Tujuan:
menghindari deteksi WAF behavior-analysis
mencegah adaptive response
menjaga validitas bukti
mencegah feedback loop palsu
Noise ≠ random.
Noise adalah distribusi yang konsisten dengan manusia.

2. Threat Model
Target modern tidak hanya melihat:
payload
header
Tetapi:
inter-request timing
path traversal order
header reuse pattern
TCP cadence
navigation coherence
Scanner gagal bukan karena request berbahaya,
tetapi karena urutan tidak masuk akal.

3. Human Navigation Model
SNXX harus mengikuti model:
context → curiosity → verification
Bukan:
enumeration → coverage → completeness
Allowed Pattern
/          (landing)
/assets    (browser fetch)
/api/info  (curiosity)
/          (back navigation)
/login     (contextual)
Forbidden Pattern
/admin
/api
/graphql
/debug
/config
/.env
/.git
Walaupun read-only.

4. Temporal Distribution
Inter-request delay:
delay ~ human_gaussian(mean=2.8s, σ=1.1s)
Burst maksimum:
≤ 3 requests / 5s
Cooldown:
after anomaly → 8–25s pause
Tidak boleh fixed interval.

5. Structural Coherence
SNXX tidak boleh melompat layer.
Jika belum melihat:
HTML reference
Maka tidak boleh akses:
API endpoint
Jika belum ada navigational path:
Tidak boleh akses deep route.
## Structural Coherence Validation

### Navigation Graph
Maintain directed graph G = (V, E):
- V = set of observed paths
- E = valid navigation transitions

### Transition Rules
Edge (A → B) exists if:
1. HTML at A contains link/reference to B
2. B is parent path of A (back navigation)
3. B is sibling path of A (contextual navigation)

### Probe Admissibility Check
Before probing path P:
1. Check if ∃ path Q in V such that (Q → P) ∈ E
2. If not, probe is INADMISSIBLE
3. Exception: root path "/" always admissible

### Example Enforcement
Observed: /
Contains: <a href="/about">, <script src="/api/config.js">

Admissible next probes:
✓ /about (HTML link)
✓ /api/config.js (script reference)
✗ /api/users (no reference)
✗ /admin (no reference)

Only after observing /api/config.js:
If it references /api/users → now admissible

6. Header Consistency
Headers harus stabil:
User-Agent konstan
Accept-Language konstan
Accept profile konstan
Yang berubah hanya:
cache validators
navigation context
Header rotation = scanner signature.

7. Retry Strategy
Jika request gagal:
Allowed:
retry once (after delay)
Forbidden:
retry burst
retry pattern
retry escalation
Karena retry storm = bot behavior.

8. Suspicion Interaction
Jika Suspicion-Model ≠ NORMAL:
| Mode      | Noise Adaptation   |
| --------- | ------------------ |
| HARDENED  | increase delay     |
| ADAPTIVE  | reduce curiosity   |
| DECEPTIVE | freeze exploration |

9. Epistemic Constraint
Noise-Strategy tidak boleh dipakai untuk:
bypass WAF
stealth scanning
evasion attack
Tujuan hanya:
menjaga observasi tetap natural sehingga respon sistem tetap representatif.
Jika sistem berubah karena kita → model salah.

10. Practical Meaning
Pentester berpengalaman tidak langsung buka semua endpoint.
Dia browsing dulu.
SNXX harus melakukan hal yang sama.
