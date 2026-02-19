---

# STAGE-01 RULE TAXONOMY MAP

*(Architecture Construction Scope Only)*

---

# I. EDGE LAYER INFERENCE RULES

## Tujuan

Mendeteksi keberadaan komponen di layer paling luar (CDN, WAF, reverse proxy, LB).

## Output Yang Diizinkan

* Node: `Asset(class=edge)`
* Edge: `Actor → Edge`
* TrustZone assignment
* Belief update

## Signal Domain

* HTTP headers
* TLS certificate issuer
* IP ASN lookup (optional)
* Redirect pattern

---

### Subkategori

### I.A CDN Presence

Indikator:

* `server` header known CDN
* `cf-ray`
* `x-cache`
* TLS issuer pattern
* IP range known CDN

Output:

```
Node(edge.cdn)
Edge(Actor → CDN)
```

---

### I.B Reverse Proxy Detection

Indikator:

* `via`
* `x-forwarded-for`
* `x-real-ip`
* Proxy-specific header patterns

Output:

```
Node(edge.reverse_proxy)
Edge(CDN → Proxy) or Actor → Proxy
```

---

### I.C Load Balancer Detection

Indikator:

* Cookie pattern (AWSALB)
* Azure ARR affinity
* GCP LB header

Output:

```
Node(edge.load_balancer)
```

---

# II. GATEWAY / ROUTING LAYER RULES

## Tujuan

Mengidentifikasi API gateway atau routing behavior.

## Output Yang Diizinkan

* Node: `Asset(class=gateway)`
* Edge: `Edge → Gateway`
* TrustZone adjustment

---

### II.A API Gateway Pattern

Indikator:

* `/api/` path convention
* `x-amzn-requestid`
* Kong header
* Apigee header

---

### II.B Microservice Routing Pattern

Indikator:

* Distinct service prefix
* Versioned API path `/v1/`
* Multiple subdomain API endpoints

---

# III. APPLICATION RUNTIME INFERENCE RULES

## Tujuan

Mengidentifikasi execution environment.

## Output Yang Diizinkan

* Node: `Execution`
* Edge: `Gateway → Execution`
* Belief increment pada runtime hypothesis

---

### III.A Framework Fingerprint

Indikator:

* Django csrf cookie
* Express `x-powered-by`
* Laravel session cookie
* ASP.NET header
* Rails authenticity token

---

### III.B Template Engine Presence

Indikator:

* CSRF hidden input
* HTML structure patterns
* Server-rendered signature

---

### III.C Static vs Dynamic Classification

Indikator:

* No cookies
* No server header
* Only static assets
* No redirect on auth attempt

Output:

```
Execution(class=static)
```

---

# IV. AUTHENTICATION / CONTROL LAYER RULES

## Tujuan

Mengidentifikasi control mechanism dan state transition potential.

## Output Yang Diizinkan

* Node: `Control`
* Edge: `Execution → Control`
* StateTransition rule (τ)

---

### IV.A Session-Based Auth

Indikator:

* `Set-Cookie: sessionid`
* HttpOnly flag
* Secure flag

---

### IV.B Token-Based Auth

Indikator:

* JWT pattern
* `Authorization: Bearer`
* 401 JSON response

---

### IV.C Redirect-Based Auth

Indikator:

* 302 → `/login`
* Access protected path redirect

---

# V. STATEFULNESS CLASSIFICATION RULES

## Tujuan

Menentukan apakah sistem menyimpan state.

## Output Yang Diizinkan

* StateTransition rule
* KnowledgeState update

---

### V.A Cookie Presence Rule

Indikator:

* Any Set-Cookie

---

### V.B Sticky Session Rule

Indikator:

* Load balancer affinity cookie

---

### V.C Idempotent Endpoint Behavior

Indikator:

* Same request → same response → no session variation

---

# VI. DATASTORE INFERENCE (LIMITED)

⚠️ Sangat dibatasi.

Hanya jika signal eksplisit.

---

### VI.A SQL Error Leakage (Structural Only)

Indikator:

* Error page reveals engine name

Output:

```
Node(DataStore)
Edge(Execution → DataStore)
```

Tanpa vulnerability claim.

---

# VII. TOPOLOGY CONSISTENCY RULES

## Tujuan

Menghubungkan node antar layer dengan cara deterministik.

Contoh:
Jika `edge.cdn` AND `execution.detected`
→ tambahkan edge `CDN → Execution`

Rule ini bersifat glue logic.

---

# VIII. PROHIBITED RULE CATEGORY

Tidak boleh ada rule untuk:

* SQL injection
* XSS
* SSRF
* LFI
* IDOR
* RCE
* Misconfiguration exploit
* Rate limit bypass
* Deserialization attack

Itu Stage-02 (TVH domain).

---

# TAXONOMY HIERARCHY SUMMARY

```
Stage-01 Rules
├── Edge Layer
│   ├── CDN
│   ├── Proxy
│   └── Load Balancer
├── Gateway Layer
│   ├── API Gateway
│   └── Routing Pattern
├── Application Runtime
│   ├── Framework Fingerprint
│   ├── Template Engine
│   └── Static/Dynamic
├── Control Layer
│   ├── Session Auth
│   ├── Token Auth
│   └── Redirect Auth
├── Statefulness
│   ├── Cookie-based
│   ├── Sticky session
│   └── Idempotent detection
├── Limited DataStore
│   └── Explicit disclosure only
└── Topology Glue
```

---

# Coverage Philosophy

Rule taxonomy ini menjawab:

> “Target ini mesin apa dan bagaimana lapisan-lapisannya tersusun?”

Bukan:

> “Target ini rentan terhadap apa?”

---

# Batas Kompleksitas

Total rule ideal Stage-01 v1:

* 25–40 rule
* Maks 3 signal per rule
* Maks 1 layer effect per rule
* Tidak ada cross-layer long inference

---

# Final Check

Dengan taxonomy ini:

* Stage-01 tetap structural
* Tidak bocor ke vulnerability reasoning
* AI nanti punya graph yang kaya untuk reasoning
* Determinism bisa dijaga

---

