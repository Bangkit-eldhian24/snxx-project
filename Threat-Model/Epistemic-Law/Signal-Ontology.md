---

# Signal Ontology Specification (SOS)

## Version: 1.0 — Foundational Semantics

---

## 1. Domain Boundary

Sistem bekerja pada domain:

```
Remote Web System Observation
```

Artinya:

Engine hanya boleh mengetahui sesuatu jika ia muncul dari:

```
Network Interaction → Observable Artifact → Recorded Representation
```

Segala hal di luar itu **tidak boleh menjadi signal**.

Contoh yang DILARANG menjadi signal:

* Dugaan teknologi
* Probabilitas framework
* Korelasi database publik
* Knowledge bawaan model
* Pattern training LLM

Semua itu nanti masuk ke *hypothesis*, bukan signal.

---

## 2. Definisi Inti

### 2.1 Observable

Observable adalah setiap fenomena yang dapat diambil langsung dari interaksi protokol.

Formal:

```
Observable := byte_sequence returned_by(target, interaction)
```

Contoh:

* header HTTP
* response body
* TLS certificate
* timing
* connection behavior

Observable masih mentah.

---

### 2.2 Signal

Signal adalah representasi terstruktur dari observable setelah normalisasi.

```
Signal := Normalize(Observable, ExtractionRule)
```

Signal bukan data mentah.
Signal adalah fakta terstandardisasi.

---

### 2.3 Evidence

Evidence BUKAN bagian dari ontology ini.

Ontology hanya mengenal:

```
Observable → Signal
```

---

## 3. Signal Object Model

Setiap signal HARUS berbentuk objek berikut:

```
Signal {
    uid: string
    class: SignalClass
    source: SourceType
    feature: FeatureType
    value: AtomicValue
    precision: PrecisionType
    stability: StabilityType
    timestamp: int64
}
```

Tidak boleh ada field tambahan.

---

## 4. SignalClass

Menentukan bentuk fenomena yang diamati.

```
enum SignalClass {
    TOKEN        // string literal
    STRUCTURE    // pola atau format
    BEHAVIOR     // respons interaksi
    PROPERTY     // atribut koneksi
    ARTIFACT     // resource eksternal
}
```

Contoh:

| Observasi                    | Class     |
| ---------------------------- | --------- |
| Header `Server: nginx`       | TOKEN     |
| Cookie format JWT            | STRUCTURE |
| Rate limit setelah 5 request | BEHAVIOR  |
| TLS version                  | PROPERTY  |
| robots.txt                   | ARTIFACT  |

---

## 5. SourceType

Asal pengambilan signal.

```
enum SourceType {
    RESPONSE_HEADER
    RESPONSE_BODY
    RESPONSE_CODE
    REQUEST_REFLECTION
    CONNECTION_METADATA
    RESOURCE_FETCH
    INTERACTION_PATTERN
}
```

Constraint:
Signal hanya boleh punya satu source.

---

## 6. FeatureType

Feature adalah *apa* yang diukur dari source.

```
enum FeatureType {
    HEADER_KEY
    HEADER_VALUE
    STATUS_CODE
    BODY_TOKEN
    BODY_PATTERN
    COOKIE_NAME
    COOKIE_FORMAT
    REDIRECT_TARGET
    TLS_FIELD
    FILE_PATH
    FILE_CONTENT
    TIMING_PATTERN
    METHOD_SUPPORT
}
```

Feature bukan kategori — feature adalah **unit makna atomik**.

---

## 7. AtomicValue

Signal harus atomic.

Dilarang:

```
"Apache + PHP + Ubuntu"
```

Wajib:

```
Apache
PHP
Ubuntu
```

Format:

```
AtomicValue :=
    string |
    integer |
    boolean |
    hash
```

Tidak boleh array. Tidak boleh kalimat.

---

## 8. PrecisionType

Mengukur keakuratan ekstraksi.

```
enum PrecisionType {
    EXACT        // literal match
    NORMALIZED   // canonicalized
    DERIVED      // hasil parsing
}
```

Contoh:

| Data             | Precision  |
| ---------------- | ---------- |
| `PHPSESSID`      | EXACT      |
| `jwt` dari regex | DERIVED    |
| lowercase header | NORMALIZED |

---

## 9. StabilityType

Menentukan apakah signal konsisten.

```
enum StabilityType {
    VOLATILE      // bisa berubah tiap request
    SESSION       // stabil per sesi
    INSTANCE      // stabil per node server
    DEPLOYMENT    // stabil hingga deploy
    STATIC        // hampir tidak berubah
}
```

Engine nanti akan memakai ini untuk anti false-positive.

---

## 10. Normalization Rules

Normalisasi wajib deterministik.

### Wajib dilakukan:

1. Trim whitespace
2. Lowercase header key
3. Collapse multiple spaces
4. Decode gzip sebelum ekstraksi
5. Remove nonce/token acak
6. Canonical newline

Jika tidak bisa dinormalisasi → **tidak boleh jadi signal**

---

## 11. Forbidden Transformations

Yang tidak boleh dilakukan sebelum menjadi signal:

* Tidak boleh fingerprint DB
* Tidak boleh lookup CVE
* Tidak boleh mapping ke framework
* Tidak boleh scoring
* Tidak boleh heuristik

