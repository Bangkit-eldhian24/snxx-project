02 — OBSERVATION STRATUM
Signal Extraction & Normalization Layer

1. Purpose
Observation Stratum bertanggung jawab untuk:
Mengubah response mentah (HTTP/TLS) menjadi representasi signal yang terstruktur dan bebas interpretasi.
Layer ini tidak menghasilkan topology,
tidak menghasilkan hypothesis,
dan tidak melakukan klasifikasi teknologi.
Output hanya boleh berupa normalized signals.

2. Input Contract
Observation menerima:
ObservationPlan (dari Interaction)
RawResponseSet
RawResponse mencakup:
{
  status_code
  headers
  body
  response_time
  tls_metadata (optional)
}

Observation tidak boleh mengakses KnowledgeState.

3. Output Contract
Output harus dalam bentuk:
SignalSet
Contoh:
{
  http.status_code: 200,
  http.server_header: "cloudflare",
  http.cache_control: "max-age=0",
  http.set_cookie.present: true,
  http.redirect.present: false,
  http.error_behavior.consistent: true,
  tls.version: "TLS1.3",
  tls.certificate.issuer: "Cloudflare Inc ECC CA-3",
  timing.response_ms: 82
}
Setiap signal harus:
atomic
ontology-compliant
traceable ke response tertentu

4. Signal Construction Rules
4.1 No Interpretation Rule
Dilarang:
"uses cloudflare"
"likely nginx"
"looks like SPA"
Wajib:
http.server_header = "cloudflare"
tls.certificate.issuer = "Cloudflare Inc ECC CA-3"
body.contains_hash_fragment = true

4.2 Deterministic Normalization
Header harus:
lowercase key
trimmed whitespace
canonicalized multi-value
Contoh:
"Server: CloudFlare"
→
http.server_header = "cloudflare"

4.3 Absence as Signal
Jika elemen tidak ada, harus dinyatakan eksplisit:
http.set_cookie.present = false
http.csp.present = false
http.hsts.present = false
Absence ≠ null
Absence = boolean false

4.4 Variation Recording
Jika Interaction mengirim beberapa request variasi, Observation harus menyimpan delta:
header_variation.delta.cache_control.changed = false
header_variation.delta.status_code.changed = true
Tanpa interpretasi makna perubahan.

5. TLS Signal Scope (Stage 1)
Jika scheme = HTTPS, Observation wajib mengumpulkan:
tls.version
tls.cipher_suite
tls.certificate.subject
tls.certificate.issuer
tls.certificate.san_count
tls.certificate.validity_days
tls.alpn
Tidak boleh melakukan:
OCSP validation
chain trust verification
active downgrade attempt

6. Timing Semantics
Timing hanya boleh disimpan sebagai:
timing.response_ms
timing.variance_ms (jika multi-request)
Tidak boleh menyimpulkan:
fast origin
slow backend

7. Error Handling Capture
Jika request ke path tidak ada:
Observation harus merekam:
error.status_code
error.body_length
error.template_similarity
Tanpa menyebut:
custom 404 handler
framework default page

8. Signal Integrity Requirements
Setiap signal harus memiliki:
{
  value,
  source_request_id,
  confidence: deterministic
}
Confidence di layer ini selalu deterministic (1.0), karena ini observasi, bukan inferensi.

9. Failure Conditions
Observation dianggap rusak jika:
Menghasilkan label semantik (CDN, SPA, WAF)
Menggabungkan dua signal menjadi kesimpulan
Menghilangkan absence marker
Menghapus raw evidence

10. Non-Goals
Observation bukan:
fingerprint matcher
tech detector
anomaly classifier
Observation adalah world-to-ontology translator.
