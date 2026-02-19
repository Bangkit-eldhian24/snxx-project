---

# Layer Taxonomy Specification (LTS)

## Target System Topology Model for Correct Inference Context

---

## 1. Tujuan

Layer Taxonomy mendefinisikan **lokasi asal sebuah fakta** di dalam arsitektur target.

Tanpa ini:

* Header CDN → disimpulkan backend
* Error page → disimpulkan server
* JS bundle → disimpulkan runtime
* Cookie → disimpulkan infra

Layer Taxonomy menjadi constraint bagi Hypothesis Engine.

```
Fact ∈ Layer
Hypothesis valid hanya jika Layer compatible
```

---

## 2. Prinsip Dasar

Layer ≠ teknologi
Layer = posisi dalam jalur request–response

```
Client → Edge → Gateway → Application → Runtime → OS → Hardware
```

Inference hanya sah jika bergerak **ke dalam**, tidak boleh melompat keluar konteks.

---

## 3. Layer Hierarchy

### 3.1 External Edge Layer

Represent komponen sebelum aplikasi menerima request.

```
EDGE_EXTERNAL
```

Contoh artefak:

* CDN cache headers
* WAF blocking pattern
* Geo routing
* bot mitigation challenge

Karakteristik:

* Tidak punya state aplikasi
* Bisa memodifikasi response
* Tidak tahu session user

Constraint:

> Tidak boleh menghasilkan hypothesis tentang framework backend

---

### 3.2 Reverse Proxy Layer

Komponen routing menuju upstream service.

```
EDGE_PROXY
```

Contoh:

* reverse proxy header rewriting
* buffering behavior
* hop headers
* connection reuse pattern

Karakteristik:

* Bisa leak server software
* Bisa generate error sendiri
* Tidak tahu logic aplikasi

Constraint:

> Tidak boleh menyimpulkan bahasa pemrograman

---

### 3.3 Application Interface Layer

Boundary HTTP handler aplikasi.

```
APP_INTERFACE
```

Ini bagian paling penting untuk fingerprint framework.

Contoh:

* routing behavior
* error format
* method handling
* csrf rejection response

Karakteristik:

* Memiliki semantic HTTP behavior
* Tidak menjalankan business logic penuh

---

### 3.4 Application Logic Layer

Core aplikasi.

```
APP_LOGIC
```

Contoh:

* template rendering
* serialization format
* validation message
* object mapping behavior

Karakteristik:

* Strong fingerprint source
* Stabil across deployments

---

### 3.5 Runtime Environment Layer

Bahasa & VM.

```
RUNTIME
```

Contoh:

* stack trace language
* exception format
* memory model artifacts

Karakteristik:

* Tidak tahu framework secara spesifik
* Lebih rendah dari app logic

---

### 3.6 System Layer

OS & web server worker.

```
SYSTEM
```

Contoh:

* file path separator
* process signal behavior
* TCP quirks

---

## 4. Layer Ordering Rule

Engine harus mengikuti urutan:

```
EDGE_EXTERNAL
→ EDGE_PROXY
→ APP_INTERFACE
→ APP_LOGIC
→ RUNTIME
→ SYSTEM
```

Tidak boleh infer dari luar ke dalam tanpa bukti layer transisi.

---

## 5. Layer Compatibility Matrix

| Hypothesis Target | Minimum Required Layer |
| ----------------- | ---------------------- |
| Framework         | APP_INTERFACE          |
| Framework Version | APP_LOGIC              |
| Language Runtime  | RUNTIME                |
| Server Software   | EDGE_PROXY             |
| Misconfiguration  | layer asal fakta       |
| Security Control  | APP_INTERFACE          |

Jika fakta datang dari layer lebih luar → penalize confidence.

---

## 6. Layer Conflict Resolution

Jika dua fakta konflik:

Contoh:

```
APP_LOGIC → Django
EDGE_PROXY → Apache
```

Tidak konflik.

Tapi:

```
APP_LOGIC → Django
APP_LOGIC → Laravel
```

Konflik valid.

Resolusi hanya boleh dalam layer yang sama.

---

## 7. Layer Propagation Rule

Fakta boleh diwariskan ke dalam:

```
APP_LOGIC implies APP_INTERFACE presence
RUNTIME implies SYSTEM presence
```

Tidak boleh sebaliknya.

---

## 8. Multi-Stack Modeling

Sistem modern bisa:

```
CDN → nginx → node → python service
```

Engine harus mengizinkan multiple hypothesis selama beda layer.

---

## 9. Stability Expectation

| Layer         | Stability |
| ------------- | --------- |
| EDGE_EXTERNAL | low       |
| EDGE_PROXY    | medium    |
| APP_INTERFACE | high      |
| APP_LOGIC     | very_high |
| RUNTIME       | very_high |
| SYSTEM        | medium    |

Digunakan untuk confidence weighting.

---

## 10. Forbidden Inference Examples

Tidak sah:

```
Cloudflare header → Node.js
gzip behavior → Django
React bundle → PHP backend
```

Sah:

```
CSRF token format → framework
stack trace → runtime
template syntax → framework
```

---

## Status

Sekarang empat dokumen lengkap secara formal:

1. **Signal Ontology** — vocabulary observasi
2. **Layer Taxonomy** — lokasi asal observasi
3. **Knowledge State** — apa yang dianggap fakta
4. **Hypothesis Semantics** — aturan penarikan kesimpulan