Ontology harus murni observasional.

---

## 12. Valid Signal Criteria

Sebuah data hanya sah menjadi signal jika:

```
Deterministic Extraction
AND
Repeatable Observation
AND
Protocol-derived
```

Jika salah satu gagal → discard.

---

## Status

Ini baru **fondasi semantik**.

Belum ada:

* relasi antar signal
* grouping
* conflict
* entropy

Itu akan masuk Part 2.

---

Signal Relations & Composition
1. Tujuan Bagian Ini

Tanpa relasi, sistem hanya menjadi:

kumpulan fakta tanpa struktur

Engine reasoning membutuhkan topologi bukti, bukan daftar indikator.

Bagian ini mendefinisikan:

bagaimana signal boleh berinteraksi
tanpa menyimpulkan sesuatu


Belum ada probabilitas.
Belum ada framework detection.
Belum ada classification.

Hanya struktur epistemik.

2. Signal Identity

Sebelum relasi, kita perlu identitas observasi.

2.1 Observation Instance

Satu request ≠ satu signal.

Satu request menghasilkan Observation Frame:

ObservationFrame {
    frame_id: UUID
    interaction_type: enum
    signals: Signal[]
    timestamp: int64
}


Contoh:

Request:
GET /

Menghasilkan 14 signal berbeda.
Semua berada dalam 1 frame.

2.2 Re-Observation

Jika request identik diulang:

Frame A != Frame B
meskipun sinyalnya sama


Ini penting untuk stabilitas.

3. Signal Relation Types

Relasi hanya boleh antar signal.
Tidak boleh antar hipotesis.

Relation {
    type: RelationType
    from: SignalUID
    to: SignalUID
    strength: float
}

3.1 CO_OCCURS

Dua signal muncul dalam frame yang sama.

A present in Frame X
B present in Frame X
→ CO_OCCURS


Makna:
Tidak menyatakan hubungan kausal.

Contoh:
Header Server
dan cookie PHPSESSID

3.2 REPEATS

Signal muncul kembali lintas frame.

Frame1: signal S
Frame2: signal S
→ REPEATS(S)


Ini dasar kestabilan.

3.3 MUTATES

Signal sama, value berubah.

cookie_length=187
cookie_length=189
→ MUTATES


Menunjukkan dinamika sistem.

3.4 EXCLUDES

Dua signal tidak pernah muncul bersamaan.

Dibentuk setelah cukup observasi.

Seen A without B (N times)
Seen B without A (N times)
Never together
→ EXCLUDES


Masih observasi, bukan kesimpulan.

3.5 DERIVES_FROM

Signal dihasilkan dari parsing signal lain.

Contoh:

Set-Cookie: session=abc.def.ghi
↓ parse
cookie_format=JWT


JWT bukan observasi langsung, tapi masih sah sebagai signal turunan.

4. Relation Strength

Relasi tidak boolean.

strength = occurrences / opportunities


Contoh:

Hubungan	Nilai
co-occur 8/10	0.8
co-occur 1/10	0.1

Belum probabilitas — hanya frekuensi observasi.

5. Signal Groups (Cluster Tanpa Makna)

Kadang sinyal selalu bersama.

Kita definisikan Bundle

SignalBundle {
    bundle_id
    members: SignalUID[]
    cohesion: float
}


Bundle hanya statistik kedekatan,
bukan berarti teknologi tertentu.

6. Temporal Semantics

Observasi memiliki waktu → penting.

6.1 Stability Calculation
stability_score =
  repeat_count / observation_count


Ini mengoreksi false positives akibat CDN, cache, atau A/B test.

6.2 Volatility Detection

Jika MUTATES sering:

dynamic_signal = true


Contoh:
nonce
csrf token
request id

7. Conflict Detection

Kadang sistem memberi data kontradiktif.

Ontology tidak memilih benar/salah.
Ontology hanya menandai konflik.

Conflict {
    signal_A
    signal_B
    conflict_type
}

Conflict Types
VALUE_CONTRADICTION
STRUCTURE_CONTRADICTION
BEHAVIOR_CONTRADICTION
TEMPORAL_CONTRADICTION


Contoh:

Server: nginx
Server: Apache


Bukan error.
Bisa load balancer.

8. Negative Observation

Tidak muncul juga informasi.

Expected artifact missing after valid probe
→ NEGATIVE_SIGNAL


Contoh:
OPTIONS tidak mengembalikan Allow header.

Ini tetap observasi sah.

9. Entropy Annotation

Beberapa signal terlalu umum.

Tambahkan:

signal_entropy ∈ [0,1]


0 = sangat umum
1 = sangat unik

Contoh:

Signal	Entropy
HTTP/1.1	0.01
csrftoken cookie name	0.6
x-django-csrf	0.9

Masih bukan inference — hanya rarity metric.

10. Ontology Output

Setelah Part-2, engine menghasilkan:

Signal Graph


Bukan report.

Struktur:

Frames
Signals
Relations
Bundles
Conflicts
Stability
Entropy


Ini menjadi input untuk dokumen berikutnya:
Knowledge State

Status

Sekarang ontology sudah punya:

atom (signal)

ruang (frame)

fisika (relation)

waktu (temporal)

konflik

kelangkaan

Belum ada arti.
